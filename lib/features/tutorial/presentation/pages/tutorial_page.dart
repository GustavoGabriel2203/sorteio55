import 'package:flutter/material.dart';
import 'package:sorteio_55_tech/config/app_routes.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Detecção de toque na tela inteira
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pushReplacementNamed(context, AppRoutes.validator);
        },
        child: Stack(
          children: [
            // Imagem de fundo ocupando toda a tela
            Positioned.fill(
              child: Image.asset(
                'assets/images/splash_afinz_totem.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
