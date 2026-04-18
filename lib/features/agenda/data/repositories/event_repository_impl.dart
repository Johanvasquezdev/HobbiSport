import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_datasource.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  EventRepositoryImpl({
    required this.remote,
    required this.local,
    required this.auth,
  });

  final EventRemoteDatasource remote;
  final EventLocalDatasource local;
  final AuthService auth;

  @override
  Future<Either<Failure, List<Event>>> getEvents() async {
    try {
      final userId = await auth.ensureUserId();
      final models = await remote.fetchEvents(userId);
      await local.cacheEvents(models);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      final cached = await local.getCachedEvents();
      if (cached.isNotEmpty) {
        return Right(cached.map((m) => m.toEntity()).toList());
      }
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getEventsForDay(DateTime date) async {
    try {
      final userId = await auth.ensureUserId();
      final models = await remote.fetchEventsForDay(userId, date);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Event>> getEventById(String id) async {
    try {
      final model = await remote.fetchEventById(id);
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
  Future<Either<Failure, void>> addEvent(Event event) async {
    try {
      final userId = await auth.ensureUserId();
      await remote.createEvent(EventModel.fromEntity(event), userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEvent(Event event) async {
    try {
      await remote.updateEvent(EventModel.fromEntity(event));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String id) async {
    try {
      await remote.deleteEvent(id);
      await local.deleteEvent(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
