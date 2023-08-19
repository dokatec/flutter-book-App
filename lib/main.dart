import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  var titulo = "";
  var itemCount = 0;

  void _buscarLivros() async {
    titulo = _controller.text;
    final url = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      {'q': '{$titulo}'},
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      itemCount = jsonResponse['totalItems'];
      setState(() {});
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _controller),
            const SizedBox(height: 16),
            ElevatedButton.icon(
                onPressed: _buscarLivros,
                icon: const Icon(Icons.search),
                label: const Text('Pesquisar')),
            const SizedBox(height: 16),
            Text(
              'Foram encontrados $itemCount livros sobre $titulo ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
