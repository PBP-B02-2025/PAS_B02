import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; 
import 'package:provider/provider.dart'; 
import 'package:ballistic/screens/login.dart'; 
import 'package:ballistic/utils/user_info.dart'; 

// --- IMPORT HALAMAN FITUR ---
import 'package:ballistic/shop/screen/shop.dart'; 
import 'package:ballistic/features/user_measurement/screens/measurement_page.dart';
import 'package:ballistic/shop/screen/transaction_history.dart';
// Import baru untuk navigasi
import 'package:ballistic/forum/screens/forum_entry_list.dart';
import 'package:ballistic/screens/news/news_list.dart';
import 'package:ballistic/voucher/screens/voucher_entry_list.dart';
import 'package:ballistic/screens/profile/profile_page.dart';
import 'package:ballistic/screens/about_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // --- FUNGSI LOGOUT ---
  Future<void> _handleLogout(BuildContext context, CookieRequest request) async {
    // Sesuaikan URL dengan environment Anda (localhost / 10.0.2.2)
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
      // Drawer hanya muncul di Mobile
      drawer: isMobile ? _buildDrawer(context) : null,
      
      // AppBar hanya muncul di Mobile
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
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const ProfilePage()));
                  },
                  icon: const Icon(Icons.person, size: 22, color: Colors.black),
                  tooltip: 'Profile',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const TransactionHistoryPage()));
                  },
                  icon: const Icon(Icons.receipt_long, size: 22, color: Colors.black),
                  tooltip: 'Transaction History',
                ),
                IconButton(
                  onPressed: () => _handleLogout(context, request),
                  icon: const Icon(Icons.logout, size: 20, color: Colors.red), 
                  tooltip: 'Logout',
                )
              ],
            )
          : null,
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Jika Desktop, tampilkan Header & Navbar khusus
            if (!isMobile) _buildTopHeader(context, request),
            if (!isMobile) _buildNavbar(context),
            
            // Hero Section (Gambar Besar)
            _buildHeroSection(context, isMobile),
            
            // Features Section
            _buildFeaturesSection(isMobile),
            
            // Why Choose Us Section
            _buildWhyChooseUsSection(isMobile),
            
            // Call to Action Section
            _buildCallToActionSection(context, isMobile),
            
            // Footer
            _buildFooter(isMobile),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER (HEADER DESKTOP) ---
  Widget _buildTopHeader(BuildContext context, CookieRequest request) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon Kiri
          Row(
            children: const [
              Icon(Icons.camera_alt_outlined, size: 20),
              SizedBox(width: 15),
              Icon(Icons.discord, size: 20),
              SizedBox(width: 15),
              Icon(Icons.business, size: 20),
            ],
          ),
          
          // Judul Tengah
          const Text(
            'BALLISTIC',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          
          // Tombol Kanan (Profile, History & Logout)
          Row(
            children: [
              IconButton(
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (c) => const ProfilePage()));
                },
                icon: const Icon(Icons.person, size: 24, color: Colors.black),
                tooltip: 'Profile',
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (c) => const TransactionHistoryPage()));
                },
                icon: const Icon(Icons.receipt_long, size: 24, color: Colors.black),
                tooltip: 'History',
              ),
              const SizedBox(width: 8),
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

  // --- WIDGET HELPER (NAVBAR DESKTOP) ---
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

  // --- NAV ITEM (NAVBAR LOGIC) ---
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
                // --- LOGIKA NAVIGASI NAVBAR ---
                if (title == 'HOME') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                } else if (title == 'FORUM') {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const ForumListPage())
                  );
                } else if (title == 'NEWS') {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const NewsListPage())
                  );
                } else if (title == 'VOUCHER') {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const VoucherEntryListPage())
                  );
                } else if (title == 'ABOUT') {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const AboutPage())
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

  // --- DRAWER (MOBILE) ---
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
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => const ShopPage())
                  );
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
          
          ListTile(
            title: const Text('HISTORY', style: TextStyle(fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (c) => const TransactionHistoryPage()));
            },
          ),

          _drawerItem(context, 'FORUM', false),
          _drawerItem(context, 'NEWS', false),
          _drawerItem(context, 'VOUCHER', false),
          _drawerItem(context, 'ABOUT', false),
        ],
      ),
    );
  }

  // --- DRAWER ITEM (MOBILE LOGIC) ---
  Widget _drawerItem(BuildContext context, String title, bool isHome) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context); // Tutup drawer dulu
        
        if (title == 'HOME') {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
        } else if (title == 'FORUM') {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ForumListPage()));
        } else if (title == 'NEWS') {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewsListPage()));
        } else if (title == 'VOUCHER') {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VoucherEntryListPage()));
        } else if (title == 'ABOUT') {
           Navigator.push(
             context, 
             MaterialPageRoute(builder: (context) => const AboutPage())
           );
        }
      },
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
              'Explore Curated\nAmerican Football\nCollections With Us',
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
              'Ballistic offers all categories of American football equipment, from protective gear to training accessories.',
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              style: TextStyle(color: Colors.white70, fontSize: isMobile ? 13 : 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopPage()));
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

  // --- FEATURES SECTION ---
  Widget _buildFeaturesSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 40 : 60,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Why Choose Ballistic',
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Premium American football equipment for serious athletes',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: isMobile ? 30 : 50),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureCard(
                Icons.verified,
                'Quality Guaranteed',
                'All products are thoroughly tested and certified',
                isMobile,
              ),
              _buildFeatureCard(
                Icons.local_shipping,
                'Fast Delivery',
                'Quick and secure shipping to your doorstep',
                isMobile,
              ),
              _buildFeatureCard(
                Icons.support_agent,
                '24/7 Support',
                'Our team is always ready to help you',
                isMobile,
              ),
              _buildFeatureCard(
                Icons.price_check,
                'Best Prices',
                'Competitive pricing with regular discounts',
                isMobile,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description, bool isMobile) {
    return Container(
      width: isMobile ? MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.width - 40 : 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFC9A25B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(icon, size: 40, color: const Color(0xFFC9A25B)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }



  // --- WHY CHOOSE US SECTION ---
  Widget _buildWhyChooseUsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 40 : 60,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join Our Community',
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Connect with fellow American football athletes, share experiences, and get expert advice from our community forum.',
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.grey[600],
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: [
                        _buildStatCard('10K+', 'Members', isMobile),
                        const SizedBox(width: 20),
                        _buildStatCard('500+', 'Products', isMobile),
                        const SizedBox(width: 20),
                        _buildStatCard('5K+', 'Reviews', isMobile),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label, bool isMobile) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFC9A25B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 12 : 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // --- CALL TO ACTION SECTION ---
  Widget _buildCallToActionSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 50 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFC9A25B),
            const Color(0xFFE8D4A0),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ready to Start Your Journey?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 24 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Explore our collection and find the perfect gear for your next game',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFC9A25B),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 30 : 40,
                    vertical: isMobile ? 16 : 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Shop Now',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ForumListPage()));
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 30 : 40,
                    vertical: isMobile ? 16 : 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Join Forum',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- FOOTER ---
  Widget _buildFooter(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 40,
      ),
      color: Colors.grey[900],
      child: Column(
        children: [
          if (!isMobile)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BALLISTIC',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC9A25B),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your trusted American football equipment store',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Links',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('About Us', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                      const SizedBox(height: 8),
                      Text('Shop', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                      const SizedBox(height: 8),
                      Text('Forum', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                      const SizedBox(height: 8),
                      Text('News', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('support@ballistic.com', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                      const SizedBox(height: 8),
                      Text('+62 123 4567 8900', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                      const SizedBox(height: 8),
                      Text('Jakarta, Indonesia', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                const Text(
                  'BALLISTIC',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC9A25B),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your trusted American football equipment store',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          const SizedBox(height: 30),
          Divider(color: Colors.grey[700]),
          const SizedBox(height: 20),
          Text(
            '© 2025 BALLISTIC - Team B02. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}