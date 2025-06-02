import 'package:floor/floor.dart';
import 'package:sorteio_55_tech/core/database/entitys/customer_entity.dart';

@dao
abstract class CustomerDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCustomer(Customer customer);

  @Query('SELECT * FROM customers')
  Future<List<Customer>> getAllCustomers();

  @Query('SELECT * FROM customers WHERE id = :id')
  Future<Customer?> getCustomerById(int id);

  @update
  Future<void> updateCustomer(Customer customer);

  @delete
  Future<void> deleteCustomer(Customer customer);

  //  Marca um participante como sorteado
  @Query('UPDATE customers SET sorted = 1 WHERE id = :id')
  Future<void> updateCustomerSorted(int id);

  //  Verifica se já existe um participante com mesmo e-mail e evento
  @Query('SELECT * FROM customers WHERE email = :email AND event = :event LIMIT 1')
  Future<Customer?> validateIfCustomerAlreadyExists(String email, int event);

  //  Limpa todos os participantes do banco
  @Query('DELETE FROM customers')
  Future<void> clearDatabase();

  // Retorna todos os participantes não sorteados de um evento
  @Query('SELECT * FROM customers WHERE sorted = 0 AND event = :eventId')
  Future<List<Customer>> getUnsortedParticipants(int eventId);
}
