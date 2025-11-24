import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../models/items.dart';

part 'app_database.g.dart';

@DataClassName('ItemEntity')
class Item extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get itemCode => text()();
  TextColumn get itemName => text()();
  RealColumn get price => real()();
  TextColumn get description => text()();
}

@DriftDatabase(tables: [Item])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  Future<void> insertOrUpdateItems(List<Items> incomingItems) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(
        item,
        incomingItems
            .map(
              (e) => ItemCompanion.insert(
                id: Value(e.itemId),
                itemCode: e.barcode,
                itemName: e.itemName,
                price: e.costPrice,
                description: e.itemCategory,
              ),
            )
            .toList(),
      );
    });
  }

  Future<List<Items>> searchItems(String query) async {
    final List dbResult = await (select(
      item,
    )..where((tbl) => tbl.itemName.contains(query))).get();

    return dbResult
        .map(
          (dbItem) => Items(
            itemId: dbItem.id,
            barcode: dbItem.itemCode,
            itemName: dbItem.itemName,
            costPrice: dbItem.price,
            itemCategory: dbItem.description,
          ),
        )
        .toList();
  }

  Future<List<Items>> getAllItems() async {
    final List dbResult = await select(item).get();

    return dbResult
        .map(
          (dbItem) => Items(
            itemId: dbItem.id,
            barcode: dbItem.itemCode,
            itemName: dbItem.itemName,
            costPrice: dbItem.price,
            itemCategory: dbItem.description,
          ),
        )
        .toList();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
