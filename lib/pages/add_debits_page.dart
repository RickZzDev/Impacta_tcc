import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:tcc_impacta/service/categories_service.dart';
import 'package:tcc_impacta/widgets/custom_text_field.dart';

class AddDebitsPage extends StatefulWidget {
  final Function(String, String, int) addDebit;
  final int index;
  final String categoryid;
  AddDebitsPage(
      {super.key,
      required this.addDebit,
      required this.index,
      required this.categoryid});

  @override
  State<AddDebitsPage> createState() => _AddDebitsPageState();
}

class _AddDebitsPageState extends State<AddDebitsPage> {
  var loading = false;

  var categoriNameController = TextEditingController();

  var valueController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: ".", leftSymbol: "R\$ ");

  final CategorieService categorieService = CategorieService();

  Future<void> sendDebit() async {
    try {
      setState(() {
        loading = true;
      });

      await categorieService.launchDebit(categoriNameController.text,
          valueController.numberValue.toString(), widget.categoryid);

      widget.addDebit(categoriNameController.text,
          valueController.numberValue.toString(), widget.index);
      Navigator.pop(context);
    } finally {
      setState(() {
        loading = false;
      });
    }
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
