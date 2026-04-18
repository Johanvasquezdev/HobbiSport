// lib/features/hobbies/domain/entities/hobby.dart

import 'package:equatable/equatable.dart';

/// Pure domain entity.
/// No Flutter imports. No serialization. No Firebase.
/// This is what the rest of the app thinks a Hobby IS.
class Hobby extends Equatable {
  final String id;
  final String name;
  final String category;
  final String description;
  final String emoji;
  final String userId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Hobby({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.emoji,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
  });

  Hobby copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? emoji,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Hobby(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        description: description ?? this.description,
        emoji: emoji ?? this.emoji,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        description,
        emoji,
        userId,
        createdAt,
        updatedAt,
      ];
}
