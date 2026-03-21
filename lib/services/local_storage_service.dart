import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _roleKey = 'user_role';

  // Lưu role khi đăng nhập thành công
  Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
  }

  // Lấy role để kiểm tra ở màn hình Splash
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  // Xóa thông tin khi đăng xuất
  Future<void> clearRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_roleKey);
  }
}