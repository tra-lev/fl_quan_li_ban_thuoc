import 'package:flutter/material.dart';

class TonKhoPage extends StatefulWidget {
  const TonKhoPage({Key? key}) : super(key: key);

  @override
  State<TonKhoPage> createState() => _TonKhoPageState();
}

class _TonKhoPageState extends State<TonKhoPage> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _inventoryData = [
    {
      'name': 'Hapacol 250',
      'batch': 'LOT202401',
      'expiry': '2024-05-15',
      'stock': 50,
      'unit': 'Gói',
      'location': 'Kệ trẻ em',
    },
    {
      'name': 'Panadol Extra',
      'batch': 'PN8829',
      'expiry': '2026-12-01',
      'stock': 1200,
      'unit': 'Viên',
      'location': 'Kệ A1',
    },
  ];

  int _checkExpiryStatus(String expiryDate) {
    DateTime now = DateTime.now();
    DateTime exp = DateTime.parse(expiryDate);
    if (exp.isBefore(now)) return 2; // Hết hạn
    if (exp.difference(now).inDays < 180) return 1; // Sắp hết hạn
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('QUẢN LÝ TỒN KHO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[800],
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Tìm tên thuốc hoặc số lô...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _inventoryData.length,
              itemBuilder: (context, index) {
                final item = _inventoryData[index];
                int status = _checkExpiryStatus(item['expiry']);
                Color statusColor = status == 2 ? Colors.red : (status == 1 ? Colors.orange : Colors.green);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: statusColor.withOpacity(0.3))),
                  child: ListTile(
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lô: ${item['batch']} | Vị trí: ${item['location']}'),
                        Text('HSD: ${item['expiry']}', style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    trailing: Text('${item['stock']} ${item['unit']}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}