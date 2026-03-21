import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../screens/login_screen.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  // 1. Khởi tạo Service xử lý đăng xuất
  static final AuthService _authService = AuthService();

  // 2. Hàm xử lý đăng xuất (Copy logic từ ProfileTab sang)
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Buộc người dùng phải chọn
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi hệ thống quản trị?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('HỦY', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Đóng Dialog

                // Thực hiện xóa dữ liệu đăng nhập (Token/Session)
                await _authService.logout();

                // Điều hướng về Login và XÓA SẠCH lịch sử các màn hình trước đó
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false, // Xóa sạch stack
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('ĐĂNG XUẤT'),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Cấu hình nhà thuốc',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 10),

          _buildSettingCard(
            title: 'Thông tin cửa hàng',
            subtitle: 'Tên tiệm, địa chỉ, hotline in trên hóa đơn',
            icon: Icons.storefront,
            onTap: () {},
          ),

          _buildSettingCard(
            title: 'Thuế & VAT',
            subtitle: 'Cấu hình mức thuế mặc định (hiện tại 5%)',
            icon: Icons.receipt_long,
            onTap: () {},
          ),

          const SizedBox(height: 24),
          const Text('Bảo mật & Hệ thống',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 10),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: const Text('Thông báo hết hạn'),
              subtitle: const Text('Cảnh báo khi thuốc còn dưới 3 tháng hạn dùng'),
              value: true,
              onChanged: (val) {},
              secondary: const Icon(Icons.notifications_active, color: Colors.orange),
            ),
          ),

          _buildSettingCard(
            title: 'Sao lưu dữ liệu',
            subtitle: 'Lần cuối: 2 giờ trước',
            icon: Icons.backup,
            trailing: const Icon(Icons.cloud_done, color: Colors.green),
            onTap: () {},
          ),

          const SizedBox(height: 32),

          // 3. NÚT ĐĂNG XUẤT ĐÃ ĐƯỢC CẬP NHẬT LOGIC
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton.icon(
              onPressed: () => _handleLogout(context),
              icon: const Icon(Icons.logout),
              label: const Text('ĐĂNG XUẤT HỆ THỐNG',
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                side: BorderSide(color: Colors.red.shade200),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget hỗ trợ vẽ các ô cài đặt cho sạch code
  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
    required VoidCallback onTap
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}