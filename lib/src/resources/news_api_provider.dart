import 'dart:convert' show json;

import 'package:http/http.dart' show Client;
import 'package:hacker_news/src/models/item_model.dart';
import 'package:hacker_news/src/resources/source.dart';

class NewsApiProvider implements ASource {
  Client client = Client();
  final _url = 'https://hacker-news.firebaseio.com/v0';

  Future<List<int>> fetchTopIds() async {
    final response = await client.get('$_url/topstories.json');
    final List ids = json.decode(response.body);
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get('$_url/item/$id.json');
    final ItemModel item = ItemModel.fromJson(json.decode(response.body));
    return item;
  }
}
