import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../database/app_database.dart';
import '../models/items.dart';
import '../globals.dart';

class ProductRepository {
  final AppDatabase db;
  final http.Client client;

  ProductRepository(this.db, {http.Client? client})
    : client = client ?? http.Client();

  final String apiUrl = dotenv.env['API_URL']!;

  Future<List<Items>> getProducts({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final localItems = await db.getAllItems();
      if (localItems.isNotEmpty) return localItems;
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic responseBody = jsonDecode(response.body);
        List<dynamic> data;

        if (responseBody is List) {
          data = responseBody;
        } else {
          data = responseBody['items'] ?? [];
        }

        final List<Items> items = data.map((e) => Items.fromJson(e)).toList();

        await db.insertOrUpdateItems(items);
        return items;
      } else {
        throw CustomException(
          message: "Failed to load API: ${response.statusCode}",
          errorCode: response.statusCode,
        );
      }
    } catch (e) {
      final localItems = await db.getAllItems();
      if (localItems.isNotEmpty) return localItems;

      if (e is CustomException) rethrow;
      throw CustomException(message: e.toString());
    }
  }

  Future<List<Items>> searchProducts(String query) async {
    return await db.searchItems(query);
  }
}
