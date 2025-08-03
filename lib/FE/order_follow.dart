import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fe_mobile_flutter/FE/models1/order.dart';
import 'package:fe_mobile_flutter/FE/models1/orderitem.dart';
import 'package:fe_mobile_flutter/FE/services/order_service.dart';

class OrderFollowScreen extends StatefulWidget {
  const OrderFollowScreen({super.key});

  @override
  State<OrderFollowScreen> createState() => _OrderFollowScreenState();
}

class _OrderFollowScreenState extends State<OrderFollowScreen> {
  final OrderService orderService = OrderService();
  List<TblOrder> userOrders = [];
  bool isLoading = true;
  int? accountId;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    accountId = prefs.getInt('accountId');

    if (accountId == null) {
      // ✅ Nếu chưa đăng nhập thì chuyển hướng tới trang login
      Future.microtask(() {
        print('❌ Account ID not found in SharedPreferences');
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }

    try {
      List<TblOrder> orders = await orderService.getOrdersByUser(accountId!);
      print("accountId: $accountId");
      print("✅ Orders fetched: ${orders.length}");
      setState(() {
        userOrders = orders;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error while loading orders: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.orange;
      case 'Shipped':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Pending':
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/userProfile');
          },
        ),
        title: const Text('Your Orders'),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userOrders.isEmpty
          ? const Center(child: Text('No orders found.'))
          : ListView.builder(
              itemCount: userOrders.length,
              itemBuilder: (context, index) {
                final order = userOrders[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 3,
                  child: ExpansionTile(
                    title: Text('Order #${order.orderId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: ${order.orderStatus}',
                          style: TextStyle(
                            color: getStatusColor(
                              order.orderStatus ?? 'Pending',
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Created at: ${order.orderCreatedAt}'),
                      ],
                    ),
                    children: [
                      ...(order.tblOrderItems?.map((item) {
                            return ListTile(
                              leading:
                                  (item.dish?.dishImageUrl != null &&
                                      item.dish!.dishImageUrl!.startsWith(
                                        'http',
                                      ))
                                  ? Image.network(
                                      item.dish!.dishImageUrl!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/default.png',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                    )
                                  : Image.asset(
                                      item.dish?.dishImageUrl != null
                                          ? 'assets/${item.dish!.dishImageUrl!}'
                                          : 'assets/default.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),

                              title: Text(item.dish?.dishName ?? 'Unknown'),
                              subtitle: Text('Qty: ${item.orderItemQuantity}'),
                              trailing: Text(
                                '\$${((item.dish?.dishPrice ?? 0.0) * (item.orderItemQuantity ?? 1)).toStringAsFixed(2)}',
                              ),
                            );
                          }).toList() ??
                          [const ListTile(title: Text('No items'))]),

                      // --- Tổng tiền dưới cùng mỗi ExpansionTile ---
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (order.orderAddress != null)
                              Text("Address: ${order.orderAddress!}"),
                            if (order.phoneNumber != null)
                              Text("Phone: ${order.phoneNumber!}"),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Total: \$${order.orderTotalPrice?.toStringAsFixed(2) ?? '0.00'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
