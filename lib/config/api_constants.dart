class ApiConstants {
  // Base URL da API 
  static const String baseUrl = 'https://api.55tech.com.br/raffle';

  // Endpoints
  static const String whitelabelEndpoint = '$baseUrl/whitelabels';

  // Bearer Token (
  static const String bearerToken =
      'bf24aa7ce2522264093a553e34a8b0b25cee9423c5a6ce054e4ab38fe3af3a232fca32e5710ac12c49835cfea27003f253fcfba10d7d9a08838442626eb1c1438df7e40c00f099251a05037acbb265623d8f9be2db17eb10cc13b9332fc88195fe4ea8ffaa2d3b6fd2ca83cdf60981e3cd55b5b88853e168534b4976dafd0581';

  // Cabeçalhos
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      };
}
