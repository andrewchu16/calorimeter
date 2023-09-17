import 'package:flutter/material.dart';
import 'firebase_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBynYnOmCAtDtluLaONM4FP4opJEgKnOxM",
      appId: "1:1018180009414:web:95b6deb7f0c387f74d46c7",
      messagingSenderId: "1018180009414",
      projectId: "calorimeter-a3a91"
    ),
  );
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
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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

  List<bool> checkStates = [];
  List<Food> foods = [];
  String company = "a0yXbgm7FSXwmuO0bq8D";
  FireBaseManager database = FireBaseManager();
  bool databaseLoaded = false;
  bool scanningQR = false;

  void _loadData() async {
    databaseLoaded = true;
    foods = await database.getItems(company);
    for(Food food in foods){
        checkStates.add(false);
    }
    setState((){
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  void _showScanner() {
    if(databaseLoaded == true) scanningQR = true;
    setState((){

    });
  }

  void _hideScanner(){
    scanningQR = false;
    for(int i=0; i<checkStates.length; i++){
      checkStates[i] = false;
    }
    setState((){

    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             if(scanningQR == true) Container(
              height: 200,
              width: 200,
              child: MobileScanner(
                fit: BoxFit.contain,
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.normal,
                  facing: CameraFacing.front,
                  torchEnabled: true,
                ),
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  final dynamic? image = capture.image;
                  String currentTime = DateTime.now().toString();
                  List<String> purchases = [];
                  for(int i=0; i<checkStates.length; i++){
                    if(checkStates[i] == true){
                      purchases.add(foods[i].itemId);
                    }
                  }
                  for (final barcode in barcodes) {
                    print('Barcode found! ${barcode.rawValue}');
                    database.sendItems(barcode.rawValue!, purchases, currentTime);
                    print('HI');
                  }
                  _hideScanner();
                },
              ),
            ),
            if (databaseLoaded == false) TextButton(
                onPressed: () async { 
                  _loadData();
                },
                child: Text('Load'),
            ),
            for(int i=0; i<foods.length; i++)
              
              CheckboxListTile(
                title: Text(foods[i].name),
                subtitle: Text(foods[i].category),
                value: checkStates[i],
                onChanged: (value){
                  setState((){
                    checkStates[i] = !checkStates[i];
                  });
                }
              ),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showScanner,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
