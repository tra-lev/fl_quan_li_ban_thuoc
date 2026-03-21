import '../models/user_model.dart';
import 'local_storage_service.dart';

class AuthService {
  final LocalStorageService _storageService = LocalStorageService();

  Future<UserModel?> login(String username, String password) async {
    // 1. Kiểm tra tài khoản Admin
    if (username == 'admin' && password == '123') {
      await _storageService.saveRole('admin');
      return UserModel(username: username, role: 'admin');
    }
    // 2. Kiểm tra tài khoản CEO
    else if (username == 'CEO' && password == '123') {
      await _storageService.saveRole('CEO');
      return UserModel(username: username, role: 'CEO');
    }
    // 3. Kiểm tra tài khoản Dược sĩ
    else if (username == 'duocsi' && password == '123') {
      await _storageService.saveRole('duocsi');
      // Gửi dữ liệu Fullname đi
      return UserModel(username: username, role: 'duocsi', fullName: 'Nguyễn Văn A');
    }
    // 4. Trả về null nếu không khớp
    return null;
  }

  Future<void> logout() async {
    await _storageService.clearRole();
  }
}