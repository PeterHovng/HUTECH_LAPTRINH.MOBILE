import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ReaderPage extends StatefulWidget {
  final String url;
  const ReaderPage({super.key, required this.url});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  bool _loading = true;
  bool _hasError = false;
  String? _errorMessage;
  late WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 10; SM-A205U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36'
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          setState(() {
            _loading = true;
            _hasError = false;
          });
        },
        onPageFinished: (String url) {
          setState(() => _loading = false);
          
          // Check if we're still on Google Books
          if (!url.contains('books.google')) {
            setState(() {
              _hasError = true;
              _errorMessage = 'Trang web đã chuyển hướng ra khỏi Google Books';
            });
          }
        },
        onWebResourceError: (WebResourceError error) {
          setState(() {
            _loading = false;
            _hasError = true;
            _errorMessage = error.description;
          });
        },
        onNavigationRequest: (NavigationRequest request) {
          // Check for external redirects
          if (!request.url.contains('books.google') && 
              !request.url.contains('accounts.google') &&
              !request.url.startsWith('data:')) {
            // Open external links in browser
            _launchExternalUrl(request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          // Handle JavaScript messages if needed
        },
      );

    _loadUrl();
  }

  Future<void> _launchExternalUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error
    }
  }

  void _loadUrl() {
    try {
      _controller.loadRequest(Uri.parse(widget.url));
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Không thể tải trang: $e';
        _loading = false;
      });
    }
  }

  Future<void> _openInExternalBrowser() async {
    try {
      final uri = Uri.parse(widget.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể mở trình duyệt external')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'Google Books WebView có vấn đề',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Đây là vấn đề phổ biến với Google Books khi nhúng vào ứng dụng mobile.',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            ElevatedButton.icon(
              onPressed: _openInExternalBrowser,
              icon: const Icon(Icons.launch),
              label: const Text('Mở trong Google Chrome'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            
            OutlinedButton.icon(
              onPressed: () {
                final embedUrl = widget.url.replaceAll(
                  'books.google.com.vn/books',
                  'books.google.com/books'
                ).replaceAll(
                  'books.google.com/books?',
                  'books.google.com/books/content?'
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReaderPage(url: embedUrl),
                  ),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử URL khác'),
            ),
            
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _loading = true;
                });
                _loadUrl();
              },
              icon: const Icon(Icons.replay),
              label: const Text('Thử lại WebView'),
            ),
            
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Gợi ý',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Google Books có thể hoạt động tốt hơn trong trình duyệt. '
                    'Một số sách có thể chỉ cho phép xem một vài trang miễn phí.',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đọc sách'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _hasError = false;
                _loading = true;
              });
              _loadUrl();
            },
            tooltip: 'Tải lại',
          ),
          IconButton(
            icon: const Icon(Icons.launch),
            onPressed: _openInExternalBrowser,
            tooltip: 'Mở trong trình duyệt',
          ),
        ],
      ),
      body: _hasError
          ? _buildErrorWidget()
          : Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_loading)
                  Container(
                    color: Colors.white,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Đang tải nội dung sách...'),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
