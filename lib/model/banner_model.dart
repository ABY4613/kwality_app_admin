class Banner {
  final int id;
  final String image;
  final bool status;
  static const String baseUrl = 'http://192.168.1.37:8000/api';

  Banner({
    required this.id,
    required this.image,
    required this.status,
  });

  String get fullImageUrl {
    if (image.startsWith('http')) {
      return image;
    }
    return '$baseUrl$image';
  }

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'],
      image: json['image'],
      status: json['status'],
    );
  }
}
