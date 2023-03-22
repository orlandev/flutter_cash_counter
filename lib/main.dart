import 'package:cash_counter/data/cash.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final Cash _cash = Cash();

  final List<TextEditingController> _controllers =
      List.generate(cashList.length, (_) => TextEditingController());

  void _cleanCalculation() {
    setState(() {
      for (var i = 0; i < _controllers.length; i++) {
        _controllers[i].text = '';
      }
      _counter = 0;
    });
  }

  void _processTextToShareCount(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);

    var mapOfValues = _getMapCash();
    var shareStr = "Fecha: $date\n";

    shareStr += "\n";

    mapOfValues.forEach((key, value) {
      shareStr += "$key -----  $value";
      shareStr += "\n";
    });

    shareStr += "\n\n---------------------------";
    shareStr += "\nTOTAL ------- \$$_counter";

    //final box = context.findRenderObject() as RenderBox?;

    await Share.share(shareStr,
      //  sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size
        );
  }

  Map<int, int> _getMapCash() {
    var mapCash = <int, int>{};
    for (var i = 0; i < cashList.length; i++) {
      var userCash = _controllers[i].text.trim();
      if (userCash.isNotEmpty) {
        mapCash.addAll({cashList[i]: int.parse(userCash)});
      }
    }
    return mapCash;
  }

  void _calculateCash() {
    setState(() {
      _counter = 0;

      _counter = _cash.calculateCant(_getMapCash());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _calculateCash();
          },
          child: const Icon(Icons.calculate)),
      appBar: AppBar(
        elevation: 0,
        title: null,
        actions: [
          IconButton(
            onPressed: () async => _processTextToShareCount(context),
            icon: const Icon(Icons.share, color: Colors.white),
          )
        ],
        leading: IconButton(
            onPressed: () => _cleanCalculation(),
            icon: const Icon(
              Icons.monetization_on,
              color: Colors.white,
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
                      '\$$_counter',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
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
                      .map<Widget>(
                        (item) => Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: Align(
                                    alignment: AlignmentDirectional.center,
                                    child: Text(item.toString()))),
                            Expanded(
                              flex: 6,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(hintText: "\$0"),
                                controller:
                                    _controllers[cashList.indexOf(item)],
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
    );
  }
}
