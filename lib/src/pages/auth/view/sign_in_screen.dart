import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:loja/src/pages/auth/controller/auth_controller.dart';
import 'package:loja/src/pages/auth/view/components/forgot_password_dialog.dart';
import 'package:loja/src/pages/common_widgets/custom_text_field.dart';
import 'package:loja/src/pages/auth/view/sign_up_screen.dart';
import 'package:loja/src/pages/base/base_screen.dart';
import 'package:loja/src/config/custom_colors.dart';
import 'package:loja/src/pages_routes/app_pages.dart';
import 'package:loja/src/services/utils_services.dart';
import 'package:loja/src/services/validators.dart';

import '../../common_widgets/app_name_widget.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    AppNameWidget(
                      mataTitleCor: Colors.white,
                      textSize: 40,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(45))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        controller: emailController,
                        icon: Icons.email,
                        label: 'Email',
                        validator: emailValidator,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        icon: Icons.lock,
                        label: 'Senha',
                        isSecret: true,
                        validator: passwordValidator,
                      ),
                      SizedBox(
                        height: 50,
                        child: GetX<AuthController>(builder: (AuthController) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: AuthController.isLoading.value
                                ? null
                                : () {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      String email = emailController.text;
                                      String pasword = passwordController.text;
                                      AuthController.signIn(
                                          email: email, password: pasword);
                                    } else {
                                      print('Campos inválidos');
                                    }

                                    //Get.offNamed(PagesRoutes.baseRoute);
                                  },
                            child: AuthController.isLoading.value
                                ? CircularProgressIndicator()
                                : const Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 20),
                                  ),
                          );
                        }),
                      ),
// Botão senha
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () async {
                              final bool? result = await showDialog(
                                  context: context,
                                  builder: (_) {
                                    return ForgotPasswordDialog(
                                        email: emailController.text);
                                  });
                              if (result ?? false) {
                                utilsServices.showToast(
                                    message:
                                        'Um link foi enviado para o email');
                              }
                            },
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                fontSize: 18,
                                color: CustomColors.customContrastColor,
                              ),
                            )),
                      ),
                      //Divisor
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(90),
                                thickness: 2,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text('Ou'),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(90),
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Botão criar conta
                      SizedBox(
                        height: 50,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                side: const BorderSide(
                                    width: 2, color: Colors.orange)),
                            onPressed: () {
                              Get.toNamed(PagesRoutes.signUpRoute);
                            },
                            child: const Text(
                              'Criar conta',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
