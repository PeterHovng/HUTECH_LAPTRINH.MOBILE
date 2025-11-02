import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import '../widgets/app_components.dart';
import '../theme/app_theme.dart';
import 'book_detail_page.dart';

class GutenbergPage extends StatefulWidget {
  const GutenbergPage({super.key});

  @override
  State<GutenbergPage> createState() => _GutenbergPageState();
}

class _GutenbergPageState extends State<GutenbergPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Phổ biến';

  final List<String> _categories = [
    'Phổ biến',
    'Tiểu thuyết',
    'Triết học', 
    'Lịch sử',
    'Khoa học',
    'Thơ ca',
    'Phiêu lưu',
    'Lãng mạn',
    'Trinh thám'
  ];

  // Danh sách sách mẫu từ Project Gutenberg
  final List<Book> _sampleBooks = [
    Book(
      id: 'gutenberg_1',
      title: 'Alice\'s Adventures in Wonderland',
      authors: ['Lewis Carroll'],
      description: 'Câu chuyện cổ tích nổi tiếng về Alice và xứ sở thần tiên.',
      thumbnail: 'https://www.gutenberg.org/cache/epub/11/pg11.cover.medium.jpg',
      webReaderLink: 'https://www.gutenberg.org/files/11/11-h/11-h.htm',
      textUrl: 'https://www.gutenberg.org/files/11/11-0.txt',
    ),
    Book(
      id: 'gutenberg_2', 
      title: 'Pride and Prejudice',
      authors: ['Jane Austen'],
      description: 'Tiểu thuyết lãng mạn kinh điển về Elizabeth Bennet và Mr. Darcy.',
      thumbnail: 'https://www.gutenberg.org/cache/epub/1342/pg1342.cover.medium.jpg',
      webReaderLink: 'https://www.gutenberg.org/files/1342/1342-h/1342-h.htm',
      textUrl: 'https://www.gutenberg.org/files/1342/1342-0.txt',
    ),
    Book(
      id: 'gutenberg_3',
      title: 'The Adventures of Sherlock Holmes',
      authors: ['Arthur Conan Doyle'],
      description: 'Bộ sưu tập 12 câu chuyện đầu tiên về thám tử Sherlock Holmes.',
      thumbnail: 'https://www.gutenberg.org/cache/epub/1661/pg1661.cover.medium.jpg',
      webReaderLink: 'https://www.gutenberg.org/files/1661/1661-h/1661-h.htm',
      textUrl: 'https://www.gutenberg.org/files/1661/1661-0.txt',
    ),
    Book(
      id: 'gutenberg_4',
      title: 'A Christmas Carol',
      authors: ['Charles Dickens'],
      description: 'Câu chuyện Giáng sinh cổ điển về Ebenezer Scrooge.',
      thumbnail: 'https://www.gutenberg.org/cache/epub/19337/pg19337.cover.medium.jpg',
      webReaderLink: 'https://www.gutenberg.org/files/19337/19337-h/19337-h.htm',
      textUrl: 'https://www.gutenberg.org/files/19337/19337-0.txt',
    ),
    Book(
      id: 'gutenberg_5',
      title: 'Frankenstein',
      authors: ['Mary Wollstonecraft Shelley'],
      description: 'Tiểu thuyết kinh điển về Victor Frankenstein và quái vật của ông.',
      thumbnail: 'https://www.gutenberg.org/cache/epub/84/pg84.cover.medium.jpg',
      webReaderLink: 'https://www.gutenberg.org/files/84/84-h/84-h.htm',
      textUrl: 'https://www.gutenberg.org/files/84/84-0.txt',
    ),
    Book(
      id: 'gutenberg_6',
      title: 'The Great Gatsby',
      authors: ['F. Scott Fitzgerald'],
      description: 'Tiểu thuyết về Jazz Age và giấc mơ Mỹ.',
      thumbnail: 'https://www.gutenberg.org/cache/epub/64317/pg64317.cover.medium.jpg',
      webReaderLink: 'https://www.gutenberg.org/files/64317/64317-h/64317-h.htm',
      textUrl: 'https://www.gutenberg.org/files/64317/64317-0.txt',
    ),
  ];

  List<Book> get _filteredBooks {
    if (_searchController.text.isEmpty) {
      return _sampleBooks;
    }
    
    return _sampleBooks.where((book) =>
      book.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
      book.authors.any((author) => 
        author.toLowerCase().contains(_searchController.text.toLowerCase()))
    ).toList();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể mở liên kết: $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayBooks = _filteredBooks;

    return Scaffold(
      body: Column(
        children: [
          // Header với design system mới
          AppHeader(
            title: 'Project Gutenberg',
            subtitle: 'Hơn 70,000 sách điện tử miễn phí',
            gradient: AppColors.secondaryGradient,
            actions: [
              IconButton(
                onPressed: () => _launchURL('https://www.gutenberg.org'),
                icon: const Icon(Icons.public, color: Colors.white),
                tooltip: 'Mở trang web',
              ),
            ],
            child: Column(
              children: [
                AppSearchBar(
                  controller: _searchController,
                  hintText: 'Tìm sách kinh điển...',
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                CategoryPills(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Content area
          Expanded(
            child: AppContentContainer(
              child: displayBooks.isEmpty
                  ? AppEmptyState(
                      icon: Icons.search_off,
                      title: 'Không tìm thấy kết quả',
                      description: 'Thử tìm kiếm với từ khóa khác',
                      iconColor: AppColors.secondary,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: AppDimensions.paddingMedium,
                          mainAxisSpacing: AppDimensions.paddingMedium,
                        ),
                        itemCount: displayBooks.length,
                        itemBuilder: (context, index) {
                          final book = displayBooks[index];
                          return BookCard(
                            book: book,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailPage(book: book),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}