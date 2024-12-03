import 'package:flutter/material.dart';
import 'package:notes/CRUD/crud_services.dart';
import 'package:notes/Utilities/show_delete_dialog.dart';

typedef OnCallBack = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> allnotes;
  final OnCallBack onDelete;
  final OnCallBack onTap;

  const NotesListView({
    super.key,
    required this.allnotes,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: allnotes.length,
        itemBuilder: (context, index) {
          final note = allnotes[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromRGBO(117, 117, 116, 0.698),
            ),
            child: ListTile(
              onTap: () {
                onTap(note);
              },
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
            ),
          );
        });
  }
}
