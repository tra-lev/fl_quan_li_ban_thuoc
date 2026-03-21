import 'package:flutter/material.dart';

class DonGiaoHangWidget extends StatefulWidget {
  const DonGiaoHangWidget({Key? key}) : super(key: key);

  @override
  State<DonGiaoHangWidget> createState() => _DonGiaoHangWidgetState();
}

class _DonGiaoHangWidgetState extends State<DonGiaoHangWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  List<Map<String, dynamic>> _selectedProducts = [
    {'name': 'Paracetamol 500mg', 'qty': 2, 'price': 35000},
  ];

  void _submitOrder() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin giao hàng!'), backgroundColor: Colors.red),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tạo đơn giao hàng thành công!'), backgroundColor: Colors.green),
    );
    Navigator.pop(context); // Quay lại trang chủ
  }

  @override
  Widget build(BuildContext context) {
    double total = _selectedProducts.fold(0, (sum, item) => sum + (item['qty'] * item['price']));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Tạo Đơn Giao Hàng', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan,
        elevation: 0,
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
                  _buildTextField(controller: _nameController, label: 'Tên khách hàng', icon: Icons.person),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _phoneController, label: 'Số điện thoại', icon: Icons.phone, isNumber: true),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _addressController, label: 'Địa chỉ giao hàng', icon: Icons.location_on),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sản phẩm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle, color: Colors.cyan),
                  label: const Text('Thêm thuốc', style: TextStyle(color: Colors.cyan)),
                )
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _selectedProducts.length,
              itemBuilder: (context, index) {
                final item = _selectedProducts[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.medication, color: Colors.cyan),
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Số lượng: ${item['qty']} x ${item['price']}đ'),
                    trailing: const Icon(Icons.delete_outline, color: Colors.red),
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
                  Text('${total.toInt()}đ', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('XÁC NHẬN TẠO ĐƠN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
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
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}