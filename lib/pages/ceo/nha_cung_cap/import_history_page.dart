import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/supplier_data.dart'; // Đảm bảo đường dẫn này đúng với máy bạn

class ImportHistoryPage extends StatelessWidget {
  final String supplierId;
  final String supplierName;

  const ImportHistoryPage({Key? key, required this.supplierId, required this.supplierName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    // LỌC DANH SÁCH: Chỉ lấy những đơn hàng của đúng Nhà cung cấp đang được chọn
    final history = globalPurchaseOrders.where((order) => order['supplierId'] == supplierId).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lịch sử nhập hàng', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(supplierName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: history.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Chưa có lịch sử nhập hàng nào.', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          final String status = item['status'] ?? 'Chờ giao hàng';

          // 🎯 ĐÃ FIX: Logic phân loại màu sắc theo trạng thái thực tế
          Color statusColor = Colors.orange; // Mặc định màu Cam cho "Chờ giao hàng"

          if (status == 'Đã nhận hàng' || status == 'Đã thanh toán') {
            statusColor = Colors.green; // Thành công -> Xanh lá
          } else if (status == 'Đang giao') {
            statusColor = Colors.blue; // Đang vận chuyển -> Xanh dương
          } else if (status == 'Đã hủy') {
            statusColor = Colors.red; // Bị hủy -> Đỏ
          }

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mã đơn: ${item['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(formatCurrency.format(item['total'] ?? 0), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Ngày nhập: ${item['date']}', style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 24),
                  const Text('Chi tiết lô hàng:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item['items']),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Trạng thái:'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}