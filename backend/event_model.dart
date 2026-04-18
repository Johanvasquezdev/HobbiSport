// lib/features/agenda/data/models/event_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.title,
    super.description,
    required super.dateTime,
    super.location,
    required super.category,
    required super.colorHex,
    required super.createdAt,
  });

  // ─── Firebase ────────────────────────────────────────────
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: d['title'] as String,
      description: d['description'] as String?,
      dateTime: (d['dateTime'] as Timestamp).toDate(),
      location: d['location'] as String?,
      category: EventCategory.values.firstWhere(
        (e) => e.name == d['category'],
        orElse: () => EventCategory.other,
      ),
      colorHex: d['colorHex'] as String? ?? '#7C3AED',
      createdAt: (d['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'dateTime': Timestamp.fromDate(dateTime),
        'location': location,
        'category': category.name,
        'colorHex': colorHex,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  // ─── JSON ────────────────────────────────────────────────
  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        dateTime: DateTime.parse(json['dateTime'] as String),
        location: json['location'] as String?,
        category: EventCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => EventCategory.other,
        ),
        colorHex: json['colorHex'] as String? ?? '#7C3AED',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dateTime': dateTime.toIso8601String(),
        'location': location,
        'category': category.name,
        'colorHex': colorHex,
        'createdAt': createdAt.toIso8601String(),
      };

  factory EventModel.fromEntity(Event e) => EventModel(
        id: e.id,
        title: e.title,
        description: e.description,
        dateTime: e.dateTime,
        location: e.location,
        category: e.category,
        colorHex: e.colorHex,
        createdAt: e.createdAt,
      );

  Event toEntity() => Event(
        id: id,
        title: title,
        description: description,
        dateTime: dateTime,
        location: location,
        category: category,
        colorHex: colorHex,
        createdAt: createdAt,
      );
}
