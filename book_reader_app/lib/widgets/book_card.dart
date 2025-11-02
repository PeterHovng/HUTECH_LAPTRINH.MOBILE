import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  const BookCard({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover - Tăng tỷ lệ để hiển thị hình đầy đủ hơn
            Expanded(
              flex: 4, // Tăng từ 3 lên 4
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8), // Thêm margin
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.grey.shade800 
                      : Colors.grey.shade50,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: 'book_${book.id}',
                    child: book.thumbnail != null
                        ? CachedNetworkImage(
                            imageUrl: book.thumbnail!,
                            fit: BoxFit.contain, // Thay đổi từ cover thành contain
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: (context, url) => Container(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey.shade800 
                                  : Colors.grey.shade50,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey.shade800 
                                  : Colors.grey.shade50,
                              child: Icon(
                                Icons.menu_book,
                                size: 40,
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.grey.shade600 
                                    : Colors.grey.shade400,
                              ),
                            ),
                          )
                        : Container(
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.grey.shade800 
                                : Colors.grey.shade50,
                            child: Icon(
                              Icons.menu_book,
                              size: 40,
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey.shade600 
                                  : Colors.grey.shade400,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            
            // Book info - Giảm tỷ lệ để tập trung vào hình ảnh
            Expanded(
              flex: 2, // Giữ nguyên
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            fontSize: 13,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      book.authors.isNotEmpty 
                          ? book.authors.join(', ') 
                          : 'Tác giả không rõ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            height: 1.1,
                            fontSize: 11,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
