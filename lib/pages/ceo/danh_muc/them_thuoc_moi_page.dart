import 'package:flutter/material.dart';

class ThemThuocMoiPage extends StatefulWidget {
  const ThemThuocMoiPage({Key? key}) : super(key: key);

  @override
  State<ThemThuocMoiPage> createState() => _ThemThuocMoiPageState();
}

class _ThemThuocMoiPageState extends State<ThemThuocMoiPage> {
  String _dvt = 'Hộp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Mã Thuốc Chuẩn'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blueAccent, width: 2)),
                    child: const Icon(Icons.add_a_photo, size: 40, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                labelText: 'Mã Barcode (Quét hoặc Nhập)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.qr_code),
                suffixIcon: IconButton(icon: const Icon(Icons.camera_alt, color: Colors.blueAccent), onPressed: (){}),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Tên thuốc / Biệt dược',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.medical_services),
              ),
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lưu vào danh mục hệ thống thành công!')));
                  Navigator.pop(context);
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