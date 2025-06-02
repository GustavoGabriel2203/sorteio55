import 'package:flutter_bloc/flutter_bloc.dart';
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
}
