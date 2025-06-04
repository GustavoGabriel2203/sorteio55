part of 'menu_cubit.dart';

sealed class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuSuccess extends MenuState {}

class MenuFailure extends MenuState {
  final String message;
  MenuFailure(this.message);
}
