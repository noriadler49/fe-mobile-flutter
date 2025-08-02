class TblIngredient {
  final int? ingredientId;
  final String? ingredientName;

  TblIngredient({this.ingredientId, this.ingredientName});

  factory TblIngredient.fromJson(Map<String, dynamic> json) {
    return TblIngredient(
      ingredientId: json['ingredientId'],
      ingredientName: json['ingredientName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'ingredientId': ingredientId, 'ingredientName': ingredientName};
  }
}
