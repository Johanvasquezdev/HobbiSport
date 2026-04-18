import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/exceptions.dart';
import '../models/post_model.dart';

abstract class PostRemoteDatasource {
  Future<List<PostModel>> fetchPosts(String currentUserId);
  Future<void> createPost(PostModel model);
  Future<void> deletePost(String postId);
  Future<PostModel> toggleLike(String postId, String currentUserId);
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  PostRemoteDatasourceImpl(this.firestore);

  final FirebaseFirestore firestore;
  static const _collection = 'posts';

  CollectionReference<Map<String, dynamic>> get _posts =>
      firestore.collection(_collection);

  @override
  Future<List<PostModel>> fetchPosts(String currentUserId) async {
    try {
      final snap = await _posts.orderBy('createdAt', descending: true).get();

      return snap.docs
          .map((doc) => PostModel.fromFirestore(doc, currentUserId))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch posts');
    }
  }

  @override
  Future<void> createPost(PostModel model) async {
    try {
      await _posts.doc(model.id).set(model.toFirestore());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to create post');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await _posts.doc(postId).delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete post');
    }
  }

  @override
  Future<PostModel> toggleLike(String postId, String currentUserId) async {
    try {
      final postRef = _posts.doc(postId);

      return await firestore.runTransaction((transaction) async {
        final snap = await transaction.get(postRef);
        if (!snap.exists || snap.data() == null) {
          throw const NotFoundException('Post not found');
        }

        final data = snap.data()!;
        final likedBy = (data['likedBy'] as List<dynamic>? ?? const <dynamic>[])
            .map((item) => item.toString())
            .toSet();
        final likesCount = (data['likesCount'] as num?)?.toInt() ?? 0;

        final isLiked = likedBy.contains(currentUserId);
        if (isLiked) {
          likedBy.remove(currentUserId);
        } else {
          likedBy.add(currentUserId);
        }

        transaction.update(postRef, {
          'likedBy': likedBy.toList(),
          'likesCount': isLiked ? (likesCount - 1).clamp(0, 1 << 30) : likesCount + 1,
        });

        return PostModel(
          id: snap.id,
          userId: data['userId'] as String,
          username: data['username'] as String,
          content: data['content'] as String,
          avatarUrl: data['avatarUrl'] as String?,
          likesCount: isLiked
              ? (likesCount - 1).clamp(0, 1 << 30)
              : likesCount + 1,
          commentsCount: (data['commentsCount'] as num?)?.toInt() ?? 0,
          likedByMe: !isLiked,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
      });
    } on NotFoundException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to toggle like');
    }
  }
}
