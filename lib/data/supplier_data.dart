// 1. Kho dữ liệu Nhà Cung Cấp
List<Map<String, dynamic>> globalSuppliers = [
  {
    'id': 'SUP001',
    'name': 'Công ty Dược phẩm Trung ương 1',
    'contact': '02438254261',
    'address': 'Hà Nội',
    'email': 'contact@cpc1.com.vn',
    'debt': 15000000.0,
    'rating': 4.5,
  },
  {
    'id': 'SUP002',
    'name': 'Dược UTC (DUTC)',
    'contact': '02923891433',
    'address': 'Số 3, đường Cầu Giấy, phường Đống Đa, Hà Nội',
    'email': 'utc@123.com.vn',
    'debt': 0.0,
    'rating': 5.0,
  },
];

// 2. TẠO THÊM KHO LƯU TRỮ LỊCH SỬ ĐẶT HÀNG (MỚI)
List<Map<String, dynamic>> globalPurchaseOrders = [
  // Tạo 1 đơn hàng mẫu có sẵn
  {
    'id': 'HDN001',
    'supplierId': 'SUP001', // Thuốc của công ty số 1
    'date': '20/03/2026',
    'total': 15000000.0,
    'items': 'Paracetamol (500), Amoxicillin (200)',
    'status': 'Đã thanh toán',
  }
];