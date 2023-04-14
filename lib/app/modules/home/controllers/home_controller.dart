import 'package:cash_counter/app/data/cash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class HomeController extends GetxController {
  final RxInt _money = 0.obs;

  int get money => _money.value;

  set money(int v) => _money.value = v;

  final List<TextEditingController> textFieldControllers =
      List.generate(cashList.length, (_) => TextEditingController());

  void cleanCalculation() {
    for (var i = 0; i < textFieldControllers.length; i++) {
      textFieldControllers[i].text = '';
    }
    money = 0;
  }

  void processTextToShareCount(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);

    var mapOfValues = getMapCash();
    var shareStr = "Fecha: $date\n";

    shareStr += "\n";

    mapOfValues.forEach((key, value) {
      shareStr += "$key -----  $value";
      shareStr += "\n";
    });

    shareStr += "\n\n---------------------------";
    shareStr += "\nTOTAL ------- \$$_money";

    //final box = context.findRenderObject() as RenderBox?;

    await Share.share(
      shareStr,
      //  sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size
    );
  }

  Map<int, int> getMapCash() {
    var mapCash = <int, int>{};
    for (var i = 0; i < cashList.length; i++) {
      var userCash = textFieldControllers[i].text.trim();
      if (userCash.isNotEmpty) {
        mapCash.addAll({cashList[i]: int.parse(userCash)});
      }
    }
    return mapCash;
  }

  void calculateCash() {
      money = Cash.calculateCant(getMapCash());
  }

}
