import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:todo_app/presentation/components/visibility_switcher.dart';
import 'package:todo_app/presentation/theme/theme.dart';

void main() {
  testWidgets('visibility icon', (tester) async {
    var counter = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: CustomTheme.lightTheme,
        home: Scaffold(
          body: VisibilitySwitcher(
            isFilterOff: true,
            onToggle: () => counter++,
          ),
        ),
      ),
    );

    final icon = find.byType(Icon);

    expect(icon, findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Icon && Icons.visibility_off == widget.icon,
      ),
      findsOneWidget,
    );
    expect(counter, 0);
    await tester.tap(icon);
    await tester.pumpAndSettle();

    expect(icon, findsOneWidget);
    expect(counter, 1);

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Icon && Icons.visibility_off == widget.icon,
      ),
      findsOneWidget,
    );
  });

  testWidgets('visibility off switch golden', (tester) async {
    await loadAppFonts();

    await tester.pumpWidget(
      MaterialApp(
        theme: CustomTheme.lightTheme,
        home: const Scaffold(
          body: VisibilitySwitcher(
            isFilterOff: true,
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(VisibilitySwitcher),
      matchesGoldenFile('goldens/visibility_off.png'),
    );
  });

  testWidgets('visibility switch golden', (tester) async {
    await loadAppFonts();

    await tester.pumpWidget(
      MaterialApp(
        theme: CustomTheme.lightTheme,
        home: const Scaffold(
          body: VisibilitySwitcher(
            isFilterOff: false,
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(VisibilitySwitcher),
      matchesGoldenFile('goldens/visibility.png'),
    );
  });
}

