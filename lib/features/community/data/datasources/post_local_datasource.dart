import 'package:sqflite/sqflite.dart';

import '../../../../core/error/exceptions.dart';
import '../models/post_model.dart';

abstract class PostLocalDatasource {
  Future<List<PostModel>> getCachedPosts();
  Future<void> cachePosts(List<PostModel> posts);
  Future<void> upsertPost(PostModel post);
  Future<void> deletePost(String id);
}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  PostLocalDatasourceImpl(this.database);

  final Database database;

  static const _table = 'posts';

  @override
  Future<List<PostModel>> getCachedPosts() async {
    try {
      final rows = await database.query(_table, orderBy: 'createdAt DESC');
      return rows.map(PostModel.fromJson).toList();
    } catch (e) {
      throw CacheException('Failed to get cached posts: $e');
    }
  }

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    try {
      final batch = database.batch();
      for (final post in posts) {
        batch.insert(_table, post.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw CacheException('Failed to cache posts: $e');
    }
  }

  @override
  Future<void> deletePost(String id) async {
    try {
      await database.delete(_table, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw CacheException('Failed to delete cached post: $e');
    }
  }

  @override
  Future<void> upsertPost(PostModel post) async {
    try {
      await database.insert(_table, post.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw CacheException('Failed to upsert cached post: $e');
    }
  }
}

class InMemoryPostLocalDatasource implements PostLocalDatasource {
  final Map<String, PostModel> _cache = <String, PostModel>{};

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    for (final post in posts) {
      _cache[post.id] = post;
    }
  }

  @override
  Future<void> deletePost(String id) async {
    _cache.remove(id);
  }

  @override
  Future<List<PostModel>> getCachedPosts() async {
    final posts = _cache.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return posts;
  }

  @override
  Future<void> upsertPost(PostModel post) async {
    _cache[post.id] = post;
  }
}
