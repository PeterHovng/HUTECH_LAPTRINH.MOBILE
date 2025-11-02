// lib/services/books_service.dart
import 'dart:convert';
import 'package:googleapis/books/v1.dart' as books;
import 'package:googleapis_auth/googleapis_auth.dart';

const String kGoogleBooksApiKey = 'AIzaSyAuv5oCEnK2ibN9fy_DogKU8p1Rgg9kMYI';

class BooksService {
  late final books.BooksApi _api;

  BooksService() {
    final client = clientViaApiKey(kGoogleBooksApiKey);
    _api = books.BooksApi(client);
  }

  Future<List<Map<String, dynamic>>> rawSearch(String query, {int startIndex = 0}) async {
    final res = await _api.volumes.list(
      query,
      maxResults: 20,
      startIndex: startIndex,
      printType: 'books',
      orderBy: 'relevance',
    );
    final items = res.items ?? [];
    return items.map((it) => jsonDecode(jsonEncode(it)) as Map<String, dynamic>).toList();
  }
}
