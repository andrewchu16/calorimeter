import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
    double price;
    String itemId;
    String name;
    String category;

    Food(this.price, this.itemId, this.name, this.category);
}

class FireBaseManager {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference companyCollection = FirebaseFirestore.instance.collection('companies');
    CollectionReference itemCollection = FirebaseFirestore.instance.collection('items');
    CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

    Future<List<Food>> getItems(String id) async {
        List<Food> ret = [];
        await companyCollection.doc(id).get().then((query) async{
            for(String itemId in query["items"]){
                print(itemId);
                await itemCollection.doc(itemId).get().then((food){
                    ret.add(Food(food['price'], itemId, food['name'], food['category']));
                });
            }
        });
        return ret;
    }

    void sendItems(String userId, List<String> purchases, String timeStamp) async{
      List<Map<String, dynamic>> mp = [{"itemIds": purchases, "timestamp": timeStamp}];
      await userCollection.doc(userId).update({"purchases": FieldValue.arrayUnion(mp)});
        /*await userCollection.doc(userId).get().then((query) async{
            query.update({"purchases": FieldValue.arrayUnion({"itemIds": purchases, "timestamp": timeStamp})});
        });*/
    }

}