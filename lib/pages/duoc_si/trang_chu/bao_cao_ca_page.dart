// lib/pages/duoc_si/trang_chu/bao_cao_ca_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/order_data.dart'; // Import dữ liệu hóa đơn
import '../../../data/shift_report_data.dart';

class BaoCaoCaPage extends StatefulWidget {
  const BaoCaoCaPage({Key? key}) : super(key: key);

  @override
  State<BaoCaoCaPage> createState() => _BaoCaoCaPageState();
}

class _BaoCaoCaPageState extends State<BaoCaoCaPage> {
  final TextEditingController _tienMatController = TextEditingController();
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  // Danh sách lưu trữ đơn hàng theo từng loại để hiển thị chi tiết
  List<Map<String, dynamic>> _allTodayOrders = [];
  List<Map<String, dynamic>> _completedOrders = [];
  List<Map<String, dynamic>> _pendingOrders = [];
  double _tongDoanhThu = 0;

  @override
  void initState() {
    super.initState();
    _tinhToanBaoCaoCa();
  }

  void _tinhToanBaoCaoCa() {
    double doanhThu = 0;
    List<Map<String, dynamic>> today = [];
    List<Map<String, dynamic>> completed = [];
    List<Map<String, dynamic>> pending = [];

    // Logic lọc: Lấy toàn bộ đơn hàng trong ca trực (giả lập là ngày hôm nay)
    for (var order in globalOrders) {
      if (order['date'] == 'Hôm nay' || order['date'].toString().contains('2026')) {
        today.add(order);
        doanhThu += (order['total'] as num).toDouble();

        if (order['status'] == 'Hoàn thành') {
          completed.add(order);
        } else {
          pending.add(order);
        }
      }
    }

    setState(() {
      _allTodayOrders = today;
      _completedOrders = completed;
      _pendingOrders = pending;
      _tongDoanhThu = doanhThu;
    });
  }

  // Hàm hiển thị danh sách đơn hàng khi bấm vào thẻ
  void _showOrderListDetail(String title, List<Map<String, dynamic>> orders, Color themeColor) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeColor)),
              const Divider(),
              Expanded(
                child: orders.isEmpty
                    ? const Center(child: Text('Không có đơn hàng nào.'))
                    : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final o = orders[index];
                    return ListTile(
                      leading: Icon(Icons.receipt, color: themeColor),
                      title: Text('Đơn: ${o['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Khách: ${o['customerName']} - ${o['time']}'),
                      trailing: Text(formatCurrency.format(o['total']), style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _chotCa() {
    if (_tienMatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đếm và nhập số tiền mặt thực tế trong két!'), backgroundColor: Colors.red),
      );
      return;
    }

    // 1. TÍNH TOÁN TIỀN LỆCH
    // Tiền hệ thống yêu cầu = Doanh thu bán hàng + 2.000.000đ (Tiền mặt đầu ca trong két)
    double expectedCash = _tongDoanhThu + 2000000;

    // Tiền Dược sĩ thực đếm (xóa các ký tự không phải số nếu có)
    double reportedCash = double.tryParse(_tienMatController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    // Độ lệch (Âm = Thiếu tiền, Dương = Thừa tiền, 0 = Khớp)
    double difference = reportedCash - expectedCash;

    // 2. LƯU BÁO CÁO VÀO DATA ĐỂ ADMIN DUYỆT
    globalShiftReports.insert(0, {
      'id': 'BC${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'pharmacist': 'Nguyễn Văn A', // Tên nhân viên trực
      'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'time': DateFormat('HH:mm').format(DateTime.now()),
      'systemCash': expectedCash,
      'reportedCash': reportedCash,
      'difference': difference,
      'totalOrders': _allTodayOrders.length,
      'revenue': _tongDoanhThu,
      'status': 'Chờ duyệt' // Trạng thái để Admin kiểm tra
    });

    // 3. HIỂN THỊ THÔNG BÁO THÀNH CÔNG
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            SizedBox(height: 10),
            Text('CHỐT CA THÀNH CÔNG', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text('Báo cáo giao ca đã được lưu lại và gửi lên Admin để đối soát.', textAlign: TextAlign.center),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text('VỀ TRANG CHỦ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentTime = DateFormat('HH:mm - dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Báo Cáo Giao Ca', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Thông tin ca trực
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Nhân viên trực:', 'Nguyễn Văn A', isBold: true),
                  const Divider(),
                  _buildInfoRow('Thời gian kết ca:', currentTime),
                  const Divider(),
                  _buildInfoRow('Ca làm việc:', 'Ca Sáng (08:00 - 12:00)'),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text('THỐNG KÊ DOANH THU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 10),

            // 2. Thẻ Doanh Thu Tổng
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue.shade700, Colors.blue.shade400]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Tổng doanh thu trong ca', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    formatCurrency.format(_tongDoanhThu),
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Grid Số liệu chi tiết (Đã thêm chức năng bấm vào)
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Tổng số đơn',
                    '${_allTodayOrders.length}',
                    Icons.receipt_long,
                    Colors.blue,
                    onTap: () => _showOrderListDetail('DANH SÁCH TỔNG ĐƠN', _allTodayOrders, Colors.blue),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Hoàn thành',
                    '${_completedOrders.length}',
                    Icons.check_circle,
                    Colors.green,
                    onTap: () => _showOrderListDetail('ĐƠN HOÀN THÀNH', _completedOrders, Colors.green),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Chờ giao',
                    '${_pendingOrders.length}',
                    Icons.local_shipping,
                    Colors.orange,
                    onTap: () => _showOrderListDetail('ĐƠN CHỜ XỬ LÝ', _pendingOrders, Colors.orange),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text('ĐỐI SOÁT TIỀN MẶT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 10),

            // 4. Nhập tiền mặt thực tế
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Vui lòng đếm tiền trong két và nhập số thực tế vào đây để đối soát với hệ thống:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _tienMatController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                    decoration: InputDecoration(
                      labelText: 'Tiền mặt thực đếm (VNĐ)',
                      prefixIcon: const Icon(Icons.payments, color: Colors.green),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.blue, width: 2), borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 5. Nút chốt ca
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _chotCa,
                icon: const Icon(Icons.lock_clock, color: Colors.white),
                label: const Text('XÁC NHẬN CHỐT CA & IN BÁO CÁO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w500, fontSize: isBold ? 16 : 14, color: Colors.black87)),
        ],
      ),
    );
  }

  // Widget thẻ thống kê đã bọc InkWell để nhận diện sự kiện bấm
  Widget _buildStatCard(String title, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}