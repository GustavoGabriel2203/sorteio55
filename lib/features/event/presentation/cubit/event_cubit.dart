import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';
import 'package:sorteio_55_tech/core/database/entitys/events_entity.dart';
import 'package:sorteio_55_tech/core/services/service_locator.dart';
import 'package:sorteio_55_tech/features/event/models/event_model.dart';
import 'package:sorteio_55_tech/features/event/repositories/service_event.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventService _eventService;

  EventCubit(this._eventService) : super(EventInitial());

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

  void onEventSelected(Event event) async {
    final dao = getIt<EventsDao>();

    final model = EventsEntity(id: event.id, name: event.name);

    await dao.insertEvent(model);

     emit(OnEventSelected());
  }
}
