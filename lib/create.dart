import 'package:flutter_note_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CreatePage extends StatefulWidget {
  final Client client;

  const CreatePage({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Create'),
      ),
      body: Column(
        children: [
          TextField(
            controller: controller,
            maxLength: 10,
          ),
          ElevatedButton(
              onPressed: () {
                widget.client.post(ApiEndpoints.createNoteUrl(),
                    body: {"body": controller.text});
                Navigator.pop(context);
              },
              child: const Text("Create Note"))
        ],
      ),
    );
  }
}
