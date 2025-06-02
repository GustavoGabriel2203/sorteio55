import 'package:sorteio_55_tech/features/auth/models/whitelabel.dart';
import 'package:sorteio_55_tech/features/auth/repositories/service_whitelabel.dart';

class WhitelabelUsecase {
  final WhitelabelService service;

  WhitelabelUsecase(this.service);

  Future<Whitelabel?> call(String accessCode) async {
    return await service.validateAccessCode(accessCode);
  }
}
