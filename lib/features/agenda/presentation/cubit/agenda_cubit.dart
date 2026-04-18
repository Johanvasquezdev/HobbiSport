import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/event.dart';
import '../../domain/usecases/agenda_usecases.dart';
import 'agenda_state.dart';

class AgendaCubit extends Cubit<AgendaState> {
  AgendaCubit({
    required GetEvents getEvents,
    required AddEvent addEvent,
    required UpdateEvent updateEvent,
    required DeleteEvent deleteEvent,
  })  : _getEvents = getEvents,
        _addEvent = addEvent,
        _updateEvent = updateEvent,
        _deleteEvent = deleteEvent,
        super(const AgendaInitial());

  final GetEvents _getEvents;
  final AddEvent _addEvent;
  final UpdateEvent _updateEvent;
  final DeleteEvent _deleteEvent;

  DateTime _selectedDay = DateTime.now();

  Future<void> loadEvents() async {
    emit(const AgendaLoading());
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
    emit(const AgendaLoading());
    final result = await _addEvent(
      AddEventParams(
        title: title,
        description: description,
        dateTime: dateTime,
        location: location,
        category: category,
        colorHex: colorHex,
      ),
    );

    await result.fold(
      (failure) async => emit(AgendaError(failure.message)),
      (_) async {
        emit(const AgendaOperationSuccess('Event added'));
        await loadEvents();
      },
    );
  }

  Future<void> updateEvent(Event event) async {
    emit(const AgendaLoading());
    final result = await _updateEvent(event);
    await result.fold(
      (failure) async => emit(AgendaError(failure.message)),
      (_) async {
        emit(const AgendaOperationSuccess('Event updated'));
        await loadEvents();
      },
    );
  }

  Future<void> deleteEvent(String id) async {
    final result = await _deleteEvent(id);
    await result.fold(
      (failure) async => emit(AgendaError(failure.message)),
      (_) async {
        emit(const AgendaOperationSuccess('Event deleted'));
        await loadEvents();
      },
    );
  }
}
