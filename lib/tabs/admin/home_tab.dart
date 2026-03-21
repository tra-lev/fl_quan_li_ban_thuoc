import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Kiểm tra độ rộng của cửa sổ ứng dụng
    // Nếu chiều rộng nhỏ hơn 1100px (khi chia đôi màn hình), ta sẽ chuyển sang xếp dọc
    bool isNarrow = MediaQuery.of(context).size.width < 1100;

    return SingleChildScrollView( // 2. Thêm cuộn dọc để tránh lỗi tràn màn hình khi các thẻ xếp chồng lên nhau
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng quan Hệ thống',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // 3. Hiển thị dạng Column (dọc) nếu hẹp, ngược lại hiển thị Row (ngang)
          if (isNarrow)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Kéo dãn các thẻ tràn toàn bộ bề ngang
              children: [
                _buildSummaryCard('Thuốc sắp hết hạn', '12', Colors.redAccent, Icons.warning_amber_rounded),
                const SizedBox(height: 16), // Khoảng cách dọc
                _buildSummaryCard('Dược sĩ đang hoạt động', '4', Colors.green, Icons.person_pin),
                const SizedBox(height: 16),
                _buildSummaryCard('Đơn nhập chờ duyệt', '3', Colors.orange, Icons.inventory_2_outlined),
              ],
            )
          else
            Row(
              children: [
                Expanded(child: _buildSummaryCard('Thuốc sắp hết hạn', '12', Colors.redAccent, Icons.warning_amber_rounded)),
                const SizedBox(width: 16), // Khoảng cách ngang
                Expanded(child: _buildSummaryCard('Dược sĩ đang hoạt động', '4', Colors.green, Icons.person_pin)),
                const SizedBox(width: 16),
                Expanded(child: _buildSummaryCard('Đơn nhập chờ duyệt', '3', Colors.orange, Icons.inventory_2_outlined)),
              ],
            ),
        ],
      ),
    );
  }

  // 4. Xóa Widget `Expanded` bọc bên ngoài ở đây để có thể dùng linh hoạt trong cả Row và Column
  Widget _buildSummaryCard(String title, String count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            count,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }
}