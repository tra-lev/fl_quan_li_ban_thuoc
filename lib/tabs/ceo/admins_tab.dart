import 'package:flutter/material.dart';
import '../../pages/ceo/admins/chi_tiet_admin_page.dart';

class CeoAdminsTab extends StatelessWidget {
  const CeoAdminsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text('Quản lý Quản trị viên (Admins)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        _buildAdminCard(context, 'Nguyễn Văn A', 'Quản lý Chi nhánh 1', true),
        _buildAdminCard(context, 'Trần Thị B', 'Quản lý Chi nhánh 2', true),
        _buildAdminCard(context, 'Lê Văn C', 'Quản lý Chi nhánh 3', false),
      ],
    );
  }

  Widget _buildAdminCard(BuildContext context, String name, String role, bool isActive) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: isActive ? Colors.blue[100] : Colors.red[100],
          child: Icon(Icons.person, color: isActive ? Colors.blue : Colors.red),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(role),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
              color: isActive ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(20) // Bo tròn như nút badge
          ),
          child: Text(isActive ? 'Hoạt động' : 'Đã khóa', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? Colors.green[800] : Colors.red[800])),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChiTietAdminPage(tenAdmin: name)),
          );
        },
      ),
    );
  }
}