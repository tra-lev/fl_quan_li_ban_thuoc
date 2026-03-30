import 'package:flutter/material.dart';
import '../../../data/medicine_data.dart'; // IMPORT KHO TỔNG ĐỂ LƯU

class ThemThuocMoiPage extends StatefulWidget {
  const ThemThuocMoiPage({Key? key}) : super(key: key);

  @override
  State<ThemThuocMoiPage> createState() => _ThemThuocMoiPageState();
}

class _ThemThuocMoiPageState extends State<ThemThuocMoiPage> {
  String _dvt = 'Hộp';

  // Tạo "máy thu" để hứng chữ từ bàn phím
  final _barcodeCtrl = TextEditingController();
  final _tenThuocCtrl = TextEditingController();
  final _giaBanCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Mã Thuốc Chuẩn', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (Phần Icon Camera giữ nguyên cho gọn)
            Center(
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blueAccent, width: 2)),
                child: const Icon(Icons.add_a_photo, size: 40, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 24),

            // Gắn controller vào các ô nhập
            TextField(
              controller: _barcodeCtrl,
              decoration: InputDecoration(labelText: 'Mã Barcode', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.qr_code)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tenThuocCtrl,
              decoration: InputDecoration(labelText: 'Tên thuốc / Biệt dược', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.medical_services)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _dvt,
                    decoration: InputDecoration(labelText: 'Đơn vị tính', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    items: ['Hộp', 'Vỉ', 'Viên', 'Lọ', 'Tuýp'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _dvt = val!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _giaBanCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Giá chuẩn (VNĐ)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_tenThuocCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập tên thuốc!'), backgroundColor: Colors.red));
                    return;
                  }

                  // 🎯 LƯU DỮ LIỆU BẠN VỪA GÕ VÀO KHO TỔNG CỦA APP
                  globalMedicines.insert(0, {
                    'id': 'SP${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                    'barcode': _barcodeCtrl.text.isEmpty ? 'Chưa cập nhật' : _barcodeCtrl.text,
                    'name': _tenThuocCtrl.text,
                    'unit': _dvt,
                    'price': int.tryParse(_giaBanCtrl.text) ?? 0,
                    'stock': 0, // Mới tạo danh mục thì tồn kho mặc định = 0
                    'category': 'Khác',
                    'location': 'Chưa xếp kệ',
                    'batch': 'N/A',
                    'expiry': 'N/A',
                  });

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lưu vào danh mục hệ thống thành công!'), backgroundColor: Colors.green));

                  // Báo cho màn hình trước biết là đã có data mới
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('LƯU DATA THUỐC', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}