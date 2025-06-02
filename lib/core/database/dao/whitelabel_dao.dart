import 'package:floor/floor.dart';
import 'package:sorteio_55_tech/core/database/entitys/whitelabel_entity.dart';

@dao
abstract class WhitelabelDao {
  @insert
  Future<void> insertWhitelabel(WhitelabelModel model);

  @Query('SELECT * FROM whitelabels ORDER BY id DESC LIMIT 1')
  Future<WhitelabelModel?> getLastWhitelabel();

  @Query('DELETE FROM whitelabels')
  Future<void> clear();
}
