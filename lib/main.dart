import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/providers/calendar_provider.dart';
import 'package:myapp/providers/color_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/screens/calendar_screen.dart';
import 'package:myapp/screens/settings_screen.dart';
import 'package:myapp/screens/summary_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ColorProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (context) => CalendarProvider(
            context.read<SettingsProvider>(),
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Calendario Laboral',
            theme: themeProvider.getTheme(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), 
              Locale('es', ''), 
            ],
            locale: const Locale('es'),
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0; // Explicitly manage the current index

  final List<Widget> _screens = [
    const CalendarScreen(),
    const SummaryScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _screens.length, vsync: this);
    // Add a listener to sync the index when swiping
    _tabController.addListener(() {
      if (_tabController.index != _currentIndex) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped, // Handle taps
        currentIndex: _currentIndex, // Use the explicit index
        selectedItemColor: themeProvider.getTheme().primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: l10n.calendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.summarize),
            label: l10n.summary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
