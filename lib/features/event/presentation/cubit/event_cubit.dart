import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';
import 'package:sorteio_55_tech/core/database/entitys/events_entity.dart';
import 'package:sorteio_55_tech/features/event/models/event_model.dart';
import 'package:sorteio_55_tech/features/event/repositories/service_event.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventService _eventService;
  final EventsDao _eventsDao;

  EventCubit(this._eventService, this._eventsDao) : super(EventInitial());

  Future<void> fetchEvents(int whitelabelId) async {
    emit(EventLoading());

    try {
      final events = await _eventService.getEventsFromWhitelabel(whitelabelId);

      if (events.isEmpty) {
        emit(EventEmpty());
      } else {
        emit(EventLoaded(events));
      }
    } catch (e) {
      emit(EventError('Erro ao carregar eventos: $e'));
    }
  }

  Future<void> onEventSelected(Event event) async {
    try {
      if (event.id == null) {
        emit(EventError('ID do evento é inválido'));
        return;
      }

      final model = EventsEntity(
        id: event.id!,
        name: event.name,
      );

      await _eventsDao.insertEvent(model);
      emit(OnEventSelected());
    } catch (e) {
      emit(EventError('Erro ao selecionar evento: $e'));
    }
  }
}
