import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({super.key, required this.experience});

  final Experience experience;

  String _formatPeriod() {
    final start = [
      experience.startMonth,
      experience.startYear,
    ].where((part) => part.trim().isNotEmpty).join(' ');
    final end = [
      experience.endMonth,
      experience.endYear,
    ].where((part) => part.trim().isNotEmpty).join(' ');

    if (start.isEmpty && end.isEmpty) return '';
    if (end.isEmpty) return '$start - Present';
    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    final hasThumbnail = experience.thumbnail.trim().isNotEmpty;
    final period = _formatPeriod();

    return Scaffold(
      appBar: AppBar(title: Text(experience.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasThumbnail) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  experience.thumbnail.trim(),
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (experience.category.trim().isNotEmpty)
              Chip(label: Text(experience.category)),
            if (period.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(period, style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 16),
            Text(
              experience.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
