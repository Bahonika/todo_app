import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/main.dart' as app;
import 'package:todo_app/presentation/components/date_format.dart';
import 'package:todo_app/presentation/localization/s.dart';
import 'package:todo_app/presentation/screens/todo_create_screen.dart';

Future<void> restoreFlutterError(Future<void> Function() call) async {
  final originalOnError = FlutterError.onError!;
  await call();
  final overriddenOnError = FlutterError.onError!;

  // restore FlutterError.onError
  FlutterError.onError = (FlutterErrorDetails details) {
    if (overriddenOnError != originalOnError) overriddenOnError(details);
    originalOnError(details);
  };
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("create e2e test", (tester) async {
    await restoreFlutterError(() async {
      app.main();
      await tester.pumpAndSettle();
    });

    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);

    await tester.tap(fab);
    await tester.pumpAndSettle();

    final createScreen = find.byType(TodoCreateScreen);
    expect(createScreen, findsOneWidget);
    BuildContext context = tester
        .element(find.byType(Scaffold)); // context to use localization files

    final textField = find.byType(TextFieldTile);
    expect(textField, findsOneWidget);

    await tester.tap(textField);
    await tester.pumpAndSettle();

    await tester.enterText(textField, "test");
    await tester.pumpAndSettle();

    final switcher = find.byType(Switch);
    await tester.tap(switcher);
    await tester.pumpAndSettle();

    final dateText = find.text(MyDateFormat().localeFormat(DateTime.now()));
    await tester.tap(dateText);
    await tester.pumpAndSettle();

    final nextButton = find.byTooltip("Next month");
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    await tester.tap(find.text("1"));
    await tester.pumpAndSettle();

    await tester.tap(find.text(S.of(context).datePickerDone));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<Importance>));
    await tester.pumpAndSettle();
    await tester.tap(
      find.text(S.of(context).low).last,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(S.of(context).save));
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 2));

    final firstScreen = find.byWidgetPredicate((Widget widget) =>
        widget is RichText && widget.text.toPlainText().endsWith("test"));

    expect(firstScreen, findsOneWidget);

    await tester.drag(firstScreen, const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(firstScreen, findsNothing);


  });
}
