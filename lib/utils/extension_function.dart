import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String toFormatGeneralData() {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

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

    if (diff.inDays > 4) {
      return tempDate.toFormatGeneralData();
    } else if (diff.inDays >= 1 && diff.inDays <= 4) {
      return '${diff.inDays}h';
    } else if (diff.inHours != 0) {
      return '${diff.inHours}j';
    } else if (diff.inMinutes != 0) {
      return '${diff.inMinutes}m';
    } else {
      return 'Baru saja';
    }
  }
}
