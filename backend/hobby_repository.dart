// lib/features/hobbies/domain/repositories/hobby_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/hobby.dart';

/// Abstract contract that the domain defines.
/// The data layer MUST implement this — domain never imports data.
/// Dependency Inversion Principle: high-level depends on abstraction.
abstract class HobbyRepository {
  /// Returns all hobbies for the current authenticated user.
  Future<Either<Failure, List<Hobby>>> getHobbies();

  /// Returns a single hobby by [id], or [NotFoundFailure] if missing.
  Future<Either<Failure, Hobby>> getHobbyById(String id);

  /// Persists a new [hobby]. ID is assigned by the datasource.
  Future<Either<Failure, void>> addHobby(Hobby hobby);

  /// Replaces the existing hobby with the same ID.
  Future<Either<Failure, void>> updateHobby(Hobby hobby);

  /// Permanently removes the hobby with [id].
  Future<Either<Failure, void>> deleteHobby(String id);
}
