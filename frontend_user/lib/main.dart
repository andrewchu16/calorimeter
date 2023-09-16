import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int currentFrame = 0;
  String userId = "a";
  List<Food> history = [Food(300, 32, "hamborgr", 20, 20)];
  bool asPercentage = false;
  static const Widget nullIco = Image(image: AssetImage('Assets/img/ico_null.png'));
  static const TextStyle listItemTitleStyle = TextStyle(fontSize: 25);

  final List<BottomNavigationBarItem> navbarItems = [
    BottomNavigationBarItem(icon: SvgPicture.asset('Assets/img/ico_chart.svg', width: 30, height: 30), label: "a"),
    BottomNavigationBarItem(icon: SvgPicture.asset('Assets/img/ico_qr_code.svg'), label: "b"),
    BottomNavigationBarItem(icon: SvgPicture.asset('Assets/img/ico_profile.svg'), label: "c"),
  ];

  void setFrame(index) {
    setState(() {
      currentFrame = index;
    });
  }
  Widget getMainWidget(){
    Widget returnVal;
    if (currentFrame == 0) {
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
        title: Text(widget.title),
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

class Food {
  int calories;
  int fat;
  String name;
  int protein;
  int sugar;

   Food (this.calories, this.fat, this.name, this.protein, this.sugar);
}

