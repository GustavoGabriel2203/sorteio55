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
      final event = await eventsDao.getCurrentEvent();
      if (event == null) {
        emit(RaffleError('Evento não encontrado no banco de dados.'));
        return;
      }

      final eventId = event.id;
      print('📌 Sincronizando participantes do evento ID: $eventId');

      final remoteList = await participantsRepository.getParticipants(eventId);
      print('🔎 Participantes encontrados na API: ${remoteList.length}');

      for (final p in remoteList) {
        final exists = await customerDao.validateIfCustomerAlreadyExists(
          p.email,
          eventId,
        );

        if (exists == null) {
          final syncedCustomer = p.copyWith(
            sync: 1,
            event: eventId, // ✅ Usa ID da tabela events, como você quer
          );
          await customerDao.insertCustomer(syncedCustomer);
          print('✅ Inserido: ${syncedCustomer.name} - ${syncedCustomer.email}');
        } else {
          print('ℹ️ Já existe: ${p.email}');
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
      final event = await eventsDao.getCurrentEvent();
      if (event == null) {
        emit(RaffleError('Evento não encontrado.'));
        return;
      }

      final eventId = event.id;
      final all = await customerDao.getAllCustomers();
      final unsorted =
          all.where((c) => c.sorted == 0 && c.event == eventId).toList();

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



  // verificar se tem participantes para sortear

  Future<bool> hasParticipantsToSort() async {
    final event = await eventsDao.getCurrentEvent();
    if (event == null) return false;

    final eventId = event.id;
    final all = await customerDao.getAllCustomers();
    final unsorted =
        all.where((c) => c.sorted == 0 && c.event == eventId).toList();

    return unsorted.isNotEmpty;
  }
}
