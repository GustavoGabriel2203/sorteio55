import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sorteio_55_tech/config/theme_colors.dart';

import 'package:sorteio_55_tech/core/database/dao/events_dao.dart';
import 'package:sorteio_55_tech/core/services/service_locator.dart';
import 'package:sorteio_55_tech/features/register/data/models/customer_model.dart';
import 'package:sorteio_55_tech/features/register/presentation/cubit/register_cubit.dart';
import 'package:sorteio_55_tech/features/register/presentation/cubit/register_state.dart';
import 'package:sorteio_55_tech/features/register/presentation/widgets/decorationtextfield.dart';
import 'package:sorteio_55_tech/shared/widgets/app_logo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final mask = MaskTextInputFormatter(mask: '(##)#####-####');

  void _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final model = await getIt<EventsDao>().getCurrentEvent();
    if (model == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Evento não encontrado.')));
      return;
    }

    final customer = CustomerRegister(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      event: model.id ?? 0,
    );

    context.read<RegisterCubit>().registerCustomer(customer.toEntity());
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
          centerTitle: true,
          backgroundColor: const Color(0xFF1E1E1E),
          iconTheme: const IconThemeData(color: Color(0xFF1E1E1E)),
          title: AppLogo(),
          elevation: 0,
        ),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.pushNamed(context, '/registerSuccess');
              _clearFields();
            } else if (state is RegisterError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Cadastre-se',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Bebas',
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Nome
                        TextFormField(
                          controller: nameController,
                          validator:
                              ValidationBuilder(localeName: 'pt-br')
                                  .required('O nome é obrigatório')
                                  .minLength(
                                    3,
                                    'O nome deve ter pelo menos 3 letras',
                                  )
                                  .maxLength(
                                    50,
                                    'O nome deve ter no máximo 50 letras',
                                  )
                                  .build(),
                          decoration: inputDecoration('Nome'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Email
                        TextFormField(
                          controller: emailController,
                          validator:
                              ValidationBuilder(localeName: 'pt-br')
                                  .required('O e-mail é obrigatório')
                                  .email('Digite um e-mail válido')
                                  .build(),
                          decoration: inputDecoration('E-mail'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 12.h),

                        // Telefone
                        TextFormField(
                          controller: phoneController,
                          inputFormatters: [mask],
                          validator:
                              ValidationBuilder(localeName: 'pt-br')
                                  .required('O telefone é obrigatório')
                                  .minLength(
                                    14,
                                    'Número de telefone incompleto',
                                  )
                                  .build(),
                          decoration: inputDecoration('Telefone'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 20.h),

                        // Botão Salvar (Reduzido)
                        SizedBox(
                          width: 120.w,
                          height: 28.h,
                          child: ElevatedButton.icon(
                            onPressed:
                                state is RegisterLoading
                                    ? null
                                    : () => _submitForm(context),
                            label: Text(
                              'Salvar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.afinzAccent,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
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
