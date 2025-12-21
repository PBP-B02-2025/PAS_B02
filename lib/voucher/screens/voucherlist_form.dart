import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ballistic/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:ballistic/screens/menu.dart';

class VoucherFormPage extends StatefulWidget {
  const VoucherFormPage({super.key});

  @override
  State<VoucherFormPage> createState() => _VoucherFormPageState();
}

class _VoucherFormPageState extends State<VoucherFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _code = "";
  String _description = "";
  String _discountPercentage = "";
  bool _isActive = true; // default

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Voucher Form',
          ),
        ),
        backgroundColor: const Color(0xFFC9A25B),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            childregit : [
              // === Kode Voucher ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Kode Voucher (contoh: DISC20)",
                    labelText: "Kode Voucher",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _code = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Kode voucher tidak boleh kosong!";
                    }
                    if (value.length < 3) {
                      return "Kode voucher minimal 3 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Deskripsi ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Deskripsi Voucher",
                    labelText: "Deskripsi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Persentase Diskon ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Persentase Diskon (1-100)",
                    labelText: "Persentase Diskon (%)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _discountPercentage = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Persentase diskon tidak boleh kosong!";
                    }
                    final number = int.tryParse(value);
                    if (number == null) {
                      return "Persentase harus berupa angka!";
                    }
                    if (number < 1 || number > 100) {
                      return "Persentase diskon harus antara 1-100!";
                    }
                    return null;
                  },
                ),
              ),

              // === Status Aktif ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SwitchListTile(
                  title: const Text("Aktifkan Voucher"),
                  subtitle: const Text(
                      "Voucher yang aktif dapat digunakan oleh pembeli"),
                  value: _isActive,
                  activeTrackColor: const Color(0xFFC9A25B),
                  onChanged: (bool value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(const Color(0xFFC9A25B)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Send data to Django backend
                        // TODO: Replace the URL with your app's URL
                        // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
                        // If you using chrome, use URL http://localhost:8000
                        
                        final response = await request.postJson(
                          "http://localhost:8000/voucher/create-flutter/",
                          jsonEncode({
                            "kode": _code,
                            "deskripsi": _description,
                            "persentase_diskon": _discountPercentage,
                            "is_active": _isActive,
                          }),
                        );
                        
                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Voucher berhasil disimpan!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Terdapat kesalahan, silakan coba lagi."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
