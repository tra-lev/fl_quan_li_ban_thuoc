import 'package:flutter/material.dart';

// --- IMPORT CÁC TRANG CHỨC NĂNG CỦA CEO ---
import '../tabs/ceo/home_tab.dart';
import '../tabs/ceo/admins_tab.dart';
import '../tabs/ceo/profile_tab.dart';
import '../pages/ceo/khuyen_mai/danh_sach_khuyen_mai_page.dart';

// --- IMPORT TRANG NHÀ CUNG CẤP ---
import '../pages/ceo/nha_cung_cap/supplier_page.dart';

class CeoDashboard extends StatefulWidget {
  const CeoDashboard({super.key});

  @override
  State<CeoDashboard> createState() => _CeoDashboardState();
}

class _CeoDashboardState extends State<CeoDashboard> {
  // Mặc định mở app lên là vào trang Tổng quan (Tab 0)
  int _selectedIndex = 0;

  // ==========================================================
  // LẮP RÁP 5 TRANG VÀO ĐÚNG VỊ TRÍ
  // ==========================================================
  final List<Widget> _pages = [
    const CeoHomeTab(),              // Tab 0: Tổng quan
    const SupplierTab(),             // Tab 1: ĐÃ ĐỔI THÀNH NHÀ CUNG CẤP
    const CeoAdminsTab(),            // Tab 2: Admins
    const DanhSachKhuyenMaiPage(),   // Tab 3: Khuyến mãi
    const CeoProfileTab(),           // Tab 4: Tài khoản
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dùng IndexedStack để giữ nguyên trạng thái các Tab khi chuyển qua lại
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // THANH MENU DƯỚI ĐÁY
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Bắt buộc dùng fixed để hiện đủ 5 tab
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Tổng quan',
          ),
          // ĐÃ ĐỔI ICON VÀ CHỮ Ở ĐÂY THÀNH "NHÀ CUNG CẤP"
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Nhà cung cấp',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Khuyến mãi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}