import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/models1/cartitem.dart';
import 'package:fe_mobile_flutter/FE/services/cart_item_service.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';
import 'package:fe_mobile_flutter/FE/services/order_service.dart';
import 'package:fe_mobile_flutter/FE/models1/account.dart';
import 'package:fe_mobile_flutter/FE/services/vourcherservice.dart';
import 'package:fe_mobile_flutter/FE/checkout_screen.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<TblCartItem> cartItems = [];
  bool isLoading = true;
  Set<int> selectedItems = {};
  bool selectAll = false;
  int? accountId;
  TextEditingController _voucherCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    accountId = await AuthStatus.getCurrentAccountId();

    if (accountId == null) {
      // Nếu chưa đăng nhập thì chuyển hướng tới trang login
      Future.microtask(() {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return; // Thoát khỏi hàm luôn
    }

    // Nếu đã login thì load giỏ hàng
    final items = await CartItemService().getCartItemsByAccountId(accountId!);

    for (var i = 0; i < items.length; i++) {
      print("Item $i:");
      print("  cartItemId: ${items[i].cartItemId}");
      print("  dishId: ${items[i].dishId}");
      print("  quantity: ${items[i].cartItemQuantity}");
      print("  dishName: ${items[i].dish?.dishName}");
      print("  dishImageUrl: ${items[i].dish?.dishImageUrl}");
    }

    setState(() {
      cartItems = items;
      isLoading = false;
    });

    // ✅ Nếu giỏ hàng trống, chuyển hướng về Home
    if (items.isEmpty) {
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Your cart is empty, Please Order with All Heart ♡♡♡",
            ),
            backgroundColor: const Color.fromARGB(255, 255, 0, 85),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacementNamed(context, '/');
      });
    }
  }

  // void _handleBuySelected() async {
  //   try {
  //     print(">> Bắt đầu xử lý Buy Selected");

  //     final selectedItemsList = cartItems
  //         .where((item) => selectedItems.contains(item.cartItemId))
  //         .toList();

  //     print(">> Số lượng item đã chọn: ${selectedItemsList.length}");
  //     for (var item in selectedItemsList) {
  //       print(
  //         ">> Món: ${item.dish?.dishName}, Số lượng: ${item.cartItemQuantity}",
  //       );
  //     }

  //     // Ví dụ: điều hướng đến trang checkout
  //     Navigator.pushNamed(
  //       context,
  //       '/checkout',
  //       arguments: {'cartItems': selectedItemsList},
  //     );
  //   } catch (e, stackTrace) {
  //     print("❌ Lỗi khi xử lý Buy Selected: $e");
  //     print(stackTrace);
  //   }
  // }

  void _showLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Thông báo"),
          content: const Text("Hãy login tài khoản của mình để xem giỏ hàng."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _incrementQuantity(int index) async {
    final currentItem = cartItems[index];
    final newQty = (currentItem.cartItemQuantity ?? 0) + 1;

    final success = await CartItemService().updateQuantity(
      currentItem.cartItemId,
      newQty,
    );
    if (success) {
      setState(() {
        cartItems[index] = currentItem.copyWith(cartItemQuantity: newQty);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update quantity"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _decrementQuantity(int index) async {
    final currentItem = cartItems[index];
    final currentQty = currentItem.cartItemQuantity ?? 1;

    if (currentQty > 1) {
      final newQty = currentQty - 1;
      final success = await CartItemService().updateQuantity(
        currentItem.cartItemId,
        newQty,
      );
      if (success) {
        setState(() {
          cartItems[index] = currentItem.copyWith(cartItemQuantity: newQty);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update quantity"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  double _calculateSelectedTotal() {
    return cartItems
        .where((item) => selectedItems.contains(item.cartItemId))
        .fold(0.0, (sum, item) {
          final price = item.dish?.dishPrice ?? 0;
          final qty = item.cartItemQuantity ?? 1;
          return sum + price * qty;
        });
  }

  void _showVoucherInvalidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Invalid Voucher"),
          content: Text(
            "The voucher code you entered is not valid. Please try again.",
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty, Please Order with All Heart ♡♡♡",
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        value: selectAll,
                        onChanged: (value) {
                          setState(() {
                            selectAll = value ?? false;
                            if (selectAll) {
                              selectedItems = cartItems
                                  .map((item) => item.cartItemId)
                                  .toSet();
                            } else {
                              selectedItems.clear();
                            }
                          });
                        },
                      ),
                      const Text("Select All"),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final dish = item.dish;
                        final dishName = dish?.dishName ?? "Unknown Dish";
                        final price = dish?.dishPrice ?? 0;
                        final quantity = item.cartItemQuantity ?? 1;
                        final imageName =
                            'assets/${dish?.dishImageUrl ?? 'burger.png'}';

                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: selectedItems.contains(
                                    item.cartItemId,
                                  ),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedItems.add(item.cartItemId);
                                        print(
                                          ">> Đã chọn item ${item.cartItemId}",
                                        );
                                      } else {
                                        selectedItems.remove(item.cartItemId);
                                        print(
                                          ">> Đã bỏ chọn item ${item.cartItemId}",
                                        );
                                      }

                                      // ✅ Cập nhật trạng thái selectAll
                                      selectAll =
                                          selectedItems.length ==
                                          cartItems.length;
                                    });
                                  },
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    imageName,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              dishName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "\$${price.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _decrementQuantity(index),
                                  icon: Icon(Icons.remove, color: Colors.red),
                                ),
                                Text(
                                  "$quantity",
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () => _incrementQuantity(index),
                                  icon: Icon(Icons.add, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomSheet: cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _voucherCodeController,
                    decoration: InputDecoration(
                      labelText: 'Voucher Code',
                      hintText: 'Enter your voucher code',
                      prefixIcon: Icon(Icons.card_giftcard),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Total: \$${_calculateSelectedTotal().toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),

                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/deals');
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(150, 48),
                          side: BorderSide(color: Colors.red),
                        ),
                        child: Text(
                          "Continue shop",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: selectedItems.isEmpty
                            ? null
                            : () async {
                                if (accountId == null) {
                                  _showLoginDialog();
                                  return;
                                }

                                final code = _voucherCodeController.text.trim();

                                // Bước 1: Kiểm tra voucher (nếu có nhập)
                                if (code.isNotEmpty) {
                                  final voucher = await VourcherService()
                                      .validateVoucher(code);
                                  print("Navigating with voucherCode: $code");
                                  if (voucher == null) {
                                    _showVoucherInvalidDialog(); // ❌ hiển thị dialog nếu mã sai
                                    return;
                                  }
                                }

                                // Bước 2: Mã đúng hoặc không có mã => Tiếp tục
                                final selectedCartItems = cartItems
                                    .where(
                                      (item) => selectedItems.contains(
                                        item.cartItemId,
                                      ),
                                    )
                                    .map((item) {
                                      return {
                                        'cartItemId': item.cartItemId,
                                        'name': item.dish?.dishName ?? '',
                                        'ingredients': '',
                                        'price': item.dish?.dishPrice ?? 0.0,
                                        'quantity': item.cartItemQuantity ?? 1,
                                        'image':
                                            'assets/${item.dish?.dishImageUrl?.isNotEmpty == true ? item.dish!.dishImageUrl : 'default.png'}',
                                      };
                                    })
                                    .toList();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                      cartItems: selectedCartItems,
                                    ),
                                    settings: RouteSettings(
                                      arguments: {
                                        'accountId': accountId,
                                        'cartItems': selectedCartItems,
                                        'voucherCode': code,
                                      },
                                    ),
                                  ),
                                );
                              },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: Size(150, 48),
                        ),
                        child: Text(
                          "Buy Selected",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
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
          if (index == 0) Navigator.pushNamed(context, '/');
          if (index == 1) return;
          if (index == 2) print('Like tapped');
          if (index == 3) {
            bool loggedIn = await AuthStatus.checkIsLoggedIn();
            if (loggedIn) {
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
