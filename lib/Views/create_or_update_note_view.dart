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
  double _lineHeight = 24.0; // Default line height

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

  void _textControllerListener() async {
    final note = _note;
    final text = _textController.text;
    if (note == null) return;
    await _noteService.updateNote(note: note, text: text);
  }

  void _setUpTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createOrGetNote() async {
    final existingNote = context.getArguement<DatabaseNote>();
    if (existingNote != null) {
      _note = existingNote;
      _textController.text = existingNote.text;
      return existingNote;
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
      dev.log('Cannot create note for some reason');
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
              _setUpTextControllerListener();

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Dynamically adjust line height based on font size and height
                  final textStyle = TextStyle(
                    height: 1.6,
                    fontSize: 21,
                  );
                  final lineHeight = textStyle.fontSize! * textStyle.height!;
                  _lineHeight = lineHeight;

                  return Stack(
                    children: [
                      // Paper background with lines
                      CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: PaperPainter(lineHeight: _lineHeight + 1),
                      ),
                      // Text input field
                      TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: textStyle.copyWith(
                          color: Colors.black.withOpacity(0.7),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Write your note here',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.3),
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  );
                },
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
  final double lineHeight;

  PaperPainter({required this.lineHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw the background to simulate paper
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw horizontal lines to simulate notebook lines
    final linePaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 1.0;

    for (double y = lineHeight; y < size.height; y += lineHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint when line height changes
  }
}
