import 'package:flutter/material.dart';

class NotiTab extends StatefulWidget {
  const NotiTab({Key? key}) : super(key: key);

  @override
  _NotiTabState createState() => _NotiTabState();
}

class _NotiTabState extends State<NotiTab> {
  // MOCK DATA: Dữ liệu giả lập thông báo
  final List<Map<String, dynamic>> _mockNotifications = [
    {
      'id': 1,
      'title': 'Đơn hàng mới nhận',
      'message': 'Bạn có một đơn hàng mới #DH1028 từ khách hàng Nguyễn Văn A. Vui lòng kiểm tra và xử lý.',
      'time': '10 phút trước',
      'type': 'order', // order, warning, system
      'isRead': false, // Chưa đọc
    },
    {
      'id': 2,
      'title': 'Cảnh báo tồn kho',
      'message': 'Sản phẩm "Amoxicillin 500mg" đã hết hàng trong kho. Vui lòng nhập thêm thuốc.',
      'time': '1 giờ trước',
      'type': 'warning',
      'isRead': false,
    },
    {
      'id': 3,
      'title': 'Đơn hàng đã giao thành công',
      'message': 'Đơn hàng #DH1025 đã được giao thành công cho khách hàng.',
      'time': 'Hôm qua, 15:30',
      'type': 'success',
      'isRead': true, // Đã đọc
    },
    {
      'id': 4,
      'title': 'Cập nhật hệ thống',
      'message': 'Hệ thống sẽ bảo trì từ 23:00 đến 00:00 tối nay. Quý khách lưu ý không thao tác trong thời gian này.',
      'time': 'Hôm qua, 09:00',
      'type': 'system',
      'isRead': true,
    },
  ];

  // Lấy icon và màu sắc tương ứng với loại thông báo
  IconData _getIconData(String type) {
    switch (type) {
      case 'order': return Icons.shopping_bag;
      case 'warning': return Icons.warning_amber_rounded;
      case 'success': return Icons.check_circle;
      case 'system': return Icons.info;
      default: return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'order': return Colors.blue;
      case 'warning': return Colors.orange;
      case 'success': return Colors.green;
      case 'system': return Colors.grey.shade700;
      default: return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // 1. Tiêu đề Xanh dương
          Container(
            width: double.infinity,
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              'THÔNG BÁO',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // 2. Nút "Đánh dấu tất cả đã đọc"
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      for (var noti in _mockNotifications) {
                        noti['isRead'] = true;
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã đánh dấu tất cả là đã đọc'))
                    );
                  },
                  icon: const Icon(Icons.done_all, color: Colors.blue, size: 20),
                  label: const Text('Đánh dấu tất cả đã đọc', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.black12),

          // 3. Danh sách thông báo
          Expanded(
            child: _mockNotifications.isEmpty
                ? const Center(child: Text('Bạn không có thông báo nào.', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              itemCount: _mockNotifications.length,
              itemBuilder: (context, index) {
                final noti = _mockNotifications[index];
                bool isRead = noti['isRead'];

                return InkWell(
                  onTap: () {
                    // Chuyển trạng thái thành đã đọc khi bấm vào
                    setState(() {
                      noti['isRead'] = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      // Nền hơi xanh nếu chưa đọc, trắng nếu đã đọc
                      color: isRead ? Colors.white : Colors.blue.shade50,
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _getIconColor(noti['type']).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_getIconColor(noti['type']) == Colors.orange ? Icons.warning : _getIconData(noti['type']),
                              color: _getIconColor(noti['type']), size: 24),
                        ),
                        const SizedBox(width: 16),

                        // Nội dung
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                noti['title'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                                  color: isRead ? Colors.black87 : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                noti['message'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isRead ? Colors.grey[600] : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                noti['time'],
                                style: TextStyle(fontSize: 12, color: Colors.blue[300]),
                              ),
                            ],
                          ),
                        ),

                        // Dấu chấm xanh báo chưa đọc
                        if (!isRead)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}