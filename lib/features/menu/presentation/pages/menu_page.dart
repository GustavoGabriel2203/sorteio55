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

  void _showCustomSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        duration: const Duration(seconds: 2),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: AppColors.afinzAccent),
                child: Text(
                  'Opções Avançadas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: Text(
                  'Apagar Participantes',
                  style: TextStyle(fontSize: 8.sp),
                ),
                onTap: () async {
                  Navigator.pop(context);
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
                    _showCustomSnackBar(
                      context,
                      '🗑️ Participantes apagados com sucesso',
                      Colors.redAccent,
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
                width: 48.w,
                height: 48.h,
              ),
              SizedBox(width: 6.w),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontFamily: 'Bebas',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),

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

                  /// Botão sincronizar com Bloc
                  BlocConsumer<MenuCubit, MenuState>(
                    listener: (context, state) {
                      if (state is MenuSuccess) {
                        _showCustomSnackBar(
                          context,
                          '✅ Participantes sincronizados com sucesso',
                          const Color(0xFF2ECC71),
                        );
                      } else if (state is MenuFailure) {
                        _showCustomSnackBar(
                          context,
                          state.message,
                          Colors.redAccent,
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
      ),
    );
  }
}
