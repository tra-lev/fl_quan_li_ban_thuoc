import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/supplier_data.dart'; // Đọc kho dữ liệu chung

class AdminImportTab extends StatefulWidget {
  const AdminImportTab({Key? key}) : super(key: key);

  @override
  State<AdminImportTab> createState() => _AdminImportTabState();
}

class _AdminImportTabState extends State<AdminImportTab> {
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  // HÀM 1: CHỈ XEM THÔNG TIN NHÀ CUNG CẤP (KHÔNG CÓ NÚT SỬA/XÓA)
  void _xemThongTinNCC(Map<String, dynamic> supplier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.business, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Expanded(child: Text(supplier['name'] ?? 'Không rõ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(leading: const Icon(Icons.phone), title: const Text('Số điện thoại'), subtitle: Text(supplier['contact'] ?? 'N/A'), contentPadding: EdgeInsets.zero),
            ListTile(leading: const Icon(Icons.email), title: const Text('Email'), subtitle: Text(supplier['email'] ?? 'N/A'), contentPadding: EdgeInsets.zero),
            ListTile(leading: const Icon(Icons.location_on), title: const Text('Địa chỉ'), subtitle: Text(supplier['address'] ?? 'N/A'), contentPadding: EdgeInsets.zero),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ĐÓNG', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  // HÀM 2: ADMIN CẬP NHẬT TRẠNG THÁI & TÍNH TOÁN CÔNG NỢ TỰ ĐỘNG
  void _capNhatTrangThai(int index, String currentStatus) {
    String selectedStatus = currentStatus;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xác nhận tình trạng lô hàng', style: TextStyle(fontWeight: FontWeight.bold)),
          content: DropdownButtonFormField<String>(
            value: ['Chờ giao hàng', 'Đang giao', 'Đã nhận hàng', 'Đã hủy'].contains(currentStatus) ? currentStatus : 'Chờ giao hàng',
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            items: ['Chờ giao hàng', 'Đang giao', 'Đã nhận hàng', 'Đã hủy']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              selectedStatus = val!;
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final order = globalPurchaseOrders[index];
                  final supplierId = order['supplierId'];
                  final double tongTienDonHang = order['total'] ?? 0.0;

                  // Tìm index của Nhà cung cấp trong Kho tổng
                  final supplierIndex = globalSuppliers.indexWhere((s) => s['id'] == supplierId);

                  if (supplierIndex != -1) {
                    // LOGIC 1: Đổi thành "Đã nhận hàng" -> TĂNG CÔNG NỢ
                    if (selectedStatus == 'Đã nhận hàng' && currentStatus != 'Đã nhận hàng') {
                      globalSuppliers[supplierIndex]['debt'] = (globalSuppliers[supplierIndex]['debt'] ?? 0.0) + tongTienDonHang;
                    }
                    // LOGIC 2: Đang là "Đã nhận hàng" mà lỡ bấm hủy/chờ giao -> TRỪ LẠI CÔNG NỢ
                    else if (currentStatus == 'Đã nhận hàng' && selectedStatus != 'Đã nhận hàng') {
                      globalSuppliers[supplierIndex]['debt'] = (globalSuppliers[supplierIndex]['debt'] ?? 0.0) - tongTienDonHang;
                    }
                  }

                  // Cập nhật trạng thái mới cho đơn hàng
                  globalPurchaseOrders[index]['status'] = selectedStatus;
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã cập nhật trạng thái kho & công nợ!'), backgroundColor: Colors.green));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text('LƯU TRẠNG THÁI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Quản lý Đơn Nhập Kho', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: globalPurchaseOrders.isEmpty
          ? const Center(child: Text('Chưa có đơn đặt hàng nào từ CEO.', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: globalPurchaseOrders.length,
        itemBuilder: (context, index) {
          final order = globalPurchaseOrders[index];

          // Map ID đơn hàng với ID Nhà cung cấp
          final supplier = globalSuppliers.firstWhere(
                  (s) => s['id'] == order['supplierId'],
              orElse: () => {'name': 'NCC không xác định', 'contact': ''}
          );

          // Setup màu sắc cho dễ nhìn
          Color statusColor = Colors.orange;
          if (order['status'] == 'Đã nhận hàng' || order['status'] == 'Đã thanh toán') statusColor = Colors.green;
          if (order['status'] == 'Đã hủy') statusColor = Colors.red;

          // 🎯 KIỂM TRA ĐIỀU KIỆN KHÓA: Nếu đã nhận hàng thì không cho sửa nữa
          bool isLocked = order['status'] == 'Đã nhận hàng' || order['status'] == 'Đã thanh toán';

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
                      Text('Mã đơn: ${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: statusColor)),
                        child: Text(order['status'], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nút xem thông tin Nhà cung cấp (Read-only)
                  InkWell(
                    onTap: () => _xemThongTinNCC(supplier),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.local_shipping, color: Colors.blueAccent, size: 20),
                          const SizedBox(width: 8),
                          Expanded(child: Text('NCC: ${supplier['name']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent))),
                          const Icon(Icons.info_outline, color: Colors.blueAccent, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text('Ngày dự kiến giao: ${order['date']}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text('Chi tiết lô hàng:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(order['items']),
                  const SizedBox(height: 8),
                  Text('Tổng giá trị: ${formatCurrency.format(order['total'] ?? 0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),

                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),

                  // 🎯 NÚT BẤM ĐÃ ĐƯỢC THÊM LOGIC BẢO MẬT KHÓA CỨNG
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      // Nếu isLocked = true, hàm onPressed sẽ là null -> Nút tự động bị vô hiệu hóa
                      onPressed: isLocked ? null : () => _capNhatTrangThai(index, order['status']),

                      // Đổi icon thành ổ khóa nếu đã nhận hàng
                      icon: Icon(isLocked ? Icons.lock : Icons.check_circle_outline, color: isLocked ? Colors.grey : Colors.white),

                      // Đổi dòng chữ cảnh báo
                      label: Text(isLocked ? 'ĐÃ KHÓA (KHÔNG THỂ SỬA)' : 'CẬP NHẬT TRẠNG THÁI', style: TextStyle(color: isLocked ? Colors.grey : Colors.white, fontWeight: FontWeight.bold)),

                      style: ElevatedButton.styleFrom(
                          backgroundColor: statusColor,
                          disabledBackgroundColor: Colors.grey.shade200, // Màu xám khi bị khóa
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                      ),
                    ),
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