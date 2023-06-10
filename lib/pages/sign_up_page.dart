import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:lottie/lottie.dart';
import 'package:tcc_impacta/pages/home_page.dart';
import 'package:tcc_impacta/service/login_service.dart';
import 'package:tcc_impacta/service/sign_up_service.dart';
import 'package:tcc_impacta/widgets/custom_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final MoneyMaskedTextController monthlyIncomeController =
      MoneyMaskedTextController(
          leftSymbol: "R\$ ", decimalSeparator: ',', thousandSeparator: ".");

  final TextEditingController passwordEditingController =
      TextEditingController();

  final TextEditingController confirmPasswordEditingController =
      TextEditingController();

  final SignUpService service = SignUpService();

  final LoginService loginService = LoginService();

  bool loading = false;

  void changeLoading() {
    setState(() {
      loading = !loading;
    });
  }

  void registerUser() async {
    if (passwordEditingController.text.length > 8) {
      Flushbar(
        title: 'Ops',
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        leftBarIndicatorColor: Colors.red,
        backgroundColor: Colors.white.withOpacity(0.8),
        message: 'Sua senha deve ter mais de 8 caracteres',
        titleColor: Colors.black,
        messageColor: Colors.black,
        borderRadius: BorderRadius.circular(20),
        margin: const EdgeInsets.only(left: 8, right: 8),
        duration: const Duration(seconds: 5),
      ).show(context);
    }
    if (passwordEditingController.text !=
        confirmPasswordEditingController.text) {
      Flushbar(
        title: 'Ops',
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        leftBarIndicatorColor: Colors.red,
        backgroundColor: Colors.white.withOpacity(0.8),
        message: 'As senhas devem ser iguais',
        titleColor: Colors.black,
        messageColor: Colors.black,
        borderRadius: BorderRadius.circular(20),
        margin: const EdgeInsets.only(left: 8, right: 8),
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }
    if (emailController.text.isEmpty ||
        nameController.text.isEmpty ||
        passwordEditingController.text.isEmpty ||
        confirmPasswordEditingController.text.isEmpty) {
      Flushbar(
        title: 'Ops',
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        leftBarIndicatorColor: Colors.red,
        backgroundColor: Colors.white.withOpacity(0.8),
        message: 'Preencha todos os campos',
        titleColor: Colors.black,
        messageColor: Colors.black,
        borderRadius: BorderRadius.circular(20),
        margin: const EdgeInsets.only(left: 8, right: 8),
        duration: const Duration(seconds: 3),
      ).show(context);
    } else {
      if (!loading) {
        changeLoading();
      }

      try {
        await service.register(
            nameController.text,
            emailController.text,
            passwordEditingController.text,
            monthlyIncomeController.numberValue);

        var jwt = await loginService.login(
            emailController.text, passwordEditingController.text);

        changeLoading();
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => HomePage(
                jwt: jwt,
              ),
            ));
      } catch (e) {
        changeLoading();

        Flushbar(
          title: 'Ops',
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          leftBarIndicatorColor: Colors.red,
          backgroundColor: Colors.white.withOpacity(0.8),
          message: 'Email ou senha incorretos',
          titleColor: Colors.black,
          messageColor: Colors.black,
          borderRadius: BorderRadius.circular(20),
          margin: const EdgeInsets.only(left: 8, right: 8),
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Hero(
                          tag: "tag::hero",
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Lottie.asset('assets/login_loader.json')),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Criar conta",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    label: "Nome",
                    hint: "Tony Stark",
                    controller: nameController,
                    icon: Icons.person_outline,
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    label: "Email",
                    hint: "email@email.com",
                    controller: emailController,
                    icon: Icons.mail_outline,
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    label: "Renda mensal",
                    hint: "R\$ 10.0000,00",
                    controller: monthlyIncomeController,
                    icon: Icons.monetization_on,
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    label: "Senha",
                    hint: "*******",
                    obscureText: true,
                    icon: Icons.lock_outline,
                    controller: passwordEditingController,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    label: "Confirmar senha",
                    hint: "*******",
                    obscureText: true,
                    icon: Icons.lock_outline,
                    controller: confirmPasswordEditingController,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        onPressed: () => registerUser(),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          child: loading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text("Entrar"),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_outlined,
                                      size: 20,
                                    )
                                  ],
                                ),
                        )),
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Ja possui conta? "),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "Logar",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
