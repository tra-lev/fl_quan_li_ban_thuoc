import 'package:flutter/material.dart'; // <--- Thư viện gốc chống 82 lỗi
import 'package:intl/intl.dart';

import '../../pages/ceo/danh_muc/them_thuoc_moi_page.dart';
import '../../pages/admin/kho_hang/category_page.dart';
import '../../pages/ceo/nha_cung_cap/supplier_page.dart';
import '../../data/medicine_data.dart';

class CeoCatalogTab extends StatelessWidget {
  const CeoCatalogTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          toolbarHeight: 0,
          bottom: const TabBar(
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blueAccent,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Thuốc chuẩn', icon: Icon(Icons.medical_services, size: 20)),
              Tab(text: 'Nhóm thuốc', icon: Icon(Icons.category, size: 20)),
              Tab(text: 'Đối tác (NCC)', icon: Icon(Icons.business, size: 20)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ThuocChuanView(), // View Danh mục thuốc gốc
            CategoryTab(),     // Quản lý Nhóm thuốc
            SupplierTab(),     // Form Nhà cung cấp
          ],
        ),
      ),
    );
  }
}

// CHUYỂN THÀNH STATEFUL WIDGET ĐỂ GIAO DIỆN TỰ CẬP NHẬT KHI CÓ THUỐC MỚI
class _ThuocChuanView extends StatefulWidget {
  const _ThuocChuanView();

  @override
  State<_ThuocChuanView> createState() => _ThuocChuanViewState();
}

class _ThuocChuanViewState extends State<_ThuocChuanView> {
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Bộ lọc thông minh lấy data từ globalMedicines
    final filteredList = globalMedicines.where((m) =>
    m['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (m['barcode']?.toString() ?? '').contains(_searchQuery)
    ).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
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
            child: filteredList.isEmpty
                ? const Center(child: Text('Chưa có thuốc nào trong hệ thống', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final med = filteredList[index];
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
                      title: Text(med['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Barcode: ${med['barcode'] ?? 'N/A'}\nGiá chuẩn: ${formatCurrency.format(med['price'] ?? 0)} / ${med['unit'] ?? ''}'),
                      isThreeLine: true,
                      trailing: IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: (){}),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Lệnh await: Chờ CEO nhập xong và quay lại thì tự động làm mới màn hình (setState)
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ThemThuocMoiPage()),
          );
          if (result == true) {
            setState(() {});
          }
        },
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm Mã Thuốc', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}