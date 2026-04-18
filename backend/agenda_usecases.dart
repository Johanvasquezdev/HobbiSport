// lib/features/agenda/domain/usecases/agenda_usecases.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

// ─── GetEvents ───────────────────────────────────────────────
class GetEvents implements UseCase<List<Event>, NoParams> {
  final EventRepository repository;
  GetEvents(this.repository);

  @override
  Future<Either<Failure, List<Event>>> call(NoParams params) =>
      repository.getEvents();
}

// ─── GetEventsForDay ─────────────────────────────────────────
class GetEventsForDay implements UseCase<List<Event>, DateTime> {
  final EventRepository repository;
  GetEventsForDay(this.repository);

  @override
  Future<Either<Failure, List<Event>>> call(DateTime date) =>
      repository.getEventsForDay(date);
}

// ─── AddEvent ────────────────────────────────────────────────
class AddEventParams {
  final String title;
  final String? description;
  final DateTime dateTime;
  final String? location;
  final EventCategory category;
  final String colorHex;

  const AddEventParams({
    required this.title,
    this.description,
    required this.dateTime,
    this.location,
    required this.category,
    required this.colorHex,
  });
}

class AddEvent implements UseCase<void, AddEventParams> {
  final EventRepository repository;
  AddEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(AddEventParams params) {
    final event = Event(
      id: '',
      title: params.title,
      description: params.description,
      dateTime: params.dateTime,
      location: params.location,
      category: params.category,
      colorHex: params.colorHex,
      createdAt: DateTime.now(),
    );
    return repository.addEvent(event);
  }
}

// ─── UpdateEvent ─────────────────────────────────────────────
class UpdateEvent implements UseCase<void, Event> {
  final EventRepository repository;
  UpdateEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(Event event) =>
      repository.updateEvent(event);
}

// ─── DeleteEvent ─────────────────────────────────────────────
class DeleteEvent implements UseCase<void, String> {
  final EventRepository repository;
  DeleteEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) =>
      repository.deleteEvent(id);
}
