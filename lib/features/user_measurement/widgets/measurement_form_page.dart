import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
// Import model kamu jika diperlukan untuk konversi data
// import 'package:ballistic/features/user_measurement/models/measurement.dart';

class MeasurementFormPage extends StatefulWidget {
  final Map<String, dynamic>? existingData;

  const MeasurementFormPage({super.key, this.existingData});

  @override
  State<MeasurementFormPage> createState() => _MeasurementFormPageState();
}

class _MeasurementFormPageState extends State<MeasurementFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _headController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _hipController = TextEditingController();
  final TextEditingController _chestController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      // Pastikan data yang masuk ke controller dikonversi ke String dengan rapi
      _heightController.text = widget.existingData!['height']?.toString() ?? "";
      _weightController.text = widget.existingData!['weight']?.toString() ?? "";
      _headController.text = widget.existingData!['head_circumference']?.toString() ?? "";
      _waistController.text = widget.existingData!['waist']?.toString() ?? "";
      _hipController.text = widget.existingData!['hip']?.toString() ?? "";
      _chestController.text = widget.existingData!['chest']?.toString() ?? "";
    }
  }

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak
    _heightController.dispose();
    _weightController.dispose();
    _headController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    _chestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.white, // Menjaga konsistensi background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Isi Data Ukuran', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ukuran Wajib", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildTextField("Tinggi (cm)", _heightController, isRequired: true),
              _buildTextField("Berat (kg)", _weightController, isRequired: true),
              _buildTextField("Lingkar Kepala (cm)", _headController, isRequired: true),

              const SizedBox(height: 24),
              const Text("Ukuran Tambahan (Opsional)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildTextField("Pinggang (cm)", _waistController, isRequired: false),
              _buildTextField("Pinggul (cm)", _hipController, isRequired: false),
              _buildTextField("DADA (cm)", _chestController, isRequired: false),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Sinkronisasi Data: Konversi input ke format yang diterima Django
                      final Map<String, dynamic> body = {
                        'height': _heightController.text,
                        'weight': _weightController.text,
                        'head_circumference': _headController.text,
                        // Kirim null atau string kosong jika opsional tidak diisi
                        'waist': _waistController.text.isEmpty ? "" : _waistController.text,
                        'hip': _hipController.text.isEmpty ? "" : _hipController.text,
                        'chest': _chestController.text.isEmpty ? "" : _chestController.text,
                      };

                      // Gunakan endpoint Django yang benar
                      final response = await request.post(
                        "http://localhost:8000/measurement/create-flutter/",
                        jsonEncode(body), // Gunakan jsonEncode agar format JSON valid
                      );

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Data berhasil disimpan!")),
                          );
                          // Navigator pop mengirim true agar UserMeasurementPage memanggil refreshPage()
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response['message'] ?? "Terjadi kesalahan")),
                          );
                        }
                      }
                    }
                  },
                  child: const Text("Simpan Data", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {required bool isRequired}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return '$label tidak boleh kosong';
          }
          if (value != null && value.isNotEmpty) {
            final n = double.tryParse(value);
            if (n == null) return 'Harus berupa angka';
          }
          return null;
        },
      ),
    );
  }
}