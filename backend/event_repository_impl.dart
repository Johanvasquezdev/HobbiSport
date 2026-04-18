// lib/features/agenda/data/repositories/event_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_datasource.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDatasource remote;
  final EventLocalDatasource local;
  final AuthService auth;

  EventRepositoryImpl({
    required this.remote,
    required this.local,
    required this.auth,
  });

  String get _userId => auth.currentUserId ?? '';

  @override
  Future<Either<Failure, List<Event>>> getEvents() async {
    try {
      final models = await remote.fetchEvents(_userId);
      await local.cacheEvents(models);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      try {
        final cached = await local.getCachedEvents();
        return Right(cached.map((m) => m.toEntity()).toList());
      } on CacheException {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getEventsForDay(DateTime date) async {
    try {
      final models = await remote.fetchEventsForDay(_userId, date);
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
      final model = EventModel.fromEntity(event);
      await remote.createEvent(model, _userId);
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
