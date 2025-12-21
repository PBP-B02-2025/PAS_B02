import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ballistic/utils/user_info.dart';
import 'package:ballistic/screens/login.dart';
import 'package:ballistic/widgets/left_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  Map<String, dynamic>? measurementData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final request = context.read<CookieRequest>();
      
      // Fetch user profile info
      final userInfo = await UserInfo.getUserInfo();
      
      // Fetch measurement data
      final measurementResponse = await request.get('https://jovian-felix-ballistic.pbp.cs.ui.ac.id/measurement/measurementdata/');
      
      setState(() {
        userData = userInfo;
        if (measurementResponse != null && 
            measurementResponse['status'] != 'error' && 
            measurementResponse.containsKey('height')) {
          measurementData = measurementResponse;
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleLogout(BuildContext context, CookieRequest request) async {
    const String logoutUrl = "https://jovian-felix-ballistic.pbp.cs.ui.ac.id/auth/logout/";
    
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

  Widget _buildInfoRow(String label, String value, {Widget? badge}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666), // Medium Gray
            ),
          ),
          badge ?? Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333), // Dark Gray
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF000000), // Black
            color, // Gold or custom color
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isAdmin) {
    if (isAdmin) {
      // Admin Badge with gold gradient
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFCDA34F), // Gold
              Color(0xFFD4AF37), // Bright Gold
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          '⭐ ADMIN',
          style: TextStyle(
            color: Color(0xFF000000), // Black text
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      // User Badge with black gradient and gold border
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF000000), // Black
              Color(0xFF333333), // Dark Gray
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFCDA34F), // Gold border
            width: 1,
          ),
        ),
        child: const Text(
          '👤 USER',
          style: TextStyle(
            color: Color(0xFFCDA34F), // Gold text
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final username = userData?['username'] ?? 'User';
    final isAdmin = userData?['is_superuser'] ?? false;
    final isStaff = userData?['is_staff'] ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC9A25B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const LeftDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF000000), // Black
                          Color(0xFF333333), // Dark Gray
                          Color(0xFFCDA34F), // Gold
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3), // rgba(255, 255, 255, 0.3)
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              username.substring(0, 2).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Username
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Email
                        Text(
                          '$username@example.com',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Account Information Section
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Akun',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333), // Dark Gray
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow('Username:', username),
                              const Divider(),
                              _buildInfoRow('Email:', '$username@example.com'),
                              const Divider(),
                              _buildInfoRow('Nama Lengkap:', 'Belum diatur'),
                              const Divider(),
                              _buildInfoRow('Tanggal Bergabung:', '23 Oktober 2025'),
                              const Divider(),
                              _buildInfoRow(
                                'Status:',
                                '',
                                badge: _buildStatusBadge(isAdmin || isStaff),
                              ),
                            ],
                          ),
                        ),

                        // Body Measurement Section
                        const SizedBox(height: 32),
                        const Text(
                          'Data Pengukuran Tubuh',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333), // Dark Gray
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: measurementData != null && measurementData!.containsKey('height')
                              ? Column(
                                  children: [
                                    _buildInfoRow(
                                      'Tinggi Badan:',
                                      '${measurementData!['height']?.toString() ?? '-'} cm',
                                    ),
                                    const Divider(),
                                    _buildInfoRow(
                                      'Berat Badan:',
                                      '${measurementData!['weight']?.toString() ?? '-'} kg',
                                    ),
                                    const Divider(),
                                    _buildInfoRow(
                                      'Lingkar Kepala:',
                                      '${measurementData!['head_circumference']?.toString() ?? '-'} cm',
                                    ),
                                    const Divider(),
                                    _buildInfoRow(
                                      'Ukuran Baju:',
                                      '',
                                      badge: _buildBadge(
                                        measurementData!['clothes_size']?.toString() ?? '-',
                                        const Color(0xFFCDA34F), // Gold
                                      ),
                                    ),
                                    const Divider(),
                                    _buildInfoRow(
                                      'Ukuran Helm:',
                                      '',
                                      badge: _buildBadge(
                                        measurementData!['helmet_size']?.toString() ?? '-',
                                        const Color(0xFFCDA34F), // Gold
                                      ),
                                    ),
                                  ],
                                )
                              : const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'Data pengukuran belum tersedia',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                        ),

                        // Logout Button
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _handleLogout(context, request),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF000000), // Black
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
