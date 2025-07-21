import 'package:flutter/material.dart';
import 'package:deepuadmin/services/food_service.dart';
import 'package:deepuadmin/services/auth_service.dart';
import 'package:deepuadmin/model/food_preorder.dart';

class FoodDetailsPage extends StatefulWidget {
  const FoodDetailsPage({super.key});

  @override
  _FoodDetailsPageState createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  List<FoodPreOrder> orders = [];
  bool isLoading = true;
  final List<String> statusOptions = ['PENDING', 'ACCEPTED', 'REJECTED', 'DELIVERED'];

  @override
  void initState() {
    super.initState();
    _loadPreOrders();
  }

  Future<void> _loadPreOrders() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No token found');
      
      final fetchedOrders = await FoodService.getPreOrderFoodOrders(token);
      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load pre-orders: $e')),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateOrderStatus(int orderId, String newStatus) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No token found');

      await FoodService.updatePreOrderStatus(orderId, newStatus, token);
      await _loadPreOrders(); // Reload orders after update
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pre-order status updated to $newStatus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update pre-order status: $e')),
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
            title: Text('Pre-Order #${order.id} - ${order.fullName}'),
            subtitle: Text('Total: ₹${order.totalAmount.toStringAsFixed(2)}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone: ${order.phoneNumber}'),
                    Text('Address: ${order.address}'),
                    Text('Pincode: ${order.pincode}'),
                    Text('Delivery Date: ${order.deliveryDate.toString()}'),
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantity: ${item.quantity}'),
                              Text('Price: ₹${item.foodItemDetails['amount']}'),
                              Text('Total: ₹${item.totalAmount.toStringAsFixed(2)}'),
                            ],
                          ),
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
      length: statusOptions.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pre-Order Food Details'),
          bottom: TabBar(
            isScrollable: true,
            tabs: statusOptions.map((status) => Tab(text: status)).toList(),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: statusOptions
                    .map((status) => _buildOrdersList(status))
                    .toList(),
              ),
      ),
    );
  }
}
