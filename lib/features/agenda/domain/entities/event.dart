import 'package:equatable/equatable.dart';

enum EventCategory { sport, hobby, community, personal, other }

class Event extends Equatable {
  const Event({
    required this.id,
    required this.title,
    this.description,
    required this.dateTime,
    this.location,
    required this.category,
    required this.colorHex,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String? description;
  final DateTime dateTime;
  final String? location;
  final EventCategory category;
  final String colorHex;
  final DateTime createdAt;

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? location,
    EventCategory? category,
    String? colorHex,
    DateTime? createdAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      category: category ?? this.category,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, description, dateTime, location, category, colorHex, createdAt];
}
