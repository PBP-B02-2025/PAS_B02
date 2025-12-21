import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:ballistic/voucher/models/voucher_model.dart';

class VoucherFormModal extends StatefulWidget {
  final Voucher? voucher; // Null for add, filled for edit

  const VoucherFormModal({super.key, this.voucher});

  @override
  State<VoucherFormModal> createState() => _VoucherFormModalState();
}

class _VoucherFormModalState extends State<VoucherFormModal> {
  final _formKey = GlobalKey<FormState>();
  late String _code;
  late String _description;
  late String _discountPercentage;
  late bool _isActive;
  bool _isLoading = false;

  bool get isEditing => widget.voucher != null;

  @override
  void initState() {
    super.initState();
    // Initialize with existing data if editing
    _code = widget.voucher?.kode ?? "";
    _description = widget.voucher?.deskripsi ?? "";
    _discountPercentage = widget.voucher?.persentaseDiskon ?? "";
    _isActive = widget.voucher?.isActive ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 650),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Voucher' : 'Add New Voucher',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC9A25B),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ],
            ),
            const Divider(height: 24),

            // Form Content
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kode Voucher
                      TextFormField(
                        initialValue: _code,
                        decoration: InputDecoration(
                          labelText: "Voucher Code",
                          hintText: "e.g., DISC20",
                          prefixIcon: const Icon(Icons.qr_code),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFC9A25B),
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _code = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Voucher code cannot be empty!";
                          }
                          if (value.length < 3) {
                            return "Voucher code must be at least 3 characters!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextFormField(
                        initialValue: _description,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Description",
                          hintText: "Enter voucher description",
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFC9A25B),
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _description = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Discount Percentage
                      TextFormField(
                        initialValue: _discountPercentage,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Discount Percentage",
                          hintText: "1-100",
                          prefixIcon: const Icon(Icons.percent),
                          suffixText: "%",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFC9A25B),
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _discountPercentage = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Discount percentage cannot be empty!";
                          }
                          final number = double.tryParse(value);
                          if (number == null) {
                            return "Must be a valid number!";
                          }
                          if (number < 1 || number > 100) {
                            return "Discount must be between 1-100!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Active Status Switch
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SwitchListTile(
                          title: const Text(
                            "Active Status",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            _isActive
                                ? "Voucher is active and can be used"
                                : "Voucher is inactive",
                            style: TextStyle(
                              fontSize: 12,
                              color: _isActive ? Colors.green : Colors.grey,
                            ),
                          ),
                          value: _isActive,
                          activeTrackColor: const Color(0xFFC9A25B),
                          onChanged: (value) {
                            setState(() {
                              _isActive = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.pop(context, false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC9A25B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              final url = isEditing
                                  ? "https://jovian-felix-ballistic.pbp.cs.ui.ac.id/voucher/edit-flutter/${widget.voucher!.id}/"
                                  : "https://jovian-felix-ballistic.pbp.cs.ui.ac.id/voucher/create-flutter/";
                              
                              final response = await request.postJson(
                                url,
                                jsonEncode({
                                  "kode": _code,
                                  "deskripsi": _description,
                                  "persentase_diskon": _discountPercentage,
                                  "is_active": _isActive,
                                }),
                              );

                              setState(() {
                                _isLoading = false;
                              });

                              if (context.mounted) {
                                if (response['status'] == 'success') {
                                  Navigator.pop(context, true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isEditing
                                            ? "Voucher updated successfully!"
                                            : "Voucher created successfully!",
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        response['message'] ?? "An error occurred, please try again.",
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
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
                        },
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Save Voucher'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
