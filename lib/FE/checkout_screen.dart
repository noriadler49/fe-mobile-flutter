import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';

class CheckoutScreen extends StatefulWidget {
  final String userName;
  final String phoneNumber;
  final String address;
  final List<Map<String, dynamic>> cartItems;

  const CheckoutScreen({
    super.key,
    required this.userName,
    required this.phoneNumber,
    required this.address,
    required this.cartItems,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late String currentName;
  late String currentPhone;
  late String currentAddress;

  @override
  void initState() {
    super.initState();
    currentName = widget.userName;
    currentPhone = widget.phoneNumber;
    currentAddress = widget.address;
  }

  void _navigateToAddressScreen() async {
    final result = await Navigator.pushNamed(context, '/address');

    if (result != null && result is Map<String, String>) {
      setState(() {
        currentName = result['name']!;
        currentPhone = result['phone']!;
        currentAddress = result['address']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.cartItems.fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('$currentName | $currentPhone'),
              subtitle: Text('Address: $currentAddress'),
              trailing: IconButton(
                icon: Icon(Icons.edit_location_alt),
                onPressed: _navigateToAddressScreen,
              ),
            ),
          ),

          // Cart items
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                var item = widget.cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(item['image'], width: 50),
                    title: Text(item['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Shop: ${item['shop']}'),
                        Text('Ingredients: ${item['ingredients']}'),
                        Text('\$${item['price']} x${item['quantity']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Payment: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("The Order: abcxyz1"),
                        content: Text("Status: Ordered"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
