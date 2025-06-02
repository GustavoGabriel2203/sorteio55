import 'package:floor/floor.dart';
import 'package:sorteio_55_tech/core/database/entitys/events_entity.dart';

@dao
abstract class EventsDao {
  @insert
  Future<void> insertEvent(EventsEntity model);

  @Query('SELECT * FROM events ORDER BY id DESC LIMIT 1')
  Future<EventsEntity?> getCurrentEvent();

  @Query('DELETE FROM events')
  Future<void> clear();
}
