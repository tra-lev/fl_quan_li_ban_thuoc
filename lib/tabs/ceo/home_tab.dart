import 'package:flutter/material.dart';
import '../../pages/ceo/tong_quan/chi_tiet_doanh_thu_page.dart';

class CeoHomeTab extends StatelessWidget {
  const CeoHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue]),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DOANH THU TOÀN CHUỖI', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('1,250,000,000 đ', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
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

          // Truyền context vào để chuyển trang
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
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
        leading: CircleAvatar(backgroundColor: iconColor.withOpacity(0.2), child: Icon(Icons.store, color: iconColor)),
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