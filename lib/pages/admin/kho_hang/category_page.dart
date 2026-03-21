import 'package:flutter/material.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({Key? key}) : super(key: key);

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Thuốc kháng sinh', 'count': 45, 'icon': Icons.biotech},
    {'name': 'Thực phẩm chức năng', 'count': 120, 'icon': Icons.health_and_safety},
    {'name': 'Dược mỹ phẩm', 'count': 30, 'icon': Icons.face},
    {'name': 'Dụng cụ y tế', 'count': 15, 'icon': Icons.medical_information},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh mục sản phẩm')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCategoryDialog(context),
        label: const Text('Thêm nhóm'),
        icon: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final cat = _categories[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                onTap: () {}, // Xem chi tiết các thuốc trong nhóm này
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat['icon'], size: 40, color: Colors.blueAccent),
                      const SizedBox(height: 10),
                      Text(cat['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text('${cat['count']} sản phẩm', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo nhóm thuốc mới'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Tên danh mục',
            hintText: 'VD: Thuốc hạ sốt...',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(onPressed: () {}, child: const Text('Thêm mới')),
        ],
      ),
    );
  }
}