import 'package:flutter/material.dart';
import 'package:ballistic/widgets/left_drawer.dart';
import 'package:ballistic/shop/screen/shop.dart';
import 'package:ballistic/features/user_measurement/screens/measurement_page.dart';
import 'package:ballistic/forum/screens/forum_entry_list.dart';
import 'package:ballistic/screens/news/news_list.dart';
import 'package:ballistic/voucher/screens/voucher_entry_list.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC9A25B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'About',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Logo/Title Section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9A25B),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'B',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'BALLISTIC',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC9A25B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your Premium American Football Equipment Store',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // About Section
              const Text(
                'Tentang Kami',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Text(
                  'BALLISTIC adalah platform e-commerce terpercaya yang menyediakan berbagai perlengkapan American football berkualitas tinggi. Kami berkomitmen untuk memberikan pengalaman berbelanja terbaik dengan produk-produk pilihan dan layanan yang profesional.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),

              const SizedBox(height: 32),

              // Features Section
              const Text(
                'Fitur Unggulan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              _buildFeatureCard(
                context,
                Icons.shopping_bag,
                'Shop',
                'Jelajahi koleksi perlengkapan American football kami yang lengkap dengan berbagai kategori dan harga yang kompetitif.',
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                Icons.straighten,
                'Size Recommendation',
                'Dapatkan rekomendasi ukuran yang tepat untuk pakaian dan helm berdasarkan data pengukuran tubuh Anda.',
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                Icons.forum,
                'Forum',
                'Bergabunglah dengan komunitas American football kami untuk berdiskusi, berbagi pengalaman, dan mendapatkan tips dari sesama pemain.',
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                Icons.newspaper,
                'News',
                'Tetap update dengan berita terbaru seputar American football, produk baru, dan event-event menarik.',
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                Icons.local_offer,
                'Voucher',
                'Nikmati berbagai promo dan diskon menarik dengan voucher yang tersedia.',
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                Icons.rate_review,
                'Review',
                'Baca review dari pengguna lain dan bagikan pengalaman Anda tentang produk yang telah dibeli.',
              ),

              const SizedBox(height: 32),

              // Team Section
              const Text(
                'Tim Kami',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Text(
                  'BALLISTIC dikembangkan oleh Tim B02 yang terdiri dari mahasiswa-mahasiswa berbakat yang berdedikasi untuk menciptakan platform e-commerce terbaik untuk komunitas American football di Indonesia.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),

              const SizedBox(height: 32),

              // Contact Section
              const Text(
                'Hubungi Kami',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildContactCard(Icons.email, 'Email', 'support@ballistic.com'),
              const SizedBox(height: 12),
              _buildContactCard(Icons.phone, 'Phone', '+62 123 4567 8900'),
              const SizedBox(height: 12),
              _buildContactCard(Icons.location_on, 'Address', 'Jakarta, Indonesia'),

              const SizedBox(height: 40),

              // Footer
              Center(
                child: Text(
                  '© 2025 BALLISTIC - Team B02. All rights reserved.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String title, String description) {
    return InkWell(
      onTap: () {
        if (title == 'Shop') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShopPage()),
          );
        } else if (title == 'Size Recommendation') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserMeasurementPage()),
          );
        } else if (title == 'Forum') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForumListPage()),
          );
        } else if (title == 'News') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewsListPage()),
          );
        } else if (title == 'Voucher') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VoucherEntryListPage()),
          );
        }
      },
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFC9A25B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFC9A25B),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildContactCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFC9A25B),
            size: 24,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
