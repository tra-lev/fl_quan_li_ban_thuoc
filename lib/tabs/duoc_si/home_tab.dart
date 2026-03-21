import 'package:flutter/material.dart';

// Import các trang chức năng theo đúng cấu trúc thư mục từ ảnh image_0cdc29.png
import '../../pages/duoc_si/don_hang/don_giao_hang.dart';
import '../../pages/duoc_si/don_hang/ban_tai_quay.dart';
import '../../pages/duoc_si/trang_chu/tra_cuu_thuoc_page.dart';
import '../../pages/duoc_si/trang_chu/ton_kho_page.dart';
import '../../pages/duoc_si/trang_chu/khach_hang_page.dart';
import '../../pages/duoc_si/trang_chu/hoa_don_page.dart';

// =============================================================
// 1. TRANG CHỦ DƯỢC SĨ (MÀN HÌNH CHÍNH)
// =============================================================
class HomeTab extends StatelessWidget {
  final String fullName;
  final Function(int) onChangeTab;

  const HomeTab({
    super.key,
    required this.fullName,
    required this.onChangeTab,
  });

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PHẦN HEADER & THẺ THỐNG KÊ (Giữ hình thức cũ, đổi logic stats cá nhân)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 160,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.blue, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Dược sĩ trực:", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          Text(fullName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                      onPressed: () => _showToast(context, "Mở quét mã vạch nhanh"),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 90, left: 16, right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Column(
                  children: [
                    const Text("Doanh số cá nhân hôm nay", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 5),
                    const Text("4.550.000đ", style: TextStyle(color: Colors.blue, fontSize: 26, fontWeight: FontWeight.bold)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Đổi sang logic thưởng và thành tích cá nhân
                        _buildSubStat("Thưởng đơn", "150K", Colors.orange, Icons.stars),
                        Container(height: 40, width: 1, color: Colors.grey[300]),
                        _buildSubStat("Đơn hoàn thành", "12", Colors.green, Icons.check_circle),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 70),

          // THANH TRA CỨU NHANH (Đưa lên vị trí ưu tiên số 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TraCuuThuocPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.blue.shade100, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text("Kiểm tra giá & Tồn kho nhanh...", style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // CHỨC NĂNG CHÍNH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ActionCard(
                    title: "BÁN TẠI QUẦY",
                    icon: Icons.point_of_sale,
                    iconColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BanTaiQuayWidget()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionCard(
                    title: "ĐƠN GIAO HÀNG",
                    icon: Icons.local_shipping,
                    iconColor: Colors.cyan,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DonGiaoHangWidget()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // THAO TÁC NHANH (Tối ưu lại danh mục cho dược sĩ)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Tiện ích dược sĩ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.8,
              children: [
                QuickActionButton(
                    title: "Quét đơn thuốc",
                    icon: Icons.camera_alt_outlined,
                    onTap: () => _showToast(context, "Mở camera quét toa thuốc...")
                ),
                QuickActionButton(
                    title: "Khách hàng",
                    icon: Icons.people_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KhachHangPage()),
                      );
                    }
                ),
                QuickActionButton(
                    title: "Lịch sử bán",
                    icon: Icons.history,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HoaDonPage()),
                      );
                    }
                ),
                QuickActionButton(
                    title: "Kiểm kho",
                    icon: Icons.inventory_2_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TonKhoPage()),
                      );
                    }
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ĐƠN HÀNG GẦN ĐÂY
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Hóa đơn gần đây', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => onChangeTab(1),
                  child: const Text('Xem tất cả', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildOrderCard(context, '#DH001', 'Nguyễn Văn A', '10:30, Hôm nay', '250.000đ', Colors.blue, Icons.receipt_long),
                _buildOrderCard(context, '#DH002', 'Trần Thị B', '09:15, Hôm nay', '120.000đ', Colors.green, Icons.check_circle),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // CÁC HÀM HELPER GIỮ NGUYÊN HÌNH THỨC BAN ĐẦU
  Widget _buildOrderCard(BuildContext context, String id, String customer, String time, String price, Color iconBg, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconBg.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: iconBg),
        ),
        title: Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Khách: $customer\nThời gian: $time'),
        trailing: Text(price, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        onTap: () => _showToast(context, "Xem chi tiết $id"),
      ),
    );
  }

  Widget _buildSubStat(String title, String value, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

// =============================================================
// 2. COMPONENT: THẺ CHỨC NĂNG LỚN (ActionCard)
// =============================================================
class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const ActionCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24), // Tăng padding cho cân đối
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 28, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// 3. COMPONENT: NÚT THAO TÁC NHANH (QuickActionButton)
// =============================================================
class QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const QuickActionButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 3))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue[700], size: 20),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}