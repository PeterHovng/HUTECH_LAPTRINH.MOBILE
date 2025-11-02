import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/book.dart';
import '../services/books_service.dart';

class AppState extends ChangeNotifier {
  final BooksService booksService;

  AppState(this.booksService);

  List<Book> searchResults = [];
  bool isLoading = false;

  late Box<String> _favBox;
  final String _favBoxName = 'favorites';

  Future<void> init() async {
    await Hive.initFlutter();
    _favBox = await Hive.openBox<String>(_favBoxName);
    
    // Thêm một số sách mẫu vào kết quả tìm kiếm để demo
    _addSampleBooks();
  }

  void _addSampleBooks() {
    searchResults = [
      Book(
        id: 'sample_1',
        title: 'Harry Potter và Hòn đá Phù thủy',
        authors: ['J.K. Rowling'],
        description: 'Cuốn sách đầu tiên trong series Harry Potter nổi tiếng.',
        thumbnail: 'https://books.google.com/books/content?id=wrOQLV6xB-wC&printsec=frontcover&img=1&zoom=1',
        webReaderLink: 'https://books.google.com/books/reader?id=wrOQLV6xB-wC',
      ),
      Book(
        id: 'sample_2',
        title: 'Sherlock Holmes: A Study in Scarlet',
        authors: ['Arthur Conan Doyle'],
        description: 'Câu chuyện đầu tiên về thám tử Sherlock Holmes nổi tiếng.',
        thumbnail: 'https://books.google.com/books/content?id=L1lmAAAAMAAJ&printsec=frontcover&img=1&zoom=1',
        webReaderLink: 'https://books.google.com/books/reader?id=L1lmAAAAMAAJ',
      ),
      Book(
        id: 'sample_3',
        title: 'The Great Gatsby',
        authors: ['F. Scott Fitzgerald'],
        description: 'Tiểu thuyết kinh điển của văn học Mỹ.',
        thumbnail: 'https://books.google.com/books/content?id=iU9dDwAAQBAJ&printsec=frontcover&img=1&zoom=1',
        webReaderLink: 'https://books.google.com/books/reader?id=iU9dDwAAQBAJ',
      ),
      Book(
        id: 'sample_4',
        title: 'Dế Mèn Phiêu Lưu Ký',
        authors: ['Tô Hoài'],
        description: 'Tác phẩm văn học thiếu nhi nổi tiếng của Việt Nam.',
        thumbnail: 'https://via.placeholder.com/128x200/4CAF50/FFFFFF?text=D%E1%BA%BF+M%C3%A8n',
      ),
      Book(
        id: 'sample_5',
        title: 'Truyện Kiều',
        authors: ['Nguyễn Du'],
        description: 'Kiệt tác của văn học cổ điển Việt Nam.',
        thumbnail: 'https://via.placeholder.com/128x200/FF9800/FFFFFF?text=Truy%E1%BB%87n+Ki%E1%BB%81u',
      ),
    ];
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _addSampleBooks(); // Hiện lại sách mẫu khi không có tìm kiếm
      notifyListeners();
      return;
    }
    
    isLoading = true; 
    notifyListeners();
    
    try {
      final raw = await booksService.rawSearch(query);
      final apiResults = raw.map((m) => Book.fromVolume(m)).toList();
      
      // Kết hợp kết quả API với sách mẫu (nếu có liên quan)
      searchResults = apiResults;
      
      // Nếu API không trả về kết quả, hiển thị sách mẫu
      if (searchResults.isEmpty) {
        _addSampleBooks();
      }
    } catch (e) {
      // Nếu có lỗi API, hiển thị sách mẫu
      print('Lỗi tìm kiếm: $e');
      _addSampleBooks();
    } finally {
      isLoading = false; 
      notifyListeners();
    }
  }

  List<Book> get favorites {
    return _favBox.values
      .map((s) => Book.fromJson(jsonDecode(s)))
      .toList();
  }

  bool isFavorite(String id) => _favBox.containsKey(id);

  Future<void> toggleFavorite(Book b) async {
    if (isFavorite(b.id)) {
      await _favBox.delete(b.id);
    } else {
      await _favBox.put(b.id, jsonEncode(b.toJson()));
    }
    notifyListeners();
  }
}
