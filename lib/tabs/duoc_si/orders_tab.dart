// lib/tabs/duoc_si/orders_tab.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // THÊM THƯ VIỆN FORMAT TIỀN
import '../../data/order_data.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({Key? key}) : super(key: key);
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  String _searchQuery = '';
  String _selectedFilter = 'Tất cả';
  final List<String> _filters = ['Tất cả', 'Hoàn thành', 'Chờ giao', 'Chờ xử lý', 'Đã hủy'];

  // Khởi tạo bộ định dạng
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  Color _getStatusColor(String status) {
    if (status == 'Hoàn thành') return Colors.green;
    if (status == 'Đã hủy') return Colors.redAccent;
    if (status == 'Chờ giao') return Colors.orange;
    return Colors.blue;
  }

  // HÀM HIỂN THỊ CHI TIẾT ĐƠN HÀNG KHI BẤM VÀO
  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 5,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Chi tiết đơn: ${order['id']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                          order['status'],
                          style: TextStyle(color: _getStatusColor(order['status']), fontWeight: FontWeight.bold, fontSize: 12)
                      ),
                    )
                  ],
                ),
                const Divider(height: 30),
                _buildDetailRow('Khách hàng:', order['customerName'] ?? 'Khách lẻ'),
                _buildDetailRow('Số điện thoại:', order['phone'] ?? 'Không có'),
                _buildDetailRow('Thời gian:', '${order['time']} - ${order['date']}'),
                _buildDetailRow('Hình thức:', order['type'] ?? 'Bán tại quầy'),

                if (order['pointsPlus'] != null && order['pointsPlus'] > 0)
                  _buildDetailRow('Điểm thưởng:', '+${order['pointsPlus']} điểm', isHighlight: true),

                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TỔNG THANH TOÁN:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                        formatCurrency.format(order['total']),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent)
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('ĐÓNG', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  // Widget hỗ trợ hiển thị các dòng thông tin chi tiết
  Widget _buildDetailRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: isHighlight ? Colors.green : Colors.black87
              )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredOrders = globalOrders.where((order) {
      bool matchFilter = _selectedFilter == 'Tất cả' || order['status'] == _selectedFilter;
      String query = _searchQuery.toLowerCase();
      bool matchSearch = order['id'].toString().toLowerCase().contains(query) ||
          order['customerName'].toString().toLowerCase().contains(query) ||
          order['phone'].toString().toLowerCase().contains(query);
      return matchFilter && matchSearch;
    }).toList();

    return Column(
      children: [
        Container(
            width: double.infinity, color: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text('QUẢN LÝ ĐƠN HÀNG', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Tìm mã đơn, tên, SĐT...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true, fillColor: Colors.grey[100],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none)
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: _filters.map((filter) {
                    bool isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(filter), selected: isSelected,
                        onSelected: (selected) => setState(() => _selectedFilter = filter),
                        selectedColor: Colors.blue, labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Expanded(
          child: filteredOrders.isEmpty
              ? const Center(child: Text('Không tìm thấy đơn hàng nào'))
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              Color statusColor = _getStatusColor(order['status']);

              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  // BẤM VÀO ĐỂ XEM CHI TIẾT ĐƠN HÀNG
                  onTap: () => _showOrderDetails(context, order),
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.receipt_long, size: 28, color: Colors.blue),
                    ),
                    title: Text('${order['id']} - ${order['customerName']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('${order['time']} ${order['date']}'),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // HIỂN THỊ TIỀN ĐÃ FORMAT
                        Text(formatCurrency.format(order['total']), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(order['status'], style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}