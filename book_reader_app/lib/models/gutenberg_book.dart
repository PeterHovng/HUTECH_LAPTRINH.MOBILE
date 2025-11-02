import 'book.dart';

class GutenbergBook {
  final int id;
  final String title;
  final List<String> authors;
  final List<String> subjects;
  final List<String> languages;
  final int downloadCount;
  final Map<String, String> formats; // key: format, value: download URL
  final String? coverImageUrl;
  
  GutenbergBook({
    required this.id,
    required this.title,
    required this.authors,
    required this.subjects,
    required this.languages,
    required this.downloadCount,
    required this.formats,
    this.coverImageUrl,
  });

  factory GutenbergBook.fromJson(Map<String, dynamic> json) {
    // Extract authors
    final authorsData = json['authors'] as List<dynamic>? ?? [];
    final authors = authorsData
        .map((author) => author['name'] as String? ?? 'Unknown')
        .where((name) => name.isNotEmpty && name != 'Unknown')
        .toList();

    // Extract subjects
    final subjectsData = json['subjects'] as List<dynamic>? ?? [];
    final subjects = subjectsData.cast<String>();

    // Extract languages
    final languagesData = json['languages'] as List<dynamic>? ?? [];
    final languages = languagesData.cast<String>();

    // Extract formats
    final formatsData = json['formats'] as Map<String, dynamic>? ?? {};
    final formats = formatsData.map((key, value) => MapEntry(key, value.toString()));

    // Try to find cover image
    String? coverImageUrl;
    if (formats.containsKey('image/jpeg')) {
      coverImageUrl = formats['image/jpeg'];
    }

    return GutenbergBook(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Untitled',
      authors: authors.isEmpty ? ['Unknown Author'] : authors,
      subjects: subjects,
      languages: languages,
      downloadCount: json['download_count'] as int? ?? 0,
      formats: formats,
      coverImageUrl: coverImageUrl,
    );
  }

  // Convert to our Book model for compatibility
  Book toBook() {
    return Book(
      id: 'gutenberg_$id',
      title: title,
      authors: authors,
      description: subjects.isNotEmpty ? subjects.join(', ') : null,
      thumbnail: coverImageUrl,
      webReaderLink: getReadableUrl(),
    );
  }

  // Get the best URL for reading the book
  String? getReadableUrl() {
    // Prefer HTML format for web reading
    if (formats.containsKey('text/html')) {
      return formats['text/html'];
    }
    // Fallback to plain text
    if (formats.containsKey('text/plain; charset=utf-8')) {
      return formats['text/plain; charset=utf-8'];
    }
    if (formats.containsKey('text/plain')) {
      return formats['text/plain'];
    }
    return null;
  }

  // Get download URL for different formats
  String? getDownloadUrl(String format) {
    return formats[format];
  }

  // Get available formats for display
  List<String> getAvailableFormats() {
    return formats.keys.toList();
  }

  // Check if book has readable format
  bool get isReadable => getReadableUrl() != null;

  // Get reading difficulty level based on subjects
  String get difficultyLevel {
    final subjectsLower = subjects.map((s) => s.toLowerCase()).join(' ');
    if (subjectsLower.contains('children') || subjectsLower.contains('juvenile')) {
      return 'Dễ đọc';
    } else if (subjectsLower.contains('fiction') || subjectsLower.contains('literature')) {
      return 'Trung bình';
    } else if (subjectsLower.contains('philosophy') || subjectsLower.contains('science')) {
      return 'Khó';
    }
    return 'Trung bình';
  }
}