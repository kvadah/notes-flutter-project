import 'package:flutter/material.dart';

class CreateOrUpdateNote extends StatefulWidget {
  const CreateOrUpdateNote({super.key});

  @override
  State<CreateOrUpdateNote> createState() => _CreateOrUpdateNoteState();
}

class _CreateOrUpdateNoteState extends State<CreateOrUpdateNote> {
  late final TextEditingController _textController;
  double _lineHeight = 24.0;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      height: 1.4, // Line height factor
      fontSize: 20, // Font size
    );
    _lineHeight = textStyle.fontSize! * textStyle.height!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        backgroundColor: Colors.lightBlue,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Draw notebook lines
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: PaperPainter(lineHeight: _lineHeight),
              ),
              // Text input
              Padding(
                padding:
                    const EdgeInsets.only(top: 4.0), // Adjust vertical padding
                child: TextField(
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 0.0, // Minimize padding for better alignment
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

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

    // Draw horizontal lines
    final linePaint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..strokeWidth = 1.0;

    // Offset to shift the first line slightly down
    final offsetY = 4.0; // Adjust this for finer alignment

    for (double y = offsetY + lineHeight; y < size.height; y += lineHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
