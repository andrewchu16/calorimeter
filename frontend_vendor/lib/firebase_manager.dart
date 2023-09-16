import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
    int price;
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
                await itemCollection.doc(itemId).get().then((food){
                    ret.add(Food(food['price'], itemId, food['name'], food['category']));
                });
            }
        });
        return ret;
    }

    void sendItems(String userId, List<String> purchases, String timeStamp) async{
        await userCollection.doc(userId).get().then((query) async{
            query["purchases"].add({"itemIds": purchases,
                                    "timestamp:" timeStamp})
        });
    }

}