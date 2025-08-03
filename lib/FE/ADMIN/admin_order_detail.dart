import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/models1/order.dart';
import 'package:fe_mobile_flutter/FE/services/admin_order_services.dart';

class AdminOrderDetailScreen extends StatelessWidget {
  final TblOrder order;

  const AdminOrderDetailScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.orderId}'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order ID: ${order.orderId}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Username: ${order.account?.accountUsername ?? "Unknown"}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Date: ${order.orderCreatedAt?.toString().substring(0, 10) ?? "N/A"}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Status: ${order.orderStatus ?? "N/A"}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Total Price: \$${order.orderTotalPrice?.toStringAsFixed(2) ?? "0.00"}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Address: ${order.account?.address ?? "N/A"}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Phone: ${order.account?.phoneNumber ?? "N/A"}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      if (order.orderStatus == 'Pending')
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await AdminOrderService.approveOrder(order.orderId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Order approved successfully')),
                              );
                              Navigator.pop(context); // Return to order list
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to approve order: $e')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Approve Order'),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Items',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...(order.tblOrderItems ?? []).map((item) => Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(item.dish?.dishName ?? 'Unknown', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Quantity: ${item.orderItemQuantity ?? 0} | Price: \$${item.orderItemPrice?.toStringAsFixed(2) ?? "0.00"}'),
                    ),
                  )).toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) async {
          if (index == 0) Navigator.pushNamed(context, '/');
          if (index == 1) Navigator.pushNamed(context, '/cart');
          if (index == 2) print('Like tapped');
          if (index == 3) {
            Navigator.pushNamed(context, '/userProfile');
          }
        },
      ),
    );
  }
}