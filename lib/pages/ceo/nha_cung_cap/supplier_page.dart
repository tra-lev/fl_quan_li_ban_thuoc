import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'import_history_page.dart';
import '../../../data/supplier_data.dart';
import '../../../data/medicine_data.dart';

// ===================================================================
// 1. MÀN HÌNH CHÍNH QUẢN LÝ NHÀ CUNG CẤP
// ===================================================================
class SupplierTab extends StatefulWidget {
  const SupplierTab({Key? key}) : super(key: key);
  @override
  State<SupplierTab> createState() => _SupplierTabState();
}

class _SupplierTabState extends State<SupplierTab> {
  String formatCurrency(double amount) {
    return "${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ";
  }

  void _showAddSupplierDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddSupplierDialog(),
    );

    if (result != null) {
      setState(() {
        globalSuppliers.insert(0, result);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm nhà cung cấp mới!'), backgroundColor: Colors.green),
      );
    }
  }

  void _showPaymentDialog(int index) {
    final sup = globalSuppliers[index];
    final double currentDebt = sup['debt'] ?? 0;

    if (currentDebt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đối tác này hiện không có công nợ!')));
      return;
    }

    final TextEditingController amountCtrl = TextEditingController(text: currentDebt.toInt().toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thanh toán công nợ', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Đối tác: ${sup['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Nợ hiện tại: ${formatCurrency(currentDebt)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Số tiền thanh toán (VNĐ)',
                prefixIcon: const Icon(Icons.payments, color: Colors.green),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('HỦY')),
          ElevatedButton(
            onPressed: () {
              double payment = double.tryParse(amountCtrl.text) ?? 0;
              if (payment > 0 && payment <= currentDebt) {
                setState(() => globalSuppliers[index]['debt'] = currentDebt - payment);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thanh toán thành công!'), backgroundColor: Colors.green));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('XÁC NHẬN TRẢ NỢ'),
          )
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) return const Icon(Icons.star, color: Colors.amber, size: 16);
        if (index == fullStars && hasHalfStar) return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        return const Icon(Icons.star_border, color: Colors.grey, size: 16);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: globalSuppliers.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final sup = globalSuppliers[index];
          final double debt = sup['debt'] ?? 0.0;

          return Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
            child: ExpansionTile(
              leading: const CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.business, color: Colors.white)),
              title: Text(sup['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    _buildRatingStars(sup['rating'] ?? 5.0),
                    const SizedBox(width: 8),
                    Text('${sup['rating']}/5.0', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(children: [const Icon(Icons.phone, size: 18, color: Colors.grey), const SizedBox(width: 10), Text('SĐT: ${sup['contact']}', style: const TextStyle(color: Colors.black87))]),
                      const SizedBox(height: 8),
                      Row(children: [const Icon(Icons.email, size: 18, color: Colors.grey), const SizedBox(width: 10), Expanded(child: Text('Email: ${sup['email']}', style: const TextStyle(color: Colors.black87)))]),

                      const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Công nợ hiện tại:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(formatCurrency(debt), style: TextStyle(color: debt > 0 ? Colors.red : Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DatHangSupplierPage(supplier: sup))),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                                icon: const Icon(Icons.shopping_cart, size: 18), label: const Text('Đặt hàng')
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                                onPressed: debt > 0 ? () => _showPaymentDialog(index) : null,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                icon: const Icon(Icons.payments, size: 18), label: const Text('Trả nợ')
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ImportHistoryPage(supplierId: sup['id']!, supplierName: sup['name']!))),
                            icon: const Icon(Icons.history, size: 18), label: const Text('Xem lịch sử giao dịch')
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSupplierDialog,
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm Đối Tác', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ===================================================================
// 2. MÀN HÌNH TẠO PHIẾU ĐẶT HÀNG (ĐÃ FIX: KHÔNG CHO TỰ NHẬP GIÁ)
// ===================================================================
class DatHangSupplierPage extends StatefulWidget {
  final Map<String, dynamic> supplier;
  const DatHangSupplierPage({Key? key, required this.supplier}) : super(key: key);
  @override State<DatHangSupplierPage> createState() => _DatHangSupplierPageState();
}

class _DatHangSupplierPageState extends State<DatHangSupplierPage> {
  DateTime? _ngayGiaoDuKien;
  final List<Map<String, dynamic>> _cart = [];
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  // Hàm tính tổng tiền lô hàng (Chỉ cộng những món đã có giá)
  double get _totalOrderAmount {
    return _cart.fold(0.0, (sum, item) => sum + ((item['qty'] as int) * (item['importPrice'] as double)));
  }

  Future<void> _chonNgayGiao() async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 1)), firstDate: DateTime.now(), lastDate: DateTime(2030));
    if (picked != null && picked != _ngayGiaoDuKien) setState(() => _ngayGiaoDuKien = picked);
  }

  // 🎯 BƯỚC 1: LẤY TỰ ĐỘNG GIÁ TỪ HỆ THỐNG - KHÔNG CHO CEO NHẬP BẰNG BÀN PHÍM
  void _promptAddCartItem(Map<String, dynamic> item) {
    final qtyCtrl = TextEditingController(text: '50');

    // GIẢ LẬP LOGIC: Hệ thống tự động lấy giá hợp đồng từ NCC (VD: Rẻ hơn giá bán 30%)
    final double giaNccQuyDinh = (item['price'] ?? 0) * 0.7;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('Nhập số lượng: ${item['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Khung hiển thị Giá (Read-only) không cho sửa
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade200)),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_user, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Giá NCC quy định:\n${formatCurrency.format(giaNccQuyDinh)} / ${item['unit'] ?? 'Hộp'}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Khung chỉ cho phép gõ số lượng
                  TextField(
                      controller: qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Số lượng cần đặt', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.add_shopping_cart))
                  ),
                ]
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  setState(() {
                    int existIndex = _cart.indexWhere((e) => e['name'] == item['name']);
                    int qty = int.tryParse(qtyCtrl.text) ?? 1;

                    if (existIndex >= 0) {
                      _cart[existIndex]['qty'] += qty; // Cộng dồn nếu chọn lại
                    } else {
                      _cart.add({
                        'name': item['name'],
                        'qty': qty,
                        'unit': item['unit'] ?? 'Hộp',
                        'importPrice': giaNccQuyDinh // Lưu thẳng giá NCC quy định vào hóa đơn
                      });
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Thêm vào đơn', style: TextStyle(color: Colors.white)),
              )
            ]
        )
    );
  }

  // 🎯 BƯỚC 2: CHỈNH SỬA SỐ LƯỢNG KHI Ở TRONG GIỎ HÀNG (GIÁ VẪN KHÓA CHẾT)
  void _editCartItem(int index) {
    final item = _cart[index];
    final qtyCtrl = TextEditingController(text: item['qty'].toString());
    final bool isChuaCoGia = item['importPrice'] == 0;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('Điều chỉnh: ${item['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isChuaCoGia ? 'Trạng thái: Chờ NCC báo giá' : 'Giá NCC: ${formatCurrency.format(item['importPrice'])} / ${item['unit']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 16),
                  TextField(controller: qtyCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Số lượng thay đổi', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                ]
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () {
                  setState(() {
                    _cart[index]['qty'] = int.tryParse(qtyCtrl.text) ?? 1;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Lưu thay đổi', style: TextStyle(color: Colors.white)),
              )
            ]
        )
    );
  }

  // 🎯 BƯỚC 3: NẾU LÀ THUỐC LẠ NGOÀI DANH MỤC -> GỬI SỐ LƯỢNG TRƯỚC, CHỜ BÁO GIÁ SAU
  void _themThuocNgoaiDanhMuc() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '50');
    final unitCtrl = TextEditingController(text: 'Hộp');

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Yêu cầu thuốc mới', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('* Ghi chú: Các thuốc ngoài danh mục sẽ được gửi đi để NCC xác nhận lại giá.', style: TextStyle(fontSize: 12, color: Colors.orange, fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên thuốc yêu cầu')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextField(controller: qtyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Số lượng'))),
                    const SizedBox(width: 16),
                    Expanded(child: TextField(controller: unitCtrl, decoration: const InputDecoration(labelText: 'Đơn vị'))),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  setState(() {
                    _cart.add({
                      'name': nameCtrl.text + ' (Khách đặt riêng)',
                      'qty': int.tryParse(qtyCtrl.text) ?? 1,
                      'unit': unitCtrl.text,
                      'importPrice': 0.0 // Mặc định = 0 đ để chờ báo giá
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Thêm vào đơn', style: TextStyle(color: Colors.white)),
            )
          ],
        )
    );
  }

  void _chonThuocCungUng() {
    List<Map<String, dynamic>> displayedMedicines = List.from(globalMedicines);
    showModalBottomSheet(
        context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
        builder: (context) => StatefulBuilder(
            builder: (context, setModalState) => Container(
              height: MediaQuery.of(context).size.height * 0.75, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))), padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Tìm trong kho...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                          onChanged: (value) => setModalState(() => displayedMedicines = globalMedicines.where((m) => m['name'].toString().toLowerCase().contains(value.toLowerCase())).toList()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(onPressed: () { Navigator.pop(context); _themThuocNgoaiDanhMuc(); }, icon: const Icon(Icons.post_add, color: Colors.orange, size: 30), tooltip: 'Nhập thuốc ngoài'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: displayedMedicines.length,
                      itemBuilder: (context, index) {
                        final item = displayedMedicines[index];
                        return ListTile(
                          leading: const Icon(Icons.medication),
                          title: Text(item['name']),
                          subtitle: Text('Tồn kho hiện tại: ${item['stock']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.blueAccent, size: 30),
                            onPressed: () {
                              Navigator.pop(context); // Đóng bottom sheet
                              _promptAddCartItem(item); // 👈 GỌI HÀM LẤY GIÁ TỰ ĐỘNG
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }

  void _guiYeuCau() {
    if (_ngayGiaoDuKien == null || _cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ngày và thuốc!'), backgroundColor: Colors.red));
      return;
    }

    String itemsText = _cart.map((e) => '${e['name']} (${e['qty']})').join(', ');

    globalPurchaseOrders.insert(0, {
      'id': 'HDN${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'supplierId': widget.supplier['id'],
      'date': DateFormat('dd/MM/yyyy').format(_ngayGiaoDuKien!),
      'total': _totalOrderAmount,
      'items': itemsText,
      'status': 'Chờ giao hàng',
    });

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          content: const Text('Đã gửi Phiếu Đặt Hàng!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          actions: [
            ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('HOÀN TẤT'))
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasPendingPrice = _cart.any((item) => item['importPrice'] == 0); // Kiểm tra xem có món nào bị 0đ không

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Lập Phiếu Đặt Hàng', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.orange, foregroundColor: Colors.white),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: ListTile(title: const Text('Ngày giao dự kiến'), subtitle: Text(_ngayGiaoDuKien != null ? DateFormat('dd/MM/yyyy').format(_ngayGiaoDuKien!) : 'Chưa chọn ngày', style: TextStyle(color: _ngayGiaoDuKien == null ? Colors.red : Colors.black)), trailing: OutlinedButton(onPressed: _chonNgayGiao, child: const Text('Chọn ngày'))),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            child: ListTile(
                title: const Text('Danh sách cung ứng', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(onPressed: _themThuocNgoaiDanhMuc, icon: const Icon(Icons.edit, color: Colors.orange), label: const Text('Nhập tay', style: TextStyle(color: Colors.orange))),
                    TextButton.icon(onPressed: _chonThuocCungUng, icon: const Icon(Icons.add), label: const Text('Chọn kho')),
                  ],
                )
            ),
          ),
          Expanded(
            child: _cart.isEmpty
                ? const Center(child: Text('Phiếu yêu cầu đang trống.', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _cart.length,
                itemBuilder: (context, index) {
                  final item = _cart[index];
                  final double subtotal = item['qty'] * item['importPrice'];
                  final bool isChuaCoGia = item['importPrice'] == 0;

                  return Card(
                      elevation: 1, margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),

                        // 🎯 NẾU CÓ GIÁ THÌ HIỆN TIỀN, NẾU 0Đ THÌ HIỆN CHỜ BÁO GIÁ
                        subtitle: Text(
                            isChuaCoGia
                                ? 'Số lượng: ${item['qty']} ${item['unit']}\nThành tiền: Đang chờ NCC báo giá'
                                : 'Giá NCC: ${formatCurrency.format(item['importPrice'])} / ${item['unit']} (x${item['qty']})\nThành tiền: ${formatCurrency.format(subtotal)}',
                            style: TextStyle(height: 1.4, color: isChuaCoGia ? Colors.orange : Colors.grey[700], fontWeight: isChuaCoGia ? FontWeight.bold : FontWeight.normal)
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Nút sửa giờ chỉ dùng để sửa Số lượng
                            IconButton(icon: const Icon(Icons.edit, color: Colors.blueAccent), onPressed: () => _editCartItem(index)),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => _cart.removeAt(index))),
                          ],
                        ),
                      )
                  );
                }
            ),
          ),

          // KHUNG TỔNG TIỀN
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -3))]
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng tiền tạm tính:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(formatCurrency.format(_totalOrderAmount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red)),
                  ],
                ),

                // Nếu trong đơn có hàng lạ chưa có giá thì nhắc nhở CEO
                if (hasPendingPrice)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('* Một số thuốc mới đang chờ NCC xác nhận giá hợp đồng.', style: TextStyle(color: Colors.orange, fontSize: 12, fontStyle: FontStyle.italic)),
                  ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                      onPressed: _guiYeuCau,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: const Text('GỬI YÊU CẦU CHO ĐỐI TÁC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ===================================================================
// 3. FORM THÊM NHÀ CUNG CẤP (Tách rời)
// ===================================================================
class AddSupplierDialog extends StatefulWidget {
  const AddSupplierDialog({Key? key}) : super(key: key);
  @override State<AddSupplierDialog> createState() => _AddSupplierDialogState();
}

class _AddSupplierDialogState extends State<AddSupplierDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'id': 'SUP${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        'name': _nameCtrl.text.trim(),
        'contact': _phoneCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'debt': 0.0,
        'rating': 5.0,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Thêm Đối Tác Mới', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: _nameCtrl, decoration: InputDecoration(labelText: 'Tên Công ty', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))), validator: (val) => val!.isEmpty ? 'Vui lòng nhập tên' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'Số điện thoại', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))), validator: (val) => val!.isEmpty ? 'Vui lòng nhập SĐT' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _emailCtrl, decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 12),
              TextFormField(controller: _addressCtrl, decoration: InputDecoration(labelText: 'Địa chỉ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('HỦY')),
        ElevatedButton(onPressed: _submit, child: const Text('LƯU ĐỐI TÁC')),
      ],
    );
  }
}