import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gutenberg_book.dart';

class GutendexService {
  static const String baseUrl = 'https://gutendx.com';
  
  // Search books with query
  Future<List<GutenbergBook>> searchBooks({
    String? query,
    String? language = 'en',
    String? topic,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'page': page.toString(),
      };

      if (query != null && query.isNotEmpty) {
        queryParams['search'] = query;
      }
      
      if (language != null && language.isNotEmpty) {
        queryParams['languages'] = language;
      }
      
      if (topic != null && topic.isNotEmpty) {
        queryParams['topic'] = topic;
      }

      final uri = Uri.parse('$baseUrl/books').replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>? ?? [];
        
        return results
            .map((json) => GutenbergBook.fromJson(json as Map<String, dynamic>))
            .where((book) => book.isReadable) // Only return readable books
            .toList();
      } else {
        throw Exception('Failed to search books: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching Gutenberg books: $e');
      return [];
    }
  }

  // Get popular books
  Future<List<GutenbergBook>> getPopularBooks({
    String? language = 'en',
    int limit = 20,
  }) async {
    return await searchBooks(
      language: language,
      page: 1,
      limit: limit,
    );
  }

  // Get books by specific topics
  Future<List<GutenbergBook>> getBooksByTopic(String topic, {
    String? language = 'en',
    int limit = 20,
  }) async {
    return await searchBooks(
      topic: topic,
      language: language,
      limit: limit,
    );
  }

  // Get featured/recommended books
  Future<List<GutenbergBook>> getFeaturedBooks() async {
    final List<Future<List<GutenbergBook>>> futures = [
      getBooksByTopic('Fiction'),
      getBooksByTopic('Literature'), 
      getBooksByTopic('Philosophy'),
      getBooksByTopic('Science'),
      getBooksByTopic('History'),
    ];

    final results = await Future.wait(futures);
    final allBooks = <GutenbergBook>[];
    
    for (final bookList in results) {
      allBooks.addAll(bookList.take(4)); // Take 4 books from each category
    }
    
    // Sort by download count and take top 20
    allBooks.sort((a, b) => b.downloadCount.compareTo(a.downloadCount));
    return allBooks.take(20).toList();
  }

  // Get book content URL for reading
  Future<String?> getBookContent(GutenbergBook book) async {
    return book.getReadableUrl();
  }

  // Get available topics/categories
  static const List<String> availableTopics = [
    'Fiction',
    'Literature', 
    'Philosophy',
    'Science',
    'History',
    'Poetry',
    'Drama',
    'Biography',
    'Adventure',
    'Mystery',
    'Romance',
    'Children',
    'Education',
    'Religion',
    'Travel',
  ];

  // Get books for children (easy reading)
  Future<List<GutenbergBook>> getChildrenBooks({int limit = 20}) async {
    return await getBooksByTopic('Children', limit: limit);
  }

  // Get classic literature
  Future<List<GutenbergBook>> getClassicLiterature({int limit = 20}) async {
    final fiction = await getBooksByTopic('Fiction', limit: limit ~/ 2);
    final literature = await getBooksByTopic('Literature', limit: limit ~/ 2);
    
    final combined = [...fiction, ...literature];
    combined.sort((a, b) => b.downloadCount.compareTo(a.downloadCount));
    return combined.take(limit).toList();
  }
}