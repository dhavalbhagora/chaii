class Shop {
  final String shopName;
  final String shopId;

  Shop({required this.shopName, required this.shopId});

  // Factory constructor to create an instance from JSON
  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      shopName: json['shopname'],
      shopId: json['shopid'],
    );
  }

  // Convert the object to JSON (if needed for other use cases)
  Map<String, dynamic> toJson() {
    return {
      'shopname': shopName,
      'shopid': shopId,
    };
  }
}
