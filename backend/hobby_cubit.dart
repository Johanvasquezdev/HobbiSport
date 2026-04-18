// lib/features/hobbies/presentation/cubit/hobby_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/usecases/add_hobby.dart';
import '../../domain/usecases/delete_hobby.dart';
import '../../domain/usecases/get_hobbies.dart';
import '../../domain/usecases/update_hobby.dart';
import 'hobby_state.dart';

/// Orchestrates the Hobbies feature state.
///
/// Rules:
/// - Depends ONLY on use cases — never on repositories or datasources
/// - Emits states; never returns values
/// - No BuildContext, no Navigator, no UI references
/// - Each public method = one user intent
class HobbyCubit extends Cubit<HobbyState> {
  final GetHobbies _getHobbies;
  final AddHobby _addHobby;
  final UpdateHobby _updateHobby;
  final DeleteHobby _deleteHobby;

  HobbyCubit({
    required GetHobbies getHobbies,
    required AddHobby addHobby,
    required UpdateHobby updateHobby,
    required DeleteHobby deleteHobby,
  })  : _getHobbies = getHobbies,
        _addHobby = addHobby,
        _updateHobby = updateHobby,
        _deleteHobby = deleteHobby,
        super(const HobbyInitial());

  // ─── Load ────────────────────────────────────────────────

  /// Triggered on screen init or pull-to-refresh.
  Future<void> loadHobbies() async {
    emit(const HobbyLoading());

    final result = await _getHobbies(const NoParams());

    result.fold(
      (failure) => emit(HobbyError(failure.message)),
      (hobbies) => emit(HobbyLoaded(hobbies)),
    );
  }

  // ─── Add ─────────────────────────────────────────────────

  /// Called when the user submits the "add hobby" form.
  Future<void> addHobby({
    required String name,
    required String category,
    required String description,
    required String emoji,
    required String userId,
  }) async {
    emit(const HobbyLoading());

    final result = await _addHobby(
      AddHobbyParams(
        name: name,
        category: category,
        description: description,
        emoji: emoji,
        userId: userId,
      ),
    );

    result.fold(
      (failure) => emit(HobbyError(failure.message)),
      (_) async {
        emit(const HobbyOperationSuccess('Hobby added!'));
        await loadHobbies();         // Refresh to get the Firestore ID
      },
    );
  }

  // ─── Update ──────────────────────────────────────────────

  /// Called when the user submits the "edit hobby" form.
  Future<void> updateHobby(Hobby hobby) async {
    emit(const HobbyLoading());

    final result = await _updateHobby(hobby);

    result.fold(
      (failure) => emit(HobbyError(failure.message)),
      (_) async {
        emit(const HobbyOperationSuccess('Hobby updated!'));
        await loadHobbies();
      },
    );
  }

  // ─── Delete ──────────────────────────────────────────────

  /// Called when the user confirms the delete dialog.
  Future<void> deleteHobby(String id) async {
    // Optimistic update: remove from UI immediately for snappiness
    if (state is HobbyLoaded) {
      final optimistic = (state as HobbyLoaded).withRemoved(id);
      emit(optimistic);
    }

    final result = await _deleteHobby(id);

    result.fold(
      (failure) {
        // Rollback on failure
        emit(HobbyError(failure.message));
        loadHobbies();               // Restore actual state from source
      },
      (_) => emit(const HobbyOperationSuccess('Hobby deleted')),
    );
  }
}
