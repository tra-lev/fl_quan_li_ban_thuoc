import 'package:flutter/material.dart';

class CeoProfileTab extends StatelessWidget {
  const CeoProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.blueAccent, width: 3)),
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.admin_panel_settings, size: 60, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          const Text('GIÁM ĐỐC ĐIỀU HÀNH', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const Text('Quản trị viên Cấp cao nhất', style: TextStyle(color: Colors.grey, fontSize: 16)),

          const SizedBox(height: 40),

          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chức năng đang được cập nhật')));
              },
              icon: const Icon(Icons.lock_outline),
              label: const Text('Đổi mật khẩu', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
              ),
            ),
          ),
        ],
      ),
    );
  }
}