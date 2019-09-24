import 'package:hacker_news/src/models/item_model.dart';

abstract class ACache {
  Future<int> addItem(ItemModel item);

  Future<int> clear();
}
