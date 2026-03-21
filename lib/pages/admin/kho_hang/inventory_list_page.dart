import 'package:flutter/material.dart';

class InventoryListPage extends StatelessWidget {
  const InventoryListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Thanh tìm kiếm nhanh
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm tên thuốc, hoạt chất...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),
          // Danh sách thuốc thực tế
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Demo 5 item
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.medication, color: Colors.blue),
                    title: const Text('Paracetamol 500mg', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Tồn kho: 120 viên | HSD: 20/12/2026'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Xem chi tiết thuốc
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}