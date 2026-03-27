import 'package:flutter/material.dart';
import 'package:fl_quan_li_ban_thuoc/pages/admin/kho_hang/add_thuoc.dart';

class InventoryListPage extends StatefulWidget {
  const InventoryListPage({Key? key}) : super(key: key);

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  // 1. Danh sách gốc (Dữ liệu nguồn không đổi)
  final List<Map<String, String>> _allMedicines = [
    {'name': 'Paracetamol 500mg', 'stock': '120', 'expiry': '20/12/2026', 'unit': 'Viên'},
    {'name': 'Amoxicillin 250mg', 'stock': '50', 'expiry': '15/05/2025', 'unit': 'Vỉ'},
    {'name': 'Vitamin C 1000mg', 'stock': '200', 'expiry': '01/01/2027', 'unit': 'Viên'},
    {'name': 'Panadol Extra', 'stock': '100', 'expiry': '10/06/2026', 'unit': 'Viên'},
  ];

  // 2. Danh sách hiển thị (Kết quả sau khi lọc)
  List<Map<String, String>> _foundMedicines = [];

  @override
  void initState() {
    super.initState();
    // Khi khởi tạo, danh sách hiển thị = danh sách gốc
    _foundMedicines = _allMedicines;
  }

  // --- LOGIC TÌM KIẾM THEO TỪNG KÝ TỰ ---
  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      // Nếu ô tìm kiếm trống, hiển thị lại tất cả
      results = _allMedicines;
    } else {
      // Lọc không phân biệt hoa thường (toLowerCase)
      results = _allMedicines
          .where((medicine) =>
          medicine['name']!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Cập nhật lại UI danh sách hiển thị
    setState(() {
      _foundMedicines = results;
    });
  }

  // --- CHỨC NĂNG THÊM THUỐC (Cập nhật insert vào list hiển thị) ---
  void _showAddMedicineDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddMedicineDialog(),
    );

    if (result != null) {
      setState(() {
        final newEntry = {
          'name': result['name'].toString(),
          'stock': result['stock'].toString(),
          'expiry': result['expiry'].toString(),
          'unit': result['unit'].toString(),
        };
        // Thêm vào cả 2 danh sách
        _allMedicines.insert(0, newEntry);
        _foundMedicines = _allMedicines;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã thêm thành công: ${result['name']}'), backgroundColor: Colors.green),
      );
    }
  }

  // --- CÁC HÀM XEM CHI TIẾT GIỮ NGUYÊN ---
  void _showProductDetails(Map<String, String> medicine) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(medicine['name']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const Divider(),
            _buildInfoRow(Icons.inventory_2, 'Tồn kho:', '${medicine['stock']} ${medicine['unit']}'),
            _buildInfoRow(Icons.date_range, 'Hạn sử dụng:', medicine['expiry']!),
            _buildInfoRow(Icons.category, 'Danh mục:', 'Thuốc kê đơn'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: const Text('ĐÓNG', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 10),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // THANH TÌM KIẾM
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => _runFilter(value), // GỌI HÀM LỌC TẠI ĐÂY
              decoration: InputDecoration(
                hintText: 'Tìm tên thuốc, hoạt chất...',
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
                // Thêm icon xóa nhanh từ khóa
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    // Logic xóa tìm kiếm nếu bạn gắn Controller cho TextField
                  },
                ),
              ),
            ),
          ),

          // DANH SÁCH HIỂN THỊ (Sử dụng _foundMedicines)
          Expanded(
            child: _foundMedicines.isNotEmpty
                ? ListView.builder(
              itemCount: _foundMedicines.length,
              itemBuilder: (context, index) {
                final item = _foundMedicines[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.medication, color: Colors.blue),
                    title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Tồn kho: ${item['stock']} | HSD: ${item['expiry']}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showProductDetails(item),
                  ),
                );
              },
            )
                : const Center(
              child: Text('Không tìm thấy thuốc phù hợp', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMedicineDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}