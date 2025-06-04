import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteio_55_tech/config/app_routes.dart';
import 'package:sorteio_55_tech/core/services/service_locator.dart';
import 'package:sorteio_55_tech/features/event/presentation/cubit/event_cubit.dart';
import 'package:sorteio_55_tech/features/event/presentation/cubit/event_state.dart';

class EventPage extends StatefulWidget {
  final int whitelabelId;
  final String whitelabelName;

  const EventPage({
    super.key,
    required this.whitelabelId,
    required this.whitelabelName,
  });

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late final EventCubit _eventCubit;

  @override
  void initState() {
    super.initState();
    _eventCubit = getIt<EventCubit>();
    _eventCubit.fetchEvents(widget.whitelabelId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _eventCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Eventos'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.validator, (route) => false);
            },
          ),
        ),
        body: BlocConsumer<EventCubit, EventState>(
          builder: (context, state) {
            if (state is EventLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EventError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Erro ao carregar os eventos.\n${state.message}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.redAccent,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state is EventLoaded) {
              final events = state.events;

              if (events.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhum evento disponível.',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16.sp),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, ${widget.whitelabelName}!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 28.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Escolha o evento que você deseja participar:',
                      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16.sp, color: Colors.white70), 
                    ),
                    SizedBox(height: 24.h),
                    Expanded(
                      child: ListView.separated(
                        itemCount: events.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return _EventCard(
                            name: event.name,
                            onTap: () {
                              _eventCubit.onEventSelected(event);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
          listener: (BuildContext context, EventState state) {
            if (state is OnEventSelected) {
              Navigator.pushReplacementNamed(context, AppRoutes.menu);
            }
          },
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _EventCard({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E), // Fundo escuro
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nome do evento e data (estático no seu código, pode ser dinâmico)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),

            // Botão verde
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50), // Verde
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Visualizar',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}