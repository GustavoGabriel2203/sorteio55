import 'package:equatable/equatable.dart';
import 'package:sorteio_55_tech/features/event/models/event_model.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<Event> events;

  const EventLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class EventEmpty extends EventState {}

class OnEventSelected extends EventState {}

class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object?> get props => [message];
}
