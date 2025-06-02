import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sorteio_55_tech/core/database/dao/whitelabel_dao.dart';

import 'package:sorteio_55_tech/core/lucid_validator/lucid_model.dart';
import 'package:sorteio_55_tech/core/lucid_validator/lucid_validator.dart';
import 'package:sorteio_55_tech/core/services/service_locator.dart';
import 'package:sorteio_55_tech/features/register/data/models/customer_model.dart';
import 'package:sorteio_55_tech/features/register/presentation/cubit/register_cubit.dart';
import 'package:sorteio_55_tech/features/register/presentation/cubit/register_state.dart';
import 'package:sorteio_55_tech/features/register/presentation/widgets/decorationtextfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final mask = MaskTextInputFormatter(mask: '(##)#####-####');

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final user = LucidModel(name: '', phone: '', email: '');
  final validator = UserValidator();

  void _submitForm(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    final model = await getIt<WhitelabelDao>().getLastWhitelabel();

    if (model == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento não encontrado.')),
      );
      return;
    }

    final customer = CustomerRegister(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      event: model.whitelabelId,
    );

    context.read<RegisterCubit>().registerCustomer(customer.toEntity());
  }
}

  void _clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Cadastro de Participantes',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.pushNamed(context, '/registerSuccess');
              _clearFields();
            } else if (state is RegisterError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Realize seu cadastro',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Bebas',
                            fontSize: 40.sp,
                          ),
                        ),
                        SizedBox(height: 35.h),
                        TextFormField(
                          controller: nameController,
                          onChanged: (value) => user.name = value,
                          validator: validator.byField(user, 'name'),
                          decoration: inputDecoration('Nome'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: emailController,
                          onChanged: (value) => user.email = value,
                          validator: validator.byField(user, 'email'),
                          decoration: inputDecoration('Email'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: phoneController,
                          onChanged: (value) => user.phone = value,
                          inputFormatters: [mask],
                          validator: validator.byField(user, 'phone'),
                          decoration: inputDecoration('Telefone'),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: state is RegisterLoading
                                ? null
                                : () => _submitForm(context),
                            child: state is RegisterLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Salvar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
