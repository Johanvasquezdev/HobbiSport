// lib/features/sports/data/models/sport_activity_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/sport_activity.dart';

class SportActivityModel extends SportActivity {
  const SportActivityModel({
    required super.id,
    required super.sportType,
    required super.date,
    required super.durationMinutes,
    super.distanceKm,
    super.caloriesBurned,
    super.notes,
    required super.createdAt,
  });

  // ─── Firebase Firestore ──────────────────────────────────
  factory SportActivityModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return SportActivityModel(
      id: doc.id,
      sportType: SportType.values.firstWhere(
        (t) => t.name == d['sportType'],
        orElse: () => SportType.other,
      ),
      date: (d['date'] as Timestamp).toDate(),
      durationMinutes: (d['durationMinutes'] as num).toInt(),
      distanceKm: (d['distanceKm'] as num?)?.toDouble(),
      caloriesBurned: (d['caloriesBurned'] as num?)?.toInt(),
      notes: d['notes'] as String?,
      createdAt: (d['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'sportType': sportType.name,
        'date': Timestamp.fromDate(date),
        'durationMinutes': durationMinutes,
        'distanceKm': distanceKm,
        'caloriesBurned': caloriesBurned,
        'notes': notes,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  // ─── JSON (local cache / REST fallback) ──────────────────
  factory SportActivityModel.fromJson(Map<String, dynamic> json) =>
      SportActivityModel(
        id: json['id'] as String,
        sportType: SportType.values.firstWhere(
          (t) => t.name == json['sportType'],
          orElse: () => SportType.other,
        ),
        date: DateTime.parse(json['date'] as String),
        durationMinutes: (json['durationMinutes'] as num).toInt(),
        distanceKm: (json['distanceKm'] as num?)?.toDouble(),
        caloriesBurned: (json['caloriesBurned'] as num?)?.toInt(),
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sportType': sportType.name,
        'date': date.toIso8601String(),
        'durationMinutes': durationMinutes,
        'distanceKm': distanceKm,
        'caloriesBurned': caloriesBurned,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  // ─── Entity mappers ──────────────────────────────────────
  factory SportActivityModel.fromEntity(SportActivity entity) =>
      SportActivityModel(
        id: entity.id,
        sportType: entity.sportType,
        date: entity.date,
        durationMinutes: entity.durationMinutes,
        distanceKm: entity.distanceKm,
        caloriesBurned: entity.caloriesBurned,
        notes: entity.notes,
        createdAt: entity.createdAt,
      );

  SportActivity toEntity() => SportActivity(
        id: id,
        sportType: sportType,
        date: date,
        durationMinutes: durationMinutes,
        distanceKm: distanceKm,
        caloriesBurned: caloriesBurned,
        notes: notes,
        createdAt: createdAt,
      );
}
