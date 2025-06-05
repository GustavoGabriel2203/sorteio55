import 'package:confetti/confetti.dart';
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
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _raffleCubit = getIt<RaffleCubit>();
    _confettiController = ConfettiController(duration: const Duration(seconds: 20));
    _raffleCubit.checkAndSort();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
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

  Widget _buildBackButton({required Color color}) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: color, size: 28.sp),
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildWinnerContent(String name, String phone) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          _buildBackButton(color: const Color(0xFF121212)),
          const Spacer(),
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
            name,
            style: TextStyle(
              fontSize: 45.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.afinzAccent,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            phone,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 40.h),
          ElevatedButton(
            onPressed: () => _raffleCubit.checkAndSort(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.afinzAccent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Sortear Novamente',
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildEmptyContent() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          _buildBackButton(color:  Colors.white),
          const Spacer(),
          Icon(Icons.check_circle_outline, size: 80.sp, color: Colors.white),
          SizedBox(height: 16.h),
          Text(
            'Todos os participantes foram sorteados ou a lista ainda não foi sincronizada.',
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Stack(
      children: [
        Center(
          child: Lottie.asset(
            'assets/lottie/loading2.json',
            width: 200.w,
            height: 200.h,
            repeat: true,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<RaffleCubit, RaffleState>(
          bloc: _raffleCubit,
          listener: (context, state) {
            if (state is RaffleError) {
              _showSnack(context, state.message);
            } else if (state is RaffleShowWinner) {
              _confettiController.play();
            }
          },
          builder: (context, state) {
            if (state is RaffleShowWinner) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirection: 3.14 / 2,
                      emissionFrequency: 0.05,
                      numberOfParticles: 15,
                      maxBlastForce: 12,
                      minBlastForce: 6,
                      blastDirectionality: BlastDirectionality.explosive,
                      gravity: 0.1,
                      colors: const [
                        AppColors.afinzAccent,
                        Colors.orange,
                        Colors.blue,
                      ],
                    ),
                  ),
                  _buildWinnerContent(state.winnerName, state.winnerPhone),
                ],
              );
            }

            if (state is RaffleEmpty) {
              return _buildEmptyContent();
            }

            if (state is RaffleCheckingParticipants ||
                state is RaffleLoadingAnimation ||
                state is RaffleLoading) {
              return _buildLoadingContent();
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
