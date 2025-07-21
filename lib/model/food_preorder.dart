class FoodPreOrder {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String address;
  final String pincode;
  final DateTime deliveryDate;
  final DateTime createdAt;
  final double totalAmount;
  final String status;
  final List<PreOrderItem> orderItems;

  FoodPreOrder({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.pincode,
    required this.deliveryDate,
    required this.createdAt,
    required this.totalAmount,
    required this.status,
    required this.orderItems,
  });

  factory FoodPreOrder.fromJson(Map<String, dynamic> json) {
    return FoodPreOrder(
      id: json['id'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      pincode: json['pincode'],
      deliveryDate: DateTime.parse(json['delivery_date']),
      createdAt: DateTime.parse(json['created_at']),
      totalAmount: double.parse(json['total_amount'].toString()),
      status: json['status'],
      orderItems: (json['order_items'] as List)
          .map((item) => PreOrderItem.fromJson(item))
          .toList(),
    );
  }
}

class PreOrderItem {
  final int id;
  final int quantity;
  final double totalAmount;
  final Map<String, dynamic> foodItemDetails;

  PreOrderItem({
    required this.id,
    required this.quantity,
    required this.totalAmount,
    required this.foodItemDetails,
  });

  factory PreOrderItem.fromJson(Map<String, dynamic> json) {
    return PreOrderItem(
      id: json['id'],
      quantity: json['quantity'],
      totalAmount: double.parse(json['total_amount'].toString()),
      foodItemDetails: json['food_item_details'],
    );
  }
}