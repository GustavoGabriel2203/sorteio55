import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';

import 'package:sorteio_55_tech/core/services/service_locator.dart';
import 'package:sorteio_55_tech/core/database/dao/whitelabel_dao.dart';
import 'package:sorteio_55_tech/features/participants/presentation/cubit/participants_cubit.dart';
import 'package:sorteio_55_tech/features/participants/presentation/cubit/participants_state.dart';

class ParticipantsPage extends StatefulWidget {
  const ParticipantsPage({super.key});

  @override
  State<ParticipantsPage> createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {
  int? eventId;
  final ParticipantsCubit participantsCubit = getIt<ParticipantsCubit>();

  @override
  void initState() {
    super.initState();
    _loadEventIdAndFetchParticipants();
  }

  Future<void> _loadEventIdAndFetchParticipants() async {
    final model = await getIt<EventsDao>().getCurrentEvent();
    if (model != null) {
      participantsCubit.fetchParticipants(model.id ?? 0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum  Participante Encontrado.')),
      );
    }
  }

  @override
  void dispose() {
    participantsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: participantsCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        appBar: AppBar(
          title: Text(
            'Participantes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.green.shade600,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<ParticipantsCubit, ParticipantsState>(
          builder: (context, state) {
            if (state is ParticipantsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            } else if (state is ParticipantsLoaded) {
              final list = state.participants;

              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhum participante encontrado.',
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: list.length,
                separatorBuilder: (_, __) => SizedBox(height: 14.h),
                itemBuilder: (context, index) {
                  final participant = list[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.green.shade700,
                        width: 1.w,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 20.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.green.shade300,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                participant.name,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade300,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.white70,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              participant.phone,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.white70,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              participant.email,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is ParticipantsError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.redAccent, fontSize: 16.sp),
                ),
              );
            }

            return const Center(
              child: Text(
                'Erro desconhecido',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}
