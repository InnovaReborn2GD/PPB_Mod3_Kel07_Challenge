import 'package:flutter/material.dart';

import '../screens/detail.dart';
import '../screens/favorites.dart';
import '../screens/home.dart';
import '../screens/profile.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  final Set<String> _favoriteCountries = {};
  List<Country> _countries = [];

  void _toggleFavorite(Country country) {
    setState(() {
      if (!_favoriteCountries.add(country.name)) {
        _favoriteCountries.remove(country.name);
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        favoriteCountries: _favoriteCountries,
        onFavoriteToggle: (country) {
          _countries = [..._countries, country]
              .fold<Map<String, Country>>({}, (map, item) {
                map[item.name] = item;
                return map;
              })
              .values
              .toList();
          _toggleFavorite(country);
        },
      ),
      FavoritesPage(
        countries: _countries,
        favoriteCountries: _favoriteCountries,
        onFavoriteToggle: _toggleFavorite,
      ),
      ProfilePage(onHomeTap: () => _onTabTapped(0)),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
