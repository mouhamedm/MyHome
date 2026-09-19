class Formatters {
  Formatters._();

  static String formatCurrency(double amount) {
    final parts = amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
    return '$parts €';
  }

  static String formatCompactCurrency(double amount) {
    if (amount >= 1000000) {
      final val = (amount / 1000000).toStringAsFixed(1).replaceAll('.0', '').replaceAll('.', ',');
      return '$val M€';
    } else if (amount >= 1000) {
      final val = (amount / 1000).toStringAsFixed(0);
      return '$val k€';
    }
    return '${amount.toInt()} €';
  }

  static String formatArea(double areaSquareMeters) {
    return '${areaSquareMeters.toInt()} m²';
  }
}
