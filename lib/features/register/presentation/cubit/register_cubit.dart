import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_55_tech/core/database/dao/customer_dao.dart';
import 'package:sorteio_55_tech/core/database/entitys/customer_entity.dart';
import 'package:sorteio_55_tech/features/register/data/repository/customer_repository.dart';
import 'package:sorteio_55_tech/features/register/presentation/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final CustomerDao customerDao;
  final RemoteCustomerRepository remoteRepository;

  RegisterCubit(this.customerDao, this.remoteRepository)
      : super(RegisterInitial());

  Future<void> registerCustomer(Customer customer) async {
    emit(RegisterLoading());

    try {
      // 1. Salva no banco local
      await customerDao.insertCustomer(customer);

      // 2. Tenta enviar para API
      final success = await remoteRepository.uploadCustomer(customer);

      if (success) {
        emit(RegisterSuccess('Cliente salvo localmente e enviado com sucesso.'));
      } else {
        emit(RegisterError('Salvo localmente, mas falha ao enviar para API.'));
      }
    } catch (e) {
      emit(RegisterError('Erro ao registrar cliente: ${e.toString()}'));
    }
  }
}
