import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:notes/Auth/auth_services.dart';
import 'package:notes/CRUD/crud_services.dart';
import 'package:notes/Utilities/get_generic_arguement.dart';

class CreateOrUpdateNote extends StatefulWidget {
  const CreateOrUpdateNote({super.key});

  @override
  State<CreateOrUpdateNote> createState() => _CreateOrUpdateNoteState();
}

class _CreateOrUpdateNoteState extends State<CreateOrUpdateNote> {
  DatabaseNote? _note;
  late final TextEditingController _textController;
  late final NotesService _noteService;

  @override
  void initState() {
    _textController = TextEditingController();
    _noteService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _saveNoteIfTextIsNotEmpty();
    _deleteNoteIfTextIsEmpty();
    _textController.dispose();
    super.dispose();
  }

  void _textControllerlistner() async {
    final note = _note;
    final text = _textController.text;
    if (note == null) return;
    await _noteService.updateNote(note: note, text: text);
  }

  void _setUptextContollerListner() {
    _textController.removeListener(_textControllerlistner);
    _textController.addListener(_textControllerlistner);
  }

  Future<DatabaseNote> createOrGetNote() async {
    final existingNote = context.getArguement<DatabaseNote>();
    if (existingNote != null) {
      _note = existingNote;
      _textController.text = existingNote.text;
      return existingNote;
    }
    final newNote = _note;
    if (newNote != null) {
      return newNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final DatabaseUser owner = await _noteService.getOrCreateUser(email: email);
    try {
      final createdNote = await _noteService.createNote(owner: owner);
      _note = createdNote;
      return createdNote;
    } catch (e) {
      dev.log(e.toString());
      dev.log('can not create note for some reason');
      rethrow;
    }
  }

  void _saveNoteIfTextIsNotEmpty() {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty && text != note.text) {
      _noteService.updateNote(note: note, text: text);
    }
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isEmpty) {
      _noteService.deleteNote(id: note.id);
      dev.log('Empty note is deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New note'),
        backgroundColor: Colors.lightBlue,
      ),
      body:  FutureBuilder(
          future: createOrGetNote(),
          builder: (context, snapshot) {
            //  dev.log(snapshot.toString());
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasError) {
                  dev.log('snapshot has an error');
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                _note = snapshot.data as DatabaseNote;
                dev.log('connection state is done');
                dev.log(_note.toString());
                _setUptextContollerListner();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'write your note here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue, // Border color
                        width: 1.5, // Border thickness
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue, // Focused border color
                        width: 2.0,
                      ),
                    ),
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}