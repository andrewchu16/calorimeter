import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'firebase_manager.dart';
import 'food.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image/image.dart' as Img;

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
  User? user;
  List<Food> history = [];
  FireBaseManager? database;
  bool asPercentage = false;
  //static const Widget nullIco = Image(image: AssetImage('Assets/img/ico_null.png'));
  static const TextStyle listItemTitleStyle = TextStyle(fontSize: 25);
  User nullUser = User(0, "your.email.here@caloriMet.re", "Please Sign-in");



  final List<BottomNavigationBarItem> navbarItems = [
    BottomNavigationBarItem(icon: SvgPicture.asset('Assets/img/ico_chart.svg', width: 30, height: 30), label: "Stats"),
    BottomNavigationBarItem(icon: SvgPicture.asset('Assets/img/ico_qrcode.svg', width: 30, height: 30), label: "QR Code"),
    BottomNavigationBarItem(icon: SvgPicture.asset('Assets/img/ico_profile.svg', width: 30, height: 30), label: "Profile"),
  ];

  Uint8List? resizedImg;
  Uint8List? tempImg;

  Future<Image> resizeImage(String url) {
    return Future.delayed(Duration.zero, () async {
      tempImg = (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
      Img.Image? img = Img.decodeImage(tempImg!);
      Img.Image resized = Img.copyResize(img!, width: 56, height: 56);
      resizedImg = Uint8List.fromList(Img.encodePng(resized));
      return Image.memory(resizedImg!);
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseSetup().then((value) => {
      getDatabase(value)
    });
  }

  void getDatabase(FireBaseManager db){
    database ??= db;
    database!.getHistory(userId).then((val) => setState(()=>history = val));
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
        database!.getHistory(userId).then((val) => {history = val});
      }
      returnVal = ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: ListView(
          children: foodList(history),
        ),
      );
    } else if (currentFrame == 1) {
      returnVal = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            QrImageView(
              data: userId,
              version: QrVersions.auto,
              size: 260,
              gapless: false
            ),
            const Padding(padding: EdgeInsets.only(top: 30), child:Text("-- OR --")),
            const TextButton(onPressed: null, child: Text("connect your e-payment methods")),
          ],
        ),
      );
    } else if (currentFrame == 2) {
      Widget cpnt;
      if (user == null) {
        Future<User> promise = database!.getUserInfo(userId);
        promise.then((value) => {user = value});
        cpnt = FutureBuilder(future: promise, builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          User currUser = nullUser;
          if (snapshot.hasData){
            currUser = snapshot.data!;
          }
          return Column(
            children: <Widget>[
              Text(currUser.username, style: const TextStyle(fontSize: 40)),
              Text(currUser.email, style: const TextStyle(fontSize: 18, color: Colors.grey)),
              Padding(padding: EdgeInsets.fromLTRB(0, 80, 0, 80),
                child: Text("Current Balance: ${NumberFormat.simpleCurrency().format(currUser.balance)}", style: const TextStyle(fontSize: 24)),)

            ],
          );
        });
      } else {
        cpnt = Column(
          children: <Widget>[
            Text(user!.username, style: const TextStyle(fontSize: 40)),
            Text(user!.email, style: const TextStyle(fontSize: 18, color: Colors.grey)),
            Padding(padding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
              child: Text("Current Balance: ${NumberFormat.simpleCurrency().format(user!.balance)}", style: const TextStyle(fontSize: 24)),)
          ],
        );
      }
      returnVal = SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 80, 0, 20),
              child:Image(image: AssetImage("Assets/img/empty_profile.png"), width: 300, height: 300)
            ),
            cpnt,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 6, 10),
      child:Card(
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(2),
            child: FutureBuilder<Image>(
              future: resizeImage(food.url),
              builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
                late Image ico;
                if (snapshot.hasData){
                  ico = snapshot.data!;
                } else {
                  ico = const Image(image: AssetImage("Assets/img/ico_null.png"), width: 60, height: 60);
                }
                return ico;
              },
            ),
          ),
          title: Padding(padding: const EdgeInsets.only(bottom: 3),
            child: Text(food.name, style: listItemTitleStyle),),
          subtitle: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("cals: "+food.calories.toString()),
              Text("prot: "+food.protein.toString()),
              Text("sug: "+food.sugar.toString()),
            ],
          ),
        ),
      ),
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
  return FireBaseManager();
}



