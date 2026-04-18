// lib/features/hobbies/presentation/cubit/hobby_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/hobby.dart';

/// Base state — every state extends this.
abstract class HobbyState extends Equatable {
  const HobbyState();

  @override
  List<Object?> get props => [];
}

/// App just launched — no data loaded yet.
class HobbyInitial extends HobbyState {
  const HobbyInitial();
}

/// A request is in flight — show loading indicator.
class HobbyLoading extends HobbyState {
  const HobbyLoading();
}

/// Data fetched successfully — render the list.
class HobbyLoaded extends HobbyState {
  final List<Hobby> hobbies;

  const HobbyLoaded(this.hobbies);

  /// Convenience: returns a new state with one hobby replaced.
  HobbyLoaded withUpdated(Hobby updated) {
    final list = hobbies.map((h) => h.id == updated.id ? updated : h).toList();
    return HobbyLoaded(list);
  }

  /// Convenience: returns a new state with one hobby removed.
  HobbyLoaded withRemoved(String id) {
    final list = hobbies.where((h) => h.id != id).toList();
    return HobbyLoaded(list);
  }

  @override
  List<Object?> get props => [hobbies];
}

/// A write operation (add/update/delete) completed successfully.
/// Emit this briefly before reloading, so the UI can show a toast.
class HobbyOperationSuccess extends HobbyState {
  final String message;

  const HobbyOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Something went wrong — show an error message.
class HobbyError extends HobbyState {
  final String message;

  const HobbyError(this.message);

  @override
  List<Object?> get props => [message];
}
