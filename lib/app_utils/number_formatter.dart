import 'package:intl/intl.dart';

class NumberFormatter {
  static final formatterCurrency = new NumberFormat("#,##0.00", "en_US");
  static final formatterWholeNumber = new NumberFormat("#,##0", "en_US");

  static String formatCurrency(num number) {
    return formatterCurrency.format(number);
  }

  static String formatWholeNumber(num number) {
    return formatterWholeNumber.format(number);
  }
}
