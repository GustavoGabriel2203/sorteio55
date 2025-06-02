import 'package:equatable/equatable.dart';
import 'package:sorteio_55_tech/features/auth/models/whitelabel.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final Whitelabel whitelabel;

  const AuthSuccess(this.message, this.whitelabel);

  @override
  List<Object?> get props => [message, whitelabel];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
