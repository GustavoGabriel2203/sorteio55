import 'package:bloc/bloc.dart';
import 'package:sorteio_55_tech/features/auth/domain/usecases/whitelabel_usecase.dart';
import 'package:sorteio_55_tech/features/auth/presentation/cubit/auth_state.dart';
import 'package:sorteio_55_tech/features/auth/models/whitelabel.dart';

import 'package:sorteio_55_tech/core/database/dao/whitelabel_dao.dart';
import 'package:sorteio_55_tech/core/database/entitys/whitelabel_entity.dart';
import 'package:sorteio_55_tech/core/services/service_locator.dart';

class AuthCubit extends Cubit<AuthState> {
  final WhitelabelUsecase whitelabelUsecase;

  AuthCubit(this.whitelabelUsecase) : super(AuthInitial());

  Future<void> validateAccessCode(String accessCode) async {
    emit(AuthLoading());

    try {
      final Whitelabel? response = await whitelabelUsecase(accessCode);

      if (response != null) {
        // Salva no banco local
        final dao = getIt<WhitelabelDao>();

        final model = WhitelabelModel(
          whitelabelId: response.id,
          name: response.name,
        );

        await dao.insertWhitelabel(model);

        emit(AuthSuccess('Código válido', response));
      } else {
        emit(AuthError('Código inválido'));
      }
    } catch (e) {
      emit(AuthError('Erro na validação: ${e.toString()}'));
    }
  }
}
