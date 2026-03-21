import 'package:flutter/material.dart';

class BanTaiQuayWidget extends StatefulWidget {
  const BanTaiQuayWidget({Key? key}) : super(key: key);

  @override
  State<BanTaiQuayWidget> createState() => _BanTaiQuayWidgetState();
}

class _BanTaiQuayWidgetState extends State<BanTaiQuayWidget> {
  // Giao diện bán tại quầy thường ưu tiên việc quét mã vạch và thanh toán nhanh
  List<Map<String, dynamic>> _cart = [
    {'name': 'Vitamin C 1000mg', 'qty': 1, 'price': 85000},
    {'name': 'Nước muối sinh lý', 'qty': 3, 'price': 5000},
  ];

  void _checkout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanh toán thành công! Đang in hóa đơn...'), backgroundColor: Colors.green),
    );
    Navigator.pop(context); // Trở về trang chủ sau khi bán xong
  }

  @override
  Widget build(BuildContext context) {
    double total = _cart.fold(0, (sum, item) => sum + (item['qty'] * item['price']));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Bán Tại Quầy (POS)', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mở camera quét mã vạch...')));
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Khung tìm kiếm thuốc nhanh
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm hoặc quét mã vạch thuốc...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.document_scanner, color: Colors.orange),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),

          // Danh sách giỏ hàng
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                final item = _cart[index];
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${item['price']}đ'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () {}),
                        Text('${item['qty']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.orange), onPressed: () {}),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Thanh toán
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Khách hàng:', style: TextStyle(color: Colors.grey)),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Khách lẻ (Bấm để thêm)'),
                      )
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TỔNG THANH TOÁN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${total.toInt()}đ', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _checkout,
                      icon: const Icon(Icons.point_of_sale, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      label: const Text('THANH TOÁN & IN BILL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}