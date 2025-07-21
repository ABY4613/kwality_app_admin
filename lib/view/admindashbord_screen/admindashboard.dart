
import 'package:deepuadmin/main.dart';
import 'package:deepuadmin/services/auth_service.dart';
import 'package:deepuadmin/view/addItemspage.dart';
import 'package:deepuadmin/view/admindashbord_screen/tabs/foodorders.dart';
import 'package:deepuadmin/view/foods_screen/fooddetailspage.dart';
import 'package:deepuadmin/view/login_page/login_page.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}
Future<void> _handleLogout(BuildContext context) async {
  // Show confirmation dialog
  final bool? confirm = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Confirm Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );

  // If user confirmed logout
  if (confirm == true) {
    await AuthService.logout();
    
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);  // Set to 2 tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildMainContent() {
    switch (_currentIndex) {
      case 0: // Home
        return Foodorders();
          
      case 1: // Add Items
        return AddItemsPage();
      case 2: // Settings
        return const FoodDetailsPage();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.brown,
        automaticallyImplyLeading: false,
        actions: [
           IconButton(
                  onPressed: () => _handleLogout(context),
                  icon: Icon(Icons.logout,color: Colors.white,),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 212, 95, 86),
                    // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(30),
                    // ),
                  ),
                ),
          const SizedBox(width: 10),
        ],
      ),
      body: _buildMainContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.online_prediction),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Items',
          ),
         
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> newOrders = [
    {
      'name': 'Manu',
      'address': '123 Main St',
      'product': 'Apple',
      'quantity': 5,
      'amount': 450
    },
    {
      'name': 'Anjali',
      'address': '456 Elm St',
      'product': 'Mop',
      'quantity': 2,
      'amount': 1200
    },
  ];
  final List<Map<String, dynamic>> acceptedOrders = [];
  final List<Map<String, dynamic>> deliveredOrders = [];

  int _selectedTabIndex = 0;

  void _acceptOrder(Map<String, dynamic> order) {
    if (!mounted) return;
    setState(() {
      newOrders.remove(order);
      acceptedOrders.add(order);
    });
  }

  void _rejectOrder(Map<String, dynamic> order) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Reject Order'),
        content: const Text('Are you sure you want to delete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                newOrders.remove(order);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deliverOrder(Map<String, dynamic> order) {
    setState(() {
      acceptedOrders.remove(order);
        deliveredOrders.add(order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade800),
              child: Text(
                'New Orders',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade800),
              child: Text(
                'Accepted',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedTabIndex = 2;
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800),
              child: Text(
                'Delivered',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_selectedTabIndex == 0) ...[
                  // Display New Orders
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: newOrders.length,
                    itemBuilder: (context, index) {
                      final order = newOrders[index];
                      return Card(
                        child: ListTile(
                          title: Text(order['product']),
                          subtitle: Text(
                              '${order['name']} - ${order['address']}\nQuantity: ${order['quantity']}\nAmount: ₹${order['amount']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () => _acceptOrder(order),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber.shade800),
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _rejectOrder(order),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade800,
                                ),
                                child: Text(
                                  'Reject',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ] else if (_selectedTabIndex == 1) ...[
                  // Display Accepted Orders
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: acceptedOrders.length,
                    itemBuilder: (context, index) {
                      final order = acceptedOrders[index];
                      return Card(
                        child: ListTile(
                          title: Text(order['product']),
                          subtitle: Text(
                              '${order['name']} - ${order['address']}\nQuantity: ${order['quantity']}\nAmount: ₹${order['amount']}'),
                          trailing: ElevatedButton(
                              onPressed: () => _deliverOrder(order),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade800),
                              child: Text(
                                'Deliver',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      );
                    },
                  ),
                ] else if (_selectedTabIndex == 2) ...[
                  // Display Delivered Orders
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: deliveredOrders.length,
                    itemBuilder: (context, index) {
                      final order = deliveredOrders[index];
                      return Card(
                        child: ListTile(
                          title: Text(order['product']),
                          subtitle: Text(
                              '${order['name']} - ${order['address']}\nQuantity: ${order['quantity']}\nAmount: ₹${order['amount']}'),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
