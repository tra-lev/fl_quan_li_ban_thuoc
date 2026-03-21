import 'package:flutter/material.dart';

class SupplierTab extends StatefulWidget {
  const SupplierTab({Key? key}) : super(key: key);

  @override
  State<SupplierTab> createState() => _SupplierTabState();
}

class _SupplierTabState extends State<SupplierTab> {
  final List<Map<String, String>> _suppliers = [
    {
      'name': 'Công ty Dược phẩm Trung ương 1',
      'contact': '024.3825.4261',
      'address': 'Hà Nội',
      'email': 'contact@cpc1.com.vn'
    },
    {
      'name': 'Dược Hậu Giang (DHG)',
      'contact': '0292.3891.433',
      'address': 'Cần Thơ',
      'email': 'dhgpharma@dhg.com.vn'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đối tác cung ứng'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.picture_as_pdf)), // Xuất báo cáo công nợ
        ],
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
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: ExpansionTile(
              leading: const CircleAvatar(child: Icon(Icons.business)),
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
                              onPressed: () {},
                              icon: const Icon(Icons.history),
                              label: const Text('Lịch sử nhập')
                          ),
                          ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.phone),
                              label: const Text('Liên hệ ngay')
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
        onPressed: () {},
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.person_add_alt_1),
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