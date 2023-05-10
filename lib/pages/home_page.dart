import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tcc_impacta/pages/add_category_page.dart';
import 'package:tcc_impacta/pages/add_debits_page.dart';
import 'package:tcc_impacta/service/categories_dto.dart';
import 'package:tcc_impacta/service/categories_service.dart';

class HomePage extends StatefulWidget {
  final String jwt;
  const HomePage({super.key, required this.jwt});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller = SwiperController();

  CategoryDto categories = CategoryDto(data: []);

  var loading = false;

  var service = CategorieService();

  @override
  void initState() {
    controller.addListener(() {});

    getCategories();
    super.initState();
  }

  void addItemToList(Data item) {
    setState(() {
      categories.data.add(item);
    });
  }

  void changeLoading() {
    setState(() {
      loading = !loading;
    });
  }

  void getCategories() async {
    changeLoading();
    var existingCategories = await service.get(widget.jwt);

    categories = existingCategories;
    changeLoading();
  }

  void addDebit(
    String name,
    String value,
    int index,
  ) {
    setState(() {
      categories.data[index].debits.add(
        Debits(
            id: 0,
            categoryId: 0,
            title: name,
            value: value,
            createdAt: "",
            updatedAt: ""),
      );

      double convertedValue = categories.data[index].debitsSum +
          double.parse(
            value.replaceAll(",", "."),
          );

      categories.data[index].debitsSum = convertedValue;
    });
  }

  MoneyMaskedTextController getValue(Data data) {
    var maxValue = double.parse(data.maxValue);
    var value = maxValue - data.debitsSum;

    var money = MoneyMaskedTextController(
        decimalSeparator: ",",
        thousandSeparator: ".",
        leftSymbol: "R\$ ",
        initialValue: value);
    return money;
  }

  String getMoneyValue(String poorValue) {
    var money = MoneyMaskedTextController(
        decimalSeparator: ",",
        thousandSeparator: ".",
        leftSymbol: "R\$ ",
        initialValue: double.parse(poorValue));
    return money.text;
  }

  Widget getCategoryRemainingMoney(Data data) {
    var maxValue = double.parse(data.maxValue);
    var value = (maxValue - data.debitsSum);

    return Text(
      "R\$ ${value.toStringAsFixed(2).replaceAll(".", ",")}",
      style: TextStyle(color: value <= 0 ? Colors.red : Colors.green),
    );
  }

  Future<void> navToDebitsAddPage(int index, String categoryId) async {
    await Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => AddDebitsPage(
        addDebit: addDebit,
        index: index,
        categoryid: categoryId,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(PageTransition(
              type: PageTransitionType.bottomToTop,
              child: AddCategoryPage(successCallBack: addItemToList),
            ));
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add_circle_outline_sharp)),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  "Meus gastos mensais",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                loading
                    ? Expanded(
                        child: Center(
                          child: LoadingAnimationWidget.threeRotatingDots(
                              color: Theme.of(context).primaryColor, size: 64),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: categories.data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => ExpansionTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(categories.data[index].title),
                                getCategoryRemainingMoney(
                                    categories.data[index])
                              ],
                            ),
                            // subtitle: Text('Trailing expansion arrow icon'),
                            children: <Widget>[
                              ListTile(
                                  title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: categories
                                            .data[index].debits.isEmpty
                                        ? 1
                                        : categories.data[index].debits.length,
                                    itemBuilder: (context, internalIndex) =>
                                        Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: categories
                                                .data[index].debits.isEmpty
                                            ? [
                                                const Text(
                                                    "Sem gastos para essa categoria")
                                              ]
                                            : [
                                                Text(
                                                  categories
                                                      .data[index]
                                                      .debits[internalIndex]
                                                      .title,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  " - ${getMoneyValue(categories.data[index].debits[internalIndex].value)}",
                                                  style: const TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () => navToDebitsAddPage(index,
                                          categories.data[index].id.toString()),
                                      icon: Icon(
                                        Icons.add,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                      )
              ],
            )),
      ),
    );
  }
}
