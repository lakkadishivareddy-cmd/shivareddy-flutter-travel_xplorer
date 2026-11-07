import 'destination.dart';

class Activity {
  final String id;
  String title;
  DateTime date;
  String time;
  double cost;
  bool done;

  Activity({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    this.cost = 0,
    this.done = false,
  });
}

class Trip {
  final String id;
  String title;
  Destination destination;
  DateTime start;
  DateTime end;
  double budget;
  int travellers;
  final List<Activity> activities;

  Trip({
    required this.id,
    required this.title,
    required this.destination,
    required this.start,
    required this.end,
    required this.budget,
    required this.travellers,
    List<Activity>? activities,
  }) : activities = activities ?? [];

  /// Number of calendar days (inclusive). Uses UTC to avoid DST off-by-one errors.
  int get days =>
      DateTime.utc(end.year, end.month, end.day)
          .difference(DateTime.utc(start.year, start.month, start.day))
          .inDays +
      1;

  /// The calendar date of day [i] (0-based) of the trip.
  DateTime dayAt(int i) => DateTime(start.year, start.month, start.day + i);

  double get spent => activities.fold(0.0, (sum, a) => sum + a.cost);
  double get remaining => budget - spent;
  double get budgetUsed => budget <= 0 ? 0 : (spent / budget).clamp(0.0, 1.0);
  int get doneCount => activities.where((a) => a.done).length;
  double get progress =>
      activities.isEmpty ? 0 : doneCount / activities.length;

  List<Activity> activitiesOn(DateTime day) {
    final list = activities
        .where((a) =>
            a.date.year == day.year &&
            a.date.month == day.month &&
            a.date.day == day.day)
        .toList();
    list.sort((a, b) => a.time.compareTo(b.time));
    return list;
  }
}
