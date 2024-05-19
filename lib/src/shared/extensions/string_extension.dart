extension StringExtension on String {
  toType(Type type) {
    switch (type) {
      case == String:
        return toString();
      case == int:
        return int.parse(this);
      default:
        return toString();
    }
  }

  toDuration() {
    List<String> parts = split(':');
    if (parts.length != 3) {
      throw FormatException('Invalid duration format');
    }
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    double seconds = double.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds.toInt());
  }
}
