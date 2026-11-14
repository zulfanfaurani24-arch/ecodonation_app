import 'package:flutter/material.dart';

class CampaignImage extends StatelessWidget {
  final String? imageUrl;
  final String emoji;
  final Color fallbackColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  const CampaignImage({
    super.key,
    this.imageUrl,
    required this.emoji,
    required this.fallbackColor,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: fallbackColor.withOpacity(0.2),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                width: width,
                height: height,
                fit: fit,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildFallback(isPlaceholder: true);
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallback();
                },
              )
            : _buildFallback(),
      ),
    );
  }

  Widget _buildFallback({bool isPlaceholder = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            fallbackColor.withOpacity(0.4),
            fallbackColor.withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: (height != null ? height! * 0.45 : 32)),
        ),
      ),
    );
  }
}
