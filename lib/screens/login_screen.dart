import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'admin_dashboard.dart';
import 'ceo_dashboard.dart';
import 'duoc_si_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController edtUsername = TextEditingController();
  final TextEditingController edtPassword = TextEditingController();
  final AuthService _authService = AuthService();

  // Biến dùng để ẩn/hiện mật khẩu
  bool _obscureText = true;

  void _handleLogin() async {
    String user = edtUsername.text.trim();
    String pass = edtPassword.text.trim();

    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
      );
      return;
    }

    var userModel = await _authService.login(user, pass);

    if (userModel != null) {
      Widget dashboard;
      if (userModel.role == 'admin') {
        dashboard = AdminDashboard();
      } else if (userModel.role == 'CEO') {
        dashboard = CeoDashboard();
      } else {
        dashboard = DuocSiDashboard(fullName: userModel.fullName!);
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => dashboard));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sai tài khoản hoặc mật khẩu!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy chiều rộng màn hình để kiểm tra là Mobile hay Desktop
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 600;

    // Chọn ảnh nền dựa trên thiết bị
    String bgImage = isDesktop ? 'assets/images/bg_desktop.png' : 'assets/images/bg_mobile.jpg';

    return Scaffold(
      body: Container(
        // 1. Cài đặt Ảnh nền phủ kín toàn màn hình
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgImage),
            fit: BoxFit.cover, // Cắt cúp ảnh cho vừa khít màn hình
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4), // Làm tối ảnh nền một chút để box đăng nhập nổi bật hơn
              BlendMode.darken,
            ),
          ),
        ),
        // 2. Canh giữa Box đăng nhập
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              // Giới hạn chiều rộng của box đăng nhập trên máy tính (không bị bè ra quá to)
              width: isDesktop ? 400 : screenWidth * 0.85,
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95), // Màu nền trắng hơi trong suốt
                borderRadius: BorderRadius.circular(20), // Bo góc mềm mại
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Chỉ chiếm chiều cao vừa đủ
                children: [
                  // Icon hoặc Logo phía trên
                  Icon(Icons.local_pharmacy, size: 80, color: Colors.blue[700]),
                  SizedBox(height: 16),

                  // Tiêu đề
                  Text(
                    'ĐĂNG NHẬP',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Ô nhập Username
                  TextField(
                    controller: edtUsername,
                    decoration: InputDecoration(
                      labelText: 'Tên đăng nhập',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Ô nhập Password có nút con mắt
                  TextField(
                    controller: edtPassword,
                    obscureText: _obscureText, // Trạng thái ẩn/hiện
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: Icon(Icons.lock),
                      // Nút ẩn/hiện mật khẩu (Suffix Icon)
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          // Đổi trạng thái khi bấm vào nút
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Nút bấm Đăng Nhập
                  SizedBox(
                    width: double.infinity, // Nút rộng bằng 100% box
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700], // Màu nền nút
                        foregroundColor: Colors.white, // Màu chữ
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'ĐĂNG NHẬP',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}