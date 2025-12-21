import 'package:ballistic/features/user_measurement/screens/measurement_page.dart';
import 'package:ballistic/forum/screens/forum_entry_list.dart';
import 'package:ballistic/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; 
import 'package:provider/provider.dart'; 
import 'package:ballistic/screens/login.dart'; 
import 'package:ballistic/utils/user_info.dart'; 

// Import halaman Shop
import 'package:ballistic/shop/screen/shop.dart'; 
// Import halaman User Measurement
import 'package:ballistic/features/user_measurement/screens/measurement_page.dart';
// Import halaman History (PASTIKAN FILE INI SUDAH DIBUAT)
import 'package:ballistic/shop/screen/transaction_history.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // --- FUNGSI LOGOUT ---
  Future<void> _handleLogout(BuildContext context, CookieRequest request) async {
    const String logoutUrl = "http://localhost:8000/auth/logout/";
    
    final response = await request.logout(logoutUrl);
    String message = response["message"];

    if (context.mounted) {
      if (response['status']) {
        String uname = response["username"];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$message Sampai jumpa, $uname."),
        ));
        
        await UserInfo.clearUserInfo();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Logout gagal: $message"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 800;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: isMobile ? _buildDrawer(context) : null,
      appBar: isMobile
          ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'BALLISTIC',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.login_outlined, size: 20),
          )
        ],
      )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!isMobile) _buildTopHeader(context, request),
            if (!isMobile) _buildNavbar(context),
            _buildHeroSection(context, isMobile),
          ],
        ),
      ),
    );
  }

  // --- DRAWER MOBILE (DENGAN SUB-MENU UNTUK SHOP) ---
  Widget _buildDrawer(BuildContext context) {
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
          _drawerItem(context, 'HOME', true),

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

          _drawerItem(context, 'FORUM', false),
          _drawerItem(context, 'NEWS', false),
          _drawerItem(context, 'VOUCHER', false),
          _drawerItem(context, 'ABOUT', false),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, bool isHome) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        if (isHome) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        }
      },
    );
  }

  // --- HEADER & NAVBAR DESKTOP ---
  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.camera_alt_outlined, size: 20),
              SizedBox(width: 15),
              Icon(Icons.discord, size: 20),
              SizedBox(width: 15),
              Icon(Icons.business, size: 20),
            ],
          ),
          const Text(
            'BALLISTIC',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          
          Row(
            children: [
              // --- TOMBOL HISTORY (DESKTOP) ---
              IconButton(
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (c) => const TransactionHistoryPage()));
                },
                icon: const Icon(Icons.receipt_long, size: 24, color: Colors.black),
                tooltip: 'History',
              ),
              const SizedBox(width: 8),
              // --- TOMBOL LOGOUT (DESKTOP) ---
              IconButton(
                onPressed: () => _handleLogout(context, request),
                icon: const Icon(Icons.logout, size: 24, color: Colors.black),
                tooltip: 'Logout',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _navItem(context, 'HOME', isActive: true),
          _navItem(context, 'SHOP', hasDropdown: true),
          _navItem(context, 'FORUM'),
          _navItem(context, 'NEWS'),
          _navItem(context, 'VOUCHER'),
          _navItem(context, 'ABOUT'),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, {bool isActive = false, bool hasDropdown = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasDropdown && title == 'SHOP')
            PopupMenuButton<String>(
              offset: const Offset(0, 30),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isActive ? const Color(0xFFC9A25B) : Colors.grey[700],
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
              onSelected: (value) {
                if (value == 'size') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserMeasurementPage()),
                  );
                } else if (value == 'standard') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShopPage()),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'standard',
                  child: Text('Standard Shop', style: TextStyle(fontSize: 13)),
                ),
                const PopupMenuItem(
                  value: 'size',
                  child: Text('Size Recommendation', style: TextStyle(fontSize: 13)),
                ),
              ],
            )
          else
            InkWell(
              onTap: () {
                if (title == 'HOME') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                } else if (title == 'FORUM') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ForumListPage()),
                  );
                } else if (title == 'NEWS') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const NewsListPage()),
                  );
                }
              },
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isActive ? const Color(0xFFC9A25B) : Colors.grey[700],
                ),
              ),
            ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 1,
              width: 25,
              color: const Color(0xFFC9A25B),
            ),
        ],
      ),
    );
  }

  // --- HERO SECTION ---
  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: isMobile ? 350 : 500),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=2070'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color.fromRGBO(0, 0, 0, 0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 25 : 80, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              'Explore Curated\nFootball Collections\nWith Us',
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 24 : 44,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Ballistic offers all categories of football merchandise, from jerseys to accessories.',
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              style: TextStyle(color: Colors.white70, fontSize: isMobile ? 13 : 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ShopPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC9A25B),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 25 : 35, vertical: isMobile ? 15 : 20),
                shape: const RoundedRectangleBorder(),
              ),
              child: const Text('See Collection', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}