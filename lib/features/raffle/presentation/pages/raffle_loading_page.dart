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
  bool _hasSorted = false;
  bool _canSort = true;

  @override
  void initState() {
    super.initState();
    _raffleCubit = getIt<RaffleCubit>();
    _checkAndStartRaffle();
  }

  /// Verifica se há participantes disponíveis para sorteio
  Future<void> _checkAndStartRaffle() async {
    final canSort = await _raffleCubit.hasParticipantsToSort();

    if (!canSort) {
      setState(() => _canSort = false);
      _showSnack(context, 'Todos os participantes já foram sorteados.');
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context);
      return;
    }

    _hasSorted = true;
    await Future.delayed(const Duration(seconds: 4));
    _raffleCubit.sortear();
  }

  /// Exibe um SnackBar flutuante com mensagem
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
      body: BlocConsumer<RaffleCubit, RaffleState>(
        bloc: _raffleCubit,
        listener: (context, state) {
          if (state is RaffleError) {
            _showSnack(context, state.message);
            Future.delayed(const Duration(seconds: 2), () => Navigator.pop(context));
          }
        },
        builder: (context, state) {
          // 🔸 Caso não haja participantes
          if (!_canSort) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 64.sp),
                  SizedBox(height: 16.h),
                  Text(
                    'Não há participantes para sortear, sincronize primeiro.',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // ✅ Vencedor sorteado com sucesso
          if (state is RaffleShowWinner) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/confetti.json',
                  repeat: true,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
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
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.afinzAccent,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 24.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Voltar',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // ⏳ Enquanto aguarda sorteio
          return Center(
            child: Lottie.asset(
              'assets/lottie/loading2.json',
              width: 200.w,
              height: 200.h,
              repeat: true,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
