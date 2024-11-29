// ignore: file_names
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:notes/Auth/auth_services.dart';
import 'package:notes/CRUD/crud_services.dart';
import 'package:notes/Utilities/show_logout_dialog.dart';
import 'package:notes/Views/notes_list_view.dart';

enum MenuAction { logout, seting }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/newnotes');
              },
              icon: Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) {
              switch (value) {
                case MenuAction.logout:
                  showLogoutDialog(context);
                case MenuAction.seting:
                default:
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Log out')),
                const PopupMenuItem<MenuAction>(
                    value: MenuAction.seting, child: Text('Seting'))
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _notesService.allNote,
                    builder: (context, snapshot) {
                      dev.log(snapshot.toString());
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          if (snapshot.hasData) {
                            final allNotes =
                                snapshot.data as List<DatabaseNote>;
                            return NotesListView(
                              allnotes: allNotes,
                              onDelete: (note) => {
                                _notesService.deleteNote(id: note.id)
                              },
                            );
                          } else {
                            return CircularProgressIndicator();
                          }

                        default:
                          return const Text('to be connected yet');
                      }
                    });
              default:
                return const Text('not done');
            }
          }),
    );
  }
}
