import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'import_history_page.dart';

class SupplierTab extends StatefulWidget {
  const SupplierTab({Key? key}) : super(key: key);

  @override
  State<SupplierTab> createState() => _SupplierTabState();
}

class _SupplierTabState extends State<SupplierTab> {
  // Thêm trường 'id' vào dữ liệu để sau này dùng làm khóa ngoại (Foreign Key) truy vấn DB
  final List<Map<String, String>> _suppliers = [
    {
      'id': 'SUP001',
      'name': 'Công ty Dược phẩm Trung ương 1',
      'contact': '02438254261',
      'address': 'Hà Nội',
      'email': 'contact@cpc1.com.vn'
    },
    {
      'id': 'SUP002',
      'name': 'Dược UTC (DUTC)',
      'contact': '02923891433',
      'address': 'Số 3, đường Cầu Giấy, phường Đống Đa, Hà Nội',
      'email': 'utc@123.com.vn'
    },
  ];

  void _showAddSupplierDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final addressCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm Đối Tác Mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên Công ty')),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Số điện thoại'), keyboardType: TextInputType.phone),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Địa chỉ')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('HỦY')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  _suppliers.add({
                    'id': 'SUP${DateTime.now().millisecondsSinceEpoch}', // Tạo ID tạm thời
                    'name': nameCtrl.text,
                    'contact': phoneCtrl.text,
                    'email': emailCtrl.text,
                    'address': addressCtrl.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('LƯU'),
          ),
        ],
      ),
    );
  }

  Future<void> _makeContact(String phone, String email) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: Text('Gọi điện: $phone'),
            onTap: () async {
              final Uri url = Uri.parse('tel:$phone');
              if (await canLaunchUrl(url)) await launchUrl(url);
            },
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: Text('Gửi Email: $email'),
            onTap: () async {
              final Uri url = Uri.parse('mailto:$email');
              if (await canLaunchUrl(url)) await launchUrl(url);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đối tác cung ứng', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0.5,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _suppliers.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final sup = _suppliers[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: ExpansionTile(
              leading: const CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.business, color: Colors.white)),
              title: Text(sup['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('SĐT: ${sup['contact']}'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.location_on, 'Địa chỉ: ${sup['address']}'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.email, 'Email: ${sup['email']}'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton.icon(
                            // CHUYỂN TRANG TẠI ĐÂY
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImportHistoryPage(
                                    supplierId: sup['id']!,
                                    supplierName: sup['name']!,
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.history),
                              label: const Text('Lịch sử nhập')
                          ),
                          ElevatedButton.icon(
                              onPressed: () => _makeContact(sup['contact']!, sup['email']!),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                              icon: const Icon(Icons.contact_phone, color: Colors.white),
                              label: const Text('Liên hệ', style: TextStyle(color: Colors.white))
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSupplierDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.person_add_alt_1, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.black87))),
      ],
    );
  }
}