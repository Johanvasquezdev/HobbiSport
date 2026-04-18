// lib/features/sports/domain/repositories/sport_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/sport_activity.dart';

abstract class SportRepository {
  Future<Either<Failure, List<SportActivity>>> getActivities();
  Future<Either<Failure, List<SportActivity>>> getActivitiesByType(SportType type);
  Future<Either<Failure, SportActivity>> getActivityById(String id);
  Future<Either<Failure, void>> logActivity(SportActivity activity);
  Future<Either<Failure, void>> updateActivity(SportActivity activity);
  Future<Either<Failure, void>> deleteActivity(String id);
  Future<Either<Failure, SportStats>> getStats();
}

// ─── Stats value object (domain) ─────────────────────────────
class SportStats {
  final int totalSessions;
  final double totalDistanceKm;
  final int totalDurationMinutes;
  final int currentStreak; // consecutive days with activity
  final SportType? mostFrequentType;

  const SportStats({
    required this.totalSessions,
    required this.totalDistanceKm,
    required this.totalDurationMinutes,
    required this.currentStreak,
    this.mostFrequentType,
  });
}

// ─────────────────────────────────────────────────────────────
// USE CASES
// ─────────────────────────────────────────────────────────────

// lib/features/sports/domain/usecases/sport_usecases.dart
import '../../../../core/usecases/usecase.dart';

class GetActivities implements UseCase<List<SportActivity>, NoParams> {
  final SportRepository repository;
  GetActivities(this.repository);
  @override
  Future<Either<Failure, List<SportActivity>>> call(NoParams params) =>
      repository.getActivities();
}

class GetActivitiesByType implements UseCase<List<SportActivity>, SportType> {
  final SportRepository repository;
  GetActivitiesByType(this.repository);
  @override
  Future<Either<Failure, List<SportActivity>>> call(SportType type) =>
      repository.getActivitiesByType(type);
}

class LogActivityParams {
  final SportType sportType;
  final DateTime date;
  final int durationMinutes;
  final double? distanceKm;
  final int? caloriesBurned;
  final String? notes;

  const LogActivityParams({
    required this.sportType,
    required this.date,
    required this.durationMinutes,
    this.distanceKm,
    this.caloriesBurned,
    this.notes,
  });
}

class LogActivity implements UseCase<void, LogActivityParams> {
  final SportRepository repository;
  LogActivity(this.repository);
  @override
  Future<Either<Failure, void>> call(LogActivityParams params) {
    final activity = SportActivity(
      id: '',
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
  final SportRepository repository;
  UpdateActivity(this.repository);
  @override
  Future<Either<Failure, void>> call(SportActivity activity) =>
      repository.updateActivity(activity);
}

class DeleteActivity implements UseCase<void, String> {
  final SportRepository repository;
  DeleteActivity(this.repository);
  @override
  Future<Either<Failure, void>> call(String id) =>
      repository.deleteActivity(id);
}

class GetStats implements UseCase<SportStats, NoParams> {
  final SportRepository repository;
  GetStats(this.repository);
  @override
  Future<Either<Failure, SportStats>> call(NoParams params) =>
      repository.getStats();
}
