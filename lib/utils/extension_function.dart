import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String toFormatGeneralData() {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy');

    return dateFormat.format(this);
  }
}

extension IntX on int {
  String formatViewsCount() {
    if (this < 1000) {
      return toString();
    } else if (this < 1000000) {
      double kViews = this / 1000;
      return '${kViews.toStringAsFixed(kViews.truncateToDouble() == kViews ? 0 : 1)} k';
    } else {
      double mViews = this / 1000000;
      return '${mViews.toStringAsFixed(mViews.truncateToDouble() == mViews ? 0 : 1)} m';
    }
  }
}

extension StringTimeX on String {
  String toLocalTime() {
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(this);
    final now = DateTime.now();
    Duration diff = now.difference(tempDate);

    if (diff.inDays > 7) {
      return tempDate.toFormatGeneralData();
    } else if (diff.inDays == 7) {
      return 'One week ago';
    } else if (diff.inDays >= 1 && diff.inDays <= 6) {
      return '${diff.inDays} days ago';
    } else {
      return 'Today';
    }
  }
}
