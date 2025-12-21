import 'package:flutter/material.dart';
import 'package:ballistic/voucher/models/voucher_model.dart';
import 'dart:math';

class VoucherEntryCard extends StatelessWidget {
  final Voucher voucher;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VoucherEntryCard({
    super.key,
    required this.voucher,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  // Color palette from Django project - gradient combinations
  static const List<List<Color>> gradientPalettes = [
    [Color(0xFF667eea), Color(0xFF764ba2)], // Purple Dream
    [Color(0xFFf093fb), Color(0xFFF5576C)], // Pink Sunset
    [Color(0xFF4facfe), Color(0xFF00f2fe)], // Ocean Blue
    [Color(0xFF43e97b), Color(0xFF38f9d7)], // Green Aqua
    [Color(0xFFfa709a), Color(0xFFfee140)], // Sunset Orange
    [Color(0xFF30cfd0), Color(0xFF330867)], // Deep Ocean
    [Color(0xFFa8edea), Color(0xFFfed6e3)], // Soft Pink
    [Color(0xFFff9a56), Color(0xFFff6a88)], // Coral Dream
    [Color(0xFF17ead9), Color(0xFF6078ea)], // Cool Blue
    [Color(0xFF96fbc4), Color(0xFFf9f586)], // Spring Fresh
  ];

  LinearGradient _getGradient() {
    // Use voucher code to generate consistent random gradient
    final random = Random(voucher.kode.hashCode);
    final paletteIndex = random.nextInt(gradientPalettes.length);
    final palette = gradientPalettes[paletteIndex];
    
    // If voucher is inactive, use grayscale colors
    if (!voucher.isActive) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF9E9E9E), // Gray
          Color(0xFF616161), // Dark Gray
        ],
      );
    }
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: palette,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: _getGradient(),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with Code and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Voucher Code
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        voucher.kode,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: voucher.isActive
                            ? Colors.green.withValues(alpha: 0.3)
                            : Colors.red.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: voucher.isActive
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        voucher.isActive ? 'ACTIVE' : 'INACTIVE',
                        style: TextStyle(
                          color: voucher.isActive
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),

                // Discount Percentage - Large Display
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucher.persentaseDiskon,
                      style: const TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        '%',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8, top: 16),
                      child: Text(
                        'OFF',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),

                // Description
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    voucher.deskripsi.isEmpty
                        ? 'Tidak ada deskripsi'
                        : (voucher.deskripsi.length > 120
                            ? '${voucher.deskripsi.substring(0, 120)}...'
                            : voucher.deskripsi),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                      fontStyle: voucher.deskripsi.isEmpty ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Bottom Info with Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side - Info
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Tap to view details',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    
                    // Right side - Action Buttons (Edit & Delete)
                    if (onEdit != null || onDelete != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit Button
                          if (onEdit != null)
                            InkWell(
                              onTap: onEdit,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          
                          if (onEdit != null && onDelete != null)
                            const SizedBox(width: 8),
                          
                          // Delete Button
                          if (onDelete != null)
                            InkWell(
                              onTap: onDelete,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
