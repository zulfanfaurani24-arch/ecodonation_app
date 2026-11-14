import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../services/app_state_scope.dart';
import '../widgets/campaign_image.dart';
import '../widgets/donation_modal.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> campaign;

  const DetailScreen({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final String campaignId = campaign['id'] ?? '';

    // Ambil data kampanye live dari appState
    final liveCampaign = appState.campaigns.firstWhere(
      (c) => c.id == campaignId,
      orElse: () => Campaign(
        id: campaignId,
        title: campaign['title'] ?? '',
        organizer: campaign['organizer'] ?? '',
        location: campaign['location'] ?? '',
        description: campaign['description'] ?? '',
        imageUrl: campaign['imageUrl'] ?? '',
        imageEmoji: campaign['imageEmoji'] ?? '🌱',
        imageColor: campaign['imageColor'] as Color? ?? const Color(0xFF81C784),
        progress: campaign['progress'] ?? 0.0,
        currentAmount: 0,
        goalAmount: 1000,
        unit: campaign['unit'] ?? 'barang',
        goal: campaign['goal'] ?? '',
        category: 'Umum',
      ),
    );

    final double progress = liveCampaign.progress;
    final int progressPercent = (progress * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EB),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF2E7D32),
                        size: 26,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Detail Kampanye',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Membagikan tautan "${liveCampaign.title}"! 🔗'),
                          backgroundColor: const Color(0xFF2E7D32),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.share_outlined,
                        color: Color(0xFF2E7D32),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Banner Image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CampaignImage(
                        imageUrl: liveCampaign.imageUrl,
                        emoji: liveCampaign.imageEmoji,
                        fallbackColor: liveCampaign.imageColor,
                        width: double.infinity,
                        height: 220,
                        borderRadius: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Details Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            liveCampaign.title,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Organizer
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.business_outlined, size: 16, color: Color(0xFF2E7D32)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      color: Color(0xFF555555),
                                    ),
                                    children: [
                                      const TextSpan(text: 'Penyelenggara: '),
                                      TextSpan(
                                        text: liveCampaign.organizer,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF212121),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Location
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF2E7D32)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      color: Color(0xFF555555),
                                    ),
                                    children: [
                                      const TextSpan(text: 'Lokasi: '),
                                      TextSpan(
                                        text: liveCampaign.location,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF212121),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Description
                          Text(
                            liveCampaign.description,
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF555555),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Progress Info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$progressPercent% terkumpul',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Target: ${liveCampaign.goal}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              backgroundColor: const Color(0xFFE0E0E0),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Donate Now Button
            Container(
              color: const Color(0xFFF7F4EB),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    DonationModal.show(context, liveCampaign);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Donasi Sekarang',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
