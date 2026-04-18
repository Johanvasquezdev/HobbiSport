import 'package:equatable/equatable.dart';

import '../../domain/entities/event.dart';

abstract class AgendaState extends Equatable {
  const AgendaState();

  @override
  List<Object?> get props => [];
}

class AgendaInitial extends AgendaState {
  const AgendaInitial();
}

class AgendaLoading extends AgendaState {
  const AgendaLoading();
}

class AgendaLoaded extends AgendaState {
  const AgendaLoaded({required this.events, required this.selectedDay});

  final List<Event> events;
  final DateTime selectedDay;

  List<Event> get eventsForSelectedDay {
    final filtered = events.where((e) {
      return e.dateTime.year == selectedDay.year &&
          e.dateTime.month == selectedDay.month &&
          e.dateTime.day == selectedDay.day;
    }).toList();
    filtered.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return filtered;
  }

  @override
  List<Object?> get props => [events, selectedDay];
}

class AgendaOperationSuccess extends AgendaState {
  const AgendaOperationSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class AgendaError extends AgendaState {
  const AgendaError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
