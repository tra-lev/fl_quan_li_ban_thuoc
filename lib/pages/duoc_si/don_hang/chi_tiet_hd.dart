// lib/pages/duoc_si/don_hang/chi_tiet_hd.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChiTietHoaDonPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const ChiTietHoaDonPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    // Lấy danh sách item từ đơn hàng hoặc trả về list rỗng nếu không có
    final List items = order['items'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng ${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Phần tóm tắt trạng thái đơn hàng
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.blueAccent,
            child: Column(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white, size: 60),
                const SizedBox(height: 10),
                Text(
                  order['status'].toString().toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${order['time']} - ${order['date']}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông tin khách hàng
                  _buildSectionTitle('Thông tin khách hàng'),
                  _buildInfoCard([
                    _buildDetailRow('Tên khách:', order['customerName'] ?? 'Khách lẻ'),
                    _buildDetailRow('Số điện thoại:', order['phone'] ?? 'Không có'),
                    _buildDetailRow('Hình thức:', order['type'] ?? 'Bán tại quầy'),
                  ]),

                  const SizedBox(height: 20),

                  // Danh sách sản phẩm
                  _buildSectionTitle('Danh sách sản phẩm (${items.length})'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('SL: ${item['qty']} x ${formatCurrency.format(item['price'])}'),
                          trailing: Text(
                            formatCurrency.format(item['qty'] * item['price']),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tổng kết tài chính
                  _buildInfoCard([
                    _buildDetailRow('Tạm tính:', formatCurrency.format(order['total'])),
                    _buildDetailRow('Điểm thưởng:', '+${order['pointsPlus'] ?? 0}'),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TỔNG THANH TOÁN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          formatCurrency.format(order['total']),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () {
            // Logic in lại hóa đơn
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang chuẩn bị bản in...')));
          },
          icon: const Icon(Icons.print),
          label: const Text('IN LẠI HÓA ĐƠN'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}