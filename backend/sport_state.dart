// lib/features/sports/presentation/cubit/sport_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/sport_activity.dart';
import '../../domain/sports_domain.dart' show SportStats;

abstract class SportState extends Equatable {
  const SportState();
  @override
  List<Object?> get props => [];
}

class SportInitial extends SportState {}

class SportLoading extends SportState {}

/// Main loaded state — holds all activities, filtered list, active filter,
/// and stats. UI reads from this single state object.
class SportLoaded extends SportState {
  final List<SportActivity> activities;
  final List<SportActivity> filteredActivities;
  final SportType? activeFilter;   // null = show all
  final SportStats? stats;

  const SportLoaded({
    required this.activities,
    required this.filteredActivities,
    this.activeFilter,
    this.stats,
  });

  SportLoaded copyWith({
    List<SportActivity>? activities,
    List<SportActivity>? filteredActivities,
    SportType? activeFilter,
    bool clearFilter = false,
    SportStats? stats,
  }) =>
      SportLoaded(
        activities: activities ?? this.activities,
        filteredActivities: filteredActivities ?? this.filteredActivities,
        activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
        stats: stats ?? this.stats,
      );

  @override
  List<Object?> get props =>
      [activities, filteredActivities, activeFilter, stats];
}

class SportOperationSuccess extends SportState {
  final String message;
  const SportOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class SportError extends SportState {
  final String message;
  const SportError(this.message);
  @override
  List<Object?> get props => [message];
}
