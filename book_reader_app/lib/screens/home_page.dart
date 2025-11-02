import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_state.dart';
import '../services/auth_service.dart';
import '../widgets/book_card.dart';
import '../widgets/app_components.dart';
import '../theme/app_theme.dart';
import 'book_detail_page.dart';
import 'icon_test_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final AuthService _auth = AuthService();
  int _tab = 0;

  Widget _buildEmptyState(BuildContext context) {
    return AppEmptyState(
      icon: Icons.search,
      title: 'Tìm kiếm sách yêu thích',
      description: 'Nhập từ khóa để tìm kiếm hàng triệu cuốn sách từ thư viện Google Books',
      action: Column(
        children: [
          FilledButton.icon(
            onPressed: () {
              final appState = context.read<AppState>();
              appState.search('Harry Potter');
              _searchCtrl.text = 'Harry Potter';
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Thử tìm "Harry Potter"'),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          OutlinedButton.icon(
            onPressed: () {
              _launchURL('https://www.gutenberg.org/browse/scores/top');
            },
            icon: const Icon(Icons.public),
            label: const Text('Project Gutenberg - Sách miễn phí'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingXLarge,
                vertical: AppDimensions.paddingSmall + 4,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            'Hàng nghìn cuốn sách kinh điển miễn phí',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesEmptyState(BuildContext context) {
    return AppEmptyState(
      icon: Icons.favorite_border,
      title: 'Chưa có sách yêu thích',
      description: 'Hãy tìm kiếm và thêm sách vào danh sách yêu thích để xem ở đây',
      iconColor: Colors.pink,
      action: FilledButton.icon(
        onPressed: () => setState(() => _tab = 0),
        icon: const Icon(Icons.search),
        label: const Text('Khám phá sách'),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.pink,
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Book Reader',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingSmall),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        child: const Icon(
          Icons.menu_book,
          color: Colors.white,
          size: 32,
        ),
      ),
      children: [
        const Text(
          'Ứng dụng đọc sách trực tuyến sử dụng Google Books API. '
          'Khám phá và đọc hàng triệu cuốn sách miễn phí.',
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        Text(
          'Phát triển bởi Flutter',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
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
    final app = context.watch<AppState>();

    final body = (_tab == 0)
        ? Column(
            children: [
              // Header với design mới
              AppHeader(
                title: 'Google Books',
                subtitle: 'Khám phá hàng triệu cuốn sách',
                actions: [
                  IconButton(
                    icon: const Icon(Icons.bug_report, color: Colors.white),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const IconTestPage()),
                    ),
                    tooltip: 'Test Icons',
                  ),
                ],
                child: AppSearchBar(
                  controller: _searchCtrl,
                  hintText: 'Tìm sách theo tên, tác giả, ISBN...',
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      app.search(query);
                    } else {
                      app.search(''); // Clear results
                    }
                  },
                ),
              ),
              
              // Content area
              Expanded(
                child: AppContentContainer(
                  child: app.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : app.searchResults.isEmpty
                          ? _buildEmptyState(context)
                          : Padding(
                              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7, // Tăng từ 0.65 lên 0.7
                                  crossAxisSpacing: AppDimensions.paddingMedium,
                                  mainAxisSpacing: AppDimensions.paddingMedium,
                                ),
                                itemCount: app.searchResults.length,
                                itemBuilder: (context, i) {
                                  final book = app.searchResults[i];
                                  return BookCard(
                                    book: book,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BookDetailPage(book: book),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              ),
            ],
          )
        : app.favorites.isEmpty
            ? _buildFavoritesEmptyState(context)
            : AppContentContainer(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7, // Tăng từ 0.65 lên 0.7
                      crossAxisSpacing: AppDimensions.paddingMedium,
                      mainAxisSpacing: AppDimensions.paddingMedium,
                    ),
                    itemCount: app.favorites.length,
                    itemBuilder: (context, i) {
                      final book = app.favorites[i];
                      return BookCard(
                        book: book,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
                        ),
                      );
                    },
                  ),
                ),
              );

    return Scaffold(
      backgroundColor: _tab == 0 ? null : AppColors.background,
      appBar: _tab == 0 ? null : AppBar(
        title: const Text(
          'Sách yêu thích',
          style: AppTextStyles.titleLarge,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'logout':
                  _auth.signOut();
                  break;
                case 'about':
                  _showAboutDialog(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'about',
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Về ứng dụng'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Đăng xuất'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.all(AppDimensions.paddingSmall),
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: AppShadows.headerShadow,
        ),
        child: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          elevation: 0,
          backgroundColor: Colors.white,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Khám phá',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Yêu thích',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
}