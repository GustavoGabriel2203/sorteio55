import 'package:floor/floor.dart';

@Entity(tableName: 'events')
class Events {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;

  Events({required this.id, required this.name});
}
