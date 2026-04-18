// lib/features/hobbies/data/repositories/hobby_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/repositories/hobby_repository.dart';
import '../datasources/hobby_remote_datasource.dart';
import '../models/hobby_model.dart';

/// Implements the domain contract using remote (Firebase) data.
///
/// Rules:
/// - NEVER throws — always returns Either<Failure, T>
/// - Catches datasource exceptions and converts to Failures
/// - Maps HobbyModel ↔ Hobby at this layer; domain stays pure
class HobbyRepositoryImpl implements HobbyRepository {
  final HobbyRemoteDatasource remoteDatasource;
  final String currentUserId;

  HobbyRepositoryImpl({
    required this.remoteDatasource,
    required this.currentUserId,
  });

  // ─── Get all ────────────────────────────────────────────

  @override
  Future<Either<Failure, List<Hobby>>> getHobbies() async {
    try {
      final models = await remoteDatasource.fetchHobbies(currentUserId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  // ─── Get by ID ──────────────────────────────────────────

  @override
  Future<Either<Failure, Hobby>> getHobbyById(String id) async {
    try {
      final model = await remoteDatasource.fetchHobbyById(id);
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  // ─── Add ────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> addHobby(Hobby hobby) async {
    try {
      final model = HobbyModel.fromEntity(hobby);
      await remoteDatasource.createHobby(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  // ─── Update ─────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> updateHobby(Hobby hobby) async {
    try {
      final model = HobbyModel.fromEntity(hobby);
      await remoteDatasource.updateHobby(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  // ─── Delete ─────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> deleteHobby(String id) async {
    try {
      await remoteDatasource.deleteHobby(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}
