import 'package:flutter/material.dart';
import '../../pages/ceo/tong_quan/chi_tiet_doanh_thu_page.dart';
import '../../data/notification_data.dart';

class CeoHomeTab extends StatefulWidget {
  const CeoHomeTab({Key? key}) : super(key: key);

  @override
  State<CeoHomeTab> createState() => _CeoHomeTabState();
}

class _CeoHomeTabState extends State<CeoHomeTab> {
  // Hàm xử lý xóa thông báo dựa trên Object thay vì Index đơn thuần để tránh sai lệch
  void _removeNotification(Map<String, dynamic> noti) {
    setState(() {
      globalCeoNotifications.remove(noti);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa thông báo'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- PHẦN HIỂN THỊ THÔNG BÁO CHO CEO (ĐÃ SỬA LỖI) ----------
          if (globalCeoNotifications.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: ExpansionTile(
                initiallyExpanded: true,
                shape: const Border(),
                leading: const Icon(Icons.notifications_active, color: Colors.orange),
                title: Text(
                  'Bạn có ${globalCeoNotifications.length} thông báo mới',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                // SỬA TẠI ĐÂY: Dùng .map từ entries để cố định dữ liệu và Key
                children: globalCeoNotifications.map((noti) {
                  return Dismissible(
                    // SỬA LỖI: Dùng UniqueKey để Flutter định danh lại widget sau khi xóa
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      _removeNotification(noti);
                    },
                    child: ListTile(
                      dense: true,
                      title: Text(noti['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(noti['content']),
                      trailing: Text(noti['time'],
                          style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ),
                  );
                }).toList(),
              ),
            ),
          // -----------------------------------------------------

          // Card Doanh thu tổng
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue]),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DOANH THU TOÀN CHUỖI',
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('1,250,000,000 đ',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('+15% so với tháng trước', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
                Icon(Icons.trending_up, color: Colors.white, size: 50),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text('So sánh chi nhánh (Tháng này)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          _buildBranchCard(context, 'Chi nhánh 1 (Quận 1)', '500 Tr', '1,200 đơn', Colors.green),
          _buildBranchCard(context, 'Chi nhánh 2 (Quận 3)', '450 Tr', '1,050 đơn', Colors.orange),
          _buildBranchCard(context, 'Chi nhánh 3 (Thủ Đức)', '300 Tr', '800 đơn', Colors.purple),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download),
              label: const Text('Xuất Báo Cáo Tổng (Excel)', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBranchCard(BuildContext context, String name, String revenue, String orders, Color iconColor) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.2),
            child: Icon(Icons.store, color: iconColor)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Doanh thu: $revenue | Số đơn: $orders'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChiTietDoanhThuPage(tenChiNhanh: name)),
          );
        },
      ),
    );
  }
}