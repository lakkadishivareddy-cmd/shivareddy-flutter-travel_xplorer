import 'package:flutter/material.dart';

import '../data/destinations_data.dart';
import '../models/destination.dart';
import '../models/trip.dart';

/// Holds trips, favourites and explore filters. Widgets listen via Provider.
class TripProvider extends ChangeNotifier {
  final List<Trip> _trips = [];
  final Set<String> _favorites = {};
  String _query = '';
  String _category = 'All';
  int _idCounter = 0;

  TripProvider() {
    _seed();
  }

  // ---------- getters ----------
  List<Trip> get trips => List.unmodifiable(_trips);
  String get query => _query;
  String get category => _category;
  Set<String> get favoriteIds => _favorites;

  List<Destination> get filteredDestinations {
    final q = _query.toLowerCase();
    return kDestinations.where((d) {
      final matchesCategory = _category == 'All' || d.category == _category;
      final matchesQuery = q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.country.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  List<Destination> get favoriteDestinations =>
      kDestinations.where((d) => _favorites.contains(d.id)).toList();

  bool isFavorite(String id) => _favorites.contains(id);

  Trip? tripById(String id) {
    for (final t in _trips) {
      if (t.id == id) return t;
    }
    return null;
  }

  double get totalBudget => _trips.fold(0.0, (s, t) => s + t.budget);
  int get countryCount => _trips.map((t) => t.destination.country).toSet().length;

  // ---------- explore filters ----------
  void setQuery(String value) {
    _query = value.trim();
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  // ---------- favourites ----------
  void toggleFavorite(String id) {
    if (!_favorites.add(id)) _favorites.remove(id);
    notifyListeners();
  }

  // ---------- trips ----------
  String _newId() => '${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';

  /// Creates a trip and returns its id. Optionally pre-fills the itinerary
  /// with the destination's highlights.
  String addTrip({
    required String title,
    required Destination destination,
    required DateTime start,
    required DateTime end,
    required double budget,
    required int travellers,
    bool suggestActivities = false,
  }) {
    final trip = Trip(
      id: _newId(),
      title: title,
      destination: destination,
      start: start,
      end: end,
      budget: budget,
      travellers: travellers,
    );
    if (suggestActivities) {
      for (var i = 0; i < destination.highlights.length; i++) {
        final dayOffset = i % trip.days;
        trip.activities.add(Activity(
          id: _newId(),
          title: 'Visit ${destination.highlights[i]}',
          date: trip.dayAt(dayOffset),
          time: '10:00',
        ));
      }
    }
    _trips.insert(0, trip);
    notifyListeners();
    return trip.id;
  }

  void removeTrip(String id) {
    _trips.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void addActivity(
    String tripId, {
    required String title,
    required DateTime date,
    required String time,
    required double cost,
  }) {
    final trip = tripById(tripId);
    if (trip == null) return;
    trip.activities.add(
      Activity(id: _newId(), title: title, date: date, time: time, cost: cost),
    );
    notifyListeners();
  }

  void toggleActivity(String tripId, String activityId) {
    final trip = tripById(tripId);
    if (trip == null) return;
    for (final a in trip.activities) {
      if (a.id == activityId) a.done = !a.done;
    }
    notifyListeners();
  }

  void removeActivity(String tripId, String activityId) {
    final trip = tripById(tripId);
    if (trip == null) return;
    trip.activities.removeWhere((a) => a.id == activityId);
    notifyListeners();
  }

  // ---------- sample data ----------
  void _seed() {
    final goa = kDestinations.firstWhere((d) => d.id == 'goa');
    final start = DateTime.now().add(const Duration(days: 20));
    final trip = Trip(
      id: _newId(),
      title: 'Goa with friends',
      destination: goa,
      start: DateTime(start.year, start.month, start.day),
      end: DateTime(start.year, start.month, start.day + 3),
      budget: 40000,
      travellers: 4,
    );
    trip.activities.addAll([
      Activity(id: _newId(), title: 'Check in to beach hostel', date: trip.start, time: '12:00', cost: 6000),
      Activity(id: _newId(), title: 'Sunset at Baga Beach', date: trip.start, time: '17:30'),
      Activity(id: _newId(), title: 'Scooter ride to Fort Aguada', date: trip.dayAt(1), time: '10:00', cost: 1500),
      Activity(id: _newId(), title: 'Dinner at a beach shack', date: trip.dayAt(1), time: '20:00', cost: 3200),
    ]);
    _trips.add(trip);
    _favorites.addAll(['bali', 'tokyo']);
  }
}
