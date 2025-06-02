import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_55_tech/features/participants/data/repository/participants_repository.dart';
import 'package:sorteio_55_tech/features/participants/presentation/cubit/participants_state.dart';

class ParticipantsCubit extends Cubit<ParticipantsState> {
  final ParticipantsRepository repository;

  ParticipantsCubit(this.repository) : super(ParticipantsInitial());

  Future<void> fetchParticipants(int eventId) async {
    emit(ParticipantsLoading());
    try {
      final list = await repository.getParticipants(eventId);
      emit(ParticipantsLoaded(list));
    } catch (e) {
      emit(ParticipantsError('Erro ao buscar participantes'));
    }
  }
}
