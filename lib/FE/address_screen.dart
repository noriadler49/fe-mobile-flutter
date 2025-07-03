// import 'package:flutter/material.dart';

// class AddressScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Choose Receive's Address")),
//       body: ListView(
//         children: [
//           ListTile(
//             leading: Radio(value: true, groupValue: true, onChanged: (_) {}),
//             title: Text('UserName | +PhoneNumber'),
//             subtitle: Text('Address: No.1 Lmain'),
//             trailing: TextButton(onPressed: () {}, child: Text('Fix')),
//           ),
//           ListTile(
//             leading: Radio(value: false, groupValue: true, onChanged: (_) {}),
//             title: Text('Another Name | +PhoneNumber'),
//             subtitle: Text('Address: No.2 Example St.'),
//             trailing: TextButton(onPressed: () {}, child: Text('Fix')),
//           ),
//           Center(
//             child: TextButton.icon(
//               icon: Icon(Icons.add_location),
//               label: Text('New Address'),
//               onPressed: () {
//                 // Open form to add new address
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int selectedAddressIndex = 0;
  List<Map<String, String>> addressList = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('saved_addresses');

    if (jsonString != null) {
      List decoded = jsonDecode(jsonString);
      setState(() {
        addressList = List<Map<String, String>>.from(decoded);
      });
    } else {
      // Default if no data saved yet
      addressList = [
        {'name': 'UserName', 'phone': '+PhoneNumber', 'address': 'No.1 Lmain'},
        {
          'name': 'Another Name',
          'phone': '+PhoneNumber',
          'address': 'No.2 Example St.',
        },
      ];
    }
  }

  Future<void> _saveAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_addresses', jsonEncode(addressList));
  }

  void _showAddAddressDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('New Address'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty &&
                  addressController.text.isNotEmpty) {
                setState(() {
                  addressList.add({
                    'name': nameController.text,
                    'phone': phoneController.text,
                    'address': addressController.text,
                  });
                  selectedAddressIndex = addressList.length - 1;
                });

                await _saveAddresses(); // ✅ Save to storage
                Navigator.pop(context, addressList[selectedAddressIndex]);
              }
            },
            child: Text('Add'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Receive's Address")),
      body: ListView(
        children: [
          ...List.generate(addressList.length, (index) {
            final addr = addressList[index];
            return ListTile(
              leading: Radio<int>(
                value: index,
                groupValue: selectedAddressIndex,
                onChanged: (value) {
                  setState(() {
                    selectedAddressIndex = value!;
                  });
                },
              ),
              title: Text('${addr['name']} | ${addr['phone']}'),
              subtitle: Text('Address: ${addr['address']}'),
              trailing: TextButton(
                onPressed: () {
                  // Future: allow editing
                },
                child: Text('Fix'),
              ),
            );
          }),
          Center(
            child: TextButton.icon(
              icon: Icon(Icons.add_location),
              label: Text('New Address'),
              onPressed: _showAddAddressDialog,
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, addressList[selectedAddressIndex]);
              },
              child: Text('Use This Address'),
            ),
          ),
        ],
      ),
    );
  }
}
