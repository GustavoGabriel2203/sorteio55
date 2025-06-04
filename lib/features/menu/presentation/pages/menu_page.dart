import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sorteio_55_tech/config/app_routes.dart';
import 'package:sorteio_55_tech/config/theme_colors.dart';
import 'package:sorteio_55_tech/core/database/dao/customer_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/whitelabel_dao.dart';
import 'package:sorteio_55_tech/core/services/service_locator.dart';
import 'package:sorteio_55_tech/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:sorteio_55_tech/features/menu/presentation/widgets/menu_buttom.dart';
import 'package:sorteio_55_tech/shared/widgets/app_logo.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.afinzAccent),
              child: Text(
                'Opções Avançadas',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Apagar Participantes'),
              onTap: () async {
                Navigator.pop(context); // Fecha o Drawer
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmar'),
                    content: const Text(
                      'Deseja realmente apagar todos os participantes?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Apagar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await getIt<CustomerDao>().clearDatabase();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Participantes apagados com sucesso'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
           AppLogo(
              
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 70.sp,
                    fontFamily: 'Bebas',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),

                /// Botões principais
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

                /// Botão sincronizar com bloc
                BlocConsumer<MenuCubit, MenuState>(
                  listener: (context, state) {
                    if (state is MenuSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Participantes sincronizados com sucesso',
                          ),
                        ),
                      );
                    } else if (state is MenuFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<MenuCubit>();
                    return MenuButton(
                      label: state is MenuLoading
                          ? 'Sincronizando...'
                          : 'Sincronizar Participantes',
                      onPressed: state is MenuLoading
                          ? null
                          : () => cubit.syncParticipants(),
                    );
                  },
                ),

                MenuButton(
                  label: 'Realizar Sorteio',
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.raffleLoading),
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
