import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import 'login_screen.dart';
import 'admin_dashboard.dart';
import 'ceo_dashboard.dart';
import 'duoc_si_dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalStorageService _storageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2)); // Giả lập thời gian load
    String? role = await _storageService.getRole();

    Widget nextScreen = LoginScreen();

    if (role == 'admin') {
      nextScreen = AdminDashboard();
    } else if (role == 'CEO') {
      nextScreen = CeoDashboard();
    } else if (role == 'duocsi') {
      nextScreen = DuocSiDashboard(fullName: "Nguyễn Văn A");
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}