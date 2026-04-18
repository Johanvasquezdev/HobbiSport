import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/community_usecases.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required GetPosts getPosts,
    required CreatePost createPost,
    required DeletePost deletePost,
    required ToggleLike toggleLike,
  })  : _getPosts = getPosts,
        _createPost = createPost,
        _deletePost = deletePost,
        _toggleLike = toggleLike,
        super(const PostInitial());

  final GetPosts _getPosts;
  final CreatePost _createPost;
  final DeletePost _deletePost;
  final ToggleLike _toggleLike;

  Future<void> loadPosts() async {
    emit(const PostLoading());
    final result = await _getPosts(const NoParams());
    result.fold(
      (failure) => emit(PostError(failure.message)),
      (posts) => emit(PostLoaded(posts)),
    );
  }

  Future<void> createPost({
    required String userId,
    required String username,
    required String content,
    String? avatarUrl,
  }) async {
    emit(const PostLoading());

    final result = await _createPost(
      CreatePostParams(
        userId: userId,
        username: username,
        content: content,
        avatarUrl: avatarUrl,
      ),
    );

    await result.fold(
      (failure) async => emit(PostError(failure.message)),
      (_) async {
        emit(const PostOperationSuccess('Post created'));
        await loadPosts();
      },
    );
  }

  Future<void> deletePost(String postId) async {
    if (state is PostLoaded) {
      emit((state as PostLoaded).withRemoved(postId));
    }

    final result = await _deletePost(postId);
    await result.fold(
      (failure) async {
        emit(PostError(failure.message));
        await loadPosts();
      },
      (_) async => emit(const PostOperationSuccess('Post deleted')),
    );
  }

  Future<void> toggleLike(Post post) async {
    if (state is! PostLoaded) return;

    final loaded = state as PostLoaded;
    final optimisticPost = post.copyWith(
      likedByMe: !post.likedByMe,
      likesCount: post.likedByMe ? (post.likesCount - 1).clamp(0, 1 << 30) : post.likesCount + 1,
    );

    emit(loaded.withUpdated(optimisticPost));

    final result = await _toggleLike(post.id);
    result.fold(
      (failure) {
        emit(PostError(failure.message));
        loadPosts();
      },
      (updatedPost) {
        if (state is PostLoaded) {
          emit((state as PostLoaded).withUpdated(updatedPost));
        }
      },
    );
  }
}
