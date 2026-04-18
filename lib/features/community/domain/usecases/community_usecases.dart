import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPosts implements UseCase<List<Post>, NoParams> {
  GetPosts(this.repository);

  final PostRepository repository;

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) => repository.getPosts();
}

class CreatePostParams {
  const CreatePostParams({
    required this.userId,
    required this.username,
    required this.content,
    this.avatarUrl,
  });

  final String userId;
  final String username;
  final String content;
  final String? avatarUrl;
}

class CreatePost implements UseCase<void, CreatePostParams> {
  CreatePost(this.repository, this._uuid);

  final PostRepository repository;
  final Uuid _uuid;

  @override
  Future<Either<Failure, void>> call(CreatePostParams params) {
    final post = Post(
      id: _uuid.v4(),
      userId: params.userId,
      username: params.username,
      content: params.content,
      avatarUrl: params.avatarUrl,
      likesCount: 0,
      commentsCount: 0,
      likedByMe: false,
      createdAt: DateTime.now(),
    );
    return repository.createPost(post);
  }
}

class DeletePost implements UseCase<void, String> {
  DeletePost(this.repository);

  final PostRepository repository;

  @override
  Future<Either<Failure, void>> call(String params) => repository.deletePost(params);
}

class ToggleLike implements UseCase<Post, String> {
  ToggleLike(this.repository);

  final PostRepository repository;

  @override
  Future<Either<Failure, Post>> call(String params) => repository.toggleLike(params);
}
