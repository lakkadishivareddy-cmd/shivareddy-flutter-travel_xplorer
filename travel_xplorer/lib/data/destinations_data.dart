import 'package:flutter/material.dart';
import '../models/destination.dart';

const List<String> kCategories = [
  'All',
  'Beach',
  'Mountain',
  'City',
  'Heritage',
  'Nature',
];

IconData categoryIcon(String category) {
  switch (category) {
    case 'Beach':
      return Icons.beach_access;
    case 'Mountain':
      return Icons.terrain;
    case 'City':
      return Icons.location_city;
    case 'Heritage':
      return Icons.account_balance;
    case 'Nature':
      return Icons.park;
    default:
      return Icons.explore;
  }
}

const List<Destination> kDestinations = [
  Destination(
    id: 'goa',
    name: 'Goa',
    country: 'India',
    category: 'Beach',
    description:
        'Sun, sand and Portuguese-era charm. Goa mixes lively beach shacks, quiet southern coves, spice plantations and old churches.',
    rating: 4.6,
    pricePerDay: 3500,
    bestTime: 'Nov - Feb',
    icon: Icons.beach_access,
    colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
    highlights: ['Baga Beach', 'Fort Aguada', 'Basilica of Bom Jesus', 'Dudhsagar Falls', 'Palolem Beach'],
  ),
  Destination(
    id: 'jaipur',
    name: 'Jaipur',
    country: 'India',
    category: 'Heritage',
    description:
        'The Pink City is famous for majestic forts, palaces and bustling bazaars full of textiles, jewellery and handicrafts.',
    rating: 4.5,
    pricePerDay: 3000,
    bestTime: 'Oct - Mar',
    icon: Icons.account_balance,
    colors: [Color(0xFFF2709C), Color(0xFFFF9472)],
    highlights: ['Amber Fort', 'Hawa Mahal', 'City Palace', 'Jantar Mantar', 'Johari Bazaar'],
  ),
  Destination(
    id: 'munnar',
    name: 'Munnar',
    country: 'India',
    category: 'Nature',
    description:
        'Rolling tea estates, misty hills and waterfalls in the Western Ghats of Kerala. Perfect for slow, scenic travel.',
    rating: 4.7,
    pricePerDay: 2800,
    bestTime: 'Sep - May',
    icon: Icons.park,
    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    highlights: ['Tea Museum', 'Eravikulam National Park', 'Mattupetty Dam', 'Top Station'],
  ),
  Destination(
    id: 'manali',
    name: 'Manali',
    country: 'India',
    category: 'Mountain',
    description:
        'A Himalayan hill station with snow-capped views, adventure sports, cafes and the gateway to Solang Valley and Rohtang Pass.',
    rating: 4.4,
    pricePerDay: 3200,
    bestTime: 'Mar - Jun',
    icon: Icons.terrain,
    colors: [Color(0xFF536976), Color(0xFF292E49)],
    highlights: ['Solang Valley', 'Hadimba Temple', 'Rohtang Pass', 'Old Manali', 'Jogini Falls'],
  ),
  Destination(
    id: 'bali',
    name: 'Bali',
    country: 'Indonesia',
    category: 'Beach',
    description:
        'The Island of Gods blends surf beaches, rice terraces, temples and a vibrant wellness and cafe culture.',
    rating: 4.8,
    pricePerDay: 6500,
    bestTime: 'Apr - Oct',
    icon: Icons.surfing,
    colors: [Color(0xFFFF8008), Color(0xFFFFC837)],
    highlights: ['Uluwatu Temple', 'Tegallalang Rice Terraces', 'Ubud Monkey Forest', 'Seminyak Beach'],
  ),
  Destination(
    id: 'paris',
    name: 'Paris',
    country: 'France',
    category: 'City',
    description:
        'The city of light: world-class museums, cafe terraces, riverside walks and the iconic Eiffel Tower.',
    rating: 4.7,
    pricePerDay: 14000,
    bestTime: 'Apr - Jun',
    icon: Icons.location_city,
    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    highlights: ['Eiffel Tower', 'Louvre Museum', 'Montmartre', 'Seine River Cruise', 'Notre-Dame'],
  ),
  Destination(
    id: 'tokyo',
    name: 'Tokyo',
    country: 'Japan',
    category: 'City',
    description:
        'A neon-lit metropolis where ancient shrines sit beside futuristic skyscrapers, with some of the best food on earth.',
    rating: 4.9,
    pricePerDay: 12000,
    bestTime: 'Mar - May',
    icon: Icons.temple_buddhist,
    colors: [Color(0xFFEB3349), Color(0xFFF45C43)],
    highlights: ['Senso-ji Temple', 'Shibuya Crossing', 'Meiji Shrine', 'Tsukiji Outer Market'],
  ),
  Destination(
    id: 'santorini',
    name: 'Santorini',
    country: 'Greece',
    category: 'Beach',
    description:
        'Whitewashed villages perched on volcanic cliffs, deep blue domes and some of the world\'s best sunsets.',
    rating: 4.8,
    pricePerDay: 13000,
    bestTime: 'May - Sep',
    icon: Icons.wb_twilight,
    colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
    highlights: ['Oia Sunset', 'Red Beach', 'Fira Town', 'Akrotiri Ruins'],
  ),
  Destination(
    id: 'rome',
    name: 'Rome',
    country: 'Italy',
    category: 'Heritage',
    description:
        'Walk through 3,000 years of history: the Colosseum, Roman Forum, Vatican City and countless piazzas.',
    rating: 4.6,
    pricePerDay: 11000,
    bestTime: 'Apr - Jun',
    icon: Icons.museum,
    colors: [Color(0xFFB79891), Color(0xFF94716B)],
    highlights: ['Colosseum', 'Vatican Museums', 'Trevi Fountain', 'Roman Forum'],
  ),
  Destination(
    id: 'swiss-alps',
    name: 'Swiss Alps',
    country: 'Switzerland',
    category: 'Mountain',
    description:
        'Cog railways, glaciers, alpine lakes and postcard villages. Ideal for hiking in summer and skiing in winter.',
    rating: 4.9,
    pricePerDay: 18000,
    bestTime: 'Jun - Sep',
    icon: Icons.downhill_skiing,
    colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
    highlights: ['Jungfraujoch', 'Interlaken', 'Lake Lucerne', 'Zermatt'],
  ),
];
