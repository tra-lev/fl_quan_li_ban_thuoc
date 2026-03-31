import 'package:flutter/material.dart';
import 'package:fl_quan_li_ban_thuoc/pages/admin/kho_hang/add_thuoc.dart';
import '../../../data/medicine_data.dart'; // IMPORT DATA THUỐC

class InventoryListPage extends StatefulWidget {
  const InventoryListPage({Key? key}) : super(key: key);
  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  List<Map<String, dynamic>> _foundMedicines = [];

  @override
  void initState() {
    super.initState();
    _foundMedicines = globalMedicines;
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      if (enteredKeyword.isEmpty) {
        _foundMedicines = globalMedicines;
      } else {
        _foundMedicines = globalMedicines.where((medicine) => medicine['name']!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      }
    });
  }

  void _showAddMedicineDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddMedicineDialog(),
    );

    if (result != null) {
      setState(() {
        final newEntry = {
          'id': 'SP${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
          'name': result['name'],
          'stock': int.tryParse(result['stock'].toString()) ?? 0,
          'expiry': result['expiry'],
          'unit': result['unit'],
          'price': result['sell_price'] ?? 0,
          'category': 'Mới thêm',
          'batch': 'NEW',
          'location': 'Chưa xếp kệ'
        };
        globalMedicines.insert(0, newEntry);
        _foundMedicines = globalMedicines;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _runFilter,
              decoration: InputDecoration(hintText: 'Tìm tên thuốc, hoạt chất...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
          Expanded(
            child: _foundMedicines.isEmpty
                ? const Center(child: Text('Không tìm thấy thuốc'))
                : ListView.builder(
              itemCount: _foundMedicines.length,
              itemBuilder: (context, index) {
                final item = _foundMedicines[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.medication, color: Colors.blue),
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Tồn kho: ${item['stock']} | HSD: ${item['expiry']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddMedicineDialog, child: const Icon(Icons.add)),
    );
  }
}