import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
    int calories;
    String category;
    int fat;
    String name;
    int price;
    int protein;
    int sugar;
    String? timeStamp;

    Food(this.calories, this.category, this.fat, this.name, this.price, this.protein, this.sugar, this.timeStamp);
}

class FireBaseManager {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference companyCollection = FirebaseFirestore.instance.collection('companies');
    CollectionReference itemCollection = FirebaseFirestore.instance.collection('items');
    CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

    Future<List<Food>> getHistory(String id) async {
        List<Food> ret = [];
        await userCollection.doc(id).get().then((query) async{
            for(Map<String, dynamic> item in query["purchases"]){
                List<String> itemIds = item["itemId"];
                for(String purchase in itemIds){
                    await itemCollection.doc(purchase).get().then((food){
                        ret.add(Food(food['calories'], food['category'], food['fat'], food['name'], food['price'], food['protein'], food['sugar'], item['timestamp']));
                    });
                }
            }
        });
        return ret;
    }

    Future<Food> getFood(String id) async {
      Food ret = Food(0, '', 0, '', 0, 0, 0, null);
      await itemCollection.doc(id).get().then((food) async{
        ret = Food(food['calories'], food['category'], food['fat'], food['name'], food['price'], food['protein'], food['sugar'], null);
      });
      return ret;
    }

}