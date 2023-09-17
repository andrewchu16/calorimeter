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

    Future<bool> sendItems(String userId, List<String> purchases, String timeStamp) async{
      double cost = 0;
      double money = 0;
      await userCollection.doc(userId).get().then((query){
        money = query["balance"];
      });
      for(int i=0; i<purchases.length; i++){
        await itemCollection.doc(purchases[i]).get().then((query){
          cost += query["price"];
        });
      }
      if(money >= cost){
        userCollection.doc(userId).update({"balance": money - cost});
      }else{
        return false;
      }
      List<Map<String, dynamic>> mp = [{"itemIds": purchases, "timestamp": timeStamp}];
      await userCollection.doc(userId).update({"purchases": FieldValue.arrayUnion(mp)});
        /*await userCollection.doc(userId).get().then((query) async{
            query.update({"purchases": FieldValue.arrayUnion({"itemIds": purchases, "timestamp": timeStamp})});
        });*/
      return true;
    }

}