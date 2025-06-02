import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sorteio_55_tech/config/app_routes.dart';
import 'package:sorteio_55_tech/config/app_theme.dart';
import 'package:sorteio_55_tech/core/services/service_locator.dart';

import 'package:sorteio_55_tech/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sorteio_55_tech/features/event/presentation/cubit/event_cubit.dart';
import 'package:sorteio_55_tech/features/register/presentation/cubit/register_cubit.dart';
import 'package:sorteio_55_tech/features/participants/presentation/cubit/participants_cubit.dart';
import 'package:sorteio_55_tech/features/raffle/presentation/cubit/raffle_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator(); 
  runApp(const SorteioApp());
}

class SorteioApp extends StatelessWidget {
  const SorteioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(
              create: (_) => getIt<AuthCubit>(),
            ),
            BlocProvider<EventCubit>(
              create: (_) => getIt<EventCubit>(),
            ),
            BlocProvider<RegisterCubit>(
              create: (_) => getIt<RegisterCubit>(),
            ),
            BlocProvider<ParticipantsCubit>(
              create: (_) => getIt<ParticipantsCubit>(),
            ),
            BlocProvider<RaffleCubit>(
              create: (_) => getIt<RaffleCubit>(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            onGenerateRoute: AppRoutes.generateRoute,
            initialRoute: AppRoutes.tutorial,
          ),
        );
      },
    );
  }
}
