import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/sport_activity.dart';
import '../../domain/repositories/sport_repository.dart';
import '../../domain/usecases/sport_stats.dart';
import '../datasources/sport_datasource.dart';
import '../models/sport_activity_model.dart';

class SportRepositoryImpl implements SportRepository {
  SportRepositoryImpl({
    required this.remote,
    required this.local,
    required this.auth,
  });

  final SportRemoteDatasource remote;
  final SportLocalDatasource local;
  final AuthService auth;

  @override
  Future<Either<Failure, List<SportActivity>>> getActivities() async {
    try {
      final userId = await auth.ensureUserId();
      final models = await remote.fetchActivities(userId);
      await local.cacheActivities(models);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      final cached = await local.getCachedActivities();
      if (cached.isNotEmpty) {
        return Right(cached.map((m) => m.toEntity()).toList());
      }
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SportActivity>>> getActivitiesByType(SportType type) async {
    try {
      final userId = await auth.ensureUserId();
      final models = await remote.fetchActivitiesByType(userId, type);
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
      final userId = await auth.ensureUserId();
      final model = SportActivityModel.fromEntity(activity);
      await remote.createActivity(model, userId);
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
      final userId = await auth.ensureUserId();
      final activities = await remote.fetchActivities(userId);

      final totalSessions = activities.length;
      final totalDistance = activities.fold<double>(0, (sum, item) => sum + (item.distanceKm ?? 0));
      final totalDuration = activities.fold<int>(0, (sum, item) => sum + item.durationMinutes);
      final streak = _calculateStreak(activities);

      final byType = <String, int>{};
      for (final activity in activities) {
        byType[activity.sportType.name] = (byType[activity.sportType.name] ?? 0) + 1;
      }

      String? mostFrequent;
      if (byType.isNotEmpty) {
        mostFrequent = byType.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
      }

      return Right(
        SportStats(
          totalSessions: totalSessions,
          totalDistanceKm: totalDistance,
          totalDurationMinutes: totalDuration,
          currentStreak: streak,
          mostFrequentType: mostFrequent,
        ),
      );
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  int _calculateStreak(List<SportActivityModel> models) {
    if (models.isEmpty) return 0;

    final uniqueDays = models
        .map((model) => DateTime(model.date.year, model.date.month, model.date.day))
        .toSet();

    var streak = 0;
    var cursor = DateTime.now();

    while (true) {
      final day = DateTime(cursor.year, cursor.month, cursor.day);
      if (!uniqueDays.contains(day)) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }
}
