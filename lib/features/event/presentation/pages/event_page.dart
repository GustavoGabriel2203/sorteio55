import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sorteio_55_tech/config/app_routes.dart';
import 'package:sorteio_55_tech/config/theme_colors.dart';
import 'package:sorteio_55_tech/core/database/dao/customer_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';
import 'package:sorteio_55_tech/core/database/dao/whitelabel_dao.dart';
import 'package:sorteio_55_tech/core/services/service_locator.dart';
import 'package:sorteio_55_tech/features/event/presentation/cubit/event_cubit.dart';
import 'package:sorteio_55_tech/features/event/presentation/cubit/event_state.dart';
import 'package:sorteio_55_tech/shared/widgets/app_logo.dart';

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
    return BlocProvider.value(
      value: _eventCubit,
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [AppLogo()],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                await getIt<EventsDao>().clear();
                await getIt<WhitelabelDao>().clear();
                await getIt<CustomerDao>().clearDatabase();

                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.validator,
                  (route) => false,
                );
              },
            ),
          ),
          body: BlocConsumer<EventCubit, EventState>(
            listener: (context, state) {
              if (state is OnEventSelected) {
                Navigator.pushReplacementNamed(context, AppRoutes.menu);
              }
            },
            builder: (context, state) {
              if (state is EventLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is EventError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Erro ao carregar eventos.\n${state.message}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 10.sp,
                      ),
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
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white70,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, ${widget.whitelabelName}!',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Escolha o evento:',
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.white60,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Expanded(
                        child: ListView.separated(
                          itemCount: events.length,
                          separatorBuilder: (_, __) => SizedBox(height: 8.h),
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
          ),
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            SizedBox(
              height: 24.h,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.afinzAccent,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Text(
                  'Visualizar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
