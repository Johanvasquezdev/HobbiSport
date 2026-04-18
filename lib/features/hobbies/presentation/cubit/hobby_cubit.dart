import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/usecases/hobby_usecases.dart';
import 'hobby_state.dart';

class HobbyCubit extends Cubit<HobbyState> {
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

  final GetHobbies _getHobbies;
  final AddHobby _addHobby;
  final UpdateHobby _updateHobby;
  final DeleteHobby _deleteHobby;

  Future<void> loadHobbies() async {
    emit(const HobbyLoading());
    final result = await _getHobbies(const NoParams());
    result.fold(
      (failure) => emit(HobbyError(failure.message)),
      (hobbies) => emit(HobbyLoaded(hobbies)),
    );
  }

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

    await result.fold(
      (failure) async => emit(HobbyError(failure.message)),
      (_) async {
        emit(const HobbyOperationSuccess('Hobby added'));
        await loadHobbies();
      },
    );
  }

  Future<void> updateHobby(Hobby hobby) async {
    emit(const HobbyLoading());
    final result = await _updateHobby(hobby);
    await result.fold(
      (failure) async => emit(HobbyError(failure.message)),
      (_) async {
        emit(const HobbyOperationSuccess('Hobby updated'));
        await loadHobbies();
      },
    );
  }

  Future<void> deleteHobby(String id) async {
    if (state is HobbyLoaded) {
      emit((state as HobbyLoaded).withRemoved(id));
    }

    final result = await _deleteHobby(id);
    await result.fold(
      (failure) async {
        emit(HobbyError(failure.message));
        await loadHobbies();
      },
      (_) async => emit(const HobbyOperationSuccess('Hobby deleted')),
    );
  }
}
