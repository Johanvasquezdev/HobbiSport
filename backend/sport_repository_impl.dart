// lib/features/sports/data/repositories/sport_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/sport_activity.dart';
import '../../domain/repositories/sport_repository.dart';
import '../../domain/sports_domain.dart' show SportStats;
import '../datasources/sport_datasource.dart';
import '../models/sport_activity_model.dart';

class SportRepositoryImpl implements SportRepository {
  final SportRemoteDatasource remote;
  final SportLocalDatasource local;
  final AuthService auth;

  SportRepositoryImpl({
    required this.remote,
    required this.local,
    required this.auth,
  });

  String get _userId => auth.currentUserId ?? '';

  @override
  Future<Either<Failure, List<SportActivity>>> getActivities() async {
    try {
      final models = await remote.fetchActivities(_userId);
      await local.cacheActivities(models);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      try {
        final cached = await local.getCachedActivities();
        return Right(cached.map((m) => m.toEntity()).toList());
      } on CacheException {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SportActivity>>> getActivitiesByType(
      SportType type) async {
    try {
      final models = await remote.fetchActivitiesByType(_userId, type);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SportActivity>> getActivityById(String id) async {
    try {
      final model = await remote.fetchActivityById(id);
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logActivity(SportActivity activity) async {
    try {
      final model = SportActivityModel.fromEntity(activity);
      await remote.createActivity(model, _userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateActivity(SportActivity activity) async {
    try {
      await remote.updateActivity(SportActivityModel.fromEntity(activity));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteActivity(String id) async {
    try {
      await remote.deleteActivity(id);
      await local.deleteActivity(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SportStats>> getStats() async {
    try {
      final models = await remote.fetchActivities(_userId);

      final totalSessions = models.length;
      final totalDistance = models.fold<double>(
        0,
        (sum, m) => sum + (m.distanceKm ?? 0),
      );
      final totalDuration = models.fold<int>(
        0,
        (sum, m) => sum + m.durationMinutes,
      );

      // Current streak: count consecutive days with at least one activity
      final streak = _calculateStreak(models);

      // Most frequent sport type
      final typeCounts = <SportType, int>{};
      for (final m in models) {
        typeCounts[m.sportType] = (typeCounts[m.sportType] ?? 0) + 1;
      }
      SportType? mostFrequent;
      if (typeCounts.isNotEmpty) {
        mostFrequent = typeCounts.entries
            .reduce((a, b) => a.value >= b.value ? a : b)
            .key;
      }

      return Right(SportStats(
        totalSessions: totalSessions,
        totalDistanceKm: totalDistance,
        totalDurationMinutes: totalDuration,
        currentStreak: streak,
        mostFrequentType: mostFrequent,
      ));
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Counts consecutive days (from today backwards) with at least one session.
  int _calculateStreak(List<SportActivityModel> models) {
    if (models.isEmpty) return 0;

    final activityDays = models
        .map((m) => DateTime(m.date.year, m.date.month, m.date.day))
        .toSet();

    int streak = 0;
    DateTime cursor = DateTime.now();

    while (true) {
      final day = DateTime(cursor.year, cursor.month, cursor.day);
      if (activityDays.contains(day)) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }
}
