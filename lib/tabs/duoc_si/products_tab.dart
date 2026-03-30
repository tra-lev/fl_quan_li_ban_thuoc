// lib/tabs/duoc_si/products_tab.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/medicine_data.dart';

class ProductsTab extends StatefulWidget {
  const ProductsTab({Key? key}) : super(key: key);

  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';

  // Khởi tạo format tiền tệ VNĐ
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  // Tự động trích xuất các danh mục duy nhất từ kho thuốc thực tế
  List<String> get _categories {
    Set<String> cats = {'Tất cả'};
    for (var m in globalMedicines) {
      if (m['category'] != null) {
        cats.add(m['category']);
      }
    }
    return cats.toList();
  }

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

  // Hộp thoại xem chi tiết sản phẩm (ĐÃ XÓA NÚT CHỈNH SỬA, CHỈ CHO XEM)
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
                            product['name'] ?? 'Chưa cập nhật',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          Text(
                            'Mã SP: ${product['id'] ?? 'N/A'}',
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
                _buildDetailRow('Danh mục:', product['category'] ?? 'Khác'),
                _buildDetailRow('Đơn vị tính:', product['unit'] ?? 'N/A'),
                _buildDetailRow('Hạn sử dụng:', product['expiry'] ?? 'N/A'),
                _buildDetailRow('Giá bán:', formatCurrency.format(product['price'] ?? 0), isPrice: true),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Text('Tồn kho: ', style: TextStyle(color: Colors.black87, fontSize: 14)),
                      Text(
                        _getStockText(product['stock'] ?? 0),
                        style: TextStyle(
                            color: _getStockColor(product['stock'] ?? 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Nút Đóng tràn viền đẹp mắt
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(color: Colors.blue.shade400, width: 1.5),
                    ),
                    child: const Text('ĐÓNG', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
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
    // Logic lọc (Category + Search)
    List<Map<String, dynamic>> filteredProducts = globalMedicines.where((product) {
      bool matchCategory = _selectedCategory == 'Tất cả' || product['category'] == _selectedCategory;
      String query = _searchQuery.toLowerCase();
      bool matchSearch = (product['id']?.toString().toLowerCase().contains(query) ?? false) ||
          (product['name']?.toString().toLowerCase().contains(query) ?? false);
      return matchCategory && matchSearch;
    }).toList();

    // Sắp xếp sản phẩm hết hàng hoặc sắp hết lên đầu để Dược sĩ ưu tiên tư vấn
    filteredProducts.sort((a, b) => (a['stock'] as int).compareTo(b['stock'] as int));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      // ĐÃ BỎ FLOATING ACTION BUTTON (Nút thêm sản phẩm) vì Dược sĩ không có quyền này
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              'TRA CỨU SẢN PHẨM', // Đổi tên từ Quản lý -> Tra cứu cho đúng nghiệp vụ
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
                int stock = product['stock'] ?? 0;
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
                                  product['name'] ?? 'N/A',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Mã: ${product['id']} • ${product['category'] ?? 'Khác'}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${formatCurrency.format(product['price'] ?? 0)} / ${product['unit'] ?? ''}',
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