import 'package:flutter/material.dart';
import '../services/app_state_scope.dart';
import '../widgets/donation_modal.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  int _selectedPinIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final allPoints = appState.dropOffPoints;

    final filteredPoints = allPoints.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.address.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Semua' ||
          p.acceptedCategories.contains(_selectedCategory);
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EB),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    'Peta Donasi',
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
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.near_me, size: 14, color: Color(0xFF2E7D32)),
                        SizedBox(width: 4),
                        Text(
                          'Jakarta Pusat',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Cari titik kumpul atau alamat...',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF9E9E9E), size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _categoryChip('Semua'),
                  const SizedBox(width: 8),
                  _categoryChip('Plastik'),
                  const SizedBox(width: 8),
                  _categoryChip('Buku'),
                  const SizedBox(width: 8),
                  _categoryChip('Pakaian'),
                  const SizedBox(width: 8),
                  _categoryChip('Elektronik'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Stylized Visual Map
            Container(
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFDCEAD8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Grid background
                    CustomPaint(
                      size: const Size(double.infinity, 180),
                      painter: _MapGridPainter(),
                    ),
                    // Simulated pins
                    Positioned(
                      top: 40,
                      left: 60,
                      child: _buildMapPin(0, 'Perpus', Icons.local_library),
                    ),
                    Positioned(
                      top: 70,
                      right: 70,
                      child: _buildMapPin(1, 'Balai Kota', Icons.location_city),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 110,
                      child: _buildMapPin(2, 'Sekolah', Icons.school),
                    ),
                    Positioned(
                      bottom: 40,
                      right: 90,
                      child: _buildMapPin(3, 'Mall', Icons.shopping_bag),
                    ),
                    // Current location dot
                    Positioned(
                      top: 85,
                      left: 180,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1976D2),
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Legend
                    Positioned(
                      bottom: 8,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '📍 4 Titik Kumpul Aktif',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Nearest Points List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Titik Kumpul Terdekat',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  Text(
                    '${filteredPoints.length} lokasi',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Points List
            Expanded(
              child: filteredPoints.isEmpty
                  ? const Center(child: Text('Tidak ada titik kumpul dalam kategori ini'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      itemCount: filteredPoints.length,
                      itemBuilder: (context, index) {
                        final point = filteredPoints[index];
                        final isSelected = _selectedPinIndex == index;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Color(0xFF2E7D32),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          point.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF212121),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          point.address,
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      point.distance,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Hours & Categories
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    point.openingHours,
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF616161)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: point.acceptedCategories
                                    .map(
                                      (cat) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F8E9),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          cat,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF2E7D32),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 10),
                              // Action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Memulai rute ke ${point.name} (${point.distance}) 🚗'),
                                            backgroundColor: const Color(0xFF2E7D32),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.directions, size: 16),
                                      label: const Text('Petunjuk Arah', style: TextStyle(fontSize: 12)),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF2E7D32),
                                        side: const BorderSide(color: Color(0xFF2E7D32)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        final matchedCampaign = appState.campaigns.first;
                                        DonationModal.show(context, matchedCampaign);
                                      },
                                      icon: const Icon(Icons.volunteer_activism, size: 16),
                                      label: const Text('Donasi di Sini', style: TextStyle(fontSize: 12)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2E7D32),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

  Widget _buildMapPin(int index, String label, IconData icon) {
    final isSelected = _selectedPinIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPinIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF2E7D32) : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
              border: Border.all(color: const Color(0xFF2E7D32), width: 2),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4),
              ],
            ),
            child: Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return ChoiceChip(
      label: Text(
        label,
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
        if (val) setState(() => _selectedCategory = label);
      },
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Jalan
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final roadPath = Path();
    roadPath.moveTo(0, size.height * 0.45);
    roadPath.quadraticBezierTo(size.width * 0.4, size.height * 0.35, size.width, size.height * 0.6);
    canvas.drawPath(roadPath, roadPaint);

    final roadPath2 = Path();
    roadPath2.moveTo(size.width * 0.5, 0);
    roadPath2.quadraticBezierTo(size.width * 0.55, size.height * 0.5, size.width * 0.4, size.height);
    canvas.drawPath(roadPath2, roadPaint);

    // Sungai
    final waterPaint = Paint()
      ..color = const Color(0xFF90CAF9).withOpacity(0.5)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final riverPath = Path();
    riverPath.moveTo(0, size.height * 0.85);
    riverPath.quadraticBezierTo(size.width * 0.5, size.height * 0.7, size.width, size.height * 0.88);
    canvas.drawPath(riverPath, waterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
