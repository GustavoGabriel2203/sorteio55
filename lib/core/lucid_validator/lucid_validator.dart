// import 'package:lucid_validation/lucid_validation.dart';
// import 'package:sorteio_55_tech/core/lucid_validator/lucid_model.dart';

// class UserValidator extends LucidValidator<LucidModel> {
//   UserValidator() {
//     ruleFor(
//       (user) => user.name,
//       key: 'name',
//     ).isNotNull().notEmpty(message: 'Preencha um nome');

//     ruleFor((user) => user.phone, key: 'phone')
//         .isNotNull()
//         .notEmpty(message: 'preencha um telefone')
//         .validPhoneBR(message: 'Preencha um telefone valido')
//         .minLength(10, message: 'O telefone deve ter ao menos 10 números');

//     ruleFor((user) => user.email, key: 'email')
//         .isNotNull()
//         .notEmpty(message: 'preencha um e-mail')
//         .validEmail(message: 'preencha um e-mail valido');
//   }
// }
