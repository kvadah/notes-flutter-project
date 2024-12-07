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
    return Container(
      color: Colors.grey,
      child: ListView.builder(
          itemCount: allnotes.length,
          itemBuilder: (context, index) {
            final note = allnotes[index];
            return Container(
              margin: const EdgeInsets.only(left: 3, top: 2, right: 5),
              height: 70,
              decoration: BoxDecoration(
                color: Color.fromRGBO(245, 245, 245, 1),
              ),
              child: allnotes.isEmpty
                  ? Center(
                      child: Text(
                        "Create your first Note",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ListTile(
                      onTap: () {
                        onTap(note);
                      },
                      title: Text(
                        style: TextStyle(
                          fontSize: 17,
                        ),
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
          }),
    );
  }
}
