import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteio_55_tech/config/app_routes.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Bem-vindo ao Sorteio!',
          style: textTheme.headlineSmall?.copyWith(
            fontFamily: 'Bebas',
            fontSize: 28.sp,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.h),
              const _Item(
                emoji: '1️⃣',
                title: 'Valide seu código',
                description: 'Use o código fornecido pela organização.',
              ),
              const _Item(
                emoji: '2️⃣',
                title: 'Cadastre todos os participantes',
                description: 'Utilize os totens para adicionar os nomes.',
              ),
              const _Item(
                emoji: '3️⃣',
                title: 'Sincronize os dados',
                description:
                    'No totem que fará o sorteio, clique em “Sincronizar” para puxar todos os cadastros.',
              ),
              const _Item(
                emoji: '4️⃣',
                title: 'Realize o sorteio!',
                description:
                    'Toque em “Sortear” e descubra o grande vencedor!',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.validator,
                    );
                  },
                  child: Text(
                    'VAMOS COMEÇAR',
                    style: textTheme.labelLarge?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _Item({
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: textTheme.titleLarge?.copyWith(fontSize: 24.sp)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
