import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'providers/theme_provider.dart';
import 'screens/main_page.dart';
import 'screens/sign_in_page.dart';
import 'services/auth_service.dart';
import 'services/books_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final booksService = BooksService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState(booksService)..init()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        StreamProvider<User?>(
          create: (_) => AuthService().authStateChanges(),
          initialData: null,
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Book Reader',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const _Root(),
        ),
      ),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) return const SignInPage();
    return const MainPage();
  }
}
