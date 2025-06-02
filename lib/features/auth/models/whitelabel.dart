class Whitelabel {
  final int id;
  final String name;
  final String accessCode;

  Whitelabel({
    required this.id,
    required this.name,
    required this.accessCode,
  });

  /// Para quando os dados vêm do JSON da API (com attributes)
  factory Whitelabel.fromJson(Map<String, dynamic> data) => Whitelabel(
        id: data['id'],
        name: data['attributes']['name'],
        accessCode: data['attributes']['accessCode'],
      );

  /// Para quando os dados vêm de um Map simples (ex: banco local)
  factory Whitelabel.fromMap(Map<String, dynamic> map) {
    return Whitelabel(
      id: map['id'] ?? 0,
      name: map['name'],
      accessCode: map['accessCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'accessCode': accessCode,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'accessCode': accessCode,
    };
  }

  @override
  String toString() {
    return 'Whitelabel{id: $id, name: $name, accessCode: $accessCode}';
  }
}
