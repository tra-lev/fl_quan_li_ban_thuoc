import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ==========================================
// 1. PHẦN XỬ LÝ DỮ LIỆU (LOGIC TỰ ĐỘNG LỌC)
// ==========================================
class ProfitLogic {
  static final List<Map<String, dynamic>> dataCuaHang = [
    {
      "tuKhoa": "Quận 1", // Dùng từ khóa để khớp với tên chi nhánh sếp bấm vào
      "doanhThu": 500000000.0,
      "chiPhiNhapThuoc": 350000000.0,
      "chiPhiVanHanh": 50000000.0,
      "soDonHang": "1,250",
      "aov": "400k"
    },
    {
      "tuKhoa": "Gò Vấp",
      "doanhThu": 400000000.0,
      "chiPhiNhapThuoc": 200000000.0,
      "chiPhiVanHanh": 30000000.0,
      "soDonHang": "980",
      "aov": "408k"
    },
    {
      "tuKhoa": "Thủ Đức",
      "doanhThu": 250000000.0,
      "chiPhiNhapThuoc": 200000000.0,
      "chiPhiVanHanh": 20000000.0,
      "soDonHang": "600",
      "aov": "416k"
    }
  ];

  // Hàm này sẽ tự tìm data khớp với chi nhánh được chọn
  static Map<String, dynamic> layDataTheoChiNhanh(String tenChiNhanh) {
    Map<String, dynamic> dataGoc;

    try {
      // Tìm xem tên chi nhánh có chứa chữ "Quận 1", "Gò Vấp"... không
      dataGoc = dataCuaHang.firstWhere((element) =>
          tenChiNhanh.toLowerCase().contains(element["tuKhoa"].toString().toLowerCase())
      );
    } catch (e) {
      // Nếu không tìm thấy (lỗi text), lấy mặc định data đầu tiên để app không bị crash
      dataGoc = dataCuaHang[0];
    }

    double doanhThu = dataGoc["doanhThu"];
    double loiNhuan = doanhThu - dataGoc["chiPhiNhapThuoc"] - dataGoc["chiPhiVanHanh"];
    double tySuat = (loiNhuan / doanhThu) * 100;

    return {
      "doanhThu": doanhThu,
      "loiNhuanRong": loiNhuan,
      "tySuat": tySuat,
      "soDonHang": dataGoc["soDonHang"],
      "aov": dataGoc["aov"],
    };
  }
}

// ==========================================
// 2. PHẦN GIAO DIỆN (UI)
// ==========================================
class ChiTietDoanhThuPage extends StatelessWidget {
  final String? tenChiNhanh; // Đã trả lại biến tenChiNhanh

  const ChiTietDoanhThuPage({Key? key, this.tenChiNhanh}) : super(key: key);

  String formatTien(double tien) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(tien);
  }

  @override
  Widget build(BuildContext context) {
    final String tenTrang = tenChiNhanh ?? "Chi tiết doanh thu";
    // Lấy đúng số liệu của riêng chi nhánh này
    final data = ProfitLogic.layDataTheoChiNhanh(tenTrang);

    final double doanhThu = data["doanhThu"] as double;
    final double loiNhuan = data["loiNhuanRong"] as double;
    final double tySuat = data["tySuat"] as double;
    final bool loiNhuanTot = tySuat >= 30;

    return Scaffold(
      appBar: AppBar(
        title: Text(tenTrang),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // BẢNG BÁO CÁO LỢI NHUẬN RÒNG (Tính năng mới gắn vào)
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("BÁO CÁO LỢI NHUẬN", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Doanh thu:", style: TextStyle(fontSize: 16)),
                      Text(formatTien(doanhThu), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Lợi nhuận ròng:", style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
                      Text(formatTien(loiNhuan), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Biên độ lợi nhuận:", style: TextStyle(fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: loiNhuanTot ? Colors.green[100] : Colors.orange[100],
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(
                          "${tySuat.toStringAsFixed(1)}%",
                          style: TextStyle(color: loiNhuanTot ? Colors.green[800] : Colors.orange[800], fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // KHỐI KPI BAN ĐẦU CỦA BẠN (Đã ghép số liệu tự động)
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Đơn Hàng', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(data["soDonHang"], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  ],
                ),
                Container(height: 50, width: 1, color: Colors.grey),
                Column(
                  children: [
                    const Text('AOV', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(data["aov"], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text('Danh mục bán chạy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildTopProductItem('1', 'Panadol Extra', '1,200 hộp', '18,000,000 đ'),
          _buildTopProductItem('2', 'Amoxicillin 500mg', '950 vỉ', '14,250,000 đ'),
          _buildTopProductItem('3', 'Vitamin C', '800 lọ', '40,000,000 đ'),

          const SizedBox(height: 24),
          const Text('Lịch sử giao dịch (Real-time)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildTransactionItem('Mã đơn: #DH-10045', '14:30 - Hôm nay', '+ 250,000 đ'),
          _buildTransactionItem('Mã đơn: #DH-10044', '14:15 - Hôm nay', '+ 1,500,000 đ'),
          _buildTransactionItem('Mã đơn: #DH-10043', '13:40 - Hôm nay', '+ 85,000 đ'),
        ],
      ),
    );
  }

  Widget _buildTopProductItem(String rank, String name, String qty, String revenue) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.blue[50], child: Text(rank, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent))),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Đã bán: $qty'),
        trailing: Text(revenue, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTransactionItem(String title, String time, String amount) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(time),
        trailing: Text(amount, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }
}