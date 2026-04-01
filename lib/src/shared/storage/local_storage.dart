import 'package:hive/hive.dart';

class LocalStorage {
    static Future<Box> openBox(String name) async{
        return await Hive.openBox(name);
    }
}