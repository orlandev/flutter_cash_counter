import 'package:cash_counter/app/data/cash.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              heightFactor: 2,
              child: Text(
                "Created by Orlando N. Rodriguez",
                style: TextStyle(color: Colors.blueAccent),
              )),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.cleanCalculation();
            },
            child: const Icon(Icons.delete)),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: null,
          actions: [
            IconButton(
              onPressed: () async =>
                  controller.processTextToShareCount(context),
              icon: const Icon(Icons.share),
            )
          ],
          leading: IconButton(
              onPressed: () => controller.cleanCalculation(),
              icon: const Icon(
                Icons.monetization_on,
              )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: Get.height * 0.20,
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColor),
              child: Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Cuenta actual',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    Text(
                      '\$${controller.money}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: cashList
                        .map(
                          (item) => Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Align(
                                      alignment: AlignmentDirectional.center,
                                      child: Text(
                                        item.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ))),
                              Expanded(
                                flex: 6,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      const InputDecoration(hintText: "\$0"),
                                  controller: controller.textFieldControllers[
                                      cashList.indexOf(item)],
                                  onChanged: (newValue) {
                                    controller
                                        .textFieldControllers[
                                            cashList.indexOf(item)]
                                        .text = newValue;
                                    controller.calculateCash();
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
