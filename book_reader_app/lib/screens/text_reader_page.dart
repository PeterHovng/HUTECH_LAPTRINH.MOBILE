import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TextReaderPage extends StatefulWidget {
  final String title;
  final String textUrl;

  const TextReaderPage({
    super.key,
    required this.title,
    required this.textUrl,
  });

  @override
  State<TextReaderPage> createState() => _TextReaderPageState();
}

class _TextReaderPageState extends State<TextReaderPage> {
  String _content = '';
  bool _isLoading = true;
  String _errorMessage = '';
  
  // Cài đặt đọc sách
  double _fontSize = 16.0;
  double _lineHeight = 1.5;
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black87;
  bool _isDarkMode = false;
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadBookContent();
  }

  Future<void> _loadBookContent() async {
    try {
      final response = await http.get(Uri.parse(widget.textUrl));
      if (response.statusCode == 200) {
        setState(() {
          _content = response.body;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Không thể tải nội dung sách (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi kết nối: $e';
        _isLoading = false;
      });
    }
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      if (_isDarkMode) {
        _backgroundColor = const Color(0xFF1E1E1E);
        _textColor = Colors.white70;
      } else {
        _backgroundColor = Colors.white;
        _textColor = Colors.black87;
      }
    });
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cài đặt đọc sách',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 20),
              
              // Font Size
              Text('Kích thước chữ', style: TextStyle(color: _textColor)),
              Slider(
                value: _fontSize,
                min: 12.0,
                max: 24.0,
                divisions: 12,
                label: _fontSize.round().toString(),
                onChanged: (value) {
                  setModalState(() => _fontSize = value);
                  setState(() => _fontSize = value);
                },
              ),
              
              // Line Height
              Text('Khoảng cách dòng', style: TextStyle(color: _textColor)),
              Slider(
                value: _lineHeight,
                min: 1.0,
                max: 2.5,
                divisions: 15,
                label: _lineHeight.toStringAsFixed(1),
                onChanged: (value) {
                  setModalState(() => _lineHeight = value);
                  setState(() => _lineHeight = value);
                },
              ),
              
              // Dark Mode Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Chế độ tối', style: TextStyle(color: _textColor)),
                  Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setModalState(() {});
                      _toggleDarkMode();
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: _textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: _backgroundColor,
        iconTheme: IconThemeData(color: _textColor),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: _textColor),
            onPressed: _showSettingsBottomSheet,
          ),
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode, 
              color: _textColor,
            ),
            onPressed: _toggleDarkMode,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Đang tải nội dung sách...',
                    style: TextStyle(color: _textColor),
                  ),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = '';
                            });
                            _loadBookContent();
                          },
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(16),
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: SelectableText(
                        _content,
                        style: TextStyle(
                          fontSize: _fontSize,
                          height: _lineHeight,
                          color: _textColor,
                          fontFamily: 'serif',
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
      
      // Reading progress fab
      floatingActionButton: _content.isNotEmpty
          ? FloatingActionButton.small(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.vertical_align_top, color: Colors.white),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}