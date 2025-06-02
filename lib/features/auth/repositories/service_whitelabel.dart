import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sorteio_55_tech/config/api_constants.dart';
import 'package:sorteio_55_tech/features/auth/models/whitelabel.dart';

class WhitelabelService {
  Future<Whitelabel?> validateAccessCode(String accessCode) async {
    final uri = Uri.parse(ApiConstants.whitelabelEndpoint).replace(
      queryParameters: {
        'filters[accessCode][\$eq]': accessCode,
        'populate': '*',
      },
    );

    try {
      // Verifica conexão
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print('Sem conexão com a internet');
        return null;
      }

      // Faz requisição
      final response = await http.get(
        uri,
        headers: ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final dataList = jsonData['data'];

        if (dataList is List && dataList.isNotEmpty) {
          final firstItem = dataList[0];
          return Whitelabel.fromJson(firstItem); 
        } else {
          print('Nenhum whitelabel encontrado');
          return null;
        }
      } else {
        print('Erro ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exceção ao validar accessCode: $e');
      return null;
    }
  }
}
