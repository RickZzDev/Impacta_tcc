import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:tcc_impacta/service/categories_dto.dart';
import 'package:tcc_impacta/service/categories_service.dart';
import 'package:tcc_impacta/widgets/custom_text_field.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key, required this.successCallBack});

  final Function(Data) successCallBack;

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final categoryService = CategorieService();

  final titleController = TextEditingController();

  final ammountControler = MoneyMaskedTextController(
    decimalSeparator: ',',
    leftSymbol: "R\$ ",
    thousandSeparator: ".",
  );

  var loading = false;

  changeLoading() {
    setState(() {
      loading = !loading;
    });
  }

  create(BuildContext context) async {
    try {
      changeLoading();
      await categoryService.create(titleController.text, ammountControler.text);
      widget.successCallBack(
        Data(
            title: titleController.text,
            maxValue: ammountControler.text,
            createdAt: '',
            id: 1,
            debits: [],
            debitsSum: ""),
      );
    } catch (e) {
      changeLoading();
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
              label: "Nome da categoria",
              hint: "Entretenimento",
              controller: titleController,
              icon: Icons.person_outline,
              obscureText: false,
            ),
            const SizedBox(
              height: 32,
            ),
            CustomTextField(
              label: "Valor máximo",
              hint: "R\$ 1.000,00",
              controller: ammountControler,
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
                    create(context);
                    Navigator.pop(context);
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
                            "Criar",
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
