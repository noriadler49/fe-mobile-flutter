
class User {
  final int? accountId;
  final String? accountUsername;
  final String? accountPassword; // Only for creation, not returned by API
  final String? accountRole;
  final String? phoneNumber;
  final String? address;

  User({
    this.accountId,
    this.accountUsername,
    this.accountPassword,
    this.accountRole,
    this.phoneNumber,
    this.address,
  });

  // Manual fromJson
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accountId: json['AccountId'] as int?,
      accountUsername: json['AccountUsername'] as String?,
      accountPassword: json['AccountPassword'] as String?, // Typically null from API
      accountRole: json['AccountRole'] as String?,
      phoneNumber: json['PhoneNumber'] as String?,
      address: json['Address'] as String?,
    );
  }

  // Manual toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'AccountUsername': accountUsername,
      'AccountPassword': accountPassword,
      'PhoneNumber': phoneNumber,
      'Address': address,
    };
    if (accountId != null) data['AccountId'] = accountId;
    if (accountRole != null) data['AccountRole'] = accountRole;
    return data..removeWhere((key, value) => value == null);
  }
}