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
      dev.log('Can not create note for some reason');
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
      body: FutureBuilder(
        future: createOrGetNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                dev.log('Snapshot has an error');
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              _note = snapshot.data as DatabaseNote;
              _setUptextContollerListner();

              return CustomPaint(
                painter: PaperPainter(),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                            height: 1.4, // Line height to match the paper lines
                            fontSize: 20,
                            color: Colors.black.withOpacity(0.6),
                            // Adjust font size as needed
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: 'Write your note here',

                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.3),
                              fontStyle: FontStyle.italic,
                              fontSize: 22,
                              // Blur effect on hint text
                              backgroundColor: Colors.transparent,
                            ),
                            border:
                                InputBorder.none, // Remove the default border
                            focusedBorder:
                                InputBorder.none, // Remove the focused border
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

// Custom painter to draw the paper background and lines
class PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw the background to simulate paper
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw horizontal lines to simulate notebook lines
    final linePaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 1.0;

    // Calculate the height of one line, this should match the TextField's line height
    const lineHeight = 32.0; // Adjust this value for the line height

    for (double y = 0; y < size.height; y += lineHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
