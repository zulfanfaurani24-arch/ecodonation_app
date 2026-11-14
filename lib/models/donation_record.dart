import 'package:flutter/material.dart';

class DonationRecord {
  final String id;
  final String campaignId;
  final String title;
  final String dateText;
  final DateTime timestamp;
  final int quantity;
  final String unit;
  final int impactPoints;
  final String emoji;
  final String? imageUrl;
  final Color color;
  final String status; // 'Completed', 'Processing', 'Verified'
  final String pickupMethod; // 'Drop-off', 'Courier Pickup'

  const DonationRecord({
    required this.id,
    required this.campaignId,
    required this.title,
    required this.dateText,
    required this.timestamp,
    required this.quantity,
    required this.unit,
    required this.impactPoints,
    required this.emoji,
    this.imageUrl,
    required this.color,
    this.status = 'Completed',
    this.pickupMethod = 'Drop-off',
  });
}
