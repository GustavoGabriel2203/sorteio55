import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:sorteio_55_tech/config/api_constants.dart';
import 'package:sorteio_55_tech/core/database/entitys/customer_entity.dart';

class ParticipantService {
  Future<List<Customer>> fetchParticipants(int eventId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/customers').replace(
      queryParameters: {
        'filters[event][id][\$eq]': '$eventId',
        'populate': '*',
      },
    );

    try {
      // Verifica conexão
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print('Sem conexão com a internet');
        return [];
      }

      // Faz requisição
      final response = await http.get(uri, headers: ApiConstants.headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final dataList = jsonData['data'] as List;

        return dataList
            .map((json) => Customer.fromJson(json))
            .toList();
      } else {
        print('Erro ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exceção ao buscar participantes: $e');
      return [];
    }
  }
}
