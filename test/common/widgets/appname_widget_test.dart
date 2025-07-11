import 'package:bloc_with_mvvm/common/widgets/appname_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget createWidget({Color? greenColorTitle}) {
    return MaterialApp(
      home: Scaffold(
        body: AppNameWidget(greenColorTitle: greenColorTitle),
      ),
    );
  }

  testWidgets('shows Text on initial', (widgetTester) async {
    await widgetTester.pumpWidget(createWidget());

    final richText = widgetTester.widget<RichText>(find.byType(RichText));
    final textSpan = richText.text as TextSpan;
    expect(textSpan.style?.fontSize, 30.0);

    expect(textSpan.toPlainText(), 'Greengrocer');
    expect((textSpan.children![0] as TextSpan).text, 'Green'); // First part
    expect((textSpan.children![1] as TextSpan).text, 'grocer'); // Second part

  });




  testWidgets('applies custom greenColorTitle', (WidgetTester tester) async {
    const customGreen = Colors.green;

    await tester.pumpWidget(createWidget(greenColorTitle: customGreen));

    final richText = tester.widget<RichText>(find.byType(RichText));
    final rootSpan = richText.text as TextSpan;
    final greenSpan = rootSpan.children![0] as TextSpan;
    
    expect(greenSpan.style?.color, customGreen); // ✅ Will pass now
  });
}
