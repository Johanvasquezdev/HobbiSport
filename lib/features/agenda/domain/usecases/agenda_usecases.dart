import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class GetEvents implements UseCase<List<Event>, NoParams> {
  GetEvents(this.repository);

  final EventRepository repository;

  @override
  Future<Either<Failure, List<Event>>> call(NoParams params) => repository.getEvents();
}

class GetEventsForDay implements UseCase<List<Event>, DateTime> {
  GetEventsForDay(this.repository);

  final EventRepository repository;

  @override
  Future<Either<Failure, List<Event>>> call(DateTime params) => repository.getEventsForDay(params);
}

class AddEventParams {
  const AddEventParams({
    required this.title,
    this.description,
    required this.dateTime,
    this.location,
    required this.category,
    required this.colorHex,
  });

  final String title;
  final String? description;
  final DateTime dateTime;
  final String? location;
  final EventCategory category;
  final String colorHex;
}

class AddEvent implements UseCase<void, AddEventParams> {
  AddEvent(this.repository, this._uuid);

  final EventRepository repository;
  final Uuid _uuid;

  @override
  Future<Either<Failure, void>> call(AddEventParams params) {
    final event = Event(
      id: _uuid.v4(),
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

class UpdateEvent implements UseCase<void, Event> {
  UpdateEvent(this.repository);

  final EventRepository repository;

  @override
  Future<Either<Failure, void>> call(Event params) => repository.updateEvent(params);
}

class DeleteEvent implements UseCase<void, String> {
  DeleteEvent(this.repository);

  final EventRepository repository;

  @override
  Future<Either<Failure, void>> call(String params) => repository.deleteEvent(params);
}
