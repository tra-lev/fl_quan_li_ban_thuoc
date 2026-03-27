import 'package:flutter/material.dart';
import 'package:fl_quan_li_ban_thuoc/pages/admin/nhan_vien/add_nhanvien.dart';

class StaffTab extends StatefulWidget {
  const StaffTab({Key? key}) : super(key: key);

  @override
  State<StaffTab> createState() => _StaffTabState();
}

class _StaffTabState extends State<StaffTab> {
  final List<Map<String, String>> _staffs = [
    {'id': 'DS001', 'name': 'Nguyễn Văn A', 'phone': '0987654321', 'status': 'Hoạt động'},
    {'id': 'DS002', 'name': 'Trần Thị B', 'phone': '0912345678', 'status': 'Nghỉ phép'},
    {'id': 'DS003', 'name': 'Lê Văn C', 'phone': '0912345678', 'status': 'Hoạt động'},
    {'id': 'DS004', 'name': 'Phạm Tuấn D', 'phone': '0912345678', 'status': 'Nghỉ phép'},
  ];

  // 1. Hàm đổi trạng thái nhanh
  void _toggleStatus(int index) {
    setState(() {
      String currentStatus = _staffs[index]['status']!;
      _staffs[index]['status'] = (currentStatus == 'Hoạt động') ? 'Nghỉ phép' : 'Hoạt động';
    });
    _showSnackBar('Đã cập nhật trạng thái cho ${_staffs[index]['name']}');
  }

  // 2. Hàm sửa thông tin nhân viên
  Future<void> _editStaff(int index) async {
    // Chúng ta dùng lại AddStaffDialog nhưng truyền dữ liệu cũ vào nếu cần
    // Ở đây tôi giả sử bạn cập nhật AddStaffDialog để nhận initialData
    // Nếu chưa có, bạn có thể hiện một Dialog nhanh tại đây:
    final nameController = TextEditingController(text: _staffs[index]['name']);
    final phoneController = TextEditingController(text: _staffs[index]['phone']);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa thông tin nhân viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Họ tên')),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Số điện thoại')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('HỦY')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('CẬP NHẬT'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        _staffs[index]['name'] = nameController.text;
        _staffs[index]['phone'] = phoneController.text;
      });
      _showSnackBar('Đã cập nhật thông tin');
    }
  }

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
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
              onPressed: () async {
                final result = await showDialog<Map<String, String>>(
                  context: context,
                  builder: (context) => const AddStaffDialog(),
                );
                if (result != null) setState(() => _staffs.add(result));
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm nhân sự'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
            ),
          ],
          columns: const [
            DataColumn(label: Text('Mã NV')),
            DataColumn(label: Text('Họ và Tên')),
            DataColumn(label: Text('Số điện thoại')),
            DataColumn(label: Text('Trạng thái')),
            DataColumn(label: Text('Hành động')),
          ],
          // Cập nhật: Truyền thêm các hàm callback vào Source
          source: _StaffDataSource(
            _staffs,
            context,
            onDelete: _deleteStaff,
            onEdit: _editStaff,
            onToggleStatus: _toggleStatus,
          ),
          rowsPerPage: 5,
        ),
      ),
    );
  }
}

class _StaffDataSource extends DataTableSource {
  final List<Map<String, String>> _data;
  final BuildContext context;
  final Function(int) onDelete;
  final Function(int) onEdit;
  final Function(int) onToggleStatus;

  _StaffDataSource(this._data, this.context, {
    required this.onDelete,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final staff = _data[index];

    return DataRow(cells: [
      DataCell(Text(staff['id']!, style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(staff['name']!)),
      DataCell(Text(staff['phone']!)),
      DataCell(
        // Cập nhật: Bọc Chip trong InkWell để có thể bấm vào đổi trạng thái
        InkWell(
          onTap: () => onToggleStatus(index),
          borderRadius: BorderRadius.circular(20),
          child: Chip(
            label: Text(staff['status']!, style: const TextStyle(fontSize: 12)),
            backgroundColor: staff['status'] == 'Hoạt động' ? Colors.green.shade50 : Colors.orange.shade50,
            labelStyle: TextStyle(color: staff['status'] == 'Hoạt động' ? Colors.green : Colors.orange),
            side: BorderSide(color: staff['status'] == 'Hoạt động' ? Colors.green.shade200 : Colors.orange.shade200),
          ),
        ),
      ),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
              onPressed: () => onEdit(index), // Gọi hàm sửa
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              onPressed: () => onDelete(index),
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