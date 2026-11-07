import 'package:intl/intl.dart';

final NumberFormat _money = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

String formatMoney(num value) => _money.format(value);
String formatDate(DateTime d) => DateFormat('d MMM yyyy').format(d);
String formatShortDate(DateTime d) => DateFormat('EEE, d MMM').format(d);
