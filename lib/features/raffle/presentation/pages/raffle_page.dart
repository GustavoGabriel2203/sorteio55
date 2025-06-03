import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sorteio_55_tech/core/services/service_locator.dart';
import 'package:sorteio_55_tech/features/raffle/presentation/cubit/raffle_cubit.dart';
import 'package:sorteio_55_tech/features/raffle/presentation/cubit/raffle_state.dart';
import 'package:sorteio_55_tech/config/app_routes.dart';

class RafflePage extends StatefulWidget {
  const RafflePage({super.key});

  @override
  State<RafflePage> createState() => _RafflePageState();
}

class _RafflePageState extends State<RafflePage> {
  late final RaffleCubit raffleCubit;

  @override
  void initState() {
    super.initState();
    raffleCubit = getIt<RaffleCubit>();
  }

  void showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar() 
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2), 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          elevation: 3,
          margin: EdgeInsets.all(16.w), 
        ),
      );
  }

  @override
  void dispose() {
    raffleCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: raffleCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: Text(
            'Sorteio',
            style: TextStyle(color: Colors.white, fontSize: 20.sp),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocConsumer<RaffleCubit, RaffleState>(
          listener: (context, state) {
            if (state is RaffleSynced) {
              showSnack(context, 'Participantes sincronizados com sucesso!');
            } else if (state is RaffleEmpty) {
              showSnack(context, 'Todos os participantes já foram sorteados.');
            } else if (state is RaffleCleaned) {
              showSnack(context, 'Participantes removidos com sucesso.');
            } else if (state is RaffleError) {
              showSnack(context, state.message);
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emoji_events, size: 80.sp, color: Colors.greenAccent),
                    SizedBox(height: 16.h),
                    Text(
                      'Antes de sortear, sincronize os participantes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xFFB0B0B0),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Gerencie os participantes do sorteio',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Botão: Sincronizar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: state is RaffleSyncing
                            ? null
                            : () => context.read<RaffleCubit>().syncParticipantsToLocal(),
                        icon: Icon(Icons.download, color: Colors.white, size: 20.sp),
                        label: Text(
                          state is RaffleSyncing
                              ? 'Sincronizando...'
                              : 'Sincronizar participantes',
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          elevation: 2,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Botão: Sortear
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.raffleLoading),
                        icon: Icon(Icons.casino, color: Colors.white, size: 20.sp),
                        label: Text(
                          'Sortear participante',
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen[400],
                          elevation: 2,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Botão: Limpar banco
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.read<RaffleCubit>().limparBanco(),
                        icon: Icon(Icons.delete_outline, color: Colors.white, size: 20.sp),
                        label: Text(
                          'Limpar participantes',
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withOpacity(0.3),
                          elevation: 2,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
