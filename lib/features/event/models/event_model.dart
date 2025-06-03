class Event {
  final int? id;
  final String name;
  final int whitelabel;

  Event({
    this.id,
    required this.name,
    required this.whitelabel,
  });

  factory Event.fromJson(Map<String, dynamic> data) => Event(
        id: data['id'] ?? 0,
        name: data['attributes']['name'],
        whitelabel: data['attributes']?['whitelabel']?['data']?['id'] ?? 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'whitelabel': whitelabel,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'whitelabel': whitelabel,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      whitelabel: map['whitelabel'],
    );
  }

  @override
  String toString() {
    return 'Event{id: $id, name: $name, whitelabel: $whitelabel}';
  }
}
