import 'package:flutter/material.dart';

import 'detail.dart';
import 'home.dart';

class FavoritesPage extends StatelessWidget {
  final List<Country> countries;
  final Set<String> favoriteCountries;
  final ValueChanged<Country> onFavoriteToggle;

  const FavoritesPage({
    super.key,
    required this.countries,
    required this.favoriteCountries,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final favorites = countries
        .where((country) => favoriteCountries.contains(country.name))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Countries')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorite countries yet'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final country = favorites[index];
                return ListTile(
                  leading: country.flagsPng == null
                      ? const SizedBox(width: 50)
                      : Image.network(country.flagsPng!, width: 50),
                  title: Text(country.name),
                  subtitle: Text(country.region),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => onFavoriteToggle(country),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(
                        country: country,
                        isFavorite: true,
                        onFavoriteToggle: () => onFavoriteToggle(country),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
