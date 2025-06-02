import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';
import 'package:sorteio_55_tech/core/database/entitys/events_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:sorteio_55_tech/core/database/entitys/customer_entity.dart';
import 'package:sorteio_55_tech/core/database/entitys/whitelabel_entity.dart';

import 'package:sorteio_55_tech/core/database/dao/customer_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/whitelabel_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Customer, WhitelabelModel, EventsEntity])
abstract class AppDatabase extends FloorDatabase {
  CustomerDao get customerDao;
  WhitelabelDao get whitelabelDao;
  EventsDao get eventsDao;
}
