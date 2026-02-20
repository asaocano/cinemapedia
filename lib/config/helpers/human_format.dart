import 'package:intl/intl.dart';

class HumanFormat {
  static String numberTransform(double number) {
    return NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
      locale: 'en-US'
    ).format(number);
  }

  static String scoreTransform(double number){
    return NumberFormat.compactCurrency(
      decimalDigits: 2,
      symbol: '',
      locale: 'en-US'
    ).format(number);
  }
}
