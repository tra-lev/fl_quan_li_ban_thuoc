import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Cần thêm intl để xử lý ngày tháng
import '../data/medicine_data.dart';
import '../data/customer_data.dart';
import '../data/order_data.dart';
import '../data/request_data.dart';
import '../data/shift_report_data.dart';

class ApiService {
  static const String baseUrl = "https://api.nhathuoccua-ban.com/api/v1";

  // Thêm header mặc định nếu cần (ví dụ: Token bảo mật)
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // 1. Đổi mật khẩu: Chuyển sang POST API thực tế
  Future<Map<String, dynamic>> changePassword(String username, String oldPassword, String newPassword) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/change-password"),
      headers: _headers,
      body: jsonEncode({
        "username": username,
        "old_password": oldPassword,
        "new_password": newPassword,
      }),
    );
    return jsonDecode(response.body);
  }

  // 2. Lấy danh sách thuốc: Gọi GET từ Server
  Future<List<Map<String, dynamic>>> fetchMedicines() async {
    final response = await http.get(Uri.parse("$baseUrl/medicines"), headers: _headers);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    }
    return []; // Trả về rỗng nếu lỗi
  }

  // 3. Lấy thuốc theo danh mục
  Future<List<Map<String, dynamic>>> fetchMedicinesByCategory(String categoryName) async {
    final response = await http.get(
      Uri.parse("$baseUrl/medicines?category=$categoryName"),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    }
    return [];
  }

  // 4. Thêm khách hàng: Gửi POST data
  Future<Map<String, dynamic>> addCustomer(Map<String, dynamic> customerData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/customers"),
      headers: _headers,
      body: jsonEncode(customerData),
    );
    return jsonDecode(response.body);
  }

  // 5. Tạo đơn hàng: Chốt dữ liệu xuống Server
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/orders"),
      headers: _headers,
      body: jsonEncode(orderData),
    );
    return jsonDecode(response.body);
  }

  // 6. Tổng kết ca: Lọc theo ngày hệ thống thực tế
  Future<Map<String, dynamic>> getShiftSummary() async {
    // Bước này có thể gọi API riêng hoặc tính toán từ danh sách đơn hàng trả về
    final response = await http.get(Uri.parse("$baseUrl/orders/today"), headers: _headers);

    double cashTotal = 0;
    double transferTotal = 0;
    double codTotal = 0;
    List<Map<String, dynamic>> todayOrders = [];

    if (response.statusCode == 200) {
      List<dynamic> orders = jsonDecode(response.body);
      String today = DateFormat('dd/MM/yyyy').format(DateTime.now());

      for (var order in orders) {
        // Kiểm tra đúng ngày thực tế
        if (order['date'] == today) {
          todayOrders.add(order);
          if (order['paymentMethod'] == 'Chuyển khoản') {
            transferTotal += (order['total'] as num).toDouble();
          } else if (order['paymentMethod'] == 'Thanh toán khi nhận hàng') {
            codTotal += (order['total'] as num).toDouble();
          } else {
            cashTotal += (order['total'] as num).toDouble();
          }
        }
      }
    }

    return {
      'cashTotal': cashTotal,
      'transferTotal': transferTotal,
      'codTotal': codTotal,
      'totalRevenue': cashTotal + transferTotal + codTotal,
      'orderCount': todayOrders.length,
      'allOrders': todayOrders,
    };
  }

  // 7. Gửi báo cáo chốt ca đối soát
  Future<Map<String, dynamic>> submitShiftReport(Map<String, dynamic> reportData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/reports/shift"),
      headers: _headers,
      body: jsonEncode(reportData),
    );
    return jsonDecode(response.body);
  }

  // 8. Gửi yêu cầu nhập hàng
  Future<Map<String, dynamic>> sendRestockRequest(Map<String, dynamic> requestData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/inventory/restock-request"),
      headers: _headers,
      body: jsonEncode(requestData),
    );
    return jsonDecode(response.body);
  }
}