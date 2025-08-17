import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twenty_forty_eight/main.dart';

void main() {
  testWidgets('Board resizes correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // initial board size 4x4
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(GestureDetector), findsOneWidget);

    // there should be 16 tiles
    expect(find.byType(Container), findsWidgets);

    // Change board size to 5x5
    await tester.tap(find.byType(DropdownButton<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('5x5').last);
    await tester.pumpAndSettle();

    // board should rebuild
    expect(find.byType(GridView), findsOneWidget);
  });
}
