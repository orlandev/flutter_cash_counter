import 'package:cash_counter/data/cash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

  void _calculateCash() {
    setState(() {
      _counter = 0;

      var mapCash = <int, int>{};
      for (var i = 0; i < cashList.length; i++) {
        var userCash = _controllers[i].text.trim();
        if (userCash.isNotEmpty) {
          mapCash.addAll({cashList[i]: int.parse(userCash)});
        }
      }
      _counter = _cash.calculateCant(mapCash);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
            heightFactor: 2, child: Text(
            "Created by Orlando N. Rodriguez",
          style: TextStyle(
            color: Colors.blueAccent
          ),
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
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.share, color: Colors.white),
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
