import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/sport_activity.dart';
import '../../domain/usecases/sport_usecases.dart';
import 'sport_state.dart';

class SportCubit extends Cubit<SportState> {
  SportCubit({
    required GetActivities getActivities,
    required GetActivitiesByType getActivitiesByType,
    required LogActivity logActivity,
    required UpdateActivity updateActivity,
    required DeleteActivity deleteActivity,
    required GetStats getStats,
  })  : _getActivities = getActivities,
        _getActivitiesByType = getActivitiesByType,
        _logActivity = logActivity,
        _updateActivity = updateActivity,
        _deleteActivity = deleteActivity,
        _getStats = getStats,
        super(const SportInitial());

  final GetActivities _getActivities;
  final GetActivitiesByType _getActivitiesByType;
  final LogActivity _logActivity;
  final UpdateActivity _updateActivity;
  final DeleteActivity _deleteActivity;
  final GetStats _getStats;

  Future<void> loadActivities() async {
    emit(const SportLoading());

    final activitiesResult = await _getActivities(const NoParams());
    final statsResult = await _getStats(const NoParams());

    activitiesResult.fold(
      (failure) => emit(SportError(failure.message)),
      (activities) {
        final stats = statsResult.fold((_) => null, (value) => value);
        emit(
          SportLoaded(
            activities: activities,
            filteredActivities: activities,
            stats: stats,
          ),
        );
      },
    );
  }

  Future<void> filterByType(SportType? type) async {
    if (state is! SportLoaded) return;

    final loaded = state as SportLoaded;
    if (type == null) {
      emit(loaded.copyWith(filteredActivities: loaded.activities, clearFilter: true));
      return;
    }

    final result = await _getActivitiesByType(type);
    result.fold(
      (failure) => emit(SportError(failure.message)),
      (filtered) => emit(loaded.copyWith(filteredActivities: filtered, activeFilter: type)),
    );
  }

  Future<void> logActivity({
    required SportType sportType,
    required DateTime date,
    required int durationMinutes,
    double? distanceKm,
    int? caloriesBurned,
    String? notes,
  }) async {
    emit(const SportLoading());
    final result = await _logActivity(
      LogActivityParams(
        sportType: sportType,
        date: date,
        durationMinutes: durationMinutes,
        distanceKm: distanceKm,
        caloriesBurned: caloriesBurned,
        notes: notes,
      ),
    );

    await result.fold(
      (failure) async => emit(SportError(failure.message)),
      (_) async {
        emit(const SportOperationSuccess('Activity logged'));
        await loadActivities();
      },
    );
  }

  Future<void> updateActivity(SportActivity activity) async {
    emit(const SportLoading());
    final result = await _updateActivity(activity);

    await result.fold(
      (failure) async => emit(SportError(failure.message)),
      (_) async {
        emit(const SportOperationSuccess('Activity updated'));
        await loadActivities();
      },
    );
  }

  Future<void> deleteActivity(String id) async {
    final result = await _deleteActivity(id);

    await result.fold(
      (failure) async => emit(SportError(failure.message)),
      (_) async {
        emit(const SportOperationSuccess('Activity deleted'));
        await loadActivities();
      },
    );
  }
}
