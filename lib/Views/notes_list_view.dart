import 'package:flutter/material.dart';
import 'package:notes/CRUD/crud_services.dart';
import 'package:notes/Utilities/show_delete_dialog.dart';

typedef OnDeleteCall = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> allnotes;
  final OnDeleteCall onDelete;

  const NotesListView({
    super.key,
    required this.allnotes,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: allnotes.length,
        itemBuilder: (context, index) {
          final note = allnotes[index];
          return ListTile(
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) onDelete(note);
              },
              icon: Icon(Icons.delete),
            ),
          );
        });
  }
}
