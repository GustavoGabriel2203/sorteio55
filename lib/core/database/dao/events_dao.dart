import 'package:floor/floor.dart';
import 'package:sorteio_55_tech/features/event/models/event_model.dart';

@dao
abstract class EventsDao {
  @insert
  Future<void> insertEvent(Event model);

  @Query('SELECT * FROM events ORDER BY id DESC LIMIT 1')
  Future<Event?> getEvents();
}
