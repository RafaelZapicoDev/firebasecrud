import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //PEGA OS DADOS DOS CAMPOS QUE EU COLOQUEI NO FIREBASE
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  //ADICIONANDO NOVAS COISAS
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  //PEGANDO MEUS DADOS DE FORMA ORDENADA PRA LER
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  //ATUALIZANDO UM CAMPO
  Future<void> updateNote(String docId, String newNote) {
    return notes
        .doc(docId)
        .update({'note': newNote, 'timestamp': Timestamp.now()});
  }

  //DELETANDO DO BANCO
  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }
}
