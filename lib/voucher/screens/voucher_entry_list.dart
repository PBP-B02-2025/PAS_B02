import 'package:flutter/material.dart';
import 'package:ballistic/voucher/models/voucher_model.dart';
import 'package:ballistic/widgets/left_drawer.dart';
import 'package:ballistic/voucher/widgets/voucher_entry_card.dart';
import 'package:ballistic/voucher/widgets/voucher_form_modal.dart';
import 'package:ballistic/utils/user_info.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class VoucherEntryListPage extends StatefulWidget {
  const VoucherEntryListPage({super.key});

  @override
  State<VoucherEntryListPage> createState() => _VoucherEntryListPageState();
}

class _VoucherEntryListPageState extends State<VoucherEntryListPage> {
  // Key for refreshing the list
  Key _futureBuilderKey = UniqueKey();

  void _refreshVoucherList() {
    setState(() {
      _futureBuilderKey = UniqueKey();
    });
  }

  Future<List<Voucher>> fetchVoucher(CookieRequest request) async {
    // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome, use URL http://localhost:8000
    
    final response = await request.get('https://jovian-felix-ballistic.pbp.cs.ui.ac.id/voucher/json/');
    
    // Decode response to json format
    var data = response;
    
    // Convert json data to Voucher objects
    List<Voucher> listVoucher = [];
    for (var d in data) {
      if (d != null) {
        listVoucher.add(Voucher.fromJson(d));
      }
    }
    return listVoucher;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Voucher List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFC9A25B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        key: _futureBuilderKey,
        future: fetchVoucher(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      size: 80,
                      color: Color(0xFFC9A25B),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No vouchers available yet.',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFC9A25B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Check back later for exciting deals!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final voucher = snapshot.data![index];
                  return FutureBuilder<bool>(
                    future: UserInfo.isSuperuser(),
                    builder: (context, adminSnapshot) {
                      final isSuperuser = adminSnapshot.data ?? false;
                      
                      return VoucherEntryCard(
                        voucher: voucher,
                        onTap: () {
                          // Show a detailed dialog when voucher card is clicked
                          showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Row(
                            children: [
                              const Icon(
                                Icons.local_offer,
                                color: Color(0xFFC9A25B),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  voucher.kode,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Discount Badge
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC9A25B).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${voucher.persentaseDiskon}% OFF',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFC9A25B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Description
                                const Text(
                                  'Description:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  voucher.deskripsi.isEmpty
                                      ? 'Tidak ada deskripsi'
                                      : voucher.deskripsi,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: voucher.deskripsi.isEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                    color: voucher.deskripsi.isEmpty
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Status
                                Row(
                                  children: [
                                    const Text(
                                      'Status: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: voucher.isActive
                                            ? Colors.green.withValues(alpha: 0.1)
                                            : Colors.red.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: voucher.isActive
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      child: Text(
                                        voucher.isActive ? 'Active' : 'Inactive',
                                        style: TextStyle(
                                          color: voucher.isActive
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Close',
                                style: TextStyle(color: Color(0xFFC9A25B)),
                              ),
                            ),
                            if (voucher.isActive)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC9A25B),
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Voucher ${voucher.kode} copied!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                },
                                child: const Text('Copy Code'),
                              ),
                          ],
                        );
                      },
                    );
                  },
                // Edit button - only for superuser
                onEdit: isSuperuser
                      ? () async {
                          final result = await showGeneralDialog<bool>(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: 'Edit Voucher',
                            barrierColor: Colors.black54,
                            transitionDuration: const Duration(milliseconds: 300),
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return VoucherFormModal(voucher: voucher);
                            },
                            transitionBuilder: (context, animation, secondaryAnimation, child) {
                              return ScaleTransition(
                                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutBack,
                                  ),
                                ),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                          );

                          if (result == true) {
                            _refreshVoucherList();
                          }
                        }
                      : null,
                  // Delete button - only for superuser
                  onDelete: isSuperuser
                      ? () async {
                          // Show confirmation dialog
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Delete Voucher'),
                                  ],
                                ),
                                content: Text(
                                  'Are you sure you want to delete voucher "${voucher.kode}"?\n\nThis action cannot be undone.',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );

                          // If confirmed, proceed with deletion
                          if (confirm == true && context.mounted) {
                            try {
                              final response = await request.post(
                                "https://jovian-felix-ballistic.pbp.cs.ui.ac.id/voucher/delete-flutter/${voucher.id}/",
                                {},
                              );

                              if (context.mounted) {
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Voucher deleted successfully!"),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  _refreshVoucherList();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        response['message'] ?? "Failed to delete voucher.",
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Error: $e"),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          }
                        }
                      : null,
                );
                    },
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FutureBuilder<bool>(
        future: UserInfo.isSuperuser(),
        builder: (context, snapshot) {
          // Only show FAB if user is superuser
          if (snapshot.data == true) {
            return FloatingActionButton(
              onPressed: () async {
                // Show modal dialog with animation
                final result = await showGeneralDialog<bool>(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: 'Add Voucher',
                  barrierColor: Colors.black54,
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const VoucherFormModal();
                  },
                  transitionBuilder: (context, animation, secondaryAnimation, child) {
                    // Scale and fade animation
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                        ),
                      ),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                );

                // Refresh list if voucher was created
                if (result == true) {
                  _refreshVoucherList();
                }
              },
              backgroundColor: const Color(0xFFC9A25B),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            );
          }
          // Return empty container if not superuser
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
