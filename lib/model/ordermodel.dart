class OrderModel {
  final String id;
  final String productName;
  final int quantity;
  // Add more fields if necessary

  OrderModel({
    required this.id,
    required this.productName,
    required this.quantity,
    // Initialize more fields here
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      // Initialize more fields here
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'quantity': quantity,
      // Add more fields here
    };
  }
}
