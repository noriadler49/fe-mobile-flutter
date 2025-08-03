// import 'package:flutter/material.dart';
// import 'package:fe_mobile_flutter/FE/auth_status.dart';
// import 'package:fe_mobile_flutter/FE/models1/account.dart';
// import 'package:fe_mobile_flutter/FE/services/account_service.dart';

// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({super.key});

//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen> {
//   TblAccount? user;
//   TextEditingController nameController = TextEditingController();
//   TextEditingController currentPwdController = TextEditingController();
//   TextEditingController newPwdController = TextEditingController();
//   TextEditingController retypePwdController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   bool _isLoading = false;
//   final AccountService _accountService = AccountService();

//   @override
//   void initState() {
//     super.initState();
//     _loadProfile();
//   }

//   Future<void> _loadProfile() async {
//     print('🔄 _loadProfile() called');

//     final accountId = await AuthStatus.getCurrentAccountId();
//     print('🆔 Fetched accountId: $accountId');
//     if (accountId == null) {
//       if (mounted) {
//         Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//       }
//       return;
//     }
//     setState(() => _isLoading = true);
//     try {
//       user = await _accountService.getProfile(accountId);
//       if (user != null) {
//         phoneController.text = user!.phoneNumber ?? '';
//         addressController.text = user!.address ?? '';
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error loading profile: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _updateProfile() async {
//     if (phoneController.text.isNotEmpty || addressController.text.isNotEmpty) {
//       setState(() => _isLoading = true);
//       try {
//         final updatedUser = TblAccount(
//           accountId: user!.accountId,
//           accountUsername: user!.accountUsername,
//           accountPassword: '',
//           accountRole: user!.accountRole,
//           phoneNumber: phoneController.text.trim().isNotEmpty
//               ? phoneController.text.trim()
//               : null,
//           address: addressController.text.trim().isNotEmpty
//               ? addressController.text.trim()
//               : null,
//         );
//         user = await _accountService.updateProfile(
//           user!.accountId!,
//           updatedUser,
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Profile updated successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error updating profile: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } finally {
//         if (mounted) setState(() => _isLoading = false);
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please enter at least one field to update'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//     }
//   }

//   void _showEditProfileDialog() {
//     nameController.text = user?.accountUsername ?? '';
//     phoneController.text = user?.phoneNumber ?? '';
//     addressController.text = user?.address ?? '';

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Text('Customize Profile'),
//         content: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.98,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _styledTextField(
//                   'Username',
//                   nameController,
//                   icon: Icons.person,
//                 ),
//                 _styledTextField(
//                   'Phone Number',
//                   phoneController,
//                   icon: Icons.phone,
//                 ),
//                 _styledTextField(
//                   'Address',
//                   addressController,
//                   icon: Icons.home,
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton.icon(
//                   onPressed: _submitProfileUpdate,
//                   icon: Icon(Icons.save),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   label: Text(
//                     'Save Profile',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 SizedBox(height: 24),
//                 Divider(thickness: 1),
//                 Text(
//                   'Reset Password',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 _styledTextField(
//                   'Current Password',
//                   currentPwdController,
//                   isPassword: true,
//                   icon: Icons.lock_outline,
//                 ),
//                 _styledTextField(
//                   'New Password',
//                   newPwdController,
//                   isPassword: true,
//                   icon: Icons.lock,
//                 ),
//                 _styledTextField(
//                   'Retype New Password',
//                   retypePwdController,
//                   isPassword: true,
//                   icon: Icons.lock_reset,
//                 ),
//                 SizedBox(height: 12),
//                 ElevatedButton.icon(
//                   onPressed: _submitPasswordUpdate,
//                   icon: Icon(Icons.refresh),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   label: Text(
//                     'Update Password',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Close', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _styledTextField(
//     String hint,
//     TextEditingController controller, {
//     bool isPassword = false,
//     IconData? icon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           prefixIcon: icon != null ? Icon(icon) : null,
//           hintText: hint,
//           filled: true,
//           fillColor: Colors.grey[100],
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     String hint,
//     TextEditingController controller, {
//     bool isPassword = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           hintText: hint,
//           border: OutlineInputBorder(),
//           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         ),
//       ),
//     );
//   }

//   Future<void> _submitProfileUpdate() async {
//     final success = await _accountService.updateAccountInfo(
//       user!.accountId!,
//       nameController.text.trim(),
//       phoneController.text.trim(),
//       addressController.text.trim(),
//     );
//     if (success) {
//       Navigator.pop(context); // Close dialog
//       _loadProfile(); // Refresh UI
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Profile updated!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update profile'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void showLoadingDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Không cho người dùng thoát
//       builder: (BuildContext context) {
//         return Center(child: CircularProgressIndicator());
//       },
//     );
//   }

//   Future<void> _submitPasswordUpdate() async {
//     if (newPwdController.text != retypePwdController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Passwords do not match'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     final success = await _accountService.updatePassword(
//       user!.accountId!,
//       currentPwdController.text.trim(),
//       newPwdController.text.trim(),
//     );

//     if (success) {
//       Navigator.pop(context); // Close dialog
//       _loadProfile();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Password updated successfully. Please login again.'),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 2),
//         ),
//       );

//       showLoadingDialog(context); // Hiện vòng xoáy loading
//       await Future.delayed(Duration(seconds: 2));
//       Navigator.pop(context);

//       await _accountService.logout(
//         context,
//       ); // Đăng xuất và chuyển hướng đến màn login
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update password'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading && user == null) {
//       return Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//     if (user == null) return Container();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Profile', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.red,
//         centerTitle: true,
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.red, Colors.redAccent],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.restaurant_menu, color: Colors.red),
//               title: Text('Menu'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/deals');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.favorite, color: Colors.red),
//               title: Text('Favorites'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/favorites');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.history, color: Colors.red),
//               title: Text('Order History'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/orderFollow');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.settings, color: Colors.red),
//               title: Text('Settings'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.contact_support, color: Colors.red),
//               title: Text('Contact Us'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/contact');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//           child: Column(
//             children: [
//               CircleAvatar(
//                 radius: 45,
//                 backgroundImage: AssetImage('assets/default.jpg'),
//               ),
//               SizedBox(height: 12),
//               Text(
//                 user!.accountUsername ?? 'Username',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 user!.accountRole ?? 'User',
//                 style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Joined 1 year ago',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//               ),
//               SizedBox(height: 32),

//               sectionTitle('Profile'),
//               profileItem(
//                 Icons.manage_accounts,
//                 'Customize Profile',
//                 _showEditProfileDialog,
//               ),

//               SizedBox(height: 20),
//               sectionTitle('Order'),
//               profileItem(Icons.local_shipping_outlined, 'Tracking Order', () {
//                 Navigator.pushNamed(context, '/orderFollow');
//               }),

//               SizedBox(height: 30),

//               SizedBox(height: 24),
//               TextButton(
//                 onPressed: () async {
//                   final confirm = await showDialog<bool>(
//                     context: context,
//                     builder: (_) => AlertDialog(
//                       title: Text('Confirm Logout'),
//                       content: Text('Are you sure you want to log out?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context, false),
//                           child: Text('Cancel'),
//                         ),
//                         TextButton(
//                           onPressed: () async {
//                             Navigator.pop(context, true);
//                             await _accountService.logout(context);
//                             setState(() {
//                               user = null;
//                               phoneController.clear();
//                               addressController.clear();
//                             });
//                           },
//                           child: Text('Logout'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 child: Text(
//                   'Sign Out',
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.red,
//         unselectedItemColor: Colors.grey,
//         currentIndex: 3,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
//         ],
//         onTap: (index) {
//           if (index == 0) Navigator.pushNamed(context, '/');
//           if (index == 1) Navigator.pushNamed(context, '/cart');
//           if (index == 2) print('Like tapped');
//           if (index == 3) Navigator.pushNamed(context, '/userProfile');
//         },
//       ),
//     );
//   }

//   Widget profileItem(IconData icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.deepPurple),
//       title: Text(title),
//       trailing: Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: onTap,
//     );
//   }

//   Widget sectionTitle(String text) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget textInputRow(
//     IconData icon,
//     TextEditingController controller,
//     String hint,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.red),
//           SizedBox(width: 12),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 hintText: hint,
//                 filled: true,
//                 fillColor: Colors.grey[100],
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide.none,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 10,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';
import 'package:fe_mobile_flutter/FE/models1/account.dart';
import 'package:fe_mobile_flutter/FE/services/account_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TblAccount? user;
  TextEditingController nameController = TextEditingController();
  TextEditingController currentPwdController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController retypePwdController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool _isLoading = false;
  final AccountService _accountService = AccountService();

  @override
  void dispose() {
    nameController.dispose();
    currentPwdController.dispose();
    newPwdController.dispose();
    retypePwdController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    print('🔄 _loadProfile() called');

    final accountId = await AuthStatus.getCurrentAccountId();
    print('🆔 Fetched accountId: $accountId');

    if (accountId == null) {
      print('⚠️ accountId is null, redirecting to login.');
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      user = await _accountService.getProfile(accountId);
      print('✅ User loaded: ${user?.accountUsername}, ID: ${user?.accountId}');

      if (user != null) {
        phoneController.text = user!.phoneNumber ?? '';
        addressController.text = user!.address ?? '';
      } else {
        print('⚠️ User object is null after fetch');
      }
    } catch (e) {
      print('❌ Error loading user profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    if (phoneController.text.isNotEmpty || addressController.text.isNotEmpty) {
      setState(() => _isLoading = true);
      try {
        final updatedUser = TblAccount(
          accountId: user!.accountId,
          accountUsername: user!.accountUsername,
          accountPassword: '',
          accountRole: user!.accountRole,
          phoneNumber: phoneController.text.trim().isNotEmpty
              ? phoneController.text.trim()
              : null,
          address: addressController.text.trim().isNotEmpty
              ? addressController.text.trim()
              : null,
        );
        user = await _accountService.updateProfile(
          user!.accountId!,
          updatedUser,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter at least one field to update'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showEditProfileDialog() {
    nameController.text = user?.accountUsername ?? '';
    phoneController.text = user?.phoneNumber ?? '';
    addressController.text = user?.address ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Customize Profile'),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.98,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _styledTextField(
                  'Username',
                  nameController,
                  icon: Icons.person,
                ),
                _styledTextField(
                  'Phone Number',
                  phoneController,
                  icon: Icons.phone,
                ),
                _styledTextField(
                  'Address',
                  addressController,
                  icon: Icons.home,
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _submitProfileUpdate,
                  icon: Icon(Icons.save),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  label: Text(
                    'Save Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 24),
                Divider(thickness: 1),
                Text(
                  'Reset Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                _styledTextField(
                  'Current Password',
                  currentPwdController,
                  isPassword: true,
                  icon: Icons.lock_outline,
                ),
                _styledTextField(
                  'New Password',
                  newPwdController,
                  isPassword: true,
                  icon: Icons.lock,
                ),
                _styledTextField(
                  'Retype New Password',
                  retypePwdController,
                  isPassword: true,
                  icon: Icons.lock_reset,
                ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _submitPasswordUpdate,
                  icon: Icon(Icons.refresh),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  label: Text(
                    'Update Password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _styledTextField(
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  // Widget _buildTextField(
  //   String hint,
  //   TextEditingController controller, {
  //   bool isPassword = false,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     child: TextField(
  //       controller: controller,
  //       obscureText: isPassword,
  //       decoration: InputDecoration(
  //         hintText: hint,
  //         border: OutlineInputBorder(),
  //         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //       ),
  //     ),
  //   );
  // } có thể bỏ

  Future<void> _submitProfileUpdate() async {
    final success = await _accountService.updateAccountInfo(
      user!.accountId!,
      nameController.text.trim(),
      phoneController.text.trim(),
      addressController.text.trim(),
    );
    if (success) {
      Navigator.pop(context); // Close dialog
      _loadProfile(); // Refresh UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Không cho người dùng thoát
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _submitPasswordUpdate() async {
    if (newPwdController.text != retypePwdController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final success = await _accountService.updatePassword(
      user!.accountId!,
      currentPwdController.text.trim(),
      newPwdController.text.trim(),
    );

    if (success) {
      Navigator.pop(context); // Close dialog
      _loadProfile();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password updated successfully. Please login again.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      showLoadingDialog(context); // Hiện vòng xoáy loading
      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);

      await _accountService.logout(
        context,
      ); // Đăng xuất và chuyển hướng đến màn login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && user == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (user == null) return Container();

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      drawer: Drawer(
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
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (user!.accountRole == 'admin') ...[
              ListTile(
                leading: Icon(Icons.admin_panel_settings, color: Colors.red),
                title: Text('Admin Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/admin/dashboard');
                },
              ),
              ListTile(
                leading: Icon(Icons.people, color: Colors.red),
                title: Text('User Management'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/userManagement');
                },
              ),
            ] else ...[
              ListTile(
                leading: Icon(Icons.restaurant_menu, color: Colors.red),
                title: Text('Menu'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/deals');
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite, color: Colors.red),
                title: Text('Favorites'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/favorites');
                },
              ),
              ListTile(
                leading: Icon(Icons.history, color: Colors.red),
                title: Text('Order History'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/orderFollow');
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.red),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '');
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_support, color: Colors.red),
                title: Text('Contact Us'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/contact');
                },
              ),
            ],
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 3,
        items: user!.accountRole == 'admin'
            ? [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Users',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Account',
                ),
              ]
            : [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Like',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Account',
                ),
              ],
        onTap: (index) {
          if (user!.accountRole == 'admin') {
            if (index == 0) Navigator.pushNamed(context, '/admin/dashboard');
            if (index == 1) Navigator.pushNamed(context, '/userManagement');
            if (index == 2) Navigator.pushNamed(context, '/adminSettings');
            if (index == 3) Navigator.pushNamed(context, '/userProfile');
          } else {
            if (index == 0) Navigator.pushNamed(context, '/');
            if (index == 1) Navigator.pushNamed(context, '/cart');
            if (index == 2) print('Like tapped');
            if (index == 3) Navigator.pushNamed(context, '/userProfile');
          }
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('assets/default.jpg'),
              ),
              SizedBox(height: 12),
              Text(
                user!.accountUsername ?? 'Username',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                user!.accountRole ?? 'User',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 8),
              Text(
                'Joined 1 year ago',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              SizedBox(height: 32),

              sectionTitle('Profile'),
              profileItem(
                Icons.account_circle,
                'Customize Profile',
                _showEditProfileDialog,
              ),

              if (user!.accountRole == 'admin') ...[
                SizedBox(height: 22),
                sectionTitle('User'),
                profileItem(
                  Icons.manage_accounts,
                  'User Management Profile',
                  () {
                    Navigator.pushNamed(context, '/userManagement');
                  },
                ),
              ],

              SizedBox(height: 25),
              sectionTitle('Order'),
              profileItem(Icons.local_shipping_outlined, 'Tracking Order', () {
                if (user!.accountRole == 'admin') {
                  Navigator.pushNamed(context, '/admin/orders');
                } else {
                  Navigator.pushNamed(context, '/orderFollow');
                }
              }),

              SizedBox(height: 30),

              SizedBox(height: 24),
              TextButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Confirm Logout'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context, true);
                            await _accountService.logout(context);
                            setState(() {
                              user = null;
                              phoneController.clear();
                              addressController.clear();
                            });
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget textInputRow(
    IconData icon,
    TextEditingController controller,
    String hint,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
