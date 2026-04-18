// lib/features/agenda/presentation/cubit/agenda_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/event.dart';

abstract class AgendaState extends Equatable {
  const AgendaState();
  @override
  List<Object?> get props => [];
}

class AgendaInitial extends AgendaState {}

class AgendaLoading extends AgendaState {}

class AgendaLoaded extends AgendaState {
  final List<Event> events;
  final DateTime selectedDay;

  const AgendaLoaded({required this.events, required this.selectedDay});

  List<Event> get eventsForSelectedDay => events.where((e) {
        return e.dateTime.year == selectedDay.year &&
            e.dateTime.month == selectedDay.month &&
            e.dateTime.day == selectedDay.day;
      }).toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  @override
  List<Object?> get props => [events, selectedDay];
}

class AgendaOperationSuccess extends AgendaState {
  final String message;
  const AgendaOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class AgendaError extends AgendaState {
  final String message;
  const AgendaError(this.message);
  @override
  List<Object?> get props => [message];
}
