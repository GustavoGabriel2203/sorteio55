import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import 'package:sorteio_55_tech/config/app_routes.dart';
import 'package:sorteio_55_tech/config/theme_colors.dart';
import 'package:sorteio_55_tech/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sorteio_55_tech/features/auth/presentation/cubit/auth_state.dart';
import 'package:sorteio_55_tech/shared/widgets/app_logo.dart';

class ValidatorPage extends StatefulWidget {
  const ValidatorPage({super.key});

  @override
  State<ValidatorPage> createState() => _ValidatorPageState();
}

class _ValidatorPageState extends State<ValidatorPage> {
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  void _showCustomSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 9.sp,
            ),
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        duration: const Duration(seconds: 2),
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 40.w,
      height: 44.h,
      textStyle: TextStyle(
        fontSize: 12.sp,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: const Color(0xFF66BB6A), width: 2.w),
      ),
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 0,
          title: const AppLogo(),
        ),
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                _showCustomSnackBar(context, state.message, AppColors.afinzAccent);
                codeController.clear();
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.event,
                  arguments: {
                    'whitelabelId': state.whitelabel.id,
                    'whitelabelName': state.whitelabel.name,
                  },
                );
              }

              if (state is AuthError) {
                _showCustomSnackBar(context, state.message, Colors.redAccent);
                codeController.clear();
              }
            },
            builder: (context, state) {
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/shieldAfinz.png',
                        width: 80.w,
                        height: 80.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Código de verificação',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Oswald',
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Insira o seu código de verificação!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Pinput(
                        controller: codeController,
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        keyboardType: TextInputType.number,
                        animationDuration: const Duration(milliseconds: 200),
                        showCursor: true,
                      ),
                      SizedBox(height: 24.h),
                      if (state is AuthLoading)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          width: 120.w,
                          height: 36.h,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final code = codeController.text.trim();
                              if (code.isNotEmpty) {
                                context.read<AuthCubit>().validateAccessCode(code);
                              }
                            },
                            label: Text(
                              'Verificar',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.afinzAccent,
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 28.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
