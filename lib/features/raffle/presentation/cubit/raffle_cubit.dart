import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_55_tech/core/database/dao/customer_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/whitelabel_dao.dart';
import 'package:sorteio_55_tech/features/raffle/presentation/cubit/raffle_state.dart';

class RaffleCubit extends Cubit<RaffleState> {
  final CustomerDao customerDao;
  final WhitelabelDao whitelabelDao;
  final EventsDao eventsDao;

  RaffleCubit({
    required this.customerDao,
    required this.whitelabelDao,
    required this.eventsDao,
  }) : super(RaffleInitial());

  Future<void> checkAndSort() async {
    emit(RaffleCheckingParticipants());

    final canSort = await hasParticipantsToSort();
    if (!canSort) {
      emit(RaffleEmpty());
      return;
    }

    emit(RaffleLoadingAnimation());
    await Future.delayed(const Duration(seconds: 4));
    await sortear();
  }

  Future<void> sortear() async {
    emit(RaffleLoading());

    try {
      final event = await eventsDao.getCurrentEvent();
      if (event == null) {
        emit(RaffleError('Evento não encontrado.'));
        return;
      }

      final eventId = event.id;
      final all = await customerDao.getAllCustomers();
      final unsorted = all
          .where((c) => c.sorted == 0 && c.event == eventId)
          .toList();

      if (unsorted.isEmpty) {
        emit(RaffleEmpty());
        return;
      }

      final sorteado = unsorted[Random().nextInt(unsorted.length)];
      await customerDao.updateCustomerSorted(sorteado.id!);

      emit(
        RaffleShowWinner(
          winnerName: sorteado.name,
          winnerPhone: sorteado.phone,
        ),
      );
    } catch (e) {
      emit(RaffleError('Erro ao sortear participante: $e'));
    }
  }

  Future<void> limparBanco() async {
    try {
      await customerDao.clearDatabase();
      emit(RaffleCleaned());
    } catch (e) {
      emit(RaffleError('Erro ao limpar participantes: $e'));
    }
  }

  Future<bool> hasParticipantsToSort() async {
    final event = await eventsDao.getCurrentEvent();
    if (event == null) return false;

    final eventId = event.id;
    final all = await customerDao.getAllCustomers();
    final unsorted = all
        .where((c) => c.sorted == 0 && c.event == eventId)
        .toList();

    return unsorted.isNotEmpty;
  }
}
