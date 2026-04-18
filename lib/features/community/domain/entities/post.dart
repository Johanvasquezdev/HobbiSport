import 'package:equatable/equatable.dart';

class Post extends Equatable {
  const Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    this.avatarUrl,
    required this.likesCount,
    required this.commentsCount,
    required this.likedByMe,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String username;
  final String content;
  final String? avatarUrl;
  final int likesCount;
  final int commentsCount;
  final bool likedByMe;
  final DateTime createdAt;

  Post copyWith({
    String? id,
    String? userId,
    String? username,
    String? content,
    String? avatarUrl,
    int? likesCount,
    int? commentsCount,
    bool? likedByMe,
    DateTime? createdAt,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      content: content ?? this.content,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      likedByMe: likedByMe ?? this.likedByMe,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, username, content, avatarUrl, likesCount, commentsCount, likedByMe, createdAt];
}
