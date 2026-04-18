// lib/features/sports/presentation/cubit/sport_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/sport_activity.dart';
import '../../domain/sports_domain.dart';
import 'sport_state.dart';

class SportCubit extends Cubit<SportState> {
  final GetActivities _getActivities;
  final GetActivitiesByType _getActivitiesByType;
  final LogActivity _logActivity;
  final UpdateActivity _updateActivity;
  final DeleteActivity _deleteActivity;
  final GetStats _getStats;

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
        super(SportInitial());

  /// Load all activities + stats in parallel
  Future<void> loadActivities() async {
    emit(SportLoading());

    final activitiesResult = await _getActivities(const NoParams());
    final statsResult = await _getStats(const NoParams());

    activitiesResult.fold(
      (failure) => emit(SportError(failure.message)),
      (activities) {
        final stats = statsResult.fold((_) => null, (s) => s);
        emit(SportLoaded(
          activities: activities,
          filteredActivities: activities,
          stats: stats,
        ));
      },
    );
  }

  /// Filter activities by sport type. Pass null to clear filter.
  Future<void> filterByType(SportType? type) async {
    if (state is! SportLoaded) return;
    final current = state as SportLoaded;

    if (type == null) {
      emit(current.copyWith(
        filteredActivities: current.activities,
        clearFilter: true,
      ));
      return;
    }

    final result = await _getActivitiesByType(type);
    result.fold(
      (failure) => emit(SportError(failure.message)),
      (filtered) => emit(current.copyWith(
        filteredActivities: filtered,
        activeFilter: type,
      )),
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
    emit(SportLoading());
    final result = await _logActivity(LogActivityParams(
      sportType: sportType,
      date: date,
      durationMinutes: durationMinutes,
      distanceKm: distanceKm,
      caloriesBurned: caloriesBurned,
      notes: notes,
    ));
    result.fold(
      (failure) => emit(SportError(failure.message)),
      (_) {
        emit(const SportOperationSuccess('Activity logged!'));
        loadActivities();
      },
    );
  }

  Future<void> updateActivity(SportActivity activity) async {
    emit(SportLoading());
    final result = await _updateActivity(activity);
    result.fold(
      (failure) => emit(SportError(failure.message)),
      (_) {
        emit(const SportOperationSuccess('Activity updated'));
        loadActivities();
      },
    );
  }

  Future<void> deleteActivity(String id) async {
    final result = await _deleteActivity(id);
    result.fold(
      (failure) => emit(SportError(failure.message)),
      (_) {
        emit(const SportOperationSuccess('Activity deleted'));
        loadActivities();
      },
    );
  }
}
