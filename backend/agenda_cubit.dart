// lib/features/agenda/presentation/cubit/agenda_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/event.dart';
import '../../domain/usecases/agenda_usecases.dart';
import 'agenda_state.dart';

class AgendaCubit extends Cubit<AgendaState> {
  final GetEvents _getEvents;
  final AddEvent _addEvent;
  final UpdateEvent _updateEvent;
  final DeleteEvent _deleteEvent;

  DateTime _selectedDay = DateTime.now();

  AgendaCubit({
    required GetEvents getEvents,
    required AddEvent addEvent,
    required UpdateEvent updateEvent,
    required DeleteEvent deleteEvent,
  })  : _getEvents = getEvents,
        _addEvent = addEvent,
        _updateEvent = updateEvent,
        _deleteEvent = deleteEvent,
        super(AgendaInitial());

  Future<void> loadEvents() async {
    emit(AgendaLoading());
    final result = await _getEvents(const NoParams());
    result.fold(
      (failure) => emit(AgendaError(failure.message)),
      (events) => emit(AgendaLoaded(events: events, selectedDay: _selectedDay)),
    );
  }

  void selectDay(DateTime day) {
    _selectedDay = day;
    if (state is AgendaLoaded) {
      final loaded = state as AgendaLoaded;
      emit(AgendaLoaded(events: loaded.events, selectedDay: day));
    }
  }

  Future<void> addEvent({
    required String title,
    String? description,
    required DateTime dateTime,
    String? location,
    required EventCategory category,
    required String colorHex,
  }) async {
    emit(AgendaLoading());
    final result = await _addEvent(AddEventParams(
      title: title,
      description: description,
      dateTime: dateTime,
      location: location,
      category: category,
      colorHex: colorHex,
    ));
    result.fold(
      (failure) => emit(AgendaError(failure.message)),
      (_) {
        emit(const AgendaOperationSuccess('Event added!'));
        loadEvents();
      },
    );
  }

  Future<void> updateEvent(Event event) async {
    emit(AgendaLoading());
    final result = await _updateEvent(event);
    result.fold(
      (failure) => emit(AgendaError(failure.message)),
      (_) {
        emit(const AgendaOperationSuccess('Event updated'));
        loadEvents();
      },
    );
  }

  Future<void> deleteEvent(String id) async {
    final result = await _deleteEvent(id);
    result.fold(
      (failure) => emit(AgendaError(failure.message)),
      (_) {
        emit(const AgendaOperationSuccess('Event deleted'));
        loadEvents();
      },
    );
  }
}
