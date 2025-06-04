import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:sorteio_55_tech/config/app_routes.dart';
import 'package:sorteio_55_tech/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sorteio_55_tech/features/auth/presentation/cubit/auth_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 64.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
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
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
                codeController.clear();
              }
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/shield.png',
                      width: 120.w,
                      height: 120.h,
                    ),

                    Text(
                      'Código de verificação',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald',
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Insira o seu código de verificação!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.sp, color: Colors.white70),
                    ),
                    SizedBox(height: 36.h),
                    Pinput(
                      controller: codeController,
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      keyboardType: TextInputType.number,
                      animationDuration: const Duration(milliseconds: 200),
                      showCursor: true,
                    ),
                    SizedBox(height: 40.h),
                    if (state is AuthLoading)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final code = codeController.text.trim();
                            if (code.isNotEmpty) {
                              context.read<AuthCubit>().validateAccessCode(
                                code,
                              );
                            }
                          },
                          label: Text(
                            'Verificar',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 60.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
