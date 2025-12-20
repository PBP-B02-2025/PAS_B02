import 'package:ballistic/features/user_measurement/screens/measurement_page.dart';
import 'package:ballistic/forum/screens/forum_entry_list.dart';
import 'package:flutter/material.dart';
import 'package:ballistic/screens/menu.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFC9A25B)),
            child: Center(
              child: Text(
                'BALLISTIC',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _drawerItem(context, 'HOME'),

          // ExpansionTile digunakan untuk membuat dropdown/sub-menu di mobile
          ExpansionTile(
            textColor: const Color(0xFFC9A25B),
            iconColor: const Color(0xFFC9A25B),
            title: const Text('SHOP', style: TextStyle(fontWeight: FontWeight.w500)),
            childrenPadding: const EdgeInsets.only(left: 20),
            children: [
              ListTile(
                title: const Text('Standard Shop', style: TextStyle(fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                  // Tambahkan navigasi ke shop standard jika sudah ada
                },
              ),
              ListTile(
                title: const Text('Size Recommendation', style: TextStyle(fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserMeasurementPage()),
                  );
                },
              ),
            ],
          ),

          _drawerItem(context, 'FORUM'),
          _drawerItem(context, 'NEWS'),
          _drawerItem(context, 'VOUCHER'),
          _drawerItem(context, 'ABOUT'),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        if (title == 'HOME') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        } else if (title == 'FORUM') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ForumListPage())
          );
        }
      },
    );
  }
}