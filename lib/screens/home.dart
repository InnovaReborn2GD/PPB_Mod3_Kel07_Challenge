import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import 'detail.dart';

class HomePage extends StatefulWidget {
  final Set<String> favoriteCountries;
  final ValueChanged<Country> onFavoriteToggle;

  const HomePage({
    super.key,
    required this.favoriteCountries,
    required this.onFavoriteToggle,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> countries;
  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    countries = fetchCountries();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse('https://www.apicountries.com/countries');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();

    if (response.statusCode == 200) {
      final respBody = await response.transform(utf8.decoder).join();
      final List jsonData = jsonDecode(respBody);
      return jsonData.map((j) => Country.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countries')),
      body: FutureBuilder<List<Country>>(
        future: countries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No countries found'));
          }

          final list = snapshot.data!
              .where(
                (country) => country.name.toLowerCase().contains(searchQuery),
              )
              .toList();
          return ListView.builder(
            itemCount: list.isEmpty ? 2 : list.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search country',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: searchController.clear,
                            ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }

              if (list.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No countries found')),
                );
              }

              final country = list[i - 1];
              return Card(
                child: ListTile(
                  leading: country.flagsPng != null
                      ? Image.network(country.flagsPng!, width: 50)
                      : const SizedBox(width: 50),
                  title: Text(country.name),
                  subtitle: Text(country.region),
                  trailing: IconButton(
                    icon: Icon(
                      widget.favoriteCountries.contains(country.name)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.favoriteCountries.contains(country.name)
                          ? Colors.red
                          : null,
                    ),
                    onPressed: () => widget.onFavoriteToggle(country),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          country: country,
                          isFavorite: widget.favoriteCountries.contains(
                            country.name,
                          ),
                          onFavoriteToggle: () =>
                              widget.onFavoriteToggle(country),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Country {
  final String name;
  final String region;
  final String? capital;
  final int population;
  final String? flagsPng;
  final List<dynamic>? languages;
  final List<dynamic>? currencies;

  Country({
    required this.name,
    required this.region,
    required this.population,
    this.capital,
    this.flagsPng,
    this.languages,
    this.currencies,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    List<dynamic>? langs;
    if (json['languages'] != null) {
      langs = (json['languages'] as List)
          .map((l) => l['name'].toString())
          .toList();
    }

    List<dynamic>? cur;
    if (json['currencies'] != null) {
      cur = (json['currencies'] as List)
          .map((c) => c['name'].toString())
          .toList();
    }

    return Country(
      name: json['name'] ?? 'N/A',
      region: json['region'] ?? 'N/A',
      population: json['population'] ?? 0,
      capital: json['capital'],
      flagsPng: json['flags'] != null ? json['flags']['png'] : null,
      languages: langs,
      currencies: cur,
    );
  }
}
