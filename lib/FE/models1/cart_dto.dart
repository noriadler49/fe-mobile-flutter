class AddToCartDto {
  final int dishId;
  final int quantity;
  final int accountId;

  AddToCartDto({
    required this.dishId,
    required this.quantity,
    required this.accountId,
  });

  Map<String, dynamic> toJson() {
    return {'dishId': dishId, 'quantity': quantity, 'accountId': accountId};
  }
}
