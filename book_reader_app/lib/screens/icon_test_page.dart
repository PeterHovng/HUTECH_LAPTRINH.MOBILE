import 'package:flutter/material.dart';

class IconTestPage extends StatelessWidget {
  const IconTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            // Test common icons
            _IconCard(Icons.home, 'home'),
            _IconCard(Icons.search, 'search'),
            _IconCard(Icons.favorite, 'favorite'),
            _IconCard(Icons.menu_book, 'menu_book'),
            _IconCard(Icons.launch, 'launch'),
            _IconCard(Icons.refresh, 'refresh'),
            _IconCard(Icons.add, 'add'),
            _IconCard(Icons.logout, 'logout'),
            _IconCard(Icons.book, 'book'),
            _IconCard(Icons.library_books, 'library_books'),
            _IconCard(Icons.smartphone, 'smartphone'),
            _IconCard(Icons.info_outline, 'info_outline'),
          ],
        ),
      ),
    );
  }
}

class _IconCard extends StatelessWidget {
  final IconData icon;
  final String name;

  const _IconCard(this.icon, this.name);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}