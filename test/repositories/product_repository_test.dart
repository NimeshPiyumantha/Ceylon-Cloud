import 'dart:convert';

import 'package:ceylon_product_app/database/app_database.dart';
import 'package:ceylon_product_app/globals.dart';
import 'package:ceylon_product_app/models/items.dart';
import 'package:ceylon_product_app/repositories/product_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_repository_test.mocks.dart';

@GenerateMocks([AppDatabase, http.Client])
void main() {
  late ProductRepository repository;
  late MockAppDatabase mockDb;
  late MockClient mockClient;

  final tItem = Items(
    itemId: 1,
    barcode: "C111",
    itemName: "Moisturizer",
    costPrice: 900.0,
    itemCategory: "Cosmetic",
  );

  final tItemsList = [tItem];

  final tUriString = "https://api.example.com/products";
  final tUri = Uri.parse(tUriString);

  setUpAll(() {
    dotenv.loadFromString(envString: 'API_URL=$tUriString');
  });

  setUp(() {
    mockDb = MockAppDatabase();
    mockClient = MockClient();
    repository = ProductRepository(mockDb, client: mockClient);
  });

  group('getProducts', () {
    test(
      'returns local data when not force refreshed and data exists',
      () async {
        when(mockDb.getAllItems()).thenAnswer((_) async => tItemsList);

        final result = await repository.getProducts(forceRefresh: false);

        expect(result, tItemsList);
        verify(mockDb.getAllItems()).called(1);
        verifyZeroInteractions(mockClient);
      },
    );

    test('calls API when forceRefresh is true', () async {
      final successResponse = jsonEncode([
        {
          "itemId": 1,
          "barcode": "C111",
          "itemName": "Moisturizer",
          "costPrice": 900.0,
          "itemCategory": "Cosmetic",
        },
      ]);

      when(
        mockClient.get(tUri),
      ).thenAnswer((_) async => http.Response(successResponse, 200));

      when(
        mockDb.insertOrUpdateItems(any),
      ).thenAnswer((_) async => Future.value());

      when(mockDb.getAllItems()).thenAnswer((_) async => tItemsList);

      final result = await repository.getProducts(forceRefresh: true);

      expect(result.length, 1);
      expect(result.first.itemName, "Moisturizer");

      verify(mockClient.get(tUri)).called(1);
      verify(mockDb.insertOrUpdateItems(any)).called(1);
    });

    test('calls API when local data is empty', () async {
      when(mockDb.getAllItems()).thenAnswer((_) async => []);

      final successResponse = jsonEncode([
        {
          "itemId": 1,
          "barcode": "C111",
          "itemName": "Moisturizer2",
          "costPrice": 900.0,
          "itemCategory": "Cosmetic",
        },
      ]);

      when(
        mockClient.get(tUri),
      ).thenAnswer((_) async => http.Response(successResponse, 200));

      when(
        mockDb.insertOrUpdateItems(any),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.getProducts(forceRefresh: false);

      expect(result.first.itemName, "Moisturizer2");
      verify(mockClient.get(tUri)).called(1);
    });

    test('returns local data on API failure if local data exists', () async {
      when(mockDb.getAllItems()).thenAnswer((_) async => tItemsList);
      when(mockClient.get(tUri)).thenThrow(Exception("Network Error"));

      final result = await repository.getProducts(forceRefresh: true);

      expect(result, tItemsList);
      verify(mockClient.get(tUri)).called(1);
      verify(mockDb.getAllItems()).called(1);
    });

    test('throws CustomException when API fails and no local data', () async {
      when(mockDb.getAllItems()).thenAnswer((_) async => []);
      when(
        mockClient.get(tUri),
      ).thenAnswer((_) async => http.Response("Not Found", 404));

      expect(
        () => repository.getProducts(forceRefresh: true),
        throwsA(isA<CustomException>()),
      );
    });
  });

  group('searchProducts', () {
    test('calls database search', () async {
      when(
        mockDb.searchItems("Moisturizer"),
      ).thenAnswer((_) async => tItemsList);

      final result = await repository.searchProducts("Moisturizer");

      expect(result, tItemsList);
      verify(mockDb.searchItems("Moisturizer")).called(1);
    });
  });
}
