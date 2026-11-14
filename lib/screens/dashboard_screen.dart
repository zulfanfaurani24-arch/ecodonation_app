import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../widgets/campaign_card.dart';
import '../widgets/eco_logo_widget.dart';
import '../widgets/donation_modal.dart';
import '../services/app_state_scope.dart';
import 'profile_screen.dart';
import 'history_screen.dart';
import 'map_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildHomeTab(List<Campaign> campaigns) {
    final filtered = campaigns.where((c) {
      final matchesSearch = c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.organizer.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Semua' || c.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Column(
      children: [
        // App Bar Area
        Container(
          color: const Color(0xFFF7F4EB),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          child: Row(
            children: [
              const EcoLogoWidget(size: 38),
              const SizedBox(width: 10),
              const Text(
                'EcoDonation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _currentIndex = 3),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2E7D32).withOpacity(0.12),
                    border: Border.all(color: const Color(0xFF2E7D32), width: 1.5),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF2E7D32),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Search Bar
        Container(
          color: const Color(0xFFF7F4EB),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Cari kampanye donasi...',
              hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13.5),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF9E9E9E), size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
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
                borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
              ),
            ),
          ),
        ),
        // Category Pills
        Container(
          color: const Color(0xFFF7F4EB),
          padding: const EdgeInsets.only(bottom: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildCategoryPill('Semua'),
                const SizedBox(width: 8),
                _buildCategoryPill('Plastik'),
                const SizedBox(width: 8),
                _buildCategoryPill('Buku'),
                const SizedBox(width: 8),
                _buildCategoryPill('Pakaian'),
                const SizedBox(width: 8),
                _buildCategoryPill('Elektronik'),
              ],
            ),
          ),
        ),
        // Campaign List
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 54, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      const Text(
                        'Kampanye tidak ditemukan',
                        style: TextStyle(color: Color(0xFF757575), fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Coba kata kunci atau filter kategori lain',
                        style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final campaign = filtered[index];
                    return CampaignCard(
                      campaign: campaign,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: {
                            'id': campaign.id,
                            'title': campaign.title,
                            'organizer': campaign.organizer,
                            'location': campaign.location,
                            'description': campaign.description,
                            'imageUrl': campaign.imageUrl,
                            'imageEmoji': campaign.imageEmoji,
                            'imageColor': campaign.imageColor,
                            'progress': campaign.progress,
                            'goal': campaign.goal,
                            'unit': campaign.unit,
                          },
                        );
                      },
                      onDonate: () {
                        DonationModal.show(context, campaign);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryPill(String title) {
    final isSelected = _selectedCategory == title;
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
        if (val) setState(() => _selectedCategory = title);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    final tabs = [
      _buildHomeTab(appState.campaigns),
      const HistoryScreen(),
      const MapScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EB),
      body: SafeArea(child: tabs[_currentIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2E7D32),
          unselectedItemColor: const Color(0xFF9E9E9E),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Peta',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
