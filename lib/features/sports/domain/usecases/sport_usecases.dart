import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/sport_activity.dart';
import '../repositories/sport_repository.dart';
import 'sport_stats.dart';

class GetActivities implements UseCase<List<SportActivity>, NoParams> {
  GetActivities(this.repository);

  final SportRepository repository;

  @override
  Future<Either<Failure, List<SportActivity>>> call(NoParams params) => repository.getActivities();
}

class GetActivitiesByType implements UseCase<List<SportActivity>, SportType> {
  GetActivitiesByType(this.repository);

  final SportRepository repository;

  @override
  Future<Either<Failure, List<SportActivity>>> call(SportType params) => repository.getActivitiesByType(params);
}

class LogActivityParams {
  const LogActivityParams({
    required this.sportType,
    required this.date,
    required this.durationMinutes,
    this.distanceKm,
    this.caloriesBurned,
    this.notes,
  });

  final SportType sportType;
  final DateTime date;
  final int durationMinutes;
  final double? distanceKm;
  final int? caloriesBurned;
  final String? notes;
}

class LogActivity implements UseCase<void, LogActivityParams> {
  LogActivity(this.repository, this._uuid);

  final SportRepository repository;
  final Uuid _uuid;

  @override
  Future<Either<Failure, void>> call(LogActivityParams params) {
    final activity = SportActivity(
      id: _uuid.v4(),
      sportType: params.sportType,
      date: params.date,
      durationMinutes: params.durationMinutes,
      distanceKm: params.distanceKm,
      caloriesBurned: params.caloriesBurned,
      notes: params.notes,
      createdAt: DateTime.now(),
    );
    return repository.logActivity(activity);
  }
}

class UpdateActivity implements UseCase<void, SportActivity> {
  UpdateActivity(this.repository);

  final SportRepository repository;

  @override
  Future<Either<Failure, void>> call(SportActivity params) => repository.updateActivity(params);
}

class DeleteActivity implements UseCase<void, String> {
  DeleteActivity(this.repository);

  final SportRepository repository;

  @override
  Future<Either<Failure, void>> call(String params) => repository.deleteActivity(params);
}

class GetStats implements UseCase<SportStats, NoParams> {
  GetStats(this.repository);

  final SportRepository repository;

  @override
  Future<Either<Failure, SportStats>> call(NoParams params) => repository.getStats();
}
