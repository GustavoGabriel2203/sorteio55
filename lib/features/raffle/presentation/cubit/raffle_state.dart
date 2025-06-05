abstract class RaffleState {}

class RaffleInitial extends RaffleState {}

class RaffleCheckingParticipants extends RaffleState {}

class RaffleLoading extends RaffleState {}

class RaffleLoadingAnimation extends RaffleState {}

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

class RaffleCleaned extends RaffleState {}
