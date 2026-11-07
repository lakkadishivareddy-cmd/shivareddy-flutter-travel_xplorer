import 'package:flutter/material.dart';

class Destination {
  final String id;
  final String name;
  final String country;
  final String category;
  final String description;
  final double rating;
  final int pricePerDay; // per person, in INR
  final String bestTime;
  final IconData icon;
  final List<Color> colors;
  final List<String> highlights;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.category,
    required this.description,
    required this.rating,
    required this.pricePerDay,
    required this.bestTime,
    required this.icon,
    required this.colors,
    required this.highlights,
  });

  LinearGradient get gradient => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

/// Arguments passed to the destination details route.
class DestinationArgs {
  final Destination destination;
  final String heroTag;
  const DestinationArgs(this.destination, this.heroTag);
}
