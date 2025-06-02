abstract class RaffleState {}

class RaffleInitial extends RaffleState {}

class RaffleLoading extends RaffleState {}

class RaffleSuccess extends RaffleState {
  final String winnerName;
  RaffleSuccess({required this.winnerName});
}

class RaffleShowWinner extends RaffleState {
  final String winnerName;
  final String winnerPhone;

  RaffleShowWinner({
    required this.winnerName,
    required this.winnerPhone,
  });
}

class RaffleError extends RaffleState {
  final String message;
  RaffleError(this.message);
}

class RaffleEmpty extends RaffleState {}

class RaffleSynced extends RaffleState {}

class RaffleSyncing extends RaffleState {}

class RaffleCleaned extends RaffleState {}
