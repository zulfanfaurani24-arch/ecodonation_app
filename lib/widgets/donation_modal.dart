import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../services/app_state_scope.dart';
import 'campaign_image.dart';

class DonationModal {
  static void show(BuildContext context, Campaign campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DonationSheet(campaign: campaign),
    );
  }
}

class _DonationSheet extends StatefulWidget {
  final Campaign campaign;
  const _DonationSheet({required this.campaign});

  @override
  State<_DonationSheet> createState() => _DonationSheetState();
}

class _DonationSheetState extends State<_DonationSheet> {
  final _quantityController = TextEditingController(text: '5');
  final _noteController = TextEditingController();
  String _selectedMethod = 'Antar Sendiri';
  bool _isSubmitting = false;

  int get _quantity => int.tryParse(_quantityController.text) ?? 0;
  int get _pointsPreview => _quantity * 15;

  void _addQuick(int delta) {
    final current = _quantity;
    final next = (current + delta).clamp(1, 999);
    setState(() {
      _quantityController.text = next.toString();
    });
  }

  void _submitDonation() async {
    final qty = _quantity;
    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap masukkan jumlah donasi yang valid'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      final appState = AppStateScope.of(context);
      final success = appState.donate(
        campaignId: widget.campaign.id,
        quantity: qty,
        method: _selectedMethod,
        note: _noteController.text.trim(),
      );

      setState(() => _isSubmitting = false);
      Navigator.pop(context); // tutup modal

      if (success) {
        _showSuccessDialog(context, qty, _pointsPreview);
      }
    }
  }

  void _showSuccessDialog(BuildContext context, int qty, int points) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFDFBF7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2E7D32).withOpacity(0.12),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 52,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Terima Kasih!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Anda berhasil mendonasikan $qty ${widget.campaign.unit} untuk:\n${widget.campaign.title}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF555555), height: 1.4),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF81C784)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.eco, color: Color(0xFF2E7D32), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '+$points Poin Dampak Diperoleh!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Lanjutkan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: Color(0xFFFBF8F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFBDBDBD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Header
            Row(
              children: [
                CampaignImage(
                  imageUrl: widget.campaign.imageUrl,
                  emoji: widget.campaign.imageEmoji,
                  fallbackColor: widget.campaign.imageColor,
                  width: 52,
                  height: 52,
                  borderRadius: 10,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Formulir Donasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.campaign.title,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757575),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 24),
            // Jumlah donasi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jumlah Barang (${widget.campaign.unit})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+$_pointsPreview poin',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Input jumlah
            Row(
              children: [
                IconButton.filledTonal(
                  onPressed: () => _addQuick(-1),
                  icon: const Icon(Icons.remove, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    onChanged: (v) => setState(() {}),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixText: widget.campaign.unit,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: () => _addQuick(1),
                  icon: const Icon(Icons.add, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Pilihan cepat
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQuickChip('+5'),
                const SizedBox(width: 8),
                _buildQuickChip('+10'),
                const SizedBox(width: 8),
                _buildQuickChip('+25'),
                const SizedBox(width: 8),
                _buildQuickChip('+50'),
              ],
            ),
            const SizedBox(height: 18),
            // Metode Penyaluran
            const Text(
              'Metode Penyaluran',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMethodTile(
                    'Antar Sendiri',
                    'Di titik kumpul terdekat',
                    Icons.store_mall_directory_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMethodTile(
                    'Jemput Kurir',
                    'Penjemputan gratis di rumah',
                    Icons.local_shipping_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Catatan
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Catatan atau pesan untuk penyelenggara (opsional)',
                hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                ),
              ),
            ),
            const SizedBox(height: 22),
            // Tombol Konfirmasi
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitDonation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Konfirmasi Donasi',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      backgroundColor: Colors.white,
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      side: const BorderSide(color: Color(0xFFE0E0E0)),
      onPressed: () {
        final addVal = int.tryParse(label.replaceAll('+', '')) ?? 0;
        _addQuick(addVal);
      },
    );
  }

  Widget _buildMethodTile(String title, String subtitle, IconData icon) {
    final isSelected = _selectedMethod == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = title),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : const Color(0xFFE0E0E0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF2E7D32) : Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
