import 'package:ballistic/features/user_measurement/screens/measurement_page.dart';
import 'package:ballistic/forum/screens/forum_entry_list.dart';
import 'package:ballistic/voucher/screens/voucher_entry_list.dart';
import 'package:flutter/material.dart';
import 'package:ballistic/screens/news/news_list.dart';
import 'package:ballistic/screens/profile/profile_page.dart';
import 'package:ballistic/screens/about_page.dart';
import 'package:ballistic/shop/screen/shop.dart';

import 'package:ballistic/screens/menu.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  String _getCurrentRoute(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route != null && route.settings.name != null) {
      return route.settings.name!;
    }
    // Fallback: check widget type
    final widget = context.widget;
    if (widget.runtimeType.toString().contains('MyHomePage')) return 'HOME';
    if (widget.runtimeType.toString().contains('ShopPage')) return 'SHOP';
    if (widget.runtimeType.toString().contains('UserMeasurementPage')) return 'SIZE';
    if (widget.runtimeType.toString().contains('ForumListPage')) return 'FORUM';
    if (widget.runtimeType.toString().contains('NewsListPage')) return 'NEWS';
    if (widget.runtimeType.toString().contains('VoucherEntryListPage')) return 'VOUCHER';
    if (widget.runtimeType.toString().contains('ProfilePage')) return 'PROFILE';
    if (widget.runtimeType.toString().contains('AboutPage')) return 'ABOUT';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = _getCurrentRoute(context);
    
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
          _drawerItem(context, 'HOME', currentRoute == 'HOME'),

          // ExpansionTile digunakan untuk membuat dropdown/sub-menu di mobile
          ExpansionTile(
            textColor: const Color(0xFFC9A25B),
            iconColor: const Color(0xFFC9A25B),
            title: Text(
              'SHOP', 
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: (currentRoute == 'SHOP' || currentRoute == 'SIZE') 
                  ? const Color(0xFFC9A25B) 
                  : Colors.black,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 20),
            children: [
              ListTile(
                title: Text(
                  'Standard Shop', 
                  style: TextStyle(
                    fontSize: 14,
                    color: currentRoute == 'SHOP' ? const Color(0xFFC9A25B) : Colors.black,
                    fontWeight: currentRoute == 'SHOP' ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                tileColor: currentRoute == 'SHOP' ? const Color(0xFFC9A25B).withOpacity(0.1) : null,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShopPage()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Size Recommendation', 
                  style: TextStyle(
                    fontSize: 14,
                    color: currentRoute == 'SIZE' ? const Color(0xFFC9A25B) : Colors.black,
                    fontWeight: currentRoute == 'SIZE' ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                tileColor: currentRoute == 'SIZE' ? const Color(0xFFC9A25B).withOpacity(0.1) : null,
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

          _drawerItem(context, 'FORUM', currentRoute == 'FORUM'),
          _drawerItem(context, 'NEWS', currentRoute == 'NEWS'),
          _drawerItem(context, 'VOUCHER', currentRoute == 'VOUCHER'),
          _drawerItem(context, 'PROFILE', currentRoute == 'PROFILE'),
          _drawerItem(context, 'ABOUT', currentRoute == 'ABOUT'),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, bool isActive) {
    return ListTile(
      title: Text(
        title, 
        style: TextStyle(
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          color: isActive ? const Color(0xFFC9A25B) : Colors.black,
        ),
      ),
      tileColor: isActive ? const Color(0xFFC9A25B).withOpacity(0.1) : null,
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
        } else if (title == 'NEWS') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewsListPage()),
          );
        } else if (title == 'VOUCHER') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const VoucherEntryListPage())
          );
        } else if (title == 'PROFILE') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        } else if (title == 'ABOUT') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutPage()),
          );
        }
      },
      
    );
  }
}