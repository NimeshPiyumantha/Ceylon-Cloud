class Items {
  final int itemId;
  final String barcode;
  final String itemName;
  final double costPrice;
  final String itemCategory;

  Items({
    required this.itemId,
    required this.barcode,
    required this.itemName,
    required this.costPrice,
    required this.itemCategory,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      itemId: json['itemId'] as int? ?? 0,
      barcode: json['barcode'] as String? ?? '',
      itemName: json['itemName'] as String? ?? 'Unknown',
      costPrice: (json['costPrice'] as num?)?.toDouble() ?? 0.0,
      itemCategory: json['itemCategory'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'barcode': barcode,
      'itemName': itemName,
      'costPrice': costPrice,
      'itemCategory': itemCategory,
    };
  }
}
