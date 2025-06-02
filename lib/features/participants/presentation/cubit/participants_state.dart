import 'package:equatable/equatable.dart';
import 'package:sorteio_55_tech/core/database/entitys/customer_entity.dart';

abstract class ParticipantsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParticipantsInitial extends ParticipantsState {}

class ParticipantsLoading extends ParticipantsState {}

class ParticipantsLoaded extends ParticipantsState {
  final List<Customer> participants;

  ParticipantsLoaded(this.participants);

  @override
  List<Object?> get props => [participants];
}

class ParticipantsError extends ParticipantsState {
  final String message;

  ParticipantsError(this.message);

  @override
  List<Object?> get props => [message];
}
