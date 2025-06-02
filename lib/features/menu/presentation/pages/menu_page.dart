import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteio_55_tech/config/app_routes.dart';
import 'package:sorteio_55_tech/core/database/dao/customer_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/whitelabel_dao.dart';
import 'package:sorteio_55_tech/core/services/service_locator.dart';
import 'package:sorteio_55_tech/features/auth/models/whitelabel.dart';
import 'package:sorteio_55_tech/features/menu/presentation/widgets/menu_buttom.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 80.sp,
                    fontFamily: 'Bebas',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Botões
                MenuButton(
                  label: 'Cadastrar Participantes',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                ),
                MenuButton(
                  label: 'Lista de Participantes',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.participants);
                  },
                ),
                MenuButton(
                  label: 'Realizar Sorteio',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.rafle);
                  },
                ),
                MenuButton(
                  label: 'Sair',
                  onPressed: () async {
                    await getIt<EventsDao>().clear();
                    await getIt<WhitelabelDao>().clear();
                    await getIt<CustomerDao>().clearDatabase();
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.validator,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
