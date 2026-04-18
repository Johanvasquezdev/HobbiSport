import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/repositories/hobby_repository.dart';
import '../datasources/hobby_datasource.dart';
import '../models/hobby_model.dart';

class HobbyRepositoryImpl implements HobbyRepository {
  HobbyRepositoryImpl({
    required this.remote,
    required this.local,
    required this.auth,
  });

  final HobbyRemoteDatasource remote;
  final HobbyLocalDatasource local;
  final AuthService auth;

  @override
  Future<Either<Failure, List<Hobby>>> getHobbies() async {
    try {
      final userId = await auth.ensureUserId();
      final models = await remote.fetchHobbies(userId);
      await local.cacheHobbies(models);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      final cached = await local.getCachedHobbies();
      if (cached.isNotEmpty) {
        return Right(cached.map((m) => m.toEntity()).toList());
      }
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Hobby>> getHobbyById(String id) async {
    try {
      final model = await remote.fetchHobbyById(id);
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addHobby(Hobby hobby) async {
    try {
      await remote.createHobby(HobbyModel.fromEntity(hobby));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateHobby(Hobby hobby) async {
    try {
      await remote.updateHobby(HobbyModel.fromEntity(hobby));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHobby(String id) async {
    try {
      await remote.deleteHobby(id);
      await local.deleteHobby(id);
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
