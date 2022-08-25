import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';
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

  group("create e2e test", () {
    testWidgets("tap on floating action button", (tester) async {
      await restoreFlutterError(() async {
        app.main();
        await tester.pumpAndSettle();
      });

      // context to use localization files
      BuildContext context = tester.element(find.byType(Scaffold));

      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pumpAndSettle();

      final createScreen = find.byType(TodoCreateScreen);
      expect(createScreen, findsOneWidget);

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

      await tester.tap(find.text(DateFormat.d().format(DateTime.now()
          .add(const Duration(days: 1))))); // don't test at last day of month))
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
    });
  });
}
