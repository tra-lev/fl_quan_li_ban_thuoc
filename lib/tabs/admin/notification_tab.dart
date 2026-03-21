import 'package:flutter/material.dart';

class NotificationTab extends StatelessWidget {
  const NotificationTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Thông báo hệ thống', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text('Đánh dấu đã đọc', style: TextStyle(color: Colors.blue))
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildSectionHeader('Hôm nay'),
          _buildNotificationItem(
            title: 'Cảnh báo: Thuốc sắp hết hạn',
            content: 'Lô thuốc Hapacol 250 (Mã: HP02) sẽ hết hạn trong 15 ngày tới. Hãy kiểm tra và xử lý.',
            time: '10 phút trước',
            icon: Icons.history_toggle_off,
            color: Colors.red,
            isUnread: true,
          ),
          _buildNotificationItem(
            title: 'Sắp hết hàng',
            content: 'Sản phẩm Vitamin C 500mg chỉ còn 5 hộp trong kho. Hãy tạo đơn nhập hàng mới.',
            time: '2 giờ trước',
            icon: Icons.inventory_2_outlined,
            color: Colors.orange,
            isUnread: true,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Trước đó'),
          _buildNotificationItem(
            title: 'Nhân sự mới',
            content: 'Dược sĩ Trần Thị C vừa được cấp quyền truy cập vào hệ thống bán hàng.',
            time: 'Yesterday',
            icon: Icons.person_add_alt_1,
            color: Colors.blue,
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String content,
    required String time,
    required IconData icon,
    required Color color,
    required bool isUnread,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isUnread ? BorderSide(color: color.withOpacity(0.3)) : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
            Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(content, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
        ),
        onTap: () {
          // Logic khi bấm vào thông báo (Ví dụ: nhảy sang tab Kho)
        },
      ),
    );
  }
}