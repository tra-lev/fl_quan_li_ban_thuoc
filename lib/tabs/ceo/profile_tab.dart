import 'package:flutter/material.dart';
import '../../screens/login_screen.dart';
import '../../services/auth_service.dart';

class CeoProfileTab extends StatelessWidget {
  const CeoProfileTab({Key? key}) : super(key: key);

  // HÀM XỬ LÝ ĐĂNG XUẤT ĐÃ THÊM HỘP THOẠI XÁC NHẬN (CONFIRM)
  void _dangXuat(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Bắt buộc người dùng phải chọn 1 trong 2 nút
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản Giám Đốc?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            // Nút Hủy
            TextButton(
              onPressed: () => Navigator.pop(context), // Đóng hộp thoại
              child: const Text('HỦY', style: TextStyle(color: Colors.grey)),
            ),
            // Nút Đăng Xuất chính thức
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Đóng hộp thoại trước

                await AuthService().logout(); // Xóa phiên lưu trữ

                // Đá văng ra màn hình Login
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('ĐĂNG XUẤT', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Tài khoản của tôi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. THÔNG TIN AVATAR
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blueAccent, width: 3),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.admin_panel_settings, size: 50, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 16),
            const Text('GIÁM ĐỐC ĐIỀU HÀNH', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const Text('Quản trị viên Cấp cao nhất', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 30),

            // 2. CÁC MENU CÀI ĐẶT
            _buildMenuOption(Icons.lock_reset, 'Đổi mật khẩu', () {}),
            _buildMenuOption(Icons.settings, 'Cài đặt hệ thống', () {}),
            _buildMenuOption(Icons.help_outline, 'Trợ giúp & Hỗ trợ', () {}),

            const SizedBox(height: 40),

            // 3. NÚT ĐĂNG XUẤT ĐỎ CHÓT
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => _dangXuat(context), // Gọi hàm hiển thị Dialog
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('ĐĂNG XUẤT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Colors.blue[800]),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}