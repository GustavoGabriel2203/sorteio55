import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_55_tech/core/database/dao/customer_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/whitelabel_dao.dart';
import 'package:sorteio_55_tech/features/participants/data/repository/participants_repository.dart';
import 'package:sorteio_55_tech/features/raffle/presentation/cubit/raffle_state.dart';

class RaffleCubit extends Cubit<RaffleState> {
  final CustomerDao customerDao;
  final WhitelabelDao whitelabelDao;
  final EventsDao eventsDao;
  final ParticipantsRepository participantsRepository;

  RaffleCubit({
    required this.customerDao,
    required this.whitelabelDao,
    required this.participantsRepository,
    required this.eventsDao,
  }) : super(RaffleInitial());

  Future<void> syncParticipantsToLocal() async {
    emit(RaffleSyncing());

    try {
      final whitelabel = await whitelabelDao.getLastWhitelabel();
      if (whitelabel == null) {
        emit(RaffleError('Evento não encontrado.'));
        return;
      }

      final eventId = whitelabel.whitelabelId;
      final remoteList = await participantsRepository.getParticipants(eventId);

      for (final p in remoteList) {
        final exists = await customerDao.validateIfCustomerAlreadyExists(
          p.email,
          p.event,
        );
        if (exists == null) {
          final syncedCustomer = p.copyWith(sync: 1);
          await customerDao.insertCustomer(syncedCustomer);
        }
      }

      emit(RaffleSynced());
    } catch (e) {
      emit(RaffleError('Erro ao sincronizar participantes: $e'));
    }
  }

  Future<void> sortear() async {
    emit(RaffleLoading());

    try {
      final whitelabel = await whitelabelDao.getLastWhitelabel();
      if (whitelabel == null) {
        emit(RaffleError('Evento não encontrado.'));
        return;
      }

      final eventId = whitelabel.whitelabelId;
      final all = await customerDao.getAllCustomers();
      final unsorted =
          all.where((c) => c.sorted == 0 && c.event == eventId).toList();

      if (unsorted.isEmpty) {
        emit(RaffleEmpty());
        return;
      }

      final sorteado = unsorted[Random().nextInt(unsorted.length)];
      await customerDao.updateCustomerSorted(sorteado.id!);

      // emit(RaffleSuccess(winnerName: sorteado.name));
      // await Future.delayed(const Duration(seconds: 20));

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
}
