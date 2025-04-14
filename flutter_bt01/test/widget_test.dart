import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bt01/main.dart'; // 👈 Sửa tên package nếu cần

void main() {
  testWidgets('Splash screen shows group members and navigates to login',
      (WidgetTester tester) async {
    // Load app
    await tester.pumpWidget(MyApp());

    // Kiểm tra có Text chứa tên nhóm
    expect(find.text('👨‍💻 Thành viên nhóm:'), findsOneWidget);
    expect(find.textContaining('Nguyễn Hoàng Phương Ngân'), findsOneWidget);
    expect(find.textContaining('Ngô Ngọc Thông'), findsOneWidget);

    // Giả lập thời gian chờ 10s
    await tester.pump(Duration(seconds: 10));

    // Kiểm tra đã chuyển sang màn hình login
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Tên đăng nhập'), findsOneWidget);
    expect(find.text('Mật khẩu'), findsOneWidget);
  });
}
