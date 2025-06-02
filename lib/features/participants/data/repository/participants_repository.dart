import 'package:sorteio_55_tech/core/database/entitys/customer_entity.dart';
import 'package:sorteio_55_tech/features/participants/data/repository/participants_service.dart';

abstract class ParticipantsRepository {
  Future<List<Customer>> getParticipants(int eventId);
}

class ParticipantsRepositoryImpl implements ParticipantsRepository {
  final ParticipantService service;

  ParticipantsRepositoryImpl(this.service);

  @override
  Future<List<Customer>> getParticipants(int eventId) {
    return service.fetchParticipants(eventId);
  }
}
