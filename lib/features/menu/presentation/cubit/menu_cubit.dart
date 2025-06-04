import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_55_tech/core/database/dao/customer_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';
import 'package:sorteio_55_tech/features/participants/data/repository/participants_repository.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final CustomerDao customerDao;
  final EventsDao eventsDao;
  final ParticipantsRepository participantsRepository;

  MenuCubit({
    required this.customerDao,
    required this.eventsDao,
    required this.participantsRepository,
  }) : super(MenuInitial());

  Future<void> syncParticipants() async {
    emit(MenuLoading());

    try {
      final event = await eventsDao.getCurrentEvent();
      if (event == null) {
        emit(MenuFailure('Evento não encontrado no banco de dados.'));
        return;
      }

      final eventId = event.id;
      final remoteList = await participantsRepository.getParticipants(eventId);

      for (final p in remoteList) {
        final exists = await customerDao.validateIfCustomerAlreadyExists(
          p.email,
          eventId,
        );

        if (exists == null) {
          final syncedCustomer = p.copyWith(
            sync: 1,
            event: eventId,
          );
          await customerDao.insertCustomer(syncedCustomer);
        }
      }

      emit(MenuSuccess());
    } catch (e) {
      emit(MenuFailure('Erro ao sincronizar participantes: $e'));
    }
  }
}
