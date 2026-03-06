class Helpers {
  static String trim(String value) => value.trim();

  static bool isEmpty(String value) {
    return value.trim().isEmpty;
  }

  static void debugLog(String message) {
    // ignore: avoid_print
    print("[DEBUG] $message");
  }
}
