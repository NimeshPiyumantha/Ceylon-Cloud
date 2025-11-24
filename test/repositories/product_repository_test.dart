import 'dart:convert';
import 'package:ceylon_product_app/database/app_database.dart';
import 'package:ceylon_product_app/globals.dart';
import 'package:ceylon_product_app/models/items.dart';
import 'package:ceylon_product_app/repositories/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'product_repository_test.mocks.dart';

@GenerateMocks([AppDatabase, http.Client])
void main() {
  late ProductRepository repository;
  late MockAppDatabase mockDb;
  late MockClient mockClient;

  final tItem = Items(
    itemId: 1,
    barcode: "ABC",
    itemName: "Test Product",
    costPrice: 10.0,
    itemCategory: "Test",
  );

  final tItemsList = [tItem];

  final tUri = Uri.parse(
    "https://ceyloncloudtech.com:8443/smart/api/v1/user-login?username=admin&password=786786",
  );

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
      final successResponse = jsonEncode({
        "items": [
          {
            "itemId": 1,
            "barcode": "ABC",
            "itemName": "Test Product",
            "costPrice": 10.0,
            "itemCategory": "Test",
          },
        ],
      });

      when(
        mockClient.get(tUri),
      ).thenAnswer((_) async => http.Response(successResponse, 200));
      when(
        mockDb.insertOrUpdateItems(any),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.getProducts(forceRefresh: true);

      expect(result.length, 1);
      expect(result.first.itemName, "Test Product");
      verify(mockClient.get(tUri)).called(1);
      verify(mockDb.insertOrUpdateItems(any)).called(1);
    });

    test('calls API when local data is empty', () async {
      when(mockDb.getAllItems()).thenAnswer((_) async => []);

      final successResponse = jsonEncode([
        {
          "itemId": 1,
          "barcode": "ABC",
          "itemName": "API Product",
          "costPrice": 10.0,
          "itemCategory": "Test",
        },
      ]);

      when(
        mockClient.get(tUri),
      ).thenAnswer((_) async => http.Response(successResponse, 200));
      when(
        mockDb.insertOrUpdateItems(any),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.getProducts(forceRefresh: false);

      expect(result.first.itemName, "API Product");
      verify(mockClient.get(tUri)).called(1);
    });

    test('returns local data on API failure if local data exists', () async {
      var callCount = 0;
      when(mockDb.getAllItems()).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) return [];
        return tItemsList;
      });

      when(mockClient.get(tUri)).thenThrow(Exception("Network Error"));

      final result = await repository.getProducts(forceRefresh: false);

      expect(result, tItemsList);
      verify(mockClient.get(tUri)).called(1);
      verify(mockDb.getAllItems()).called(2);
    });

    test('throws CustomException when API fails and no local data', () async {
      when(mockDb.getAllItems()).thenAnswer((_) async => []); // Always empty
      when(
        mockClient.get(tUri),
      ).thenAnswer((_) async => http.Response("Not Found", 404));

      expect(() => repository.getProducts(), throwsA(isA<CustomException>()));
    });
  });

  group('searchProducts', () {
    test('calls database search', () async {
      when(mockDb.searchItems("Apple")).thenAnswer((_) async => tItemsList);

      final result = await repository.searchProducts("Apple");

      expect(result, tItemsList);
      verify(mockDb.searchItems("Apple")).called(1);
    });
  });
}
