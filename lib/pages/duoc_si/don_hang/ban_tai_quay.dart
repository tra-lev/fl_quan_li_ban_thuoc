// lib/pages/duoc_si/don_hang/ban_tai_quay.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // THÊM IMPORT NÀY

import '../../../data/medicine_data.dart';
import '../../../data/customer_data.dart';
import '../../../data/order_data.dart';
import 'qr_scanner_page.dart';

class BanTaiQuayWidget extends StatefulWidget {
  final Map<String, dynamic>? initialPrescription;

  const BanTaiQuayWidget({Key? key, this.initialPrescription}) : super(key: key);

  @override
  State<BanTaiQuayWidget> createState() => _BanTaiQuayWidgetState();
}

class _BanTaiQuayWidgetState extends State<BanTaiQuayWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ'); // Biến định dạng tiền chung

  List<Map<String, dynamic>> _cart = [];
  String _currentPhone = '';

  @override
  void initState() {
    super.initState();

    if (widget.initialPrescription != null) {
      _nameController.text = widget.initialPrescription!['patientName'];
      _phoneController.text = widget.initialPrescription!['phone'];
      _currentPhone = widget.initialPrescription!['phone'];

      _cart = List<Map<String, dynamic>>.from(widget.initialPrescription!['medicines']);
    }

    _phoneController.addListener(() {
      String newPhone = _phoneController.text.trim();
      int existingIndex = globalCustomers.indexWhere((c) => c['phone'] == newPhone);
      setState(() { _currentPhone = newPhone; });

      if (existingIndex != -1) {
        String existingName = globalCustomers[existingIndex]['name'];
        if (_nameController.text != existingName) {
          _nameController.text = existingName;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    final scannedCode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerPage()),
    );

    if (scannedCode != null && scannedCode is String) {
      String cleanCode = scannedCode.trim();

      int index = globalMedicines.indexWhere((m) {
        String dataBarcode = m['barcode']?.toString().trim() ?? '';
        String dataId = m['id']?.toString().trim() ?? '';
        String dataBatch = m['batch']?.toString().trim() ?? '';

        return dataBarcode == cleanCode || dataId == cleanCode || dataBatch == cleanCode;
      });

      if (index != -1) {
        _addToCart(globalMedicines[index]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không tìm thấy thuốc!\nMã máy ảnh đọc được là: "$cleanCode"'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _addCustomer() {
    String phone = _phoneController.text.trim();
    String name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên khách hàng trước khi lưu!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      globalCustomers.add({
        'name': name,
        'phone': phone,
        'address': 'Chưa cập nhật',
        'points': 0,
        'level': 'Bạc',
        'totalSpent': '0',
        'lastVisit': 'Vừa xong',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã thêm khách hàng thân thiết thành công!'), backgroundColor: Colors.green),
    );
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      int existingIndex = _cart.indexWhere((element) => element['name'] == item['name']);
      if (existingIndex >= 0) {
        _cart[existingIndex]['qty']++;
      } else {
        _cart.add({'name': item['name'], 'price': item['price'], 'qty': 1});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã thêm ${item['name']}'), duration: const Duration(seconds: 1)));
  }

  void _showSearchMedicineBottomSheet() {
    List<Map<String, dynamic>> displayedMedicines = List.from(globalMedicines);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tìm kiếm thuốc', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Nhập tên thuốc...',
                          prefixIcon: const Icon(Icons.search, color: Colors.orange),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.orange), borderRadius: BorderRadius.circular(10)),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            displayedMedicines = globalMedicines.where((m) =>
                                m['name'].toString().toLowerCase().contains(value.toLowerCase())).toList();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: displayedMedicines.length,
                          itemBuilder: (context, index) {
                            final item = displayedMedicines[index];
                            return Card(
                              color: Colors.orange.shade50, elevation: 0,
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: const Icon(Icons.medication, color: Colors.orange),
                                title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                // ĐÃ SỬA: Format giá đẹp trong danh sách tìm kiếm
                                subtitle: Text('Tồn: ${item['stock']} | Giá: ${formatCurrency.format(item['price'])}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add_circle, color: Colors.orange, size: 30),
                                  onPressed: () {
                                    _addToCart(item);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }

  void _checkout() {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Giỏ hàng trống!'), backgroundColor: Colors.red));
      return;
    }

    String phone = _phoneController.text.trim();
    String name = _nameController.text.trim();
    double total = _cart.fold(0, (sum, item) => sum + (item['qty'] * item['price']));
    int pointsEarned = (total / 10000).floor();

    if (phone.isNotEmpty) {
      int existingIndex = globalCustomers.indexWhere((c) => c['phone'] == phone);
      if (existingIndex != -1) {
        globalCustomers[existingIndex]['points'] += pointsEarned;
        globalCustomers[existingIndex]['lastVisit'] = 'Vừa xong';
      }
    }

    globalOrders.insert(0, {
      'id': 'DH${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'date': 'Hôm nay',
      'time': 'Vừa xong',
      'customerName': name.isEmpty ? 'Khách lẻ' : name,
      'phone': phone.isEmpty ? 'N/A' : phone,
      'total': total.toInt(),
      'status': 'Hoàn thành',
      'pointsPlus': pointsEarned,
      'type': 'Bán tại quầy'
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thanh toán thành công!'), backgroundColor: Colors.green));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double total = _cart.fold(0, (sum, item) => sum + (item['qty'] * item['price']));

    bool customerExists = globalCustomers.any((c) => c['phone'] == _currentPhone);
    bool showAddButton = _currentPhone.isNotEmpty && !customerExists;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Bán Tại Quầy (POS)', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thông tin khách hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Nhập Số điện thoại',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.orange), borderRadius: BorderRadius.circular(10)),
                      )
                  ),
                  const SizedBox(height: 12),
                  TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Tên khách hàng (Khách lẻ để trống)',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.orange), borderRadius: BorderRadius.circular(10)),
                      )
                  ),

                  if (showAddButton) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: _addCustomer,
                        icon: const Icon(Icons.person_add, color: Colors.white),
                        label: const Text('Thêm khách hàng thân thiết', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sản phẩm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton.icon(
                    onPressed: _showSearchMedicineBottomSheet,
                    icon: const Icon(Icons.search, color: Colors.orange),
                    label: const Text('Tìm thủ công', style: TextStyle(color: Colors.orange))
                )
              ],
            ),

            _cart.isEmpty
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Chưa có sản phẩm nào', style: TextStyle(color: Colors.grey))),
            )
                : ListView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                final item = _cart[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.medication, color: Colors.orange),
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    // ĐÃ SỬA: Format giá sản phẩm trong giỏ hàng
                    subtitle: Text(formatCurrency.format(item['price'])),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.grey), onPressed: () => setState(() { if (item['qty'] > 1) item['qty']--; else _cart.removeAt(index); })),
                        Text('${item['qty']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.orange), onPressed: () => setState(() => item['qty']++)),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TỔNG THANH TOÁN:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  // ĐÃ SỬA: Format tổng hóa đơn cực kỳ đẹp mắt
                  Text(formatCurrency.format(total), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                  onPressed: _checkout,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('THANH TOÁN & IN BILL', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
              ),
            ),
          ],
        ),
      ),
    );
  }
}