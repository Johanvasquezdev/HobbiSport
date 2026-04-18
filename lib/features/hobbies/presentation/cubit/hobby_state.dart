import 'package:equatable/equatable.dart';

import '../../domain/entities/hobby.dart';

abstract class HobbyState extends Equatable {
  const HobbyState();

  @override
  List<Object?> get props => [];
}

class HobbyInitial extends HobbyState {
  const HobbyInitial();
}

class HobbyLoading extends HobbyState {
  const HobbyLoading();
}

class HobbyLoaded extends HobbyState {
  const HobbyLoaded(this.hobbies);

  final List<Hobby> hobbies;

  HobbyLoaded withRemoved(String id) {
    return HobbyLoaded(hobbies.where((h) => h.id != id).toList());
  }

  @override
  List<Object?> get props => [hobbies];
}

class HobbyOperationSuccess extends HobbyState {
  const HobbyOperationSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class HobbyError extends HobbyState {
  const HobbyError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
