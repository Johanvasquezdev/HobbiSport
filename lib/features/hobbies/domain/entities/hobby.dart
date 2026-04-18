import 'package:equatable/equatable.dart';

class Hobby extends Equatable {
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

  final String id;
  final String name;
  final String category;
  final String description;
  final String emoji;
  final String userId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Hobby copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? emoji,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Hobby(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, category, description, emoji, userId, createdAt, updatedAt];
}
