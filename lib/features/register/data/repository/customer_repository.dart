import 'package:sorteio_55_tech/core/database/entitys/customer_entity.dart';
import 'package:sorteio_55_tech/features/register/data/repository/remote_customer_service.dart';

abstract class RemoteCustomerRepository {
  Future<bool> uploadCustomer(Customer customer);
}

class RemoteCustomerRepositoryImpl implements RemoteCustomerRepository {
  final RemoteCustomerService service;

  RemoteCustomerRepositoryImpl(this.service);

  @override
  Future<bool> uploadCustomer(Customer customer) {
    return service.sendCustomer(customer);
  }
}
