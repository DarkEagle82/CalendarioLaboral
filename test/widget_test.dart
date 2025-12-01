import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:calendario_laboral/main.dart';
import 'package:calendario_laboral/providers/calendar_provider.dart';
import 'package:calendario_laboral/providers/settings_provider.dart';
import 'package:calendario_laboral/providers/theme_provider.dart';
import 'package:calendario_laboral/screens/calendar_screen.dart';
import 'package:calendario_laboral/screens/settings_screen.dart';

void main() async {
  // Initialize locale data for tests
  await initializeDateFormatting('es_ES', null);

  testWidgets('Initial screen shows bottom navigation', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (context) => CalendarProvider(context.read<SettingsProvider>())),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the bottom navigation items are present.
    expect(find.text('Calendario'), findsWidgets);
    expect(find.text('Configuración'), findsOneWidget);
    expect(find.text('Resumen'), findsOneWidget);

    // Verify the initial screen is the Calendar screen
    expect(find.byType(CalendarScreen), findsOneWidget);
    expect(find.byType(SettingsScreen), findsNothing);
  });
}
