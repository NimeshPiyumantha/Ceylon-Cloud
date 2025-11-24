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
    barcode: "C111",
    itemName: "Face Cream",
    costPrice: 750.0,
    itemCategory: "Cosmetic",
  );

  final item2 = Items(
    itemId: 2,
    barcode: "E222",
    itemName: "Headphones",
    costPrice: 2500.0,
    itemCategory: "Electronic",
  );

  test('Database starts empty', () async {
    final items = await database.getAllItems();
    expect(items, isEmpty);
  });

  test('Insert items and retrieve them', () async {
    await database.insertOrUpdateItems([item1, item2]);

    final items = await database.getAllItems();

    expect(items.length, 2);
    expect(items.first.itemName, "Face Cream");
    expect(items.last.itemName, "Headphones");
  });

  test('Insert updates existing items on conflict (based on ID)', () async {
    await database.insertOrUpdateItems([item1]);

    final updatedItem1 = Items(
      itemId: 1,
      barcode: "C111",
      itemName: "Moisturizer",
      costPrice: 900.0,
      itemCategory: "Cosmetic",
    );

    await database.insertOrUpdateItems([updatedItem1]);

    final items = await database.getAllItems();
    expect(items.length, 1);
    expect(items.first.itemName, "Moisturizer");
    expect(items.first.costPrice, 900.0);
  });

  test('Search items filters correctly', () async {
    await database.insertOrUpdateItems([item1, item2]);

    final searchResults = await database.searchItems('Head');

    expect(searchResults.length, 1);
    expect(searchResults.first.itemName, 'Headphones');

    final emptyResults = await database.searchItems('Laptop');
    expect(emptyResults, isEmpty);
  });
}
