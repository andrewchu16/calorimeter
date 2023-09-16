import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
    double calories;
    String category;
    double fat;
    String name;
    double price;
    double protein;
    double sugar;
    Timestamp timeStamp;

    Food(this.calories, this.category, this.fat, this.name, this.price, this.protein, this.sugar, this.timeStamp);
}