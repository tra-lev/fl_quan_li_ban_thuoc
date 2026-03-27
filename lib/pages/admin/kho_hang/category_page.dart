import 'package:flutter/material.dart';
import 'category_detail_page.dart'; // Import trang chi tiết

class CategoryTab extends StatefulWidget {
  const CategoryTab({Key? key}) : super(key: key);

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Thuốc kháng sinh', 'count': 45, 'icon': Icons.biotech},
    {
      'name': 'Thực phẩm chức năng',
      'count': 120,
      'icon': Icons.health_and_safety
    },
    {'name': 'Dược mỹ phẩm', 'count': 30, 'icon': Icons.face},
    {'name': 'Dụng cụ y tế', 'count': 15, 'icon': Icons.medical_information},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Danh mục sản phẩm', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCategoryDialog(context),
        label: const Text('Thêm nhóm'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            // Thu nhỏ độ rộng tối đa để hiển thị nhiều cột hơn
            childAspectRatio: 1.0,
            // Chỉnh về 1.0 (hình vuông) để có nhiều chỗ cho chữ hơn
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final cat = _categories[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  // CHUYỂN SANG TRANG CHI TIẾT
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryDetailPage(categoryName: cat['name']),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat['icon'], size: 40, color: Colors.blueAccent),
                      const SizedBox(height: 12),
                      Text(
                        cat['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text('${cat['count']} loại',
                          style: const TextStyle(color: Colors.grey,
                              fontSize: 12)),
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
    final TextEditingController _categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Tạo nhóm thuốc mới'),
            content: TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Tên danh mục',
                hintText: 'VD: Thuốc giảm đau...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy')),
              ElevatedButton(
                onPressed: () {
                  if (_categoryController.text.isNotEmpty) {
                    setState(() {
                      _categories.add({
                        'name': _categoryController.text,
                        'count': 0, // Nhóm mới chưa có thuốc
                        'icon': Icons.category_outlined, // Icon mặc định
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Thêm mới'),
              ),
            ],
          ),
    );
  }
}