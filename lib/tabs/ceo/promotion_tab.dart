import 'package:flutter/material.dart';
import '../../pages/ceo/khuyen_mai/tao_khuyen_mai_page.dart';

class CeoPromotionTab extends StatefulWidget {
  const CeoPromotionTab({Key? key}) : super(key: key);

  @override
  State<CeoPromotionTab> createState() => _CeoPromotionTabState();
}

class _CeoPromotionTabState extends State<CeoPromotionTab> {
  bool _kmTet = true;
  bool _kmHe = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text('Khuyến mãi toàn hệ thống', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaoKhuyenMaiPage()),
              );
            },
            icon: const Icon(Icons.add_box, color: Colors.white),
            label: const Text('Phát hành Khuyến Mãi Mới', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(height: 20),

        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.local_offer, color: Colors.redAccent, size: 30),
            title: const Text('Giảm 10% dịp Lễ 30/4', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Phạm vi: Toàn chuỗi'),
            trailing: Switch(value: _kmTet, onChanged: (val) => setState(() => _kmTet = val), activeColor: Colors.blueAccent),
          ),
        ),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.local_offer, color: Colors.grey, size: 30),
            title: const Text('Flash Sale Chào Hè', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Phạm vi: Toàn chuỗi'),
            trailing: Switch(value: _kmHe, onChanged: (val) => setState(() => _kmHe = val), activeColor: Colors.blueAccent),
          ),
        ),

        const SizedBox(height: 30),
        const Text('Cấu hình giá bán theo chi nhánh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildPriceRuleCard('Chi nhánh Quận 1', 'Áp dụng Giá Chuẩn (0%)', Colors.green),
        _buildPriceRuleCard('Chi nhánh Quận 3', 'Bán cao hơn Giá Chuẩn (+5%)', Colors.orange),
        _buildPriceRuleCard('Chi nhánh Thủ Đức', 'Bán thấp hơn Giá Chuẩn (-2%)', Colors.blue),
      ],
    );
  }

  Widget _buildPriceRuleCard(String branch, String rule, Color color) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(branch, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(rule, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.tune, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}