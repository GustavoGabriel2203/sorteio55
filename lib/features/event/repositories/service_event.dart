import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sorteio_55_tech/config/api_constants.dart';
import 'package:sorteio_55_tech/features/event/models/event_model.dart';

class EventService {
  Future<List<Event>> getEventsFromWhitelabel(int whitelabelId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/events').replace(
      queryParameters: {
        'filters[whitelabel][\$eq]': whitelabelId.toString(),
        'populate': '*',
      },
    );

    try {
      // Verifica conexão com a internet
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print('Sem conexão com a internet');
        return [];
      }

      // Faz a requisição
      final response = await http.get(
        uri,
        headers: ApiConstants.headers,
      );

      print('[INFO] GET $uri');
      print('[INFO] Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final dataList = jsonData['data'];

        if (dataList is List && dataList.isNotEmpty) {
          final events = dataList.map((e) => Event.fromJson(e)).toList();
          print('[INFO] ${events.length} eventos carregados.');
          return events;
        } else {
          print('Nenhum evento encontrado');
          return [];
        }
      } else {
        print('Erro ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exceção ao buscar eventos: $e');
      return [];
    }
  }
}
