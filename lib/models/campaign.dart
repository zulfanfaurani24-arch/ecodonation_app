import 'package:flutter/material.dart';

class Campaign {
  final String id;
  final String title;
  final String organizer;
  final String location;
  final String description;
  final String imageUrl;
  final String imageEmoji;
  final Color imageColor;
  final double progress; // 0.0 to 1.0
  final double currentAmount;
  final double goalAmount;
  final String unit;
  final String goal;
  final String category;

  const Campaign({
    required this.id,
    required this.title,
    required this.organizer,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.imageEmoji,
    required this.imageColor,
    required this.progress,
    required this.currentAmount,
    required this.goalAmount,
    required this.unit,
    required this.goal,
    required this.category,
  });

  Campaign copyWith({
    String? id,
    String? title,
    String? organizer,
    String? location,
    String? description,
    String? imageUrl,
    String? imageEmoji,
    Color? imageColor,
    double? progress,
    double? currentAmount,
    double? goalAmount,
    String? unit,
    String? goal,
    String? category,
  }) {
    return Campaign(
      id: id ?? this.id,
      title: title ?? this.title,
      organizer: organizer ?? this.organizer,
      location: location ?? this.location,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      imageEmoji: imageEmoji ?? this.imageEmoji,
      imageColor: imageColor ?? this.imageColor,
      progress: progress ?? this.progress,
      currentAmount: currentAmount ?? this.currentAmount,
      goalAmount: goalAmount ?? this.goalAmount,
      unit: unit ?? this.unit,
      goal: goal ?? this.goal,
      category: category ?? this.category,
    );
  }
}
