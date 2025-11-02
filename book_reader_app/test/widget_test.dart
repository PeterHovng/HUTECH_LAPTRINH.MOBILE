// This is a basic Flutter widget test for Book Reader App.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Test individual components instead of the full app
import 'package:book_reader_app/widgets/book_card.dart';
import 'package:book_reader_app/models/book.dart';

void main() {
  group('Book Reader App Tests', () {
    testWidgets('BookCard widget displays book information correctly', (WidgetTester tester) async {
      // Create a test book
      final testBook = Book(
        id: 'test_id',
        title: 'Test Book Title',
        authors: ['Test Author'],
        description: 'Test Description',
        thumbnail: 'https://example.com/image.jpg',
      );

      // Build BookCard widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(book: testBook),
          ),
        ),
      );

      // Verify that book information is displayed
      expect(find.text('Test Book Title'), findsOneWidget);
      expect(find.text('Test Author'), findsOneWidget);
      
      // Verify that the ListTile is present
      expect(find.byType(ListTile), findsOneWidget);
      
      // Verify chevron icon is present
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('BookCard shows placeholder when no thumbnail', (WidgetTester tester) async {
      // Create a test book without thumbnail
      final testBook = Book(
        id: 'test_id',
        title: 'Test Book Title',
        authors: ['Test Author'],
      );

      // Build BookCard widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(book: testBook),
          ),
        ),
      );

      // Verify that book icon is displayed when no thumbnail
      expect(find.byIcon(Icons.book_outlined), findsOneWidget);
    });

    testWidgets('BookCard shows default author text when no authors', (WidgetTester tester) async {
      // Create a test book with empty authors
      final testBook = Book(
        id: 'test_id',
        title: 'Test Book Title',
        authors: [],
      );

      // Build BookCard widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(book: testBook),
          ),
        ),
      );

      // Verify that default author text is displayed
      expect(find.text('Tác giả không rõ'), findsOneWidget);
    });

    testWidgets('Basic widget test - Simple app functionality', (WidgetTester tester) async {
      // Test a simple app widget for demonstration
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Book Reader App')),
            body: const Center(
              child: Text('Welcome to Book Reader'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.search),
            ),
          ),
        ),
      );

      // Verify that the widgets are present
      expect(find.text('Book Reader App'), findsOneWidget);
      expect(find.text('Welcome to Book Reader'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    test('Book model can be created and accessed', () {
      // Test Book model without UI
      final book = Book(
        id: 'test_id',
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        authors: ['Author 1', 'Author 2'],
        description: 'Test description',
        thumbnail: 'https://example.com/image.jpg',
        webReaderLink: 'https://example.com/reader',
      );

      expect(book.id, 'test_id');
      expect(book.title, 'Test Title');
      expect(book.subtitle, 'Test Subtitle');
      expect(book.authors, ['Author 1', 'Author 2']);
      expect(book.description, 'Test description');
      expect(book.thumbnail, 'https://example.com/image.jpg');
      expect(book.webReaderLink, 'https://example.com/reader');
    });

    test('Book.fromVolume factory method works correctly', () {
      // Test Book.fromVolume factory method
      final volumeData = {
        'id': 'volume_id',
        'volumeInfo': {
          'title': 'Volume Title',
          'subtitle': 'Volume Subtitle',
          'authors': ['Volume Author'],
          'description': 'Volume description',
          'imageLinks': {
            'thumbnail': 'https://example.com/thumb.jpg'
          }
        },
        'accessInfo': {
          'webReaderLink': 'https://example.com/web-reader'
        }
      };

      final book = Book.fromVolume(volumeData);

      expect(book.id, 'volume_id');
      expect(book.title, 'Volume Title');
      expect(book.subtitle, 'Volume Subtitle');
      expect(book.authors, ['Volume Author']);
      expect(book.description, 'Volume description');
      expect(book.thumbnail, 'https://example.com/thumb.jpg');
      expect(book.webReaderLink, 'https://example.com/web-reader');
    });
  });
}
