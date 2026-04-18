import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
  Future<Either<Failure, void>> createPost(Post post);
  Future<Either<Failure, void>> deletePost(String postId);
  Future<Either<Failure, Post>> toggleLike(String postId);
}
