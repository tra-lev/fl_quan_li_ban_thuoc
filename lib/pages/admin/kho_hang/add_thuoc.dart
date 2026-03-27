import 'package:flutter/material.dart';

class AddMedicineDialog extends StatefulWidget {
  const AddMedicineDialog({Key? key}) : super(key: key);

  @override
  State<AddMedicineDialog> createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controllers để lấy dữ liệu từ ô nhập
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _activeIngredientController = TextEditingController();
  final TextEditingController _unitController = TextEditingController(text: 'Viên');
  final TextEditingController _importPriceController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.add_business, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text('Thêm Thuốc Mới'),
        ],
      ),
      content: SizedBox(
        width: 450, // Cố định chiều rộng cho đẹp trên cả Web và Mobile
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_nameController, 'Tên thuốc (Ví dụ: Hapacol 650)', Icons.medication),
                const SizedBox(height: 12),
                _buildTextField(_activeIngredientController, 'Hoạt chất (Ví dụ: Paracetamol)', Icons.science_outlined),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(child: _buildTextField(_unitController, 'Đơn vị', Icons.unfold_more)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(_stockController, 'Số lượng nhập', Icons.inventory, isNumber: true)),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(child: _buildTextField(_importPriceController, 'Giá nhập', Icons.download, isNumber: true)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(_sellPriceController, 'Giá bán', Icons.upload, isNumber: true)),
                  ],
                ),
                const SizedBox(height: 12),

                _buildTextField(_expiryController, 'Hạn sử dụng (DD/MM/YYYY)', Icons.date_range),
                const SizedBox(height: 8),
                const Text(
                  '* Lưu ý: Kiểm tra kỹ thông số trước khi lưu kho.',
                  style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('HỦY BỎ', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('LƯU KHO'),
        ),
      ],
    );
  }

  // Widget rút gọn để tạo các ô nhập liệu nhanh hơn
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      validator: (value) => value!.isEmpty ? 'Vui lòng nhập' : null,
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // Gom dữ liệu thành một Map để gửi đi
      final newMedicine = {
        'name': _nameController.text,
        'active': _activeIngredientController.text,
        'unit': _unitController.text,
        'stock': _stockController.text,
        'import_price': _importPriceController.text,
        'sell_price': _sellPriceController.text,
        'expiry': _expiryController.text,
      };

      // Đóng Dialog và trả dữ liệu về trang danh sách
      Navigator.pop(context, newMedicine);
    }
  }
}