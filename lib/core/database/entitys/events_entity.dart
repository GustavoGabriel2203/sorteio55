import 'package:floor/floor.dart';

@Entity(tableName: 'events')
class EventsEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;

  EventsEntity({required this.id, required this.name});
}
