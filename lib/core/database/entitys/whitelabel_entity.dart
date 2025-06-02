import 'package:floor/floor.dart';

@Entity(tableName: 'whitelabels')
class WhitelabelModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int whitelabelId;
  final String name;

  WhitelabelModel({
    this.id,
    required this.whitelabelId,
    required this.name,
  });
}
