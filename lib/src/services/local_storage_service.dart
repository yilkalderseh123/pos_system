import 'package:hive_flutter/hive_flutter.dart';
import '../models/menu_item.dart';

class LocalStorageService {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MenuItemAdapter());
  }

  Future<void> saveMenuItem(MenuItem item) async {
    final box = await Hive.openBox<MenuItem>('menu');
    box.add(item);
  }

  Future<List<MenuItem>> getMenuItems() async {
    final box = await Hive.openBox<MenuItem>('menu');
    return box.values.toList();
  }
}
