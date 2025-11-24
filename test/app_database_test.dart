import 'package:ceylon_product_app/database/app_database.dart';
import 'package:ceylon_product_app/models/items.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  final item1 = Items(
    itemId: 1,
    barcode: "111",
    itemName: "Apple",
    costPrice: 100.0,
    itemCategory: "Fruit",
  );

  final item2 = Items(
    itemId: 2,
    barcode: "222",
    itemName: "Banana",
    costPrice: 50.0,
    itemCategory: "Fruit",
  );

  test('Database starts empty', () async {
    final items = await database.getAllItems();
    expect(items, isEmpty);
  });

  test('Insert items and retrieve them', () async {
    await database.insertOrUpdateItems([item1, item2]);

    final items = await database.getAllItems();

    expect(items.length, 2);
    expect(items.first.itemName, "Apple");
    expect(items.last.itemName, "Banana");
  });

  test('Insert updates existing items on conflict (based on ID)', () async {
    await database.insertOrUpdateItems([item1]);

    final updatedItem1 = Items(
      itemId: 1,
      barcode: "111",
      itemName: "Green Apple",
      costPrice: 120.0,
      itemCategory: "Fruit",
    );

    await database.insertOrUpdateItems([updatedItem1]);

    final items = await database.getAllItems();
    expect(items.length, 1);
    expect(items.first.itemName, "Green Apple");
    expect(items.first.costPrice, 120.0);
  });

  test('Search items filters correctly', () async {
    await database.insertOrUpdateItems([item1, item2]);

    final searchResults = await database.searchItems('Ban');

    expect(searchResults.length, 1);
    expect(searchResults.first.itemName, 'Banana');

    final emptyResults = await database.searchItems('Orange');
    expect(emptyResults, isEmpty);
  });
}
