import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'firebase_manager.dart';
import 'food.dart';
import 'package:firebase_core/firebase_core.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int currentFrame = 0;
  String userId = "dHg450bwEz2YoX0N8diI";
  List<Food> history = [];
  FireBaseManager? database;
  bool asPercentage = false;
  static const Widget nullIco = Image(image: AssetImage('Assets/img/ico_null.png'));
  static const TextStyle listItemTitleStyle = TextStyle(fontSize: 25);



  final List<BottomNavigationBarItem> navbarItems = [
    BottomNavigationBarItem(icon: SvgPicture.asset('Assets/img/ico_chart.svg', width: 30, height: 30), label: "Stats"),
    BottomNavigationBarItem(icon: SvgPicture.asset('Assets/img/ico_qr_code.svg'), label: "b"),
    BottomNavigationBarItem(icon: SvgPicture.asset('Assets/img/ico_profile.svg'), label: "c"),
  ];

  @override
  void initState() {
    super.initState();
    firebaseSetup().then((value) => {
      getDatabase(value)
    });
  }

  void getDatabase(FireBaseManager value){
    database = value;
    database!.getHistory(userId).then((val) => {print("----------------------------"+val.toString())});
  }

  void setFrame(index) {
    setState(() {
      currentFrame = index;
    });
  }
  Widget getMainWidget(){
    Widget returnVal;
    if (currentFrame == 0) {
      if (database != null){
        database!.getHistory(userId).then((val) => {print("----------------------------"+val.toString())});
      }
      returnVal = ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: Column(
          children: foodList(history),
        ),
      );
    } else if (currentFrame == 1) {
      returnVal = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Image(image: image),
            Text("-- OR --"),
            TextButton(onPressed: null, child: Text("connect your apple pay")),
          ],
        ),
      );
    } else if (currentFrame == 2) {
      returnVal = const SizedBox(
        width: double.infinity,
        child: Column(
          children: [

          ],
        )
      );
    } else {
      returnVal = const Text("err");
    }
    return returnVal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("CaloriMeter"),
      ),

      body: getMainWidget(),

      bottomNavigationBar: BottomNavigationBar(
        items: navbarItems,
        onTap: setFrame
      ),

    );
  }

  Widget historyListTile(Food food) {

    return Row(
      mainAxisSize:MainAxisSize.max,
      children: [
        const Image(image: AssetImage("Assets/img/ico_null.png"), width: 60, height: 60),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 2),
              child: Text(food.name, style: listItemTitleStyle),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 60),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(food.calories.toString()),
                  Text(food.protein.toString()),
                  Text(food.sugar.toString()),
                ],
              )
            ),
          ],
        )
      ],
    );
  }
  List<Widget> foodList(List<Food> foods){
    List<Widget> foodTileList = [];
    for (Food food in foods){
      foodTileList.add(historyListTile(food));
    }
    return foodTileList;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  void verify(ctx) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("CaloriMeter"),
      ),

      body: Center(
        child: Column (
          children: <Widget>[
            TextButton(onPressed: () => {
              verify(context)
            }, child: const Text("Sign-in")),
          ]
        )
      ),

    );
  }
  
}

Future<FireBaseManager> firebaseSetup() async {
  print("Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBynYnOmCAtDtluLaONM4FP4opJEgKnOxM",
      authDomain: "calorimeter-a3a91.firebaseapp.com",
      projectId: "calorimeter-a3a91",
      storageBucket: "calorimeter-a3a91.appspot.com",
      messagingSenderId: "1018180009414",
      appId: "1:1018180009414:web:95b6deb7f0c387f74d46c7",
    ),
  );
  print("B");
  return FireBaseManager();
}



