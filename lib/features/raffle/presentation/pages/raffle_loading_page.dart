import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sorteio_55_tech/config/theme_colors.dart';
import 'package:sorteio_55_tech/core/services/service_locator.dart';
import 'package:sorteio_55_tech/features/raffle/presentation/cubit/raffle_cubit.dart';
import 'package:sorteio_55_tech/features/raffle/presentation/cubit/raffle_state.dart';

class RaffleLoadingPage extends StatefulWidget {
  const RaffleLoadingPage({super.key});

  @override
  State<RaffleLoadingPage> createState() => _RaffleLoadingPageState();
}

class _RaffleLoadingPageState extends State<RaffleLoadingPage> {
  late final RaffleCubit _raffleCubit;

  @override
  void initState() {
    super.initState();
    _raffleCubit = getIt<RaffleCubit>();
    _raffleCubit.checkAndSort();
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          margin: EdgeInsets.all(16.w),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<RaffleCubit, RaffleState>(
        bloc: _raffleCubit,
        listener: (context, state) {
          if (state is RaffleError) {
            _showSnack(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is RaffleShowWinner) {
            return Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                Lottie.asset(
                  'assets/lottie/confetti.json',
                  repeat: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Vencedor:',
                        style: TextStyle(
                          fontSize: 40.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        state.winnerName,
                        style: TextStyle(
                          fontSize: 45.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.afinzAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        state.winnerPhone,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      ElevatedButton(
                        onPressed: (state is RaffleEmpty)
                            ? null
                            : () => _raffleCubit.checkAndSort(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 24.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Sortear Novamente',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          if (state is RaffleEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 80.sp, color: Colors.white),
                    SizedBox(height: 16.h),
                    Text(
                      'Todos os participantes foram sorteados ou a lista ainda não foi sincronizada.',
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is RaffleCheckingParticipants ||
              state is RaffleLoadingAnimation ||
              state is RaffleLoading) {
            return Center(
              child: Lottie.asset(
                'assets/lottie/loading2.json',
                width: 200.w,
                height: 200.h,
                repeat: true,
                fit: BoxFit.contain,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
