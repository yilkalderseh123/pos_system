import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class MenuItem {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double price;

  MenuItem({required this.name, required this.price});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'price': price};
}
