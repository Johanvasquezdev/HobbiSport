import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_local_datasource.dart';
import '../datasources/post_remote_datasource.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({
    required this.remote,
    required this.local,
    required this.auth,
  });

  final PostRemoteDatasource remote;
  final PostLocalDatasource local;
  final AuthService auth;

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      final userId = await auth.ensureUserId();
      final remotePosts = await remote.fetchPosts(userId);
      await local.cachePosts(remotePosts);
      return Right(remotePosts.map((post) => post.toEntity()).toList());
    } on ServerException catch (e) {
      final cached = await local.getCachedPosts();
      if (cached.isNotEmpty) {
        return Right(cached.map((post) => post.toEntity()).toList());
      }
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createPost(Post post) async {
    try {
      final model = PostModel.fromEntity(post);
      await remote.createPost(model);
      await local.upsertPost(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await remote.deletePost(postId);
      await local.deletePost(postId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Post>> toggleLike(String postId) async {
    try {
      final currentUserId = await auth.ensureUserId();
      final updated = await remote.toggleLike(postId, currentUserId);
      await local.upsertPost(updated);
      return Right(updated.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}
