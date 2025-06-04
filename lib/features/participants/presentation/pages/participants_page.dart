import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';
import 'package:sorteio_55_tech/core/services/service_locator.dart';
import 'package:sorteio_55_tech/features/participants/presentation/cubit/participants_cubit.dart';
import 'package:sorteio_55_tech/features/participants/presentation/cubit/participants_state.dart';

class ParticipantsPage extends StatefulWidget {
  const ParticipantsPage({super.key});

  @override
  State<ParticipantsPage> createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {
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
        const SnackBar(content: Text('Nenhum Participante Encontrado.')),
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
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
                    style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(14.w),
                itemCount: list.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final participant = list[index];
                  return ParticipantCard(
                    name: participant.name,
                    phone: participant.phone,
                    email: participant.email,
                  );
                },
              );
            } else if (state is ParticipantsError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.redAccent, fontSize: 13.sp),
                ),
              );
            }

            return Center(
              child: Text(
                'Erro desconhecido.',
                style: TextStyle(color: Colors.red, fontSize: 13.sp),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ParticipantCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;

  const ParticipantCard({
    required this.name,
    required this.phone,
    required this.email,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _participantInfoRow(Icons.person, name, isTitle: true),
          SizedBox(height: 6.h),
          _participantInfoRow(Icons.phone, phone),
          SizedBox(height: 4.h),
          _participantInfoRow(Icons.email, email),
        ],
      ),
    );
  }

  Widget _participantInfoRow(IconData icon, String text, {bool isTitle = false}) {
    return Row(
      children: [
        Icon(
          icon,
          color: isTitle ? Colors.green.shade400 : Colors.white70,
          size: isTitle ? 16.sp : 14.sp,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isTitle ? 14.sp : 12.sp,
              fontWeight: isTitle ? FontWeight.w600 : FontWeight.normal,
              color: isTitle ? Colors.green.shade400 : Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
