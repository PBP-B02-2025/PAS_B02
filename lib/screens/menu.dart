import 'package:flutter/material.dart';
// Import halaman Shop
import 'package:ballistic/shop/screen/shop.dart'; 
// Import halaman User Measurement
import 'package:ballistic/features/user_measurement/screens/measurement_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
            if (!isMobile) _buildTopHeader(),
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
              // --- NAVIGASI STANDARD SHOP (MOBILE) ---
              ListTile(
                title: const Text('Standard Shop', style: TextStyle(fontSize: 14)),
                onTap: () {
                  Navigator.pop(context); // Tutup Drawer
                  // Pindah ke ShopPage
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => const ShopPage())
                  );
                },
              ),
              // --- NAVIGASI SIZE RECOMMENDATION (MOBILE) ---
              ListTile(
                title: const Text('Size Recommendation', style: TextStyle(fontSize: 14)),
                onTap: () {
                  Navigator.pop(context); // Tutup Drawer
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
        Navigator.pop(context); // Tutup drawer
        if (title == 'HOME') {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
        } else if (title == 'SHOP') {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ShopPage()));
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
          const Icon(Icons.login_outlined, size: 24),
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
          _navItem(context, 'SHOP', hasDropdown: true), // SHOP memiliki dropdown
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
          // Dropdown menggunakan PopupMenuButton untuk Desktop
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
                // --- LOGIKA NAVIGASI DROPDOWN DESKTOP ---
                if (value == 'size') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserMeasurementPage()),
                  );
                } else if (value == 'standard') {
                  // Navigasi ke Standard Shop
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
          image: const NetworkImage('https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?q=80&w=2000'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
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
                  // Tombol 'See Collection' langsung ke ShopPage
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