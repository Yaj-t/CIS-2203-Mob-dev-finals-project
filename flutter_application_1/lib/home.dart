import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'routes.dart';
import 'package:logger/logger.dart'; // Import the logger package

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    routes: routes,
  ));
}

class HomeScreen extends StatelessWidget {
  static const String routeName = "home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _HomeBodyPage(),
      ),
    );
  }
}

class _HomeBodyPage extends StatefulWidget {
  @override
  _HomeBodyPageState createState() => _HomeBodyPageState();
}

class _HomeBodyPageState extends State<_HomeBodyPage> {
  final Logger logger = Logger();
  List<dynamic> charactersData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    
    try {
      final int totalPages = await getTotalPages();

      if (totalPages > 0) {
        for (int currentPage = 1; currentPage <= totalPages; currentPage++) {
          final response = await http.get(
              Uri.parse('https://gsi.fly.dev/characters?page=$currentPage'));

          if (response.statusCode == 200) {
            final dynamic responseData = json.decode(response.body);

            if (responseData != null &&
                responseData['results'] is List<dynamic>) {
              setState(() {
                charactersData.addAll(responseData['results']);
              });
            } else {
              logger.e('Invalid data format received from the API');
            }
          } else {
            throw Exception('Failed to load data from the API');
          }
        }
      }
    } catch (e) {
      logger.e('Error fetching data: $e');
    }
  }

  Future<int> getTotalPages() async {
    final response =
        await http.get(Uri.parse('https://gsi.fly.dev/characters'));

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      return responseData['total_pages'] ?? 0;
    } else {
      throw Exception('Failed to get total pages from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: charactersData.isEmpty
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: charactersData.length,
              itemBuilder: (context, index) {
                final character = charactersData[index];
                final String name = character['name'];
                final String vision = character['vision'];

                return ListTile(
                  title: Text('$index: $name - Vision: $vision'),
                );
              },
            ),
    );
  }
}
