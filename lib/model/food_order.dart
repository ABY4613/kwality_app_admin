class FoodOrder {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String address;
  final String landmark;
  final String status;
  final DateTime createdAt;
  final double totalAmount;
  final int userId;
  final List<FoodOrderItem> orderItems;

  FoodOrder({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.landmark,
    required this.status,
    required this.createdAt,
    required this.totalAmount,
    required this.userId,
    required this.orderItems,
  });

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    return FoodOrder(
      id: json['id'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      landmark: json['landmark'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      totalAmount: double.parse(json['total_amount']),
      userId: json['user'],
      orderItems: (json['order_items'] as List)
          .map((item) => FoodOrderItem.fromJson(item))
          .toList(),
    );
  }
}

class FoodOrderItem {
  final int id;
  final Map<String, dynamic> foodItemDetails;
  final int quantity;
  final double totalAmount;

  FoodOrderItem({
    required this.id,
    required this.foodItemDetails,
    required this.quantity,
    required this.totalAmount,
  });

  factory FoodOrderItem.fromJson(Map<String, dynamic> json) {
    return FoodOrderItem(
      id: json['id'],
      foodItemDetails: json['food_item_details'],
      quantity: json['quantity'],
      totalAmount: double.parse(json['total_amount'].toString()),
    );
  }
}