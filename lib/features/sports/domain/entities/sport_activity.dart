import 'package:equatable/equatable.dart';

enum SportType { running, swimming, football, cycling, gym, basketball, other }

class SportActivity extends Equatable {
  const SportActivity({
    required this.id,
    required this.sportType,
    required this.date,
    required this.durationMinutes,
    this.distanceKm,
    this.caloriesBurned,
    this.notes,
    required this.createdAt,
  });

  final String id;
  final SportType sportType;
  final DateTime date;
  final int durationMinutes;
  final double? distanceKm;
  final int? caloriesBurned;
  final String? notes;
  final DateTime createdAt;

  double? get averagePace =>
      (distanceKm != null && durationMinutes > 0) ? distanceKm! / (durationMinutes / 60) : null;

  SportActivity copyWith({
    String? id,
    SportType? sportType,
    DateTime? date,
    int? durationMinutes,
    double? distanceKm,
    int? caloriesBurned,
    String? notes,
    DateTime? createdAt,
  }) {
    return SportActivity(
      id: id ?? this.id,
      sportType: sportType ?? this.sportType,
      date: date ?? this.date,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      distanceKm: distanceKm ?? this.distanceKm,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sportType,
        date,
        durationMinutes,
        distanceKm,
        caloriesBurned,
        notes,
        createdAt,
      ];
}
