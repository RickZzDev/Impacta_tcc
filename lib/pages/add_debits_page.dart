import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:tcc_impacta/widgets/custom_text_field.dart';

class AddDebitsPage extends StatefulWidget {
  final Function(String, String, int) addDebit;
  final int index;
  AddDebitsPage({super.key, required this.addDebit, required this.index});

  @override
  State<AddDebitsPage> createState() => _AddDebitsPageState();
}

class _AddDebitsPageState extends State<AddDebitsPage> {
  var loading = false;

  var categoriNameController = TextEditingController();

  var valueController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: ".", leftSymbol: "R\$ ");

  Future<void> sendDebit() async {
    setState(() {
      loading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      loading = false;
    });

    widget.addDebit(
        categoriNameController.text, valueController.text, widget.index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            CustomTextField(
              label: "Nome do gasto",
              hint: "Pneu do carro",
              controller: categoriNameController,
              icon: Icons.person_outline,
              obscureText: false,
            ),
            const SizedBox(
              height: 32,
            ),
            CustomTextField(
              label: "Valor",
              hint: "R\$ 200,00",
              controller: valueController,
              keyboardType: TextInputType.number,
              icon: Icons.person_outline,
              obscureText: false,
            ),
            const SizedBox(
              height: 32,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: () {
                    sendDebit();
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                            ))
                        : const Text(
                            "Lançar",
                            style: TextStyle(color: Colors.white),
                          ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
