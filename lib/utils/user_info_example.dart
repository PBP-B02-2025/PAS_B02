// ============================================================
// CONTOH PENGGUNAAN UserInfo
// ============================================================
// File ini menunjukkan cara menggunakan UserInfo untuk 
// mengecek status superuser dan menampilkan UI berbeda
// ============================================================

import 'package:flutter/material.dart';
import 'package:ballistic/utils/user_info.dart';

// ============================================================
// CONTOH 1: Mengecek status di dalam Widget
// ============================================================
class ExampleWidget extends StatefulWidget {
  const ExampleWidget({super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  bool isSuperuser = false;
  bool isStaff = false;
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    // Ambil informasi user
    final userInfo = await UserInfo.getUserInfo();
    setState(() {
      username = userInfo['username'];
      isSuperuser = userInfo['is_superuser'];
      isStaff = userInfo['is_staff'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $username'),
      ),
      body: Column(
        children: [
          // Menu yang hanya muncul untuk admin
          if (isSuperuser) ...[
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin Panel'),
              subtitle: const Text('Khusus Admin'),
              onTap: () {
                // Navigasi ke halaman admin
              },
            ),
            ListTile(
              leading: const Icon(Icons.discount),
              title: const Text('Manage Vouchers'),
              subtitle: const Text('Khusus Admin'),
              onTap: () {
                // Navigasi ke halaman voucher management
              },
            ),
          ],

          // Menu untuk semua user
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Navigasi ke home
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Shop'),
            onTap: () {
              // Navigasi ke shop
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CONTOH 2: Menggunakan FutureBuilder
// ============================================================
class ExampleFutureBuilder extends StatelessWidget {
  const ExampleFutureBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserInfo.isSuperuser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        bool isSuperuser = snapshot.data ?? false;

        return Column(
          children: [
            Text(isSuperuser ? 'Anda adalah Admin' : 'Anda adalah User Biasa'),
            
            // Tombol khusus admin
            if (isSuperuser)
              ElevatedButton(
                onPressed: () {
                  // Aksi khusus admin
                },
                child: const Text('Admin Action'),
              ),
          ],
        );
      },
    );
  }
}

// ============================================================
// CONTOH 3: Checking sebelum navigasi
// ============================================================
Future<void> navigateToAdminPage(BuildContext context) async {
  bool isSuperuser = await UserInfo.isSuperuser();
  
  if (isSuperuser) {
    // Navigasi ke halaman admin
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminPage()),
    );
  } else {
    // Tampilkan pesan error
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Akses ditolak! Halaman ini hanya untuk admin.'),
      ),
    );
  }
}

// Placeholder untuk AdminPage
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Page')),
      body: const Center(child: Text('Admin Only Content')),
    );
  }
}

// ============================================================
// CONTOH 4: Conditional Button
// ============================================================
class ExampleConditionalButton extends StatelessWidget {
  const ExampleConditionalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserInfo.isSuperuser(),
      builder: (context, snapshot) {
        bool isSuperuser = snapshot.data ?? false;

        return ElevatedButton(
          onPressed: isSuperuser
              ? () {
                  // Admin action
                  print('Admin button clicked');
                }
              : null, // Disable button untuk non-admin
          child: const Text('Admin Only Button'),
        );
      },
    );
  }
}
