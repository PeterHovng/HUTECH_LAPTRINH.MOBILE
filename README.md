# HUTECH_LAPTRINH.MOBILE - Flutter Book Reader App
Đồ án học phần "Lập trình trên thiết bị di động". Ứng dụng đọc sách được phát triển bằng Flutter, tích hợp Firebase Authentication để đăng nhập bằng Google và sử dụng Google Books API để tìm kiếm, hiển thị và đọc sách trực tuyến. Dự án này được xây dựng với mục tiêu minh họa cách kết hợp giữa dịch vụ Google, Firebase và Flutter trong một ứng dụng hoàn chỉnh.

## Giới thiệu
Ứng dụng cho phép người dùng:
- Đăng nhập bằng tài khoản Google thông qua Firebase Authentication.
- Tìm kiếm và hiển thị thông tin sách từ Google Books API.
- Xem mô tả, ảnh bìa và chi tiết từng cuốn sách.
- Lưu danh sách sách yêu thích vào cơ sở dữ liệu cục bộ bằng Hive.
- Đọc sách trực tiếp trong ứng dụng thông qua WebView.
- Quản lý trạng thái và dữ liệu người dùng bằng Provider và Shared Preferences.

## Công nghệ và thư viện sử dụng
| Thư viện / Gói | Phiên bản | Mục đích sử dụng |
|-----------------|------------|------------------|
| **flutter** | sdk | Nền tảng chính để phát triển ứng dụng. |
| **cupertino_icons** | ^1.0.5 | Cung cấp bộ icon theo phong cách iOS. |
| **googleapis** | ^15.0.0 | Giao tiếp với Google Books API để truy xuất dữ liệu sách. |
| **googleapis_auth** | ^1.2.0 | Hỗ trợ xác thực OAuth 2.0 cho API của Google. |
| **http** | ^1.5.0 | Gửi yêu cầu và nhận phản hồi HTTP từ máy chủ. |
| **firebase_core** | ^2.10.0 | Kết nối ứng dụng với Firebase Project. |
| **firebase_auth** | ^4.4.0 | Xử lý đăng nhập và xác thực người dùng Firebase. |
| **google_sign_in** | ^6.1.0 | Cho phép người dùng đăng nhập bằng tài khoản Google. |
| **provider** | ^6.0.5 | Quản lý trạng thái ứng dụng theo mô hình reactive. |
| **hive** | ^2.2.3 | Cơ sở dữ liệu NoSQL nhẹ để lưu dữ liệu cục bộ. |
| **hive_flutter** | ^1.1.0 | Tích hợp Hive với môi trường Flutter. |
| **path_provider** | ^2.0.15 | Lấy đường dẫn lưu trữ dữ liệu trong thiết bị. |
| **cached_network_image** | ^3.2.4 | Tải và cache hình ảnh từ mạng, giúp tăng hiệu năng. |
| **webview_flutter** | ^4.0.7 | Nhúng trình duyệt WebView để hiển thị nội dung sách. |
| **url_launcher** | ^6.1.12 | Mở liên kết hoặc URL ngoài từ ứng dụng. |
| **shared_preferences** | ^2.2.2 | Lưu trữ dữ liệu đơn giản như tùy chọn hoặc trạng thái người dùng. |
| **flutter_test** | sdk | Dùng để viết và chạy unit test. |
| **flutter_lints** | latest | Bộ quy tắc lint giúp giữ chất lượng mã nguồn. |

## Hướng dẫn cài đặt
1. Clone dự án về máy:
   ~~~bash
   git clone https://github.com/yourusername/flutter-book-reader.git
   ~~~
2. Cài đặt các dependencies:
   ~~~bash
   flutter pub get
   ~~~
3. Cấu hình Firebase:
   - Truy cập [Firebase Console](https://console.firebase.google.com/)
   - Tạo dự án mới và bật **Authentication → Sign-in method → Google**
   - Tải file cấu hình:
     - Android: `google-services.json`
     - iOS: `GoogleService-Info.plist`
   - Thêm các file này vào đúng thư mục của dự án.
4. Chạy ứng dụng:
   ~~~bash
   flutter run
   ~~~

## Cấu trúc thư mục (tham khảo)
~~~
lib/
│
├── main.dart
├── models/
├── screens/
├── services/
├── providers/
├── widgets/
└── utils/
~~~

---
