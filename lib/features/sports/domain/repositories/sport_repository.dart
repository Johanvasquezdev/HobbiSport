import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/sport_activity.dart';
import '../usecases/sport_stats.dart';

abstract class SportRepository {
  Future<Either<Failure, List<SportActivity>>> getActivities();
  Future<Either<Failure, List<SportActivity>>> getActivitiesByType(SportType type);
  Future<Either<Failure, SportActivity>> getActivityById(String id);
  Future<Either<Failure, void>> logActivity(SportActivity activity);
  Future<Either<Failure, void>> updateActivity(SportActivity activity);
  Future<Either<Failure, void>> deleteActivity(String id);
  Future<Either<Failure, SportStats>> getStats();
}
