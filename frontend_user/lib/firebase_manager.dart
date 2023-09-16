import 'package:cloud_firestore/cloud_firestore.dart';
import 'food.dart';


class FireBaseManager {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference companyCollection = FirebaseFirestore.instance.collection('companies');
    CollectionReference itemCollection = FirebaseFirestore.instance.collection('items');
    CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

    Future<List<Food>> getHistory(String id) async {
        List<Food> ret = [];
        await userCollection.doc(id).get().then((query) async{
            for(Map<String, dynamic> item in query["purchases"]){
                List<dynamic> itemIds = item["itemIds"];
                for(dynamic purchase in itemIds){
                    await itemCollection.doc(purchase as String).get().then((food){
                        ret.add(Food(food['calories'] + 0.0, food['category'], food['fat'] + 0.0, food['name'], food['price'] + 0.0, food['protein'] + 0.0, food['sugar'] + 0.0, item['timestamp']));
                    });
                }
            }
        });
        return ret;
    }

    Future<Food> getFood(String id) async {
      late Food ret;
      await itemCollection.doc(id).get().then((food) async{
        ret = Food(food['calories'], food['category'], food['fat'], food['name'], food['price'], food['protein'], food['sugar'], food['timestamp']);
      });
      return ret;
    }

}