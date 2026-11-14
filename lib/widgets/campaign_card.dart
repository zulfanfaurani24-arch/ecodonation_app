import 'package:flutter/material.dart';
import '../models/campaign.dart';
import 'campaign_image.dart';

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback onTap;
  final VoidCallback onDonate;

  const CampaignCard({
    super.key,
    required this.campaign,
    required this.onTap,
    required this.onDonate,
  });

  @override
  Widget build(BuildContext context) {
    final int progressPercent = (campaign.progress * 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campaign Image
                    CampaignImage(
                      imageUrl: campaign.imageUrl,
                      emoji: campaign.imageEmoji,
                      fallbackColor: campaign.imageColor,
                      width: 80,
                      height: 80,
                      borderRadius: 12,
                    ),
                    const SizedBox(width: 12),
                    // Title, Progress & Goal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            campaign.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          // Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: campaign.progress,
                              minHeight: 7,
                              backgroundColor: const Color(0xFFE0E0E0),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$progressPercent%',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Target: ${campaign.goal}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Donate Now Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onDonate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Donasi Sekarang',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
