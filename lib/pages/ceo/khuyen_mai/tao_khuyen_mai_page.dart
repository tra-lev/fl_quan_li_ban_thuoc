import 'package:flutter/material.dart';

class TaoKhuyenMaiPage extends StatefulWidget {
  const TaoKhuyenMaiPage({super.key});

  @override
  State<TaoKhuyenMaiPage> createState() => _TaoKhuyenMaiPageState();
}

class _TaoKhuyenMaiPageState extends State<TaoKhuyenMaiPage> {
  // Controller giữ data không bị giật khi gõ Telex
  final TextEditingController _tenKMCtrl = TextEditingController();
  final TextEditingController _giaTriCtrl = TextEditingController();

  bool _laGiamPhanTram = true; // Mặc định là giảm theo phần trăm

  @override
  void dispose() {
    _tenKMCtrl.dispose();
    _giaTriCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo Khuyến Mãi Mới"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tên chương trình khuyến mãi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _tenKMCtrl,
              decoration: const InputDecoration(
                hintText: "VD: Flash Sale Chào Hè",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.local_offer),
              ),
            ),
            const SizedBox(height: 24),

            const Text("Loại khuyến mãi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text("Giảm theo %"), icon: Icon(Icons.percent)),
                ButtonSegment(value: false, label: Text("Giảm tiền mặt"), icon: Icon(Icons.money_off)),
              ],
              selected: {_laGiamPhanTram},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _laGiamPhanTram = newSelection.first;
                  _giaTriCtrl.clear(); // Chuyển loại thì xóa trắng ô nhập số để tránh nhầm lẫn
                });
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(double.infinity, 45)),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _giaTriCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _laGiamPhanTram ? "Mức giảm (%)" : "Số tiền giảm trực tiếp (VNĐ)",
                border: const OutlineInputBorder(),
                prefixIcon: Icon(_laGiamPhanTram ? Icons.pie_chart : Icons.attach_money),
              ),
            ),
            const SizedBox(height: 24),

            // Lời nhắc nhở cho CEO
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[800], size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Hệ thống sẽ tự động áp dụng mức giảm này lúc Dược sĩ lên đơn thanh toán. Giá vốn và giá niêm yết trong kho không bị thay đổi.",
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // NÚT KÍCH HOẠT VÀ GỬI DỮ LIỆU
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Đổi màu đỏ cho tone-sur-tone với nút ngoài Dashboard
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // 1. Lấy và ép kiểu dữ liệu CEO vừa nhập
                  double giaTriNhap = double.tryParse(_giaTriCtrl.text) ?? 0.0;
                  String tenKM = _tenKMCtrl.text.trim();

                  // Bắt lỗi nếu quên nhập tên
                  if (tenKM.isEmpty) {
                    tenKM = "Chương trình khuyến mãi mới";
                  }

                  // 2. GÓI THÀNH 1 MAP (KIỆN HÀNG)
                  Map<String, dynamic> khuyenMaiMoi = {
                    "ten": tenKM,
                    "laGiamPhanTram": _laGiamPhanTram,
                    "giaTri": giaTriNhap,
                    "dangHoatDong": true, // Vừa tạo xong là mặc định Bật
                  };

                  // 3. Hiển thị thông báo nhỏ
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Đã tạo chiến dịch thành công!"), backgroundColor: Colors.green)
                  );

                  // 4. ĐÓNG TRANG VÀ GỬI KIỆN HÀNG VỀ CHO NÚT ĐỎ Ở DASHBOARD
                  Navigator.pop(context, khuyenMaiMoi);
                },
                child: const Text("Phát Hành Khuyến Mãi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}