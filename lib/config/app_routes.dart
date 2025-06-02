import 'package:flutter/material.dart';
import 'package:sorteio_55_tech/features/auth/presentation/pages/validator_page.dart';
import 'package:sorteio_55_tech/features/event/presentation/pages/event_page.dart';
import 'package:sorteio_55_tech/features/menu/presentation/pages/menu_page.dart';
import 'package:sorteio_55_tech/features/participants/presentation/pages/participants_page.dart';
import 'package:sorteio_55_tech/features/raffle/presentation/pages/raffle_loading_page.dart';
import 'package:sorteio_55_tech/features/raffle/presentation/pages/raffle_page.dart';
import 'package:sorteio_55_tech/features/register/presentation/pages/register_page.dart';
import 'package:sorteio_55_tech/features/register/presentation/pages/register_sucess_page.dart';
import 'package:sorteio_55_tech/features/tutorial/presentation/pages/tutorial_page.dart';

class AppRoutes {
  static const tutorial = '/tutorial';
  static const validator = '/validator';
  static const event = '/event';
  static const menu = 'menu';
  static const register = '/register';
  static const registerSuccess = '/registerSuccess';
  static const participants = '/participants';
  static const rafle = '/raffle';
  static const raffleLoading = '/raffleLoading';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case tutorial:
        return MaterialPageRoute(builder: (_) => const TutorialPage());

      case validator:
        return MaterialPageRoute(builder: (_) => const ValidatorPage());

      case event:
        final args = settings.arguments as Map<String, dynamic>;
        final whitelabelId = args['whitelabelId'] as int;
        final whitelabelName = args['whitelabelName'] as String;

        return MaterialPageRoute(
          builder:
              (_) => EventPage(
                whitelabelId: whitelabelId,
                whitelabelName: whitelabelName,
              ),
        );

      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());

      case menu:
        return MaterialPageRoute(builder: (_) => MenuPage());

      case registerSuccess:
        return MaterialPageRoute(builder: (_) => RegisterSuccessPage());

      case participants:
        return MaterialPageRoute(builder: (_) => ParticipantsPage());

      case rafle:
        return MaterialPageRoute(builder: (_) => const RafflePage());

      case raffleLoading:
        return MaterialPageRoute(
          builder: (_) => RaffleLoadingPage());

      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Rota não encontrada')),
              ),
        );
    }
  }
}
