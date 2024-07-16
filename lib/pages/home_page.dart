import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasecrud/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //service criado para fazer operações no banco de dados
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController textController = TextEditingController();

  //pop up para adicionar ou atualizar
  void openNoteBox({String? docId}) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: TextField(controller: textController),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (docId == null) {
                      firestoreService.addNote(textController.text);
                    } else {
                      firestoreService.updateNote(docId, textController.text);
                    }
                    textController.clear();

                    Navigator.pop(context);
                  },
                  child: const Text("Add"))
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CRUD")),
      floatingActionButton: FloatingActionButton(
          onPressed: openNoteBox, child: const Icon(Icons.add)),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                String noteText = data['note'];

                return ListTile(
                    title: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () => openNoteBox(docId: docID),
                            icon: const Icon(Icons.update)),
                        IconButton(
                            onPressed: () => firestoreService.deleteNote(docID),
                            icon: const Icon(Icons.delete)),
                      ],
                    ));
              },
            );
          } else {
            return const Text("Sem notas...");
          }
        },
      ),
    );
  }
}
