class UserSession {
  static int? userId;
  static String? username;

  static void setSession({required int id, required String name}) {
    userId = id;
    username = name;
  }

  static void clear() {
    userId = null;
    username = null;
  }
}
