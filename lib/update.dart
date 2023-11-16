import 'package:flutter_note_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdatePage extends StatefulWidget {
  final Client client;
  final int id;
  final String note;
  const UpdatePage({
    Key? key,
    required this.client,
    required this.id,
    required this.note,
  }) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text = widget.note;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Update'),
      ),
      body: Column(
        children: [
          TextField(
            controller: controller,
            maxLength: 10,
          ),
          ElevatedButton(
              onPressed: () {
                widget.client.put(ApiEndpoints.updateNoteUrl(widget.id),
                    body: {"body": controller.text});
                Navigator.pop(context);
              },
              child: const Text("Update Note"))
        ],
      ),
    );
  }
}
