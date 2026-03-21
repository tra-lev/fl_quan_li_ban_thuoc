import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class CeoDashboard extends StatelessWidget {
  final AuthService _authService = AuthService();

  void _logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang CEO'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => _logout(context)),
        ],
      ),
      body: Center(child: Text('Chào mừng CEO!')), //
    );
  }
}