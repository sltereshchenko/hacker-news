import 'package:hacker_news/src/models/item_model.dart';
import 'package:hacker_news/src/resources/cache.dart';
import 'package:hacker_news/src/resources/news_api_provider.dart';
import 'package:hacker_news/src/resources/source.dart';

import 'news_db_provider.dart';

class Repository {
  List<ASource> sources = [
    newsDbProvider,
    NewsApiProvider(),
  ];
  List<ACache> caches = [
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() {
    for (ASource source in sources) {
      var ids = source.fetchTopIds();
      if (ids != null) return ids;
    }
    return null;
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;
    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) break;
    }
    for (ACache cache in caches) {
      if ((cache != source) & (item != null)) cache.addItem(item);
    }
    return item;
  }

  Future clear() async {
    for (ACache cache in caches) {
      return await cache.clear();
    }
  }
}
