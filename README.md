# fl_quan_li_ban_thuoc

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

lib/
├── main.dart                          <-- File gốc khởi chạy ứng dụng
│
├── models/                            <-- Nơi định nghĩa cấu trúc dữ liệu
│   └── user_model.dart
│
├── services/                          <-- Nơi gọi API, xử lý Database, đăng nhập
│   ├── auth_service.dart
│   └── local_storage_service.dart
│
├── screens/                           <-- 1. CÁC MÀN HÌNH GỐC & KHUNG SƯỜN
│   ├── splash_screen.dart             <-- Màn hình chờ
│   ├── login_screen.dart              <-- Màn hình đăng nhập
│   ├── admin_dashboard.dart           <-- Khung sườn chứa Menu của Admin
│   ├── ceo_dashboard.dart             <-- Khung sườn chứa Menu của CEO (BẠN ĐÃ CODE XONG)
│   └── duoc_si_dashboard.dart         <-- Khung sườn chứa Menu của Dược sĩ
│
├── tabs/                              <-- 2. NỘI DUNG 5 TAB CHÍNH (Gắn vào Khung sườn)
│   ├── admin/
│   │   ├── home_tab.dart
│   │   ├── inventory_tab.dart         
│   │   ├── staff_tab.dart
│   │   ├── notification_tab.dart
│   │   └── setting_tab.dart
│   │
│   ├── ceo/                           <-- (MỚI: Thư mục chứa các Tab của CEO)
│   │   ├── home_tab.dart              <-- Tab Tổng quan chuỗi
│   │   ├── catalog_tab.dart           <-- Tab Danh mục thuốc chuẩn
│   │   ├── admins_tab.dart            <-- Tab Quản lý Admins chi nhánh
│   │   ├── promotion_tab.dart         <-- Tab Khuyến mãi & Cấu hình giá
│   │   └── profile_tab.dart           <-- Tab Tài khoản CEO
│   │
│   └── duoc_si/
│       ├── home_tab.dart              <-- Tab Trang chủ
│       ├── orders_tab.dart            <-- Tab Đơn hàng
│       ├── products_tab.dart          <-- Tab Sản phẩm
│       ├── noti_tab.dart              <-- Tab Thông báo
│       └── profile_tab.dart           <-- Tab Tài khoản
│
└── pages/                             <-- 3. CÁC TRANG CHỨC NĂNG NHỎ LẺ (Mở lên từ các Tab)
├── admin/
│   └── kho_hang/
│       ├── inventory_list_page.dart  <-- Chi tiết kho
│       ├── category_page.dart        <-- Danh mục
│       └── supplier_page.dart        <-- Nhà cung cấp
│
├── ceo/                           <-- (MỚI: Thư mục chứa các trang chi tiết của CEO)
│   ├── tong_quan/
│   │   └── chi_tiet_doanh_thu_page.dart <-- (Mở từ Tab Tổng quan khi bấm vào chi nhánh)
│   │
│   ├── danh_muc/
│   │   └── them_thuoc_moi_page.dart     <-- (Mở từ Tab Danh mục khi bấm nút Thêm mã thuốc)
│   │
│   ├── admins/
│   │   └── chi_tiet_admin_page.dart     <-- (Mở từ Tab Admins khi bấm vào một Admin)
│   │
│   └── khuyen_mai/
│       └── tao_khuyen_mai_page.dart     <-- (Mở từ Tab Khuyến mãi khi bấm nút Phát hành)
│
└── duoc_si/                       <-- (Nơi bạn tạo các trang nhỏ lẻ cho dược sĩ)
├── trang_chu/
│   ├── don_giao_hang_page.dart   <-- Bấm từ tab Trang chủ -> mở trang này
│   ├── ban_tai_quay_page.dart    <-- Bấm từ tab Trang chủ -> mở trang này
│   └── tra_cuu_thuoc_page.dart   <-- (Bạn sẽ tạo ở đây)
│
├── don_hang/
│   ├── chi_tiet_don_hang_page.dart <-- (Bấm từ tab Đơn hàng -> mở trang này)
│   └── in_hoa_don_page.dart
│
├── san_pham/
│   ├── them_san_pham_page.dart   <-- (Bấm nút (+) ở tab Sản phẩm -> mở trang này)
│   └── chinh_sua_sp_page.dart
│
└── tai_khoan/
├── cap_nhat_thong_tin_page.dart <-- (Bấm từ tab Tài khoản -> mở trang này)
└── doi_mat_khau_page.dart