import 'package:flutter/material.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  // Biến lưu trữ từ khóa tìm kiếm
  String _searchQuery = '';

  // Biến lưu trữ trạng thái filter hiện tại
  String _selectedFilter = 'Tất cả';

  // Danh sách các tab lọc
  final List<String> _filters = ['Tất cả', 'Hoàn thành', 'Đang giao', 'Chờ xử lý', 'Đã hủy'];

  // MOCK DATA: Dữ liệu giả lập
  final List<Map<String, dynamic>> _mockOrders = [
    {
      'id': 'DH1024',
      'date': '15/03/2026 14:30',
      'customerName': 'Nguyễn Văn A',
      'phone': '0987654321',
      'total': '350.000',
      'status': 'Hoàn thành',
    },
    {
      'id': 'DH1025',
      'date': '15/03/2026 15:00',
      'customerName': 'Trần Thị B',
      'phone': '0912345678',
      'total': '125.000',
      'status': 'Đang giao',
    },
    {
      'id': 'DH1026',
      'date': '15/03/2026 16:15',
      'customerName': 'Lê Văn C',
      'phone': '0888999777',
      'total': '420.000',
      'status': 'Chờ xử lý',
    },
    {
      'id': 'DH1027',
      'date': '15/03/2026 17:00',
      'customerName': 'Phạm Khánh D',
      'phone': '0333222111',
      'total': '80.000',
      'status': 'Đã hủy',
    },
    {
      'id': 'DH1028',
      'date': '16/03/2026 08:30',
      'customerName': 'Nguyễn Văn A', // Cùng tên để test tìm kiếm
      'phone': '0987654321',
      'total': '150.000',
      'status': 'Chờ xử lý',
    },
  ];

  // Hàm chọn màu sắc dựa trên trạng thái đơn hàng
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Hoàn thành':
        return Colors.green;
      case 'Đã hủy':
        return Colors.redAccent;
      case 'Đang giao':
      case 'Chờ xử lý':
      default:
        return Colors.blue;
    }
  }

  // Hàm hiển thị Popup Chi tiết hóa đơn
  void _showInvoiceDialog(BuildContext context, Map<String, dynamic> order) {
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
                // Header Popup
                Text(
                  'TIỆM THUỐC UTC',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue[800], fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'HÓA ĐƠN BÁN HÀNG',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // Thông tin chung
                _buildDetailRow('Mã đơn:', '#${order['id']}'),
                _buildDetailRow('Ngày bán:', order['date']),
                _buildDetailRow('Khách hàng:', '${order['customerName']} - ${order['phone']}'),

                // Trạng thái (có màu)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Text('Trạng thái: ', style: TextStyle(color: Colors.black87, fontSize: 14)),
                      Text(
                        order['status'],
                        style: TextStyle(color: _getStatusColor(order['status']), fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                const Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 12),

                // Chi tiết sản phẩm
                const Text('Chi tiết sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('1 x Đơn thuốc kê theo toa', style: TextStyle(fontSize: 14, color: Colors.black87)),
                    Text('(Theo giá tổng)', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 12),

                // Tổng cộng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('TỔNG CỘNG:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(
                      '${order['total']}đ',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Các nút thao tác
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
                          // Thêm chức năng in hóa đơn ở đây
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang kết nối máy in...')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('IN HÓA ĐƠN', style: TextStyle(fontWeight: FontWeight.bold)),
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

  // Widget con hỗ trợ vẽ từng dòng trong Popup
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: const TextStyle(color: Colors.black87, fontSize: 14)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // KẾT HỢP LOGIC TÌM KIẾM VÀ LỌC TRẠNG THÁI
    List<Map<String, dynamic>> filteredOrders = _mockOrders.where((order) {
      // 1. Kiểm tra bộ lọc trạng thái
      bool matchFilter = _selectedFilter == 'Tất cả' || order['status'] == _selectedFilter;

      // 2. Kiểm tra từ khóa tìm kiếm (Tìm theo ID, Tên, hoặc SĐT)
      String query = _searchQuery.toLowerCase();
      bool matchSearch = order['id'].toString().toLowerCase().contains(query) ||
          order['customerName'].toString().toLowerCase().contains(query) ||
          order['phone'].toString().toLowerCase().contains(query);

      return matchFilter && matchSearch;
    }).toList();

    return Column(
      children: [
        // 1. Tiêu đề Xanh dương
        Container(
          width: double.infinity,
          color: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Text(
            'QUẢN LÝ ĐƠN HÀNG',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        // Khung trắng chứa Search và Filter
        Container(
          color: Colors.white,
          child: Column(
            children: [
              // 2. Thanh tìm kiếm (Search Bar)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm theo tên khách, SĐT, mã đơn...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    // Cập nhật state khi người dùng gõ phím
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              // 3. Bộ lọc trạng thái (Filter Chips)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: _filters.map((filter) {
                      bool isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          selectedColor: Colors.blue,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          backgroundColor: Colors.grey[100], // Màu nền khi chưa chọn
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

        // 4. Danh sách đơn hàng
        Expanded(
          child: Container(
            color: Colors.grey[100], // Nền xám nhạt làm nổi bật thẻ trắng
            child: filteredOrders.isEmpty
                ? const Center(
              child: Text(
                'Không tìm thấy đơn hàng nào',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                Color statusColor = _getStatusColor(order['status']);

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    // Bấm vào Card để mở Popup
                    onTap: () => _showInvoiceDialog(context, order),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dòng 1: Icon List + ID + Ngày giờ + Nút Trạng thái
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.receipt_long, color: Colors.black87, size: 28),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '#${order['id']}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order['date'],
                                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              // Label Trạng thái
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  order['status'],
                                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Dòng 2: Icon Person + Tên SĐT + Tổng tiền
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.person, color: Colors.black54, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${order['customerName']} - ${order['phone']}',
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              ),
                              Text(
                                '${order['total']}đ',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}