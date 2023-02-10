import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<dynamic> _listData = [
    {"name": "Usmokhan", "id": "1"},
    {"name": "Umar Khan", "id": "2"},
    {"name": "Bobomurad", "id": "3"},
    {"name": "Heow", "id": "4"}
  ];
  List<dynamic> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoritesString = prefs.getString('favorites');
    if (favoritesString != null) {
      _favorites = jsonDecode(favoritesString);
    }
    setState(() {});
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(_favorites));
  }

  void _toggleFavorite(int index) {
    dynamic item = _listData[index];
    int favoriteIndex = _favorites.indexWhere((f) => f['id'] == item['id']);
    if (favoriteIndex == -1) {
      _favorites.add(item);
    } else {
      _favorites.removeAt(favoriteIndex);
    }
    _saveFavorites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _loadFavorites();
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: ListView.builder(
        itemCount: _listData.length,
        itemBuilder: (context, index) {
          dynamic item = _listData[index];
          bool isFavorite = _favorites.any((f) => f['id'] == item['id']);
          return ListTile(
            title: Text(item['name']),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(item),
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () => _toggleFavorite(index),
            ),
          );
        },
      ),
    );
  }
}

class DetailsPage extends StatefulWidget {
  final dynamic item;

  const DetailsPage(this.item);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<dynamic> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoritesString = prefs.getString('favorites');
    if (favoritesString != null) {
      _favorites = jsonDecode(favoritesString);
    }
    setState(() {});
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(_favorites));
  }

  void _toggleFavorite() {
    dynamic item = widget.item;
    int favoriteIndex = _favorites.indexWhere((f) => f['id'] == item['id']);
    if (favoriteIndex == -1) {
      _favorites.add(item);
    } else {
      _favorites.removeAt(favoriteIndex);
    }
    _saveFavorites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    dynamic item = widget.item;
    bool isFavorite = _favorites.any((f) => f['id'] == item['id']);
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Center(
        child: Text(item['name']),
      ),
    );
  }
}
