import 'package:floor/floor.dart';
import 'package:sorteio_55_tech/core/database/entitys/events_entity.dart';

@dao
abstract class EventsDao {
  /// Insere um evento. Se o ID já existir, ele será substituído.
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertEvent(EventsEntity model);

  /// Retorna o evento mais recente salvo no banco (baseado no maior ID).
  @Query('SELECT * FROM events ORDER BY id DESC LIMIT 1')
  Future<EventsEntity?> getCurrentEvent();

  /// Remove todos os eventos salvos localmente.
  @Query('DELETE FROM events')
  Future<void> clear();
}
