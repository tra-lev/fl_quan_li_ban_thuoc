import 'package:flutter/material.dart';
import '../../pages/admin/nhan_vien/add_nhanvien.dart';
import '../../data/staff_data.dart'; // IMPORT DATA NHÂN SỰ

class StaffTab extends StatefulWidget {
  const StaffTab({Key? key}) : super(key: key);
  @override
  State<StaffTab> createState() => _StaffTabState();
}

class _StaffTabState extends State<StaffTab> {
  void _toggleStatus(int index) {
    setState(() {
      globalStaffs[index]['status'] = (globalStaffs[index]['status'] == 'Hoạt động') ? 'Nghỉ phép' : 'Hoạt động';
    });
  }

  void _deleteStaff(int index) {
    setState(() => globalStaffs.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Nhân sự', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0.5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: PaginatedDataTable(
          header: const Text('Danh sách Dược sĩ & Nhân viên'),
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                final result = await showDialog<Map<String, String>>(context: context, builder: (context) => const AddStaffDialog());
                if (result != null) setState(() => globalStaffs.add(result));
              },
              icon: const Icon(Icons.add), label: const Text('Thêm nhân sự'),
            ),
          ],
          columns: const [DataColumn(label: Text('Mã NV')), DataColumn(label: Text('Họ Tên')), DataColumn(label: Text('SĐT')), DataColumn(label: Text('Trạng thái')), DataColumn(label: Text('Hành động'))],
          source: _StaffDataSource(globalStaffs, context, onDelete: _deleteStaff, onToggleStatus: _toggleStatus),
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
  final Function(int) onToggleStatus;

  _StaffDataSource(this._data, this.context, {required this.onDelete, required this.onToggleStatus});

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final staff = _data[index];
    return DataRow(cells: [
      DataCell(Text(staff['id']!)), DataCell(Text(staff['name']!)), DataCell(Text(staff['phone']!)),
      DataCell(InkWell(onTap: () => onToggleStatus(index), child: Chip(label: Text(staff['status']!), backgroundColor: staff['status'] == 'Hoạt động' ? Colors.green.shade50 : Colors.orange.shade50))),
      DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => onDelete(index))),
    ]);
  }
  @override bool get isRowCountApproximate => false;
  @override int get rowCount => _data.length;
  @override int get selectedRowCount => 0;
}