import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:hacker_news/src/resources/news_api_provider.dart';

void main() {
  test('FetchTopIds returns a list of ids', () async {
    List<int> expIds = [1, 2, 3, 4, 5];
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode(expIds), 200);
    });

    final ids = await newsApi.fetchTopIds();
    expect(ids, expIds,
        reason: 'newsApi.fetchTopIds() does not return correct values');
  });

  test('FetchItem returns a item model', () async {
    final id = 34;
    final jsonMap = {'id': id};
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode(jsonMap), 200);
    });

    final item = await newsApi.fetchItem(1);
    expect(item.id, id,
        reason: 'newsApi.fetchItem() does not return correctid value');
  });
}
