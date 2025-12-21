import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/measurement_detail.dart';

class UserMeasurementPage extends StatefulWidget {
  const UserMeasurementPage({super.key});

  @override
  State<UserMeasurementPage> createState() => _UserMeasurementPageState();
}

class _UserMeasurementPageState extends State<UserMeasurementPage> {
  // Fungsi untuk mengambil data dari backend
  Future<Map<String, dynamic>?> fetchMeasurement(CookieRequest request) async {
    try {
      // Endpoint ini harus sesuai dengan urls.py di Django kamu yang mengembalikan JSON
      final response = await request.get('http://localhost:8000/measurement/measurementdata/');

      // Jika response mengandung error atau data kosong dari backend
      if (response == null || response['status'] == 'error' || response.isEmpty) {
        return null;
      }
      return response;
    } catch (e) {
      return null;
    }
  }

  // Fungsi refresh untuk memicu build ulang FutureBuilder
  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Size Recommendation",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text("Berikut data ukuran badanmu saat ini.",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 30),

                  // SINKRONISASI BACKEND MENGGUNAKAN FUTUREBUILDER
                  FutureBuilder(
                    future: fetchMeasurement(request),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(color: Colors.black);
                      }

                      // Jika data ada di backend
                      if (snapshot.hasData && snapshot.data != null) {
                        return MeasurementDetailCard(
                          data: snapshot.data!, // Kirim data dari Django ke widget detail
                          onDelete: refreshPage, // Panggil refresh saat data dihapus
                          onEdit: refreshPage,   // Panggil refresh saat data diubah
                        );
                      }

                      // Jika data kosong atau error (Tampilan awal/Empty State)
                      return EmptyStateCard(
                        onFillNow: refreshPage, // Refresh saat user selesai isi form
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                  const Divider(),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Produk yang Direkomendasikan",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),

                  // Text rekomendasi juga bisa dibuat dinamis nanti
                  const Text("No measurement data found",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}