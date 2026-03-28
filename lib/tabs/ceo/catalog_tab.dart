import 'package:flutter/material.dart';
import '../../pages/ceo/danh_muc/them_thuoc_moi_page.dart';

class CeoCatalogTab extends StatelessWidget {
  const CeoCatalogTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Để lộ nền xám của khung Dashboard
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Tìm kiếm thuốc, barcode...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0)
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDrugItem('Panadol Extra', 'Barcode: 893123456', '15,000 đ'),
                _buildDrugItem('Amoxicillin 500mg', 'Barcode: 893654321', '25,000 đ'),
                _buildDrugItem('Vitamin C 1000mg', 'Barcode: 893987654', '50,000 đ'),
                _buildDrugItem('Thuốc ho Bảo Thanh', 'Barcode: 893112233', '35,000 đ'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ThemThuocMoiPage()),
          );
        },
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm Mã Thuốc', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildDrugItem(String name, String barcode, String price) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.medical_services, color: Colors.blueAccent)
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$barcode\nGiá chuẩn: $price'),
        isThreeLine: true,
        trailing: IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: (){}),
      ),
    );
  }
}