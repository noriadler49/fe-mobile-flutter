class TblVourcher {
  final int vourcherId;
  final String? vourcherCode;
  final double? voucherDiscountPercentage;

  TblVourcher({
    required this.vourcherId,
    this.vourcherCode,
    this.voucherDiscountPercentage,
  });

  factory TblVourcher.fromJson(Map<String, dynamic> json) {
    return TblVourcher(
      vourcherId: json['vourcherId'],
      vourcherCode: json['vourcherCode'],
      voucherDiscountPercentage: json['voucherDiscountPercentage'] != null
          ? (json['voucherDiscountPercentage'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vourcherId': vourcherId,
      'vourcherCode': vourcherCode,
      'voucherDiscountPercentage': voucherDiscountPercentage,
    };
  }
}
