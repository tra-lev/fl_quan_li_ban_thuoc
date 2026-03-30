// lib/pages/duoc_si/don_hang/don_giao_hang.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // THÊM THƯ VIỆN FORMAT TIỀN TỆ

import '../../../data/medicine_data.dart';
import '../../../data/customer_data.dart';
import '../../../data/order_data.dart';
import 'qr_scanner_page.dart';

class DonGiaoHangWidget extends StatefulWidget {
  const DonGiaoHangWidget({Key? key}) : super(key: key);

  @override
  State<DonGiaoHangWidget> createState() => _DonGiaoHangWidgetState();
}

class _DonGiaoHangWidgetState extends State<DonGiaoHangWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Khởi tạo bộ định dạng tiền tệ VNĐ
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  List<Map<String, dynamic>> _selectedProducts = [];
  String _currentPhone = '';

  final Color primaryColor = Colors.cyan.shade600;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      String newPhone = _phoneController.text.trim();

      int existingIndex = globalCustomers.indexWhere((c) => c['phone'] == newPhone);

      setState(() {
        _currentPhone = newPhone;
      });

      if (existingIndex != -1) {
        String existingName = globalCustomers[existingIndex]['name'];
        String existingAddress = globalCustomers[existingIndex]['address'];

        if (_nameController.text != existingName) {
          _nameController.text = existingName;
        }
        if (_addressController.text != existingAddress && existingAddress != 'Chưa cập nhật') {
          _addressController.text = existingAddress;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
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

        bool matchBarcode = dataBarcode.isNotEmpty && (cleanCode.contains(dataBarcode) || dataBarcode.contains(cleanCode));
        bool matchId = dataId.isNotEmpty && (cleanCode.contains(dataId) || dataId.contains(cleanCode));
        bool matchBatch = dataBatch.isNotEmpty && (cleanCode.contains(dataBatch) || dataBatch.contains(cleanCode));

        return matchBarcode || matchId || matchBatch;
      });

      if (index != -1) {
        _addToOrder(globalMedicines[index]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Chưa có thuốc này trong Data.\nMã máy quét được là: [$cleanCode]'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _addCustomer() {
    String phone = _phoneController.text.trim();
    String name = _nameController.text.trim();
    String address = _addressController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên khách hàng!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      globalCustomers.add({
        'name': name,
        'phone': phone,
        'address': address.isEmpty ? 'Chưa cập nhật' : address,
        'points': 0,
        'level': 'Bạc',
        'totalSpent': '0',
        'lastVisit': 'Vừa xong',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu thông tin khách hàng mới!'), backgroundColor: Colors.green),
    );
  }

  void _addToOrder(Map<String, dynamic> item) {
    setState(() {
      int existingIndex = _selectedProducts.indexWhere((element) => element['name'] == item['name']);
      if (existingIndex >= 0) {
        _selectedProducts[existingIndex]['qty']++;
      } else {
        _selectedProducts.add({'name': item['name'], 'price': item['price'], 'qty': 1});
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
                          prefixIcon: Icon(Icons.search, color: primaryColor),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(10)),
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
                              color: Colors.cyan.shade50, elevation: 0, margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Icon(Icons.medication, color: primaryColor),
                                title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                // ĐÃ SỬA FORMAT GIÁ TRONG TÌM KIẾM
                                subtitle: Text('Tồn: ${item['stock']} | Giá: ${formatCurrency.format(item['price'])}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.add_circle, color: primaryColor, size: 30),
                                  onPressed: () { _addToOrder(item); Navigator.pop(context); },
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

  void _submitOrder() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin giao hàng!'), backgroundColor: Colors.red));
      return;
    }
    if (_selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đơn hàng chưa có sản phẩm!'), backgroundColor: Colors.red));
      return;
    }

    double total = _selectedProducts.fold(0, (sum, item) => sum + (item['qty'] * item['price']));
    int pointsEarned = (total / 10000).floor();

    int existingIndex = globalCustomers.indexWhere((c) => c['phone'] == _phoneController.text.trim());
    if (existingIndex != -1) {
      globalCustomers[existingIndex]['points'] += pointsEarned;
      globalCustomers[existingIndex]['lastVisit'] = 'Vừa xong';
      globalCustomers[existingIndex]['address'] = _addressController.text.trim();
    }

    setState(() {
      globalOrders.insert(0, {
        'id': 'DH${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        'date': 'Hôm nay', 'time': 'Vừa xong',
        'customerName': _nameController.text,
        'phone': _phoneController.text,
        'total': total.toInt(),
        'status': 'Chờ giao', // Chuyển thành Chờ giao cho chuẩn logic
        'pointsPlus': pointsEarned,
        'type': 'Giao hàng'
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tạo đơn giao hàng thành công!'), backgroundColor: Colors.green));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double total = _selectedProducts.fold(0, (sum, item) => sum + (item['qty'] * item['price']));

    bool customerExists = globalCustomers.any((c) => c['phone'] == _currentPhone);
    bool showAddButton = _currentPhone.isNotEmpty && !customerExists;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Tạo Đơn Giao Hàng', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
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
            const Text('Thông tin người nhận', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildTextField(controller: _phoneController, label: 'Số điện thoại', icon: Icons.phone, isNumber: true),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _nameController, label: 'Tên khách hàng', icon: Icons.person),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _addressController, label: 'Địa chỉ giao hàng', icon: Icons.location_on),

                  if (showAddButton) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: _addCustomer,
                        icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
                        label: const Text('Lưu khách hàng thân thiết', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    icon: Icon(Icons.search, color: primaryColor),
                    label: Text('Tìm thủ công', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))
                )
              ],
            ),

            _selectedProducts.isEmpty
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Chưa có sản phẩm nào', style: TextStyle(color: Colors.grey))),
            )
                : ListView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: _selectedProducts.length,
              itemBuilder: (context, index) {
                final item = _selectedProducts[index];
                return Card(
                  elevation: 1, margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.cyan.shade50, borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.medication, color: primaryColor)
                    ),
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    // ĐÃ SỬA FORMAT GIÁ TRONG GIỎ HÀNG
                    subtitle: Text(formatCurrency.format(item['price'])),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.grey), onPressed: () => setState(() { if (item['qty'] > 1) item['qty']--; else _selectedProducts.removeAt(index); })),
                        Text('${item['qty']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(icon: Icon(Icons.add_circle_outline, color: primaryColor), onPressed: () => setState(() => item['qty']++)),
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
                  const Text('TỔNG CỘNG:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  // ĐÃ SỬA FORMAT TỔNG TIỀN ĐƠN GIAO HÀNG
                  Text(formatCurrency.format(total), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                  ),
                  child: const Text('XÁC NHẬN TẠO ĐƠN', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2), borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}