import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Adicionado
import 'package:lottie/lottie.dart';
import 'package:sorteio_55_tech/features/raffle/presentation/cubit/raffle_cubit.dart';
import 'package:sorteio_55_tech/features/raffle/presentation/cubit/raffle_state.dart';

class RaffleLoadingPage extends StatefulWidget {
  const RaffleLoadingPage({super.key});

  @override
  State<RaffleLoadingPage> createState() => _RaffleLoadingPageState();
}

class _RaffleLoadingPageState extends State<RaffleLoadingPage> {
  @override
  void initState() {
    super.initState();
    context.read<RaffleCubit>().sortear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: BlocConsumer<RaffleCubit, RaffleState>(
        listener: (context, state) {
          if (state is RaffleError || state is RaffleEmpty) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is RaffleShowWinner) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/confetti.json',
                  repeat: true,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Column(
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
                        color: Colors.greenAccent,
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
                        backgroundColor: Colors.greenAccent,
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
              ],
            );
          }

          return Center(
            child: Lottie.asset(
              'assets/lottie/loading.json',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}