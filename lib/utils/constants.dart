class AppConstants {
  static const String CURRENCY_SYMBOL = '₹';
  
  static String formatPrice(dynamic amount) {
    if (amount == null) return '₹0.00';
    return '₹${amount.toStringAsFixed(2)}';
  }

  static String formatOfferPrice(dynamic amount) {
    if (amount == null) return '';
    return '₹${amount.toStringAsFixed(2)}';
  }
}
