import 'package:equatable/equatable.dart';

import '../../domain/entities/post.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {
  const PostInitial();
}

class PostLoading extends PostState {
  const PostLoading();
}

class PostLoaded extends PostState {
  const PostLoaded(this.posts);

  final List<Post> posts;

  PostLoaded withUpdated(Post updatedPost) {
    return PostLoaded(
      posts.map((post) => post.id == updatedPost.id ? updatedPost : post).toList(),
    );
  }

  PostLoaded withRemoved(String id) {
    return PostLoaded(posts.where((post) => post.id != id).toList());
  }

  @override
  List<Object?> get props => [posts];
}

class PostOperationSuccess extends PostState {
  const PostOperationSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class PostError extends PostState {
  const PostError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
