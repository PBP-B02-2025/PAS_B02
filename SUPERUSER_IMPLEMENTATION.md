# 📱 Implementasi Status Superuser/Admin di Flutter

## ✅ Yang Sudah Diimplementasikan

### 1. **Package yang Diinstall**
- ✅ `shared_preferences: ^2.5.4` - untuk menyimpan status user secara lokal

### 2. **File yang Dibuat/Dimodifikasi**

#### 📄 `lib/utils/user_info.dart` (BARU)
Helper class untuk mengelola informasi user:
- `saveUserInfo()` - Simpan username, is_superuser, is_staff
- `getUsername()` - Ambil username
- `isSuperuser()` - Cek apakah user adalah superuser/admin
- `isStaff()` - Cek apakah user adalah staff
- `getUserInfo()` - Ambil semua informasi user
- `clearUserInfo()` - Hapus informasi user saat logout

#### 📄 `lib/screens/login.dart` (DIUPDATE)
- Import `user_info.dart`
- Saat login berhasil:
  - Ambil `is_superuser` dan `is_staff` dari response
  - Simpan ke SharedPreferences dengan `UserInfo.saveUserInfo()`
  - Tampilkan "(Admin)" di SnackBar jika user adalah superuser

#### 📄 `lib/screens/menu.dart` (DIUPDATE)
- Import `user_info.dart`
- Saat logout (mobile & desktop):
  - Hapus informasi user dengan `UserInfo.clearUserInfo()`

---

## 🚀 Cara Menggunakan

### **1. Cek Status Superuser di Widget**

```dart
import 'package:ballistic/utils/user_info.dart';

// Di dalam widget
FutureBuilder<bool>(
  future: UserInfo.isSuperuser(),
  builder: (context, snapshot) {
    bool isSuperuser = snapshot.data ?? false;
    
    return Column(
      children: [
        // Menu khusus admin
        if (isSuperuser) ...[
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text('Admin Panel'),
            onTap: () {
              // Navigasi ke halaman admin
            },
          ),
        ],
        
        // Menu untuk semua user
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {},
        ),
      ],
    );
  },
)
```

### **2. Cek Sebelum Navigasi**

```dart
Future<void> navigateToAdminPage(BuildContext context) async {
  bool isSuperuser = await UserInfo.isSuperuser();
  
  if (isSuperuser) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminPage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Akses ditolak! Halaman ini hanya untuk admin.')),
    );
  }
}
```

### **3. Disable Button untuk Non-Admin**

```dart
FutureBuilder<bool>(
  future: UserInfo.isSuperuser(),
  builder: (context, snapshot) {
    bool isSuperuser = snapshot.data ?? false;
    
    return ElevatedButton(
      onPressed: isSuperuser ? () {
        // Admin action
      } : null, // Disable untuk non-admin
      child: Text('Admin Only'),
    );
  },
)
```

### **4. Load User Info di initState**

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool isSuperuser = false;
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await UserInfo.getUserInfo();
    setState(() {
      username = userInfo['username'];
      isSuperuser = userInfo['is_superuser'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Welcome, $username ${isSuperuser ? "(Admin)" : ""}');
  }
}
```

---

## 📊 Flow Aplikasi

### **Login Flow:**
```
1. User input username & password
2. Flutter kirim ke Django backend
3. Django response dengan:
   {
     "username": "admin",
     "message": "Login successful!",
     "status": true,
     "is_superuser": true,
     "is_staff": true
   }
4. Flutter simpan ke SharedPreferences via UserInfo.saveUserInfo()
5. Redirect ke HomePage dengan pesan "Welcome, admin (Admin)"
```

### **Check Admin Flow:**
```
1. Widget memanggil UserInfo.isSuperuser()
2. UserInfo mengambil dari SharedPreferences
3. Return true/false
4. Widget menampilkan UI sesuai status
```

### **Logout Flow:**
```
1. User klik logout button
2. Flutter panggil request.logout()
3. Flutter hapus data dari SharedPreferences via UserInfo.clearUserInfo()
4. Redirect ke LoginPage
```

---

## 🎯 Contoh Penggunaan di Voucher

### **Tampilkan Tombol "Add Voucher" hanya untuk Admin:**

```dart
// Di halaman voucher list
FutureBuilder<bool>(
  future: UserInfo.isSuperuser(),
  builder: (context, snapshot) {
    bool isSuperuser = snapshot.data ?? false;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Vouchers'),
        actions: [
          // Tombol add voucher hanya untuk admin
          if (isSuperuser)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddVoucherPage()),
                );
              },
            ),
        ],
      ),
      body: VoucherList(),
      floatingActionButton: isSuperuser
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddVoucherPage()),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  },
)
```

---

## 📝 Catatan Penting

1. ✅ Backend Django sudah mengirim `is_superuser` dan `is_staff` di response login
2. ✅ Flutter sudah menyimpan status tersebut ke SharedPreferences
3. ✅ Saat logout, status dihapus otomatis
4. ✅ Bisa digunakan di semua halaman dengan import `user_info.dart`

---

## 🔍 File Contoh

Lihat `lib/utils/user_info_example.dart` untuk contoh lengkap berbagai cara penggunaan!

---

## 🎉 Selesai!

Sekarang aplikasi Flutter sudah bisa membedakan user biasa dengan admin (superuser) dan menampilkan fitur sesuai role mereka!
