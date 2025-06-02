import 'package:floor/floor.dart';

@Entity(tableName: 'customers')
class Customer {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final String email;
  final String phone;
  final int sorted;
  final int event;
  final int sync;

  Customer({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.sorted,
    required this.event,
    required this.sync,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'];
    return Customer(
      id: json['id'],
      name: attrs['name'] ?? '',
      email: attrs['email'] ?? '',
      phone: attrs['phone'] ?? '',
      sorted: attrs['sorted'] ?? 0,
      event: attrs['event']?['data']?['id'] ?? 0,
      sync: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'sorted': sorted,
      'event': event,
      'sync': sync,
    };
  }

  Customer copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    int? sorted,
    int? event,
    int? sync,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      sorted: sorted ?? this.sorted,
      event: event ?? this.event,
      sync: sync ?? this.sync,
    );
  }

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, email: $email, phone: $phone, sorted: $sorted, event: $event, sync: $sync)';
  }
}
