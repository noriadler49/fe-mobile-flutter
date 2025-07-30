class TblAccount {
  final int accountId;
  final String accountUsername;
  final String accountPassword;
  final String accountRole;
  final String? phoneNumber;
  final String? address;

  // Relationships (can be used if needed)
  final List<dynamic>?
  tblCartItems; // You can replace dynamic with a CartItem model
  final List<dynamic>? tblOrders; // Replace dynamic with an Order model

  TblAccount({
    required this.accountId,
    required this.accountUsername,
    required this.accountPassword,
    required this.accountRole,
    this.phoneNumber,
    this.address,
    this.tblCartItems,
    this.tblOrders,
  });
  factory TblAccount.fromJson(Map<String, dynamic> json) {
    return TblAccount(
      accountId: json['accountId'],
      accountUsername: json['accountUsername'] ?? '',
      accountPassword:
          json['accountPassword'] ?? '', // Backend doesn't send this
      accountRole: json['accountRole'] ?? 'User',
      phoneNumber: json['phoneNumber'], // nullable
      address: json['address'], // nullable
      tblCartItems: json['tblCartItems'], // nullable or handle as empty list
      tblOrders: json['tblOrders'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'accountUsername': accountUsername,
      'accountPassword': accountPassword,
      'accountRole': accountRole,
      'phoneNumber': phoneNumber,
      'address': address,
      'tblCartItems': tblCartItems, // optionally serialize if needed
      'tblOrders': tblOrders,
    };
  }
}
