import 'package:flutter/material.dart';
import 'package:fl_quan_li_ban_thuoc/pages/admin/nhan_vien/add_nhanvien.dart';

class StaffTab extends StatefulWidget {
  const StaffTab({Key? key}) : super(key: key);

  @override
  State<StaffTab> createState() => _StaffTabState();
}

class _StaffTabState extends State<StaffTab> {
  // Dữ liệu mẫu ban đầu
  final List<Map<String, String>> _staffs = [
    {'id': 'DS001', 'name': 'Nguyễn Văn A', 'phone': '0987654321', 'status': 'Hoạt động'},
    {'id': 'DS002', 'name': 'Trần Thị B', 'phone': '0912345678', 'status': 'Nghỉ phép'},
  ];

  // Hàm mở Dialog thêm nhân viên
  Future<void> _openAddStaffDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const AddStaffDialog(),
    );

    if (result != null) {
      setState(() {
        _staffs.add(result); // Cập nhật danh sách
      });
      _showSnackBar('Đã thêm nhân viên ${result['name']}');
    }
  }

  // Hàm xử lý xóa nhân viên
  void _deleteStaff(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa nhân viên ${_staffs[index]['name']}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('HỦY')),
          ElevatedButton(
            onPressed: () {
              setState(() => _staffs.removeAt(index));
              Navigator.pop(context);
              _showSnackBar('Đã xóa nhân viên');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('XÓA', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Nhân sự', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: PaginatedDataTable(
          header: const Text('Danh sách Dược sĩ & Nhân viên'),
          actions: [
            ElevatedButton.icon(
              onPressed: _openAddStaffDialog,
              icon: const Icon(Icons.add),
              label: const Text('Thêm nhân sự'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
          columns: const [
            DataColumn(label: Text('Mã NV')),
            DataColumn(label: Text('Họ và Tên')),
            DataColumn(label: Text('Số điện thoại')),
            DataColumn(label: Text('Trạng thái')),
            DataColumn(label: Text('Hành động')),
          ],
          // Truyền hàm xóa vào Source để xử lý sự kiện trong bảng
          source: _StaffDataSource(_staffs, context, onDelete: _deleteStaff),
          rowsPerPage: 5,
          showFirstLastButtons: true,
        ),
      ),
    );
  }
}

class _StaffDataSource extends DataTableSource {
  final List<Map<String, String>> _data;
  final BuildContext context;
  final Function(int) onDelete;

  _StaffDataSource(this._data, this.context, {required this.onDelete});

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final staff = _data[index];

    return DataRow(cells: [
      DataCell(Text(staff['id']!, style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(staff['name']!)),
      DataCell(Text(staff['phone']!)),
      DataCell(
        Chip(
          label: Text(staff['status']!, style: const TextStyle(fontSize: 12)),
          backgroundColor: staff['status'] == 'Hoạt động' ? Colors.green.shade50 : Colors.grey.shade100,
          labelStyle: TextStyle(color: staff['status'] == 'Hoạt động' ? Colors.green : Colors.grey),
          side: BorderSide.none,
        ),
      ),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chức năng sửa đang phát triển')));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              onPressed: () => onDelete(index), // Gọi hàm xóa từ lớp cha
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
}