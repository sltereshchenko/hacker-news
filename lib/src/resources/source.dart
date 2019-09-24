import 'package:hacker_news/src/models/item_model.dart';

abstract class ASource {
  Future<List<int>> fetchTopIds();

  Future<ItemModel> fetchItem(int id);
}
