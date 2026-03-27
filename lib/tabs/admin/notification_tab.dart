import 'package:flutter/material.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({Key? key}) : super(key: key);

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  // 1. Danh sách dữ liệu thông báo
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'Cảnh báo: Thuốc sắp hết hạn',
      'content': 'Lô thuốc Hapacol 250 (Mã: HP02) sẽ hết hạn trong 15 ngày tới.',
      'time': '10 phút trước',
      'icon': Icons.history_toggle_off,
      'color': Colors.red,
      'isUnread': true,
    },
    {
      'id': 2,
      'title': 'Sắp hết hàng',
      'content': 'Sản phẩm Vitamin C 500mg chỉ còn 5 hộp trong kho.',
      'time': '2 giờ trước',
      'icon': Icons.inventory_2_outlined,
      'color': Colors.orange,
      'isUnread': true,
    },
    {
      'id': 3,
      'title': 'Nhân sự mới',
      'content': 'Dược sĩ Trần Thị C vừa được cấp quyền truy cập hệ thống.',
      'time': 'Hôm qua',
      'icon': Icons.person_add_alt_1,
      'color': Colors.blue,
      'isUnread': false,
    },
  ];

  // 2. Hàm đánh dấu tất cả là đã đọc
  void _markAllAsRead() {
    setState(() {
      for (var item in _notifications) {
        item['isUnread'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã đánh dấu tất cả là đã đọc'), behavior: SnackBarBehavior.floating),
    );
  }

  // 3. Hàm đọc từng thông báo
  void _markAsRead(int id) {
    setState(() {
      final index = _notifications.indexWhere((element) => element['id'] == id);
      if (index != -1) {
        _notifications[index]['isUnread'] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách cho 2 phần
    final unreadList = _notifications.where((n) => n['isUnread'] == true).toList();
    final readList = _notifications.where((n) => n['isUnread'] == false).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Thông báo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          if (unreadList.isNotEmpty)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Đánh dấu tất cả', style: TextStyle(color: Colors.blue)),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (unreadList.isNotEmpty) ...[
            _buildSectionHeader('Chưa đọc (${unreadList.length})'),
            ...unreadList.map((n) => _buildNotificationItem(n)),
          ],
          if (readList.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionHeader('Đã đọc'),
            ...readList.map((n) => _buildNotificationItem(n)),
          ],
          if (_notifications.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: Text('Không có thông báo nào'),
            )),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(title.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 12, letterSpacing: 1.1)),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> data) {
    bool isUnread = data['isUnread'];
    Color color = data['color'];

    return Card(
      elevation: isUnread ? 2 : 0, // Thông báo chưa đọc sẽ nổi lên một chút
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isUnread ? BorderSide(color: color.withOpacity(0.2)) : BorderSide.none,
      ),
      child: InkWell( // Dùng InkWell để có hiệu ứng gợn sóng khi bấm
        onTap: () => _markAsRead(data['id']),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUnread ? Colors.white : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon trạng thái
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isUnread ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(data['icon'], color: isUnread ? color : Colors.grey, size: 22),
              ),
              const SizedBox(width: 12),
              // Nội dung
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data['title'],
                            style: TextStyle(
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                                color: isUnread ? Colors.black : Colors.grey[600],
                                fontSize: 14
                            )),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(data['content'],
                        style: TextStyle(fontSize: 13, color: isUnread ? Colors.black87 : Colors.grey, height: 1.4)),
                    const SizedBox(height: 8),
                    Text(data['time'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}