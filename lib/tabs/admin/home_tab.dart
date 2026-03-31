// lib/tabs/admin/home_tab.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/request_data.dart';
import '../../data/shift_report_data.dart';
import '../../data/medicine_data.dart';
import '../../data/staff_data.dart';

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
    // 1. Đếm số liệu thực tế từ các nguồn dữ liệu
    int warningMedsCount = globalMedicines.where((m) => (m['stock'] as int) <= 20).length;
    int activeStaffsCount = globalStaffs.where((s) => s['status'] == 'Hoạt động').length;
    int pendingRequestsCount = globalRequests.where((req) => req['status'] == 'Chờ duyệt').length;

    // Lọc theo trạng thái "Đã nộp" để khớp với code của Dược sĩ
    List<Map<String, dynamic>> pendingReports = globalShiftReports
        .where((rep) => rep['status'] == 'Đã nộp' || rep['status'] == 'Chờ duyệt')
        .toList();
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

            // LƯỚI THỐNG KÊ (GRID VIEW)
            LayoutBuilder(builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth >= 600 ? 4 : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _buildModernStatCard(
                    title: 'Thuốc cần chú ý',
                    count: warningMedsCount.toString(),
                    color: Colors.redAccent,
                    icon: Icons.warning_amber_rounded,
                    onTap: () => widget.onChangeTab?.call(3),
                  ),
                  _buildModernStatCard(
                    title: 'Dược sĩ hoạt động',
                    count: activeStaffsCount.toString(),
                    color: Colors.green,
                    icon: Icons.person_pin,
                    onTap: () => widget.onChangeTab?.call(2),
                  ),
                  _buildModernStatCard(
                    title: 'Đơn nhập chờ duyệt',
                    count: pendingRequestsCount.toString(),
                    color: Colors.orange,
                    icon: Icons.inventory_2_outlined,
                    onTap: () => widget.onChangeTab?.call(3),
                  ),
                  _buildModernStatCard(
                    title: 'Ca chờ đối soát',
                    count: pendingReportsCount.toString(),
                    color: Colors.blueAccent,
                    icon: Icons.account_balance_wallet,
                  ),
                ],
              );
            }),

            const SizedBox(height: 30),

            // DANH SÁCH BÁO CÁO CA CẦN XỬ LÝ
            if (pendingReports.isNotEmpty) ...[
              const Row(
                children: [
                  Icon(Icons.assignment_late_rounded, color: Colors.redAccent, size: 22),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Báo Cáo Ca Cần Xử Lý',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
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

                  // TÍNH TOÁN DỰA TRÊN KEY TRONG FILE DUOC SI CỦA BẠN
                  double systemCash = (report['cashRevenue'] ?? 0).toDouble();
                  // Nếu dược sĩ chưa nhập tiền thực tế, ta coi như khớp để tránh lỗi giao diện
                  double reportedCash = (report['reportedCash'] ?? systemCash).toDouble();
                  double diff = reportedCash - systemCash;

                  Color diffColor = Colors.green;
                  String diffStatus = "Khớp số liệu";

                  if (diff < 0) {
                    diffColor = Colors.red;
                    diffStatus = "THIẾU: ${formatCurrency.format(diff.abs())}";
                  } else if (diff > 0) {
                    diffColor = Colors.orange;
                    diffStatus = "THỪA: ${formatCurrency.format(diff)}";
                  }

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: diffColor.withOpacity(0.3), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue.shade50,
                                child: const Icon(Icons.person, color: Colors.blue),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${report['pharmacist']} - Ca ${report['date']}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text('Chốt lúc: ${report['time']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Đã nộp', style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          const Divider(height: 24),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                _buildMoneyRow('Doanh thu hệ thống:', formatCurrency.format(report['totalRevenue'] ?? 0)),
                                _buildMoneyRow('Trong đó Tiền mặt:', formatCurrency.format(systemCash)),
                                _buildMoneyRow('Tiền chuyển khoản:', formatCurrency.format(report['transferRevenue'] ?? 0)),
                                const Divider(),
                                _buildMoneyRow('TRẠNG THÁI:', diffStatus, color: diffColor, isBold: true),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.call, size: 18),
                                label: const Text('Liên hệ'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () => _duyetBaoCao(originalIndex),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                icon: const Icon(Icons.check_circle, size: 18),
                                label: const Text('Xác nhận đối soát'),
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
              // Trạng thái trống
              const SizedBox(height: 60),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline, size: 60, color: Colors.green.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    const Text('Hệ thống đã đối soát hết!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildModernStatCard({required String title, required String count, required Color color, required IconData icon, VoidCallback? onTap}) {
    return Card(
      elevation: 2,
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
              Icon(icon, color: color, size: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoneyRow(String label, String value, {Color color = Colors.black87, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: isBold ? Colors.black87 : Colors.grey[700], fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 13, color: color, fontWeight: isBold ? FontWeight.bold : FontWeight.bold)),
        ],
      ),
    );
  }
}