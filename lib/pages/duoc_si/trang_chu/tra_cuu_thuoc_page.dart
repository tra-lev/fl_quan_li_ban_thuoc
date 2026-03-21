import 'package:flutter/material.dart';

// =============================================================
// TRANG TRA CỨU THUỐC CHUYÊN BIỆT CHO DƯỢC SĨ
// Logic: Tìm kiếm đa điểm (Tên, Hoạt chất, Công dụng, Vị trí kệ)
// =============================================================
class TraCuuThuocPage extends StatefulWidget {
  const TraCuuThuocPage({Key? key}) : super(key: key);

  @override
  State<TraCuuThuocPage> createState() => _TraCuuThuocPageState();
}

class _TraCuuThuocPageState extends State<TraCuuThuocPage> {
  String _searchQuery = '';

  // Dữ liệu thuốc với cấu trúc chuyên sâu cho dược sĩ
  final List<Map<String, dynamic>> _medicineData = [
    {
      'id': 'SP001',
      'name': 'Panadol Extra',
      'activeIngredient': 'Paracetamol 500mg, Caffeine 65mg',
      'usage': 'Giảm đau đầu, đau răng, hạ sốt',
      'location': 'Kệ A - Ngăn 2',
      'stock': 150,
      'unit': 'Viên/Vỉ',
      'price': '5.000',
      'category': 'Giảm đau',
    },
    {
      'id': 'SP002',
      'name': 'Augmentin 625mg',
      'activeIngredient': 'Amoxicillin 500mg, Acid Clavulanic 125mg',
      'usage': 'Kháng sinh điều trị nhiễm khuẩn hô hấp',
      'location': 'Kệ B - Ngăn lạnh',
      'stock': 25,
      'unit': 'Viên/Hộp',
      'price': '18.000',
      'category': 'Kháng sinh',
    },
    {
      'id': 'SP003',
      'name': 'Siro Prospan',
      'activeIngredient': 'Cao khô lá thường xuân',
      'usage': 'Trị ho, long đờm, viêm phế quản',
      'location': 'Kệ C - Tầng 1',
      'stock': 10,
      'unit': 'Chai',
      'price': '75.000',
      'category': 'Hô hấp',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // LOGIC TRA CỨU KHÁC BIỆT:
    // Tìm trên 4 trường dữ liệu cùng lúc để dược sĩ phản ứng nhanh với yêu cầu khách hàng
    List<Map<String, dynamic>> results = _medicineData.where((m) {
      final query = _searchQuery.toLowerCase();
      return m['name'].toLowerCase().contains(query) ||
          m['activeIngredient'].toLowerCase().contains(query) ||
          m['usage'].toLowerCase().contains(query) ||
          m['id'].toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('TRA CỨU NHANH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // THANH TÌM KIẾM THÔNG MINH
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Tên thuốc, hoạt chất hoặc công dụng...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // DANH SÁCH KẾT QUẢ TỐI ƯU HIỂN THỊ
          Expanded(
            child: results.isEmpty
                ? _buildEmpty()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) => _buildMedicineTile(results[index]),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HIỂN THỊ CHI TIẾT THUỐC
  Widget _buildMedicineTile(Map<String, dynamic> item) {
    bool lowStock = item['stock'] < 20;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
          child: const Icon(Icons.medication, color: Colors.blue),
        ),
        title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        subtitle: Text(item['activeIngredient'], style: const TextStyle(fontSize: 13, color: Colors.blueGrey)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${item['price']}đ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
            Text(
              lowStock ? 'Sắp hết (${item['stock']})' : 'Tồn: ${item['stock']}',
              style: TextStyle(color: lowStock ? Colors.orange : Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const Divider(),
                _buildInfoRow(Icons.health_and_safety, 'Công dụng', item['usage']),
                _buildInfoRow(Icons.place, 'Vị trí kệ', item['location'], isHighlight: true),
                _buildInfoRow(Icons.category, 'Nhóm', item['category']),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        label: const Text('THÊM VÀO GIỎ'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                color: isHighlight ? Colors.orange.shade800 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          const Text('Không tìm thấy thuốc hoặc hoạt chất này', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}