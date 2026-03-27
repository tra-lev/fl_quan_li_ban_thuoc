import 'package:flutter/material.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryName;
  const CategoryDetailPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dữ liệu giả lập thuốc theo danh mục
    final List<Map<String, String>> medicines = [
      {'name': 'Paracetamol 500mg', 'price': '1.000đ', 'origin': 'Việt Nam', 'desc': 'Giảm đau, hạ sốt nhanh chóng.'},
      {'name': 'Hapacol 650', 'price': '2.500đ', 'origin': 'DHG Pharma', 'desc': 'Dùng cho các trường hợp đau đầu, sốt cao.'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(categoryName), backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final med = medicines[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.medication, color: Colors.blueAccent),
              title: Text(med['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Giá: ${med['price']} - Xuất xứ: ${med['origin']}'),
              trailing: const Icon(Icons.info_outline, color: Colors.grey),
              onTap: () => _showMedicineDetails(context, med), // Bấm để xem chi tiết
            ),
          );
        },
      ),
    );
  }

  // HÀM HIỂN THỊ CHI TIẾT THUỐC (Modal Bottom Sheet)
  void _showMedicineDetails(BuildContext context, Map<String, String> med) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 1. CHO PHÉP MỞ RỘNG CHIỀU CAO
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        // 2. BỌC TRONG SINGLECHILDSCROLLVIEW ĐỂ CUỘN ĐƯỢC
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Giúp Column chỉ chiếm diện tích vừa đủ
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)
                      )
                  )
              ),
              const SizedBox(height: 20),
              Text(
                  med['name']!,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent)
              ),
              const Divider(height: 30),
              _detailRow(Icons.monetization_on_outlined, 'Giá bán:', med['price']!),
              _detailRow(Icons.location_on_outlined, 'Nhà sản xuất:', med['origin']!),
              const SizedBox(height: 15),
              const Text('Mô tả sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                  med['desc']!,
                  style: const TextStyle(color: Colors.black87, height: 1.5)
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15)
                  ),
                  child: const Text('ĐÓNG', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 10),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}