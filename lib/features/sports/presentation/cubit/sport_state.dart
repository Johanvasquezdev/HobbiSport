import 'package:equatable/equatable.dart';

import '../../domain/entities/sport_activity.dart';
import '../../domain/usecases/sport_stats.dart';

abstract class SportState extends Equatable {
  const SportState();

  @override
  List<Object?> get props => [];
}

class SportInitial extends SportState {
  const SportInitial();
}

class SportLoading extends SportState {
  const SportLoading();
}

class SportLoaded extends SportState {
  const SportLoaded({
    required this.activities,
    required this.filteredActivities,
    this.activeFilter,
    this.stats,
  });

  final List<SportActivity> activities;
  final List<SportActivity> filteredActivities;
  final SportType? activeFilter;
  final SportStats? stats;

  SportLoaded copyWith({
    List<SportActivity>? activities,
    List<SportActivity>? filteredActivities,
    SportType? activeFilter,
    bool clearFilter = false,
    SportStats? stats,
  }) {
    return SportLoaded(
      activities: activities ?? this.activities,
      filteredActivities: filteredActivities ?? this.filteredActivities,
      activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [activities, filteredActivities, activeFilter, stats];
}

class SportOperationSuccess extends SportState {
  const SportOperationSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SportError extends SportState {
  const SportError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
