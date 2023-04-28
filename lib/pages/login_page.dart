import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tcc_impacta/pages/home_page.dart';
import 'package:tcc_impacta/service/login_service.dart';
import 'package:tcc_impacta/pages/sign_up_page.dart';
import 'package:tcc_impacta/widgets/custom_text_field.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();

  bool expandBottomSheet = false;
  bool loading = false;
  final LoginService service = LoginService();

  void changeLoading() {
    setState(() {
      loading = !loading;
    });
  }

  void login() async {
    if (emailController.text.isEmpty ||
        passwordEditingController.text.isEmpty) {
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
        var jwt = await service.login(
            emailController.text, passwordEditingController.text);

        changeLoading();
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => HomePage(jwt: jwt),
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

    ///todo login
    ///
    ///
    ///
    ///
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: "tag::hero",
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Lottie.asset('assets/login_loader.json')),
                    ),
                  ),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Coloque seus dados para continuar",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    label: "Email",
                    hint: "email@email.com",
                    controller: emailController,
                    icon: Icons.person_outline,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
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
                                  child: CircularProgressIndicator())
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      "Entrar",
                                      style: TextStyle(color: Colors.white),
                                    ),
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
                        const Text("Não possui conta? "),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const SignUp(),
                              )),
                          child: const Text(
                            "Cadastrar",
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
