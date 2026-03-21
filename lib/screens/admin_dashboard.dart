import 'package:flutter/material.dart';
import 'package:fl_quan_li_ban_thuoc/tabs/admin/home_tab.dart';
import 'package:fl_quan_li_ban_thuoc/tabs/admin/inventory_tab.dart';
import 'package:fl_quan_li_ban_thuoc/tabs/admin/setting_tab.dart';
import 'package:fl_quan_li_ban_thuoc/tabs/admin/staff_tab.dart';
import 'package:fl_quan_li_ban_thuoc/tabs/admin/notification_tab.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  // Danh sách 5 màn hình chính - Thứ tự cực kỳ quan trọng
  final List<Widget> _tabs = [
    const HomeTab(),         // Index 0
    const InventoryTab(),    // Index 1
    const StaffTab(),        // Index 2
    const NotificationTab(), // Index 3
    const SettingsTab(),     // Index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      // Chỉ hiển thị nội dung của Tab được chọn
      body: _tabs[_selectedIndex],

      // Luôn luôn sử dụng BottomNavigationBar ở dưới đáy
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Kho'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Nhân viên'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}