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
                Navigator.of(context).pushNamed('/createOrUpdateNote');
              },
              icon: Icon(
                Icons.add,
                color: Colors.black,
              )),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    // ignore: use_build_context_synchronously
                    await Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  }
                  break;
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
                            if (allNotes.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No notes available. Create your first note!',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }
                            return Container(
                              margin: EdgeInsets.only(top: 7),
                              child: NotesListView(
                                allnotes: allNotes,
                                onDelete: (note) =>
                                    {_notesService.deleteNote(id: note.id)},
                                onTap: (note) async {
                                  await Navigator.of(context).pushNamed(
                                      '/createOrUpdateNote',
                                      arguments: note);
                                },
                              ),
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
