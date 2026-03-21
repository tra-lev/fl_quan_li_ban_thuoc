import 'package:flutter/material.dart';

class ProductsTab extends StatefulWidget {
  const ProductsTab({Key? key}) : super(key: key);

  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';

  final List<String> _categories = ['Tất cả', 'Giảm đau', 'Kháng sinh', 'Vitamin', 'Hô hấp', 'Khác'];

  final List<Map<String, dynamic>> _mockProducts = [
    {
      'id': 'SP001',
      'name': 'Panadol Extra 500mg',
      'category': 'Giảm đau',
      'price': '65.000',
      'stock': 120,
      'unit': 'Hộp',
      'expiry': '12/2025',
    },
    {
      'id': 'SP002',
      'name': 'Vitamin C 1000mg',
      'category': 'Vitamin',
      'price': '85.000',
      'stock': 15,
      'unit': 'Lọ',
      'expiry': '05/2025',
    },
    {
      'id': 'SP003',
      'name': 'Amoxicillin 500mg',
      'category': 'Kháng sinh',
      'price': '45.000',
      'stock': 0,
      'unit': 'Vỉ',
      'expiry': '11/2024',
    },
    {
      'id': 'SP004',
      'name': 'Nước muối sinh lý 0.9%',
      'category': 'Khác',
      'price': '5.000',
      'stock': 350,
      'unit': 'Chai',
      'expiry': '01/2026',
    },
    {
      'id': 'SP005',
      'name': 'Siro ho Prospan',
      'category': 'Hô hấp',
      'price': '75.000',
      'stock': 8,
      'unit': 'Chai',
      'expiry': '08/2025',
    },
  ];

  Color _getStockColor(int stock) {
    if (stock == 0) return Colors.red;
    if (stock <= 20) return Colors.orange;
    return Colors.green;
  }

  String _getStockText(int stock) {
    if (stock == 0) return 'Hết hàng';
    if (stock <= 20) return 'Sắp hết ($stock)';
    return 'Còn hàng ($stock)';
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                      child: const Icon(Icons.medication, color: Colors.blue, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          Text(
                            'Mã SP: ${product['id']}',
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 12),
                _buildDetailRow('Danh mục:', product['category']),
                _buildDetailRow('Đơn vị tính:', product['unit']),
                _buildDetailRow('Hạn sử dụng:', product['expiry']),
                _buildDetailRow('Giá bán:', '${product['price']}đ', isPrice: true),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Text('Tồn kho: ', style: TextStyle(color: Colors.black87, fontSize: 14)),
                      Text(
                        _getStockText(product['stock']),
                        style: TextStyle(
                            color: _getStockColor(product['stock']),
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                        child: const Text('ĐÓNG', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tính năng sửa đang phát triển...')));
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('CHỈNH SỬA', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isPrice = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: const TextStyle(color: Colors.black87, fontSize: 14)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  color: isPrice ? Colors.blue : Colors.black87,
                  fontSize: isPrice ? 16 : 14,
                  fontWeight: isPrice ? FontWeight.bold : FontWeight.normal
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Logic lọc (Category + Search)
    List<Map<String, dynamic>> filteredProducts = _mockProducts.where((product) {
      bool matchCategory = _selectedCategory == 'Tất cả' || product['category'] == _selectedCategory;
      String query = _searchQuery.toLowerCase();
      bool matchSearch = product['id'].toString().toLowerCase().contains(query) ||
          product['name'].toString().toLowerCase().contains(query);
      return matchCategory && matchSearch;
    }).toList();

    // 2. Logic Quản lý: Sắp xếp sản phẩm hết hàng hoặc sắp hết lên đầu để quản lý theo dõi
    filteredProducts.sort((a, b) => a['stock'].compareTo(b['stock']));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tính năng Thêm sản phẩm mới')));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              'QUẢN LÝ SẢN PHẨM',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm theo tên thuốc, mã SP...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: _categories.map((category) {
                        bool isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) => setState(() => _selectedCategory = category),
                            selectedColor: Colors.blue,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            backgroundColor: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Colors.transparent),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('Không tìm thấy sản phẩm nào', style: TextStyle(color: Colors.grey, fontSize: 16)))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                int stock = product['stock'];
                Color stockColor = _getStockColor(stock);

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () => _showProductDetails(context, product),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.medication_liquid, color: Colors.blue, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Mã: ${product['id']} • ${product['category']}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${product['price']}đ / ${product['unit']}',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                                    ),
                                    Text(
                                      _getStockText(stock),
                                      style: TextStyle(color: stockColor, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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