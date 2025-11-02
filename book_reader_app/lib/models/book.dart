class Book {
  final String id;
  final String title;
  final String? subtitle;
  final List<String> authors;
  final String? thumbnail;
  final String? description;
  final String? webReaderLink;
  final String? textUrl;

  Book({
    required this.id,
    required this.title,
    this.subtitle,
    required this.authors,
    this.thumbnail,
    this.description,
    this.webReaderLink,
    this.textUrl,
  });

  factory Book.fromVolume(Map<String, dynamic> v) {
    final info = v['volumeInfo'] ?? {};
    final access = v['accessInfo'] ?? {};
    return Book(
      id: v['id'] ?? '',
      title: info['title'] ?? 'Untitled',
      subtitle: info['subtitle'],
      authors: (info['authors'] as List?)?.cast<String>() ?? <String>[],
      thumbnail: (info['imageLinks'] ?? {})['thumbnail'],
      description: info['description'],
      webReaderLink: access['webReaderLink'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'authors': authors,
    'thumbnail': thumbnail,
    'description': description,
    'webReaderLink': webReaderLink,
    'textUrl': textUrl,
  };

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json['id'],
    title: json['title'],
    subtitle: json['subtitle'],
    authors: (json['authors'] as List).cast<String>(),
    thumbnail: json['thumbnail'],
    description: json['description'],
    webReaderLink: json['webReaderLink'],
    textUrl: json['textUrl'],
  );
}
