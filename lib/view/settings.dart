// import 'package:flutter/material.dart';
// import 'package:deepuadmin/main.dart';  // For AuthService

// class Setting extends StatelessWidget {
//   const Setting({super.key});

//   Future<void> _handleLogout(BuildContext context) async {
//     try {
//       // Clear the stored auth data
//       await AuthService.logout();
      
//       // Navigate to login screen and remove all previous routes
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => LoginPage()),
//         (Route<dynamic> route) => false,
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error during logout: ${e.toString()}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // CircleAvatar(
//               //   radius: 50,
//               //   backgroundColor: Colors.purple[100],
//               //   child: Icon(
//               //     Icons.person,
//               //     size: 50,
//               //     color: Colors.purple,
//               //   ),
//               // ),
//               // SizedBox(height: 20),
//               // Text(
//               //   'John Doe',
//               //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               // ),
//               // Text(
//               //   'john.doe@example.com',
//               //   style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//               // ),
//               // SizedBox(height: 40),
//               // ListTile(
//               //   leading: Icon(Icons.local_shipping),
//               //   title: Text('Delivery Status'),
//               //   onTap: () {
//               // //       Navigator.pushReplacement(
//               // // context,
//               // // MaterialPageRoute(
//               // //   builder: (context) => DeliveryStatusScreen(),
//               // // ));
//               //     },
//               //   ),
//                 // ListTile(
//                 //   leading: Icon(Icons.history),
//                 //   title: Text('Order History'),
//                 //   onTap: () {
//                 //   // Navigator.push(
//                 //   //     context,
//                 //   //     MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
//                 //   //   );
                
//                 //   },
//                 // ),
//                 // ListTile(
//                 //   leading: Icon(Icons.info),
//                 //   title: Text('About Us'),
//                 //   onTap: () {
//                 //     // Handle About Us action
//                 //   },
//                 // ),
                
//                 ElevatedButton(
//                   onPressed: () => _handleLogout(context),
//                   child: Text('Logout'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
