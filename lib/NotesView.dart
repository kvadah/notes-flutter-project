// ignore: file_names
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:notes/Auth/auth_services.dart';
import 'package:notes/CRUD/crud_services.dart';

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

                            return ListView.builder(
                                itemCount: allNotes.length,
                                itemBuilder: (context, index) {
                                  final note = allNotes[index];
                                  return ListTile(
                                    title: Text(
                                      note.text,
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                });
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

Future<bool> showLogoutDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        backgroundColor: Colors.grey,
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blueAccent),
            Text(
              'Log out',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to log out'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context).pop(true);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text('Logout')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'))
        ],
      );
    },
  ).then((value) => value ?? false);
}
