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
      final measurementResponse = await request.get('http://localhost:8000/measurement/measurementdata/');
      
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
              color: Colors.grey,
            ),
          ),
          badge ?? Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Center(
                            child: Text(
                              username.substring(0, 2).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC9A25B),
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
                            color: Colors.black87,
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
                                color: Colors.grey.withOpacity(0.1),
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
                                badge: _buildBadge(
                                  (isAdmin || isStaff) ? 'ADMIN' : 'USER',
                                  const Color(0xFFC9A25B),
                                ),
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
                            color: Colors.black87,
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
                                color: Colors.grey.withOpacity(0.1),
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
                                        const Color(0xFF8B7355),
                                      ),
                                    ),
                                    const Divider(),
                                    _buildInfoRow(
                                      'Ukuran Helm:',
                                      '',
                                      badge: _buildBadge(
                                        measurementData!['helmet_size']?.toString() ?? '-',
                                        const Color(0xFF8B7355),
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
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFC9A25B),
                              side: const BorderSide(color: Color(0xFFC9A25B)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
