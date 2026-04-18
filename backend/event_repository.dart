// lib/features/agenda/domain/repositories/event_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/event.dart';

abstract class EventRepository {
  Future<Either<Failure, List<Event>>> getEvents();
  Future<Either<Failure, List<Event>>> getEventsForDay(DateTime date);
  Future<Either<Failure, Event>> getEventById(String id);
  Future<Either<Failure, void>> addEvent(Event event);
  Future<Either<Failure, void>> updateEvent(Event event);
  Future<Either<Failure, void>> deleteEvent(String id);
}
