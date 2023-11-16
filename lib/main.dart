import 'dart:convert';
import 'dart:developer';

import 'package:flutter_note_app/create.dart';
import 'package:flutter_note_app/note.dart';
import 'package:flutter_note_app/update.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Note App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Map<String, dynamic>> endpointList = [
  {
    "Endpoint": "/notes/",
    "method": "GET",
    "body": null,
    "description": "Returns an array of notes"
  },
  {
    "Endpoint": "/notes/id",
    "method": "GET",
    "body": null,
    "description": "Returns a single notes object"
  },
  {
    "Endpoint": "/notes/create/",
    "method": "POST",
    "body": {"body": ""},
    "description": "Creates new note with data sent in post request"
  },
  {
    "Endpoint": "/notes/id/updates",
    "method": "PUT",
    "body": {"body": ""},
    "description": "Creates an existing note with data sent in post request"
  },
  {
    "Endpoint": "/notes/id/delete/",
    "method": "DELETE",
    "body": null,
    "description": "Deletes an existing note"
  },
];

class ApiEndpoints {
  static String baseUrl =
      "http://192.168.0.134:8000"; // Replace with your actual base URL

  static Uri getNotesUrl() {
    return Uri.parse('$baseUrl/notes/');
  }

  static Uri getNoteUrl(int id) {
    return Uri.parse('$baseUrl/notes/$id/');
  }

  static Uri createNoteUrl() {
    return Uri.parse('$baseUrl/notes/create/');
  }

  static Uri updateNoteUrl(int id) {
    return Uri.parse('$baseUrl/notes/$id/update/');
  }

  static Uri deleteUrl(int id) {
    return Uri.parse('$baseUrl/notes/$id/delete/');
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Client client = http.Client();
  List<Note> notes = [];
  Uri retrieveUrl = ApiEndpoints.getNotesUrl();

  @override
  void initState() {
    _retrieveNotes();
    super.initState();
  }

  _retrieveNotes() async {
    try {
      notes = [];

      http.Response response = await client.get(retrieveUrl);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        for (var element in data) {
          notes.add(Note.fromMap(element));
        }

        setState(() {});
      } else {
        log("Failed to retrieve data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("Error retrieving data: $e");
    }
  }

  void _deleteNote(int id) {
    client.delete(ApiEndpoints.deleteUrl(id));
    _retrieveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _retrieveNotes();
        },
        child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(notes[index].note),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdatePage(
                            client: client,
                            id: notes[index].id,
                            note: notes[index].note,
                          )));
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteNote(notes[index].id),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreatePage(
                    client: client,
                  )));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
