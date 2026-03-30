import 'package:flutter/material.dart';
import 'tao_khuyen_mai_page.dart';

class DanhSachKhuyenMaiPage extends StatefulWidget {
  const DanhSachKhuyenMaiPage({super.key});

  @override
  State<DanhSachKhuyenMaiPage> createState() => _DanhSachKhuyenMaiPageState();
}

class _DanhSachKhuyenMaiPageState extends State<DanhSachKhuyenMaiPage> {
  // 1. DATA KHUYẾN MÃI
  List<Map<String, dynamic>> danhSachKhuyenMai = [
    {"ten": "Giảm 10% dịp Lễ 30/4", "laGiamPhanTram": true, "dangHoatDong": true},
    {"ten": "Flash Sale Chào Hè", "laGiamPhanTram": false, "dangHoatDong": false}
  ];

  // 2. DATA CHI NHÁNH
  List<Map<String, dynamic>> danhSachChiNhanh = [
    {"ten": "Chi nhánh Quận 1", "dieuChinh": 0},
    {"ten": "Chi nhánh Quận 3", "dieuChinh": 5},
    {"ten": "Chi nhánh Thủ Đức", "dieuChinh": -2},
  ];

  Color _layMauChiNhanh(int dieuChinh) {
    if (dieuChinh == 0) return Colors.green;
    if (dieuChinh > 0) return Colors.orange;
    return Colors.blue;
  }

  String _layTextChiNhanh(int dieuChinh) {
    if (dieuChinh == 0) return "Áp dụng Giá Chuẩn (0%)";
    if (dieuChinh > 0) return "Bán cao hơn Giá Chuẩn (+$dieuChinh%)";
    return "Bán thấp hơn Giá Chuẩn ($dieuChinh%)";
  }

  // BỘ NÃO HỨNG DỮ LIỆU TỪ FORM (ĐÃ XÓA CÁC DÒNG PRINT DEBUG)
  Future<void> _moFormTaoKhuyenMai() async {
    final duLieuTraVe = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaoKhuyenMaiPage()),
    );

    if (duLieuTraVe != null && duLieuTraVe is Map<String, dynamic>) {
      setState(() {
        danhSachKhuyenMai.insert(0, duLieuTraVe);
      });
    }
  }

  // POPUP CHỈNH GIÁ
  void _hienThiMenuDoiGia(int index) {
    final chiNhanh = danhSachChiNhanh[index];
    double giaTriMoi = chiNhanh["dieuChinh"].toDouble();

    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cấu hình giá: ${chiNhanh["ten"]}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Text("Mức chênh lệch: ${giaTriMoi > 0 ? '+' : ''}${giaTriMoi.toInt()}%",
                          style: TextStyle(fontSize: 16, color: _layMauChiNhanh(giaTriMoi.toInt()), fontWeight: FontWeight.bold)
                      ),
                      Slider(
                        value: giaTriMoi, min: -20, max: 20, divisions: 40,
                        activeColor: _layMauChiNhanh(giaTriMoi.toInt()),
                        onChanged: (value) => setModalState(() => giaTriMoi = value),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity, height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], foregroundColor: Colors.white),
                          onPressed: () {
                            setState(() => danhSachChiNhanh[index]["dieuChinh"] = giaTriMoi.toInt());
                            Navigator.pop(context);
                          },
                          child: const Text("Lưu Cấu Hình", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                );
              }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Khuyến mãi toàn hệ thống", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // NÚT ĐỎ GỌI HÀM
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4D4F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.add_box),
                label: const Text("Phát hành Khuyến Mãi Mới", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: _moFormTaoKhuyenMai,
              ),
            ),
            const SizedBox(height: 16),

            // LIST KHUYẾN MÃI
            ListView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: danhSachKhuyenMai.length,
              itemBuilder: (context, index) {
                final km = danhSachKhuyenMai[index];
                return Card(
                  elevation: 1, margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: km["laGiamPhanTram"] ? Colors.red[50] : Colors.grey[200],
                      child: Icon(Icons.local_offer, color: km["laGiamPhanTram"] ? Colors.redAccent : Colors.grey[600]),
                    ),
                    title: Text(km["ten"], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Phạm vi: Toàn chuỗi"),
                    trailing: Switch(
                      value: km["dangHoatDong"], activeColor: Colors.blue[600],
                      onChanged: (bool value) => setState(() => km["dangHoatDong"] = value),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            const Text("Cấu hình giá bán theo chi nhánh", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // LIST CHI NHÁNH
            ListView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: danhSachChiNhanh.length,
              itemBuilder: (context, index) {
                final cn = danhSachChiNhanh[index];
                final int dieuChinh = cn["dieuChinh"];
                return Card(
                  elevation: 1, margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    title: Text(cn["ten"], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(_layTextChiNhanh(dieuChinh), style: TextStyle(color: _layMauChiNhanh(dieuChinh), fontWeight: FontWeight.w600)),
                    ),
                    trailing: const Icon(Icons.tune, color: Colors.grey),
                    onTap: () => _hienThiMenuDoiGia(index),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}