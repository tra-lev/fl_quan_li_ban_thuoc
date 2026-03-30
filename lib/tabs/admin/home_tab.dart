// lib/tabs/admin/home_tab.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/request_data.dart';
import '../../data/shift_report_data.dart';
import '../../data/medicine_data.dart';
import '../../data/staff_data.dart';

// ĐÃ THÊM: Import data nhà cung cấp để đếm số đơn hàng
import '../../data/supplier_data.dart';

class HomeTab extends StatefulWidget {
  final Function(int)? onChangeTab;

  const HomeTab({Key? key, this.onChangeTab}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  void _duyetBaoCao(int index) {
    setState(() {
      globalShiftReports[index]['status'] = 'Đã xác nhận';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xác nhận đối soát ca thành công!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Đếm số liệu thực tế
    int warningMedsCount = globalMedicines.where((m) => (m['stock'] as int) <= 20).length;
    int activeStaffsCount = globalStaffs.where((s) => s['status'] == 'Hoạt động').length;
    int pendingRequestsCount = globalRequests.where((req) => req['status'] == 'Chờ duyệt').length;

    // ĐÃ THÊM: Đếm số lượng đơn hàng từ Nhà cung cấp đang chờ nhận (Chờ giao hoặc Đang giao)
    int incomingOrdersCount = globalPurchaseOrders.where((order) => order['status'] == 'Chờ giao hàng' || order['status'] == 'Đang giao').length;

    List<Map<String, dynamic>> pendingReports = globalShiftReports.where((rep) => rep['status'] == 'Chờ duyệt').toList();
    int pendingReportsCount = pendingReports.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.dashboard_rounded, color: Colors.blueAccent, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tổng quan Hệ thống',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // LƯỚI THỐNG KÊ ĐÃ CẬP NHẬT THÊM THẺ THỨ 5
            LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;
                  double childAspectRatio = 0.85;

                  if (constraints.maxWidth >= 1100) {
                    crossAxisCount = 4;
                    childAspectRatio = 1.3;
                  } else if (constraints.maxWidth >= 600) {
                    crossAxisCount = 3;
                    childAspectRatio = 1.1;
                  }

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: childAspectRatio,
                    children: [
                      _buildModernStatCard(
                        title: 'Thuốc cần chú ý',
                        count: warningMedsCount.toString(),
                        color: Colors.redAccent,
                        icon: Icons.warning_amber_rounded,
                        onTap: () => widget.onChangeTab?.call(3), // Chuyển sang Thông báo
                      ),
                      _buildModernStatCard(
                        title: 'Dược sĩ hoạt động',
                        count: activeStaffsCount.toString(),
                        color: Colors.green,
                        icon: Icons.person_pin,
                        onTap: () => widget.onChangeTab?.call(2), // Chuyển sang Nhân sự
                      ),
                      _buildModernStatCard(
                        title: 'Đơn DS chờ duyệt',
                        count: pendingRequestsCount.toString(),
                        color: Colors.orange,
                        icon: Icons.inventory_2_outlined,
                        onTap: () => widget.onChangeTab?.call(3), // Chuyển sang Thông báo
                      ),
                      _buildModernStatCard(
                          title: 'Ca chờ đối soát',
                          count: pendingReportsCount.toString(),
                          color: Colors.blueAccent,
                          icon: Icons.account_balance_wallet,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Danh sách đối soát đang hiển thị ngay bên dưới! 👇'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.blueAccent,
                              ),
                            );
                          }
                      ),
                      // THẺ MỚI THÊM VÀO: Đơn hàng từ nhà cung cấp
                      _buildModernStatCard(
                        title: 'Đơn NCC đang giao',
                        count: incomingOrdersCount.toString(),
                        color: Colors.teal, // Phối màu xanh ngọc cho khác biệt
                        icon: Icons.local_shipping,
                        onTap: () => widget.onChangeTab?.call(4), // Chuyển sang Tab Nhập Hàng (Index 4 mới)
                      ),
                    ],
                  );
                }
            ),

            const SizedBox(height: 30),

            // DANH SÁCH BÁO CÁO CA CẦN XỬ LÝ (Giữ nguyên)
            if (pendingReports.isNotEmpty) ...[
              const Row(
                children: [
                  Icon(Icons.assignment_late_rounded, color: Colors.redAccent, size: 22),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Báo Cáo Ca Cần Xử Lý',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendingReports.length,
                itemBuilder: (context, index) {
                  final originalIndex = globalShiftReports.indexOf(pendingReports[index]);
                  final report = pendingReports[index];

                  double diff = (report['difference'] as num).toDouble();

                  Color diffColor = Colors.green;
                  String diffText = "Khớp số liệu";
                  if (diff < 0) {
                    diffColor = Colors.red;
                    diffText = "THIẾU: ${formatCurrency.format(diff.abs())}";
                  } else if (diff > 0) {
                    diffColor = Colors.orange;
                    diffText = "THỪA: ${formatCurrency.format(diff)}";
                  }

                  return Card(
                    elevation: 3,
                    shadowColor: Colors.black12,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: diffColor.withOpacity(0.4), width: 1.5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.blue.shade50,
                                  child: const Icon(Icons.person, color: Colors.blueAccent)
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${report['pharmacist']} - Ca ${report['date']}',
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'Chốt lúc: ${report['time']}',
                                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.orange.shade200)
                                ),
                                child: const Text('Chờ duyệt', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 11)),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, thickness: 1, color: Colors.black12),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200)
                            ),
                            child: Column(
                              children: [
                                _buildMoneyRow('Hệ thống:', formatCurrency.format(report['systemCash'])),
                                _buildMoneyRow('Nộp thực tế:', formatCurrency.format(report['reportedCash'])),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Divider(height: 1, color: Colors.black12),
                                ),
                                _buildMoneyRow('LỆCH KÉT:', diffText, color: diffColor, isBold: true, size: 15),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          Wrap(
                            alignment: WrapAlignment.end,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang gọi điện cho Dược sĩ...')));
                                },
                                icon: const Icon(Icons.call, size: 18),
                                label: const Text('Liên hệ', style: TextStyle(fontSize: 13)),
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.blueGrey,
                                    side: BorderSide(color: Colors.grey.shade300),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _duyetBaoCao(originalIndex),
                                icon: const Icon(Icons.verified, color: Colors.white, size: 18),
                                label: const Text('Xác Nhận', style: TextStyle(fontSize: 13)),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              const SizedBox(height: 60),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                      child: Icon(Icons.check_circle_outline, size: 50, color: Colors.green.shade300),
                    ),
                    const SizedBox(height: 16),
                    Text('Tuyệt vời!', style: TextStyle(color: Colors.green.shade700, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Không có báo cáo ca nào cần đối soát.', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildModernStatCard({
    required String title,
    required String count,
    required Color color,
    required IconData icon,
    VoidCallback? onTap
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  if (onTap != null)
                    Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 14)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoneyRow(String label, String value, {Color color = Colors.black87, bool isBold = false, double size = 13}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: size, color: isBold ? Colors.black87 : Colors.grey[700], fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
              value,
              style: TextStyle(fontSize: isBold ? size + 2 : size, color: color, fontWeight: isBold ? FontWeight.w900 : FontWeight.bold)
          ),
        ],
      ),
    );
  }
}