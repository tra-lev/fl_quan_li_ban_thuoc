import 'package:flutter/material.dart';

class HoaDonPage extends StatelessWidget {
  const HoaDonPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _invoices = const [
    {
      'id': 'LC-88291',
      'customer': 'Nguyễn Văn A',
      'phone': '0987654321',
      'time': '14:20 - 20/03/2026',
      'total': '350.000',
      'pointsPlus': 35,
      'status': 'Đã thanh toán',
    },
    {
      'id': 'LC-88292',
      'customer': 'Trần Thị B',
      'phone': '0912345678',
      'time': '15:10 - 20/03/2026',
      'total': '125.000',
      'pointsPlus': 12,
      'status': 'Đã thanh toán',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar( // Đã sửa lỗi app_bar -> appBar tại đây
        title: const Text('LỊCH SỬ HÓA ĐƠN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _invoices.length,
        itemBuilder: (context, index) {
          final inv = _invoices[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: () => _showInvoiceDetail(context, inv),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(inv['id'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                        Text(inv['status'], style: const TextStyle(color: Colors.green, fontSize: 12)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text('${inv['customer']} - ${inv['phone']}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(inv['time'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('${inv['total']}đ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showInvoiceDetail(BuildContext context, Map<String, dynamic> inv) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('CHI TIẾT HÓA ĐƠN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            _detailItem('Mã hóa đơn', inv['id']),
            _detailItem('Khách hàng', inv['customer']),
            _detailItem('Số điện thoại', inv['phone']),
            _detailItem('Thời gian', inv['time']),
            const Divider(),
            _detailItem('Tổng tiền hàng', inv['total']),
            _detailItem('Điểm tích lũy cộng', '+${inv['pointsPlus']}'),
            const Divider(),
            _detailItem('THANH TOÁN', inv['total'], isBold: true),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.print),
                label: const Text('IN LẠI HÓA ĐƠN'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900], foregroundColor: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w600, fontSize: isBold ? 16 : 14)),
        ],
      ),
    );
  }
}