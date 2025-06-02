import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sorteio_55_tech/core/database/entitys/customer_entity.dart';
import 'package:sorteio_55_tech/config/api_constants.dart';

class RemoteCustomerService {
  final String _url = '${ApiConstants.baseUrl}/customers';

  Future<bool> sendCustomer(Customer customer) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: ApiConstants.headers,
        body: jsonEncode({
          "data": {
            "name": customer.name,
            "email": customer.email,
            "phone": customer.phone,
            "sorted": customer.sorted,
            "event": customer.event, 
          }
        }),
      );
      print(response.body);

      final success = response.statusCode == 200 || response.statusCode == 201;

      if (!success) {
        print('Erro ${response.statusCode}: ${response.body}');
      }

      return success;
    } catch (e) {
      print('Exceção ao enviar cliente: $e');
      return false;
    }
  }
}
