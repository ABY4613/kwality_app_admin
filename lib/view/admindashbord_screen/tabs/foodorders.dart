
import 'package:flutter/material.dart';
import 'package:deepuadmin/model/food_order.dart';
import 'package:deepuadmin/services/food_service.dart';
import 'package:deepuadmin/services/auth_service.dart';

class Foodorders extends StatefulWidget {
  const Foodorders({super.key});

  @override
  _FoodordersState createState() => _FoodordersState();
}

class _FoodordersState extends State<Foodorders> {
  List<FoodOrder> orders = [];
  bool isLoading = true;

  // Add this list of status options
  final List<String> statusOptions = ['PENDING', 'ACCEPTED', 'REJECTED', 'DELIVERED'];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No token found');
      
      final fetchedOrders = await FoodService.getFoodOrders(token);
      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load orders: $e')),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  // Modify the update order status method to handle any status
  Future<void> _updateOrderStatus(int orderId, String newStatus) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No token found');

      await FoodService.updateOrderStatus(orderId, newStatus, token);
      await _loadOrders(); // Reload orders after update
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order status updated to $newStatus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update order status: $e')),
        );
      }
    }
  }

  Widget _buildOrdersList(String status) {
    final filteredOrders = orders.where((order) => order.status == status).toList();

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Text('Order #${order.id} - ${order.fullName}'),
            subtitle: Text('Total: ₹${order.totalAmount.toStringAsFixed(2)}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone: ${order.phoneNumber}'),
                    Text('Address: ${order.address}'),
                    Text('Landmark: ${order.landmark}'),
                    Text('Order Date: ${order.createdAt.toString()}'),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status: ${order.status}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          value: order.status,
                          items: statusOptions.map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (String? newStatus) {
                            if (newStatus != null && newStatus != order.status) {
                              _updateOrderStatus(order.id, newStatus);
                            }
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    const Text('Order Items:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...order.orderItems.map((item) => ListTile(
                          title: Text(item.foodItemDetails['title']),
                          subtitle: Text(
                              'Quantity: ${item.quantity} x ₹${item.foodItemDetails['amount']}'),
                          trailing: Text(
                              '₹${item.totalAmount.toStringAsFixed(2)}'),
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Changed to 4 to match the number of tabs
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Rejected'), // Added Rejected tab
              Tab(text: 'Delivered'),
            ],
            isScrollable: true, // Added to handle multiple tabs better
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: [
                      _buildOrdersList('PENDING'),
                      _buildOrdersList('ACCEPTED'),
                      _buildOrdersList('REJECTED'),
                      _buildOrdersList('DELIVERED'),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
