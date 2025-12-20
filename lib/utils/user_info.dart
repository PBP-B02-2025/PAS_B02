import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  // Simpan informasi user saat login
  static Future<void> saveUserInfo(
      String username, bool isSuperuser, bool isStaff) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setBool('is_superuser', isSuperuser);
    await prefs.setBool('is_staff', isStaff);
  }

  // Ambil username
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  // Cek apakah user adalah superuser/admin
  static Future<bool> isSuperuser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_superuser') ?? false;
  }

  // Cek apakah user adalah staff
  static Future<bool> isStaff() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_staff') ?? false;
  }

  // Ambil semua informasi user
  static Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString('username') ?? '',
      'is_superuser': prefs.getBool('is_superuser') ?? false,
      'is_staff': prefs.getBool('is_staff') ?? false,
    };
  }

  // Hapus informasi user saat logout
  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('is_superuser');
    await prefs.remove('is_staff');
  }
}
