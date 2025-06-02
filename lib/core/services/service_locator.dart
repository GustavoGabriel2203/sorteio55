import 'package:get_it/get_it.dart';

// Banco de dados
import 'package:sorteio_55_tech/core/database/app_database.dart';
import 'package:sorteio_55_tech/core/database/dao/customer_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/whitelabel_dao.dart';

// AUTH
import 'package:sorteio_55_tech/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sorteio_55_tech/features/auth/repositories/service_whitelabel.dart';
import 'package:sorteio_55_tech/features/auth/domain/usecases/whitelabel_usecase.dart';

// EVENT
import 'package:sorteio_55_tech/features/event/presentation/cubit/event_cubit.dart';
import 'package:sorteio_55_tech/features/event/repositories/service_event.dart';

// PARTICIPANTS
import 'package:sorteio_55_tech/features/participants/data/repository/participants_service.dart';
import 'package:sorteio_55_tech/features/participants/data/repository/participants_repository.dart';
import 'package:sorteio_55_tech/features/participants/presentation/cubit/participants_cubit.dart';

// REGISTER
import 'package:sorteio_55_tech/features/register/data/repository/customer_repository.dart';
import 'package:sorteio_55_tech/features/register/data/repository/remote_customer_service.dart';
import 'package:sorteio_55_tech/features/register/presentation/cubit/register_cubit.dart';

// RAFFLE
import 'package:sorteio_55_tech/features/raffle/presentation/cubit/raffle_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // AUTH
  getIt.registerLazySingleton<WhitelabelService>(() => WhitelabelService());
  getIt.registerLazySingleton<WhitelabelUsecase>(
    () => WhitelabelUsecase(getIt<WhitelabelService>()),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<WhitelabelUsecase>()));

  // EVENT
  getIt.registerLazySingleton<EventService>(() => EventService());
  getIt.registerFactory<EventCubit>(() => EventCubit(getIt<EventService>()));

  // DATABASE (Floor)
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  getIt.registerSingleton<AppDatabase>(database);
  getIt.registerSingleton<CustomerDao>(database.customerDao);
  getIt.registerSingleton<WhitelabelDao>(database.whitelabelDao);
  getIt.registerSingleton<EventsDao>(database.eventsDao);

  // REGISTER (local + remoto)
  getIt.registerLazySingleton<RemoteCustomerService>(
    () => RemoteCustomerService(),
  );
  getIt.registerLazySingleton<RemoteCustomerRepository>(
    () => RemoteCustomerRepositoryImpl(getIt<RemoteCustomerService>()),
  );

  getIt.registerFactory(
    () =>
        RegisterCubit(getIt<CustomerDao>(), getIt<RemoteCustomerRepository>()),
  );

  // PARTICIPANTS
  getIt.registerLazySingleton<ParticipantService>(() => ParticipantService());
  getIt.registerLazySingleton<ParticipantsRepository>(
    () => ParticipantsRepositoryImpl(getIt<ParticipantService>()),
  );
  getIt.registerFactory(
    () => ParticipantsCubit(getIt<ParticipantsRepository>()),
  );

  // RAFFLE
  getIt.registerFactory(
    () => RaffleCubit(
      customerDao: getIt<CustomerDao>(),
      whitelabelDao: getIt<WhitelabelDao>(),
      eventsDao: getIt<EventsDao>(),
      participantsRepository: getIt<ParticipantsRepository>(),
    ),
  );
}
