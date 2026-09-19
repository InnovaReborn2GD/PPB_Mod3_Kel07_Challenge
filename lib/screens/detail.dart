import 'package:flutter/material.dart';

import 'home.dart';

class DetailPage extends StatefulWidget {
  final Country country;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const DetailPage({
    super.key,
    required this.country,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.name),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() => isFavorite = !isFavorite);
              widget.onFavoriteToggle();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.country.flagsPng != null)
              Center(
                child: Image.network(widget.country.flagsPng!, width: 200),
              ),
            const SizedBox(height: 16),
            Text(
              'Name: ${widget.country.name}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Capital: ${widget.country.capital ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Region: ${widget.country.region}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Population: ${widget.country.population}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Languages: ${widget.country.languages?.join(', ') ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Currencies: ${widget.country.currencies?.join(', ') ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
