// lib/pages/duoc_si/don_hang/xuat_hd.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class XuatHoaDonPage extends StatelessWidget {
  final Map<String, dynamic> order;
  final List<Map<String, dynamic>>? cartItems;

  const XuatHoaDonPage({Key? key, required this.order, this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    // ĐỊNH DẠNG NGÀY GIỜ: dd/MM/yyyy HH:mm
    // Nếu order['date'] là String "Hôm nay", ta lấy thời gian thực tế hiện tại
    String formattedDateTime;
    if (order['date'] == 'Hôm nay' || order['date'] == null) {
      formattedDateTime = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    } else {
      // Nếu đã có dữ liệu ngày cụ thể từ trước
      formattedDateTime = '${order['date']} ${order['time'] ?? ''}';
    }

    final List items = cartItems ?? (order['items'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hóa Đơn Chi Tiết', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đang kết nối máy in nhiệt...')),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10)],
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              const Text('NHÀ THUỐC PHARMA PLUS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('123 Đường ABC, Quận 1, TP.HCM'),
              const Text('SĐT: 0123.456.789'),
              const SizedBox(height: 10),
              const Divider(thickness: 2),
              const Text('HÓA ĐƠN BÁN LẺ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              // THÔNG TIN CHUNG (ĐÃ CẬP NHẬT NGÀY GIỜ)
              _buildRow('Mã HD:', order['id'] ?? 'N/A'),
              _buildRow('Thời gian:', formattedDateTime), // Hiển thị dd/MM/yyyy HH:mm
              _buildRow('Khách hàng:', order['customerName'] ?? 'Khách lẻ'),
              _buildRow('SĐT:', order['phone'] ?? 'N/A'),
              const Divider(),

              // Bảng sản phẩm
              Row(
                children: const [
                  Expanded(flex: 3, child: Text('Tên thuốc', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text('SL', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Thành tiền', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 8),
              ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text(item['name'])),
                    Expanded(child: Text(item['qty'].toString(), textAlign: TextAlign.center)),
                    Expanded(flex: 2, child: Text(formatCurrency.format(item['price'] * item['qty']), textAlign: TextAlign.right)),
                  ],
                ),
              )).toList(),

              const Divider(thickness: 2),

              _buildRow('Tạm tính:', formatCurrency.format(order['total'])),
              _buildRow('Giảm giá:', '0đ'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TỔNG CỘNG:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(formatCurrency.format(order['total']), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ),
              const SizedBox(height: 25),
              const Text('Cảm ơn quý khách. Hẹn gặp lại!', style: TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 15),

              // Giả lập mã vạch đơn hàng để quét tra cứu nhanh
              Icon(Icons.view_headline, size: 80, color: Colors.grey[400]),
              Text(order['id'] ?? '', style: const TextStyle(letterSpacing: 4, fontSize: 10)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Yêu cầu in đã được gửi!'), backgroundColor: Colors.green),
            );
          },
          icon: const Icon(Icons.print, color: Colors.white),
          label: const Text('IN HÓA ĐƠN NGAY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[800],
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}