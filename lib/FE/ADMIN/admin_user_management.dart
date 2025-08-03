import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/services/account_service.dart';
import 'package:fe_mobile_flutter/FE/models1/account.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  TextEditingController searchController = TextEditingController();
  List<TblAccount> _accounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() async {
    final service = AccountService();
    final result = await service.getAllAccounts();
    setState(() {
      _accounts = result;
    });
  }

  Future<void> showAccountFormDialog({
  required BuildContext context,
  TblAccount? account,
  required Function onSave,
}) async {
  final usernameController = TextEditingController(
    text: account?.accountUsername ?? '',
  );
  final phoneController = TextEditingController(
    text: account?.phoneNumber ?? '',
  );
  final addressController = TextEditingController(
    text: account?.address ?? '',
  );
  final passwordController = TextEditingController(); // always shown now
  String selectedRole = account?.accountRole ?? 'user';

  final isEditing = account != null;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(isEditing ? 'Edit Account' : 'Add Account'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: ['user', 'admin']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedRole = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText:
                      isEditing ? 'New Password (optional)' : 'Password',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final accountService = AccountService();
              final username = usernameController.text.trim();
              final phone = phoneController.text.trim();
              final address = addressController.text.trim();
              final password = passwordController.text.trim();

              if (isEditing) {
                await accountService.updateAccountInfo(
                  account!.accountId,
                  username,
                  phone,
                  address,
                );

                if (password.isNotEmpty) {
                  await accountService.adminResetPassword(
                    account.accountId,
                    password,
                  );
                }
              } else {
                if (password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password cannot be empty")),
                  );
                  return;
                }

                await accountService.createAccount(
                  username,
                  password,
                  selectedRole,
                  phone,
                  address,
                );
              }

              Navigator.pop(context);
              onSave();
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    final filteredAccounts = _accounts.where((acc) {
      final query = searchController.text.toLowerCase();
      return acc.accountUsername.toLowerCase().contains(query) ||
          (acc.phoneNumber?.toLowerCase().contains(query) ?? false);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                showAccountFormDialog(context: context, onSave: _loadAccounts),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Summary Info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.people, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    'Total Users: ${_accounts.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by username or phone...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 12),

            // User List
            Expanded(
              child: filteredAccounts.isEmpty
                  ? const Center(child: Text('No users found.'))
                  : ListView.separated(
                      itemCount: filteredAccounts.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final account = filteredAccounts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red[300],
                            child: Text(
                              account.accountUsername[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(account.accountUsername),
                          subtitle: Text(
                            '${account.phoneNumber ?? 'No Phone'} • ${account.address ?? 'No Address'}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => showAccountFormDialog(
                                  context: context,
                                  account: account,
                                  onSave: _loadAccounts,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final confirmed = await showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: const Text(
                                        'Are you sure you want to delete this account?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed == true) {
                                    final accountService = AccountService();
                                    await accountService.deleteAccount(
                                      account.accountId,
                                    );
                                    _loadAccounts();
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            showAccountFormDialog(context: context, onSave: _loadAccounts),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.person_add),
        label: const Text("Add User"),
      ),
    );
  }
}
