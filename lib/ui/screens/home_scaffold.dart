import 'package:flutter/material.dart';
import 'journal_screen.dart';

import 'therapy_history_screen.dart';
import 'dreams_screen.dart';
import 'echoes_screen.dart';

import '../widgets/background_wrapper.dart';

import 'package:psicolog/l10n/app_localizations.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DreamsScreen(),
    JournalScreen(),
    TherapyHistoryScreen(),
    EchoesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundWrapper(child: _screens[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.nights_stay_outlined),
            selectedIcon: const Icon(Icons.nights_stay),
            label: l10n.navDreams,
          ),
          NavigationDestination(
            icon: const Icon(Icons.book_outlined),
            selectedIcon: const Icon(Icons.book),
            label: l10n.navJournal,
          ),
          NavigationDestination(
            icon: const Icon(Icons.self_improvement_outlined),
            selectedIcon: const Icon(Icons.self_improvement),
            label: l10n.navTherapy,
          ),
          NavigationDestination(
            icon: const Icon(Icons.graphic_eq),
            selectedIcon: const Icon(Icons.graphic_eq),
            label: l10n.navEchoes,
          ),
        ],
      ),
    );
  }
}
