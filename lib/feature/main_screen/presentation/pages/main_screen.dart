import 'package:bloc_with_mvvm/feature/nav_screen/category/presentation/pages/category_screen.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/favorite/presentation/pages/fav_screen.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/settings/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../nav_screen/home/presentation/pages/home_screen.dart';
import '../bloc/bottom_bloc.dart';

class MainScreen extends StatelessWidget {
  final BottomNavBloc? bloc;

  const MainScreen({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BottomNavBloc>(
      create: (_) => bloc ?? BottomNavBloc(),
      child: Scaffold(
        body: BlocBuilder<BottomNavBloc, int>(
          builder: (context, selectedIndex) {
            return IndexedStack(
              index: selectedIndex,
              children: const [
                HomeScreen(),
                CategoryScreen(),
                FavoriteScreen(),
                SettingsScreen(),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<BottomNavBloc, int>(
          builder: (context, selectedIndex) {
            return BottomNavigationBar(
              currentIndex: selectedIndex,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                context.read<BottomNavBloc>().add(BottomNavEvent.values[index]);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Category'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
              ],
            );
          },
        ),
      ),
    );
  }
}

