// lib/tabs/admin/staff_tab.dart

import 'package:flutter/material.dart';
import '../../pages/admin/nhan_vien/add_nhanvien.dart';
import '../../pages/admin/nhan_vien/chi_tiet_nhan_vien_page.dart'; // IMPORT TRANG CHI TIẾT
import '../../data/staff_data.dart';

class StaffTab extends StatefulWidget {
  const StaffTab({Key? key}) : super(key: key);

  @override
  State<StaffTab> createState() => _StaffTabState();
}

class _StaffTabState extends State<StaffTab> {
  String _searchQuery = '';

  void _toggleStatus(Map<String, String> staff) {
    setState(() {
      staff['status'] = (staff['status'] == 'Hoạt động') ? 'Nghỉ phép' : 'Hoạt động';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã cập nhật trạng thái của ${staff['name']}'), backgroundColor: Colors.blue, behavior: SnackBarBehavior.floating),
    );
  }

  void _confirmDelete(Map<String, String> staff) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Bạn có chắc chắn muốn xóa nhân sự "${staff['name']}" khỏi hệ thống không?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('HỦY', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              setState(() => globalStaffs.remove(staff));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa nhân sự thành công!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('XÓA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredStaffs = globalStaffs.where((staff) {
      String query = _searchQuery.toLowerCase();
      String name = (staff['name'] ?? '').toLowerCase();
      String phone = (staff['phone'] ?? '').toLowerCase();
      String id = (staff['id'] ?? '').toLowerCase();
      return name.contains(query) || phone.contains(query) || id.contains(query);
    }).toList();

    int activeCount = globalStaffs.where((s) => s['status'] == 'Hoạt động').length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Quản lý Nhân sự', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: Colors.blueAccent),
            tooltip: 'Thêm nhân sự',
            onPressed: () async {
              final result = await showDialog<Map<String, String>>(context: context, builder: (context) => const AddStaffDialog());
              if (result != null) {
                if (!result.containsKey('role')) result['role'] = 'Dược sĩ bán hàng';
                setState(() => globalStaffs.add(result));
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Tìm theo tên, mã NV, SĐT...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true, fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tổng: ${globalStaffs.length} nhân sự', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text('$activeCount đang hoạt động', style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: filteredStaffs.isEmpty
                ? const Center(child: Text('Không tìm thấy nhân sự nào.', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredStaffs.length,
              itemBuilder: (context, index) {
                final staff = filteredStaffs[index];
                bool isActive = staff['status'] == 'Hoạt động';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    // SỰ KIỆN BẤM VÀO ĐỂ XEM CHI TIẾT NẰM Ở ĐÂY
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChiTietNhanVienPage(staff: staff)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: isActive ? Colors.blue.shade50 : Colors.grey.shade200,
                            child: Icon(Icons.person, size: 30, color: isActive ? Colors.blueAccent : Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(staff['name'] ?? 'Chưa cập nhật', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                                const SizedBox(height: 4),
                                Text('${staff['role'] ?? 'Nhân viên'} • ${staff['id']}', style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 13, fontWeight: FontWeight.w500)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.phone_android, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(staff['phone'] ?? 'N/A', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'toggle') _toggleStatus(staff);
                                  else if (value == 'delete') _confirmDelete(staff);
                                },
                                icon: const Icon(Icons.more_vert, color: Colors.grey),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                itemBuilder: (context) => [
                                  PopupMenuItem(value: 'toggle', child: Row(children: [Icon(isActive ? Icons.pause_circle_outline : Icons.play_circle_outline, color: isActive ? Colors.orange : Colors.green), const SizedBox(width: 8), Text(isActive ? 'Chuyển sang Nghỉ phép' : 'Chuyển sang Hoạt động')])),
                                  const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, color: Colors.red), SizedBox(width: 8), Text('Xóa nhân sự', style: TextStyle(color: Colors.red))])),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isActive ? Colors.green.shade50 : Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: isActive ? Colors.green.shade200 : Colors.orange.shade200),
                                ),
                                child: Text(staff['status'] ?? '', style: TextStyle(color: isActive ? Colors.green.shade700 : Colors.orange.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}