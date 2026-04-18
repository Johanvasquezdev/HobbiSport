import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/hobby.dart';

class HobbyModel extends Hobby {
  const HobbyModel({
    required super.id,
    required super.name,
    required super.category,
    required super.description,
    required super.emoji,
    required super.userId,
    required super.createdAt,
    super.updatedAt,
  });

  factory HobbyModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return HobbyModel(
      id: doc.id,
      name: data['name'] as String,
      category: data['category'] as String,
      description: data['description'] as String,
      emoji: data['emoji'] as String? ?? '??',
      userId: data['userId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'category': category,
        'description': description,
        'emoji': emoji,
        'userId': userId,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      };

  factory HobbyModel.fromJson(Map<String, dynamic> json) => HobbyModel(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        description: json['description'] as String,
        emoji: json['emoji'] as String? ?? '??',
        userId: json['userId'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'emoji': emoji,
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  factory HobbyModel.fromEntity(Hobby entity) => HobbyModel(
        id: entity.id,
        name: entity.name,
        category: entity.category,
        description: entity.description,
        emoji: entity.emoji,
        userId: entity.userId,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  Hobby toEntity() => Hobby(
        id: id,
        name: name,
        category: category,
        description: description,
        emoji: emoji,
        userId: userId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
