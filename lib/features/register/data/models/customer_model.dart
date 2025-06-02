import 'package:sorteio_55_tech/core/database/entitys/customer_entity.dart';

class CustomerRegister {
  final String name;
  final String email;
  final String phone;
  final int event;

  CustomerRegister({
    required this.name,
    required this.email,
    required this.phone,
    required this.event,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'event': {'id': event},
    };
  }

  factory CustomerRegister.fromJson(Map<String, dynamic> json) {
    return CustomerRegister(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      event: json['event']?['id'] ?? 0,
    );
  }

  Customer toEntity({
    int? id,
    int sorted = 0,
    int sync = 0,
  }) {
    return Customer(
      id: id,
      name: name,
      email: email,
      phone: phone,
      sorted: sorted,
      event: event,
      sync: sync,
    );
  }

  @override
  String toString() {
    return 'CustomerRegister{name: $name, email: $email, phone: $phone, event: $event}';
  }
}
