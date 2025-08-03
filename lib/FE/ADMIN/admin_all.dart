import 'package:fe_mobile_flutter/FE/ADMIN/admin_order_detail.dart';
import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/services/admin_order_services.dart';
import 'package:fe_mobile_flutter/FE/models1/order.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';
import 'package:fe_mobile_flutter/FE/admin/admin_search_button.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  _AllOrdersScreenState createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  List<TblOrder> orders = [];
  List<TblOrder> allOrders = [];
  bool isLoading = true;
  DateTime? _fromDate;
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  // Load orders from API
  Future<void> _loadOrders() async {
    try {
      final fetchedOrders = await AdminOrderService.getAllOrders();
      setState(() {
        orders = fetchedOrders;
        allOrders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load orders: $e')));
    }
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked;
        final dateStr = DateFormat('yyyy-MM-dd').format(picked);
        orders = allOrders.where((order) {
          final created = order.orderCreatedAt?.toString();
          return created != null && created.contains(dateStr);
        }).toList();
      });
    }
  }

  double getTotalRevenue() {
    return orders.fold(
      0.0,
      (sum, order) => sum + (order.orderTotalPrice ?? 0.0),
    );
  }

  Future<void> _generatePDF() async {
    final fontData = await rootBundle.load("assets/fonts/times.ttf");
    final timesFont = pw.Font.ttf(fontData);

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: timesFont),
        build: (context) => [
          pw.Text('Order Report', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: ['ID', 'Username', 'Date', 'Total', 'Status'],
            data: orders
                .map(
                  (o) => [
                    o.orderId.toString(),
                    o.account?.accountUsername ?? '-',
                    o.orderCreatedAt?.toString().substring(0, 10) ?? '-',
                    '\$${o.orderTotalPrice?.toStringAsFixed(2)}',
                    o.orderStatus ?? '-',
                  ],
                )
                .toList(),
          ),
          pw.Divider(),
          pw.Text(
            'Total Revenue: \$${getTotalRevenue().toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: 18),
          ),
        ],
      ),
    );

    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        Directory? output;

        if (Platform.isAndroid) {
          output = await getExternalStorageDirectory();
        } else if (Platform.isWindows) {
          output = Directory('D:/Ki3_CNTT/FullMobile');
        } else {
          output = await getApplicationDocumentsDirectory();
        }

        if (output == null) throw 'Cannot access storage directory.';

        final filePath = '${output.path}/orders_report.pdf';
        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('PDF saved to $filePath')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save PDF: $e')));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Storage permission denied.')));
    }

    //     final status = await Permission.storage.request();
    // if (status.isGranted) {
    //   Directory output;
    //   if (Platform.isAndroid || Platform.isIOS) {
    //     output = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
    //   } else {
    //     output = Directory('D:/Ki3_CNTT/FullMobile');
    //   }

    //   final file = File('${output.path}/orders_report.pdf');
    //   await file.writeAsBytes(await pdf.save());

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('PDF saved to ${file.path}')),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Storage permission denied.')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.redAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Text(
                      'Admin Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.list_alt, color: Colors.red),
                    title: Text('All Orders'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/orders');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add_circle, color: Colors.red),
                    title: Text('Add Dish'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/add');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.kitchen, color: Colors.red),
                    title: Text('Manage Ingredients'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/ingredients');
                    },
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.admin_panel_settings, color: Colors.red),
              title: Text('Admin Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin/dashboard');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.redAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Builder(
                          builder: (BuildContext context) {
                            return IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          },
                        ),
                        Text(
                          'Tất cả đơn hàng',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Danh sách đơn hàng:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Above: inside Padding(...) before "Danh sách đơn hàng"
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        children: [
                          // Show Date Picker
                          Expanded(
                            flex: 4,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.date_range),
                              label: _fromDate == null
                                  ? const Text(
                                      'From Date',
                                      style: TextStyle(fontSize: 14),
                                    )
                                  : Text(
                                      DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(_fromDate!),
                                    ),

                              onPressed: () => _selectFromDate(context),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                minimumSize: Size(120, 48),
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          // Total Revenue Display
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Revenue:",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    "\$${getTotalRevenue().toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          // Export PDF Button
                          Expanded(
                            flex: 3,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.picture_as_pdf),
                              label: Text("Export"),
                              onPressed: _generatePDF,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Table(
                            border: TableBorder.all(color: Colors.grey),
                            columnWidths: {
                              0: FlexColumnWidth(0.8),
                              1: FlexColumnWidth(2),
                              2: FlexColumnWidth(1.5),
                              3: FlexColumnWidth(1.5),
                              4: FlexColumnWidth(1.5),
                            },
                            children: [
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'ID',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: FilterButtonWithPopup(
                                      label: 'Username',
                                      onSearch: (value) async {
                                        if (value.isEmpty) {
                                          setState(() {
                                            orders = allOrders;
                                          });
                                        } else {
                                          setState(() {
                                            orders = allOrders
                                                .where(
                                                  (order) =>
                                                      order
                                                          .account
                                                          ?.accountUsername
                                                          ?.toLowerCase()
                                                          .contains(
                                                            value.toLowerCase(),
                                                          ) ??
                                                      false,
                                                )
                                                .toList();
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: FilterButtonWithPopup(
                                      label: 'Date',
                                      onSearch: (value) async {
                                        if (value.isEmpty) {
                                          setState(() {
                                            orders = allOrders;
                                          });
                                        } else {
                                          setState(() {
                                            orders = allOrders
                                                .where(
                                                  (order) =>
                                                      order.orderCreatedAt
                                                          ?.toString()
                                                          .toLowerCase()
                                                          .contains(
                                                            value.toLowerCase(),
                                                          ) ??
                                                      false,
                                                )
                                                .toList();
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Total',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...orders
                                  .map(
                                    (order) => TableRow(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminOrderDetailScreen(
                                                      order: order,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              order.orderId.toString(),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminOrderDetailScreen(
                                                      order: order,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              order.account?.accountUsername ??
                                                  'Unknown',
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminOrderDetailScreen(
                                                      order: order,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              order.orderCreatedAt
                                                      ?.toString()
                                                      .substring(0, 10) ??
                                                  'N/A',
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminOrderDetailScreen(
                                                      order: order,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              '\$${order.orderTotalPrice?.toStringAsFixed(2) ?? "0.00"}',
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminOrderDetailScreen(
                                                      order: order,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              order.orderStatus ?? 'N/A',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) async {
          if (index == 0) return;
          if (index == 1) Navigator.pushNamed(context, '/cart');
          if (index == 2) print('Like tapped');
          if (index == 3) {
            if (await AuthStatus.checkIsLoggedIn()) {
              Navigator.pushNamed(context, '/userProfile');
            } else {
              Navigator.pushNamed(context, '/login');
            }
          }
        },
      ),
    );
  }
}
