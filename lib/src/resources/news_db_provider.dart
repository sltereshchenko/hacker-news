import 'dart:io';

import 'package:hacker_news/src/models/item_model.dart';
import 'package:hacker_news/src/resources/cache.dart';
import 'package:hacker_news/src/resources/source.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NewsDbProvider implements ASource, ACache {
  final itemsTable = 'Items';
  Database db;

  NewsDbProvider() {
    init();
  }

  init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'items.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE $itemsTable
          (
            id INTEGER PRIMERY KEY,
            deleted INTEGER,
            type TEXT,
            by TEXT,
            time INTEGER,
            text TEXT,
            dead INTEGER,
            parent INTEGER,
            kids BLOB,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
          """);
      },
    );
  }

  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      itemsTable,
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  Future<int> addItem(ItemModel item) {
    return db.insert(
      itemsTable, item.toMapForDb(),
      //conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<List<int>> fetchTopIds() {
    //throw UnimplementedError();
    return null;
  }

  Future<int> clear() {
    return db.delete(
      itemsTable,
    );
  }
}

final NewsDbProvider newsDbProvider = NewsDbProvider();
