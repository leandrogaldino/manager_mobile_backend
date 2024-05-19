extension DurationExtension on Duration {
  String formatedString() {
    String twoDigits(int n) {
      return n.toString().padLeft(2, '0');
    }

    String hours = twoDigits(inHours);
    String minutes = twoDigits(inMinutes.remainder(60));
    String seconds = twoDigits(inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }
}
