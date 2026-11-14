import 'package:flutter/material.dart';
import '../services/app_state_scope.dart';
import '../models/donation_record.dart';
import '../widgets/campaign_image.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'Semua';

  void _showReceiptDialog(BuildContext context, DonationRecord record) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFDFBF7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: Color(0xFF2E7D32)),
            const SizedBox(width: 8),
            const Text(
              'Bukti Donasi',
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close, size: 20, color: Colors.grey),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CampaignImage(
                imageUrl: record.imageUrl,
                emoji: record.emoji,
                fallbackColor: record.color,
                width: 70,
                height: 70,
                borderRadius: 14,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                record.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF212121),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            _receiptRow('ID Bukti', record.id),
            _receiptRow('Status', record.status, isGreen: true),
            _receiptRow('Tanggal', record.dateText.replaceAll('Selesai, ', '')),
            _receiptRow('Jumlah', '${record.quantity} ${record.unit}'),
            _receiptRow('Metode', record.pickupMethod),
            _receiptRow('Poin Dampak', '+${record.impactPoints} poin', isGreen: true),
            const Divider(),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: Color(0xFF2E7D32), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Terverifikasi oleh Yayasan EcoDonation',
                      style: TextStyle(fontSize: 11, color: Color(0xFF1B5E20), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sertifikat donasi disalin ke clipboard! 📄'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
              },
              icon: const Icon(Icons.share, size: 18),
              label: const Text('Bagikan Sertifikat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _receiptRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF757575))),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isGreen ? const Color(0xFF2E7D32) : const Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final history = appState.history;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EB),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Text(
                    'Riwayat Donasi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${history.length} Aktivitas',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Filter Pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _filterChip('Semua'),
                  const SizedBox(width: 8),
                  _filterChip('Selesai'),
                  const SizedBox(width: 8),
                  _filterChip('Dalam Proses'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // List of items
            Expanded(
              child: history.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'Belum ada donasi',
                            style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Ikuti kampanye untuk mulai membuat dampak!',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final item = history[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => _showReceiptDialog(context, item),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                child: Row(
                                  children: [
                                    // Number
                                    SizedBox(
                                      width: 20,
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF9E9E9E),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Thumbnail Image
                                    CampaignImage(
                                      imageUrl: item.imageUrl,
                                      emoji: item.emoji,
                                      fallbackColor: item.color,
                                      width: 44,
                                      height: 44,
                                      borderRadius: 10,
                                    ),
                                    const SizedBox(width: 12),
                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF212121),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Text(
                                                item.dateText,
                                                style: const TextStyle(
                                                  fontSize: 11.5,
                                                  color: Color(0xFF9E9E9E),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '• ${item.quantity} ${item.unit}',
                                                style: const TextStyle(
                                                  fontSize: 11.5,
                                                  color: Color(0xFF757575),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Points Badge
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '+${item.impactPoints}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2E7D32),
                                        ),
                                      ),
                                    ),
                                    // Checkmark
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF2E7D32),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String title) {
    final isSelected = _selectedFilter == title;
    return ChoiceChip(
      label: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : const Color(0xFF555555),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFF2E7D32),
      backgroundColor: Colors.white,
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      onSelected: (val) {
        if (val) setState(() => _selectedFilter = title);
      },
    );
  }
}
