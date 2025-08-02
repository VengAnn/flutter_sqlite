/// Usage example:
/**
 void main() {
  final now = DateTime.now();
  final formattedDate = DateFormatter.format(now, 'dd-MM-yyyy');
  print(formattedDate);  // e.g. 17-09-2025
  print(DateFormatter.format(now, 'dd/MM/yyyy HH:mm')); // 01/08/2025 18:30
  print(DateFormatter.format(now, 'dd-MM-yyyy HH:mm')); // 01-08-2025 18:30
  print(DateFormatter.format(now, 'dd.MM.yyyy HH:mm')); // 01.08.2025 18:30
  print(DateFormatter.format(now, 'yyyy_MM_dd'));       // 2025_08_01
}

 */
///
///
class DateFormatter {
  static String format(DateTime dt, String format) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String fourDigits(int n) => n.toString().padLeft(4, '0');

    final replacements = <String, String>{
      'yyyy': fourDigits(dt.year),
      'yy': dt.year.toString().substring(2),
      'MM': twoDigits(dt.month),
      'M': dt.month.toString(),
      'dd': twoDigits(dt.day),
      'd': dt.day.toString(),
      'HH': twoDigits(dt.hour),
      'H': dt.hour.toString(),
      'mm': twoDigits(dt.minute),
      'm': dt.minute.toString(),
      'ss': twoDigits(dt.second),
      's': dt.second.toString(),
    };

    String formatted = format;
    replacements.forEach((key, value) {
      formatted = formatted.replaceAll(key, value);
    });

    return formatted;
  }
}
