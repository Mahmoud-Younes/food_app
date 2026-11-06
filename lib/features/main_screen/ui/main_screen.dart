import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../home/logic/home_cubit.dart';
import '../../home/ui/home_screen.dart';
import '../../search/logic/search_cubit.dart';
import '../../search/ui/search_screen.dart';
import '../../favorites/ui/favorites_screen.dart';

/// Bottom navigation shell: Home / Search / Favorites tabs.
/// IndexedStack keeps every tab alive (state is not lost on switching).
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    homeCubit.loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>.value(value: homeCubit),
        BlocProvider<SearchCubit>.value(value: searchCubit),
      ],
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Semantics(
                identifier: 'nav-home',
                child: const Icon(Icons.home_outlined),
              ),
              activeIcon: Semantics(
                identifier: 'nav-home',
                child: const Icon(Icons.home_rounded),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Semantics(
                identifier: 'nav-search',
                child: const Icon(Icons.search_rounded),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Semantics(
                identifier: 'nav-favorites',
                child: const Icon(Icons.favorite_outline_rounded),
              ),
              activeIcon: Semantics(
                identifier: 'nav-favorites',
                child: const Icon(Icons.favorite_rounded),
              ),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
