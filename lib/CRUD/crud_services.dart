import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:notes/CRUD/crud_exception.dart';
//we need a database user

class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person ,Id $id , Email $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });
  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud = map[isSyncedWithCloudColumn] as int == 1;

  @override
  String toString() =>
      'Note, ID = $id, UserId = $userId, IsSyncedWithCloud =$isSyncedWithCloud';

  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class NotesService {
  Database? _db;
  Database getDatabaseorthrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpened();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (_db == null) {
      throw DatabaseIsNotOpened();
    }
    await db?.close();
    _db = null;
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlredyOpened();
    }
    try {
      final docsPath = await getApplicationCacheDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);

      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      // ignore: avoid_print
      print('Missind...');
    }
  }

  Future<void> deleteUser({required String email}) async {
    final db = getDatabaseorthrow();
    final deleteCount = await db
        .delete(userTable, where: 'email=?', whereArgs: [email.toLowerCase()]);
    if (deleteCount != 1) {
      throw CouldnotDeleteUser;
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = getDatabaseorthrow();
    final result = await db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);
    if (result.isNotEmpty) {
      throw UserAlreadyRegistered();
    }
    final userid = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DatabaseUser(id: userid, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = getDatabaseorthrow();
    final result = await db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);
    if (result.isEmpty) {
      throw CouldNotFindUser();
    }
    return DatabaseUser.fromRow(result.first);
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = getDatabaseorthrow();
    DatabaseUser dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    final text = '';

    final noteid = await db.insert(noteTabel,
        {userIdColumn: db, textColumn: text, isSyncedWithCloudColumn: 1});
    return DatabaseNote(
        id: noteid, userId: dbUser.id, text: text, isSyncedWithCloud: true);
  }

  Future<void> deleteNote({required int id}) async {
    final db = getDatabaseorthrow();
    final deleteCount = db.delete(noteTabel, where: 'id=?', whereArgs: [id]);
    if (deleteCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<int> deleteAllNote() async {
    final db = getDatabaseorthrow();

    return await db.delete(noteTabel);
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = getDatabaseorthrow();
    final note = await db.query(
      noteTabel,
      where: 'id=?',
      whereArgs: [id],
    );
    if (note.isEmpty) {
      throw CouldNotFindNote();
    }
    return DatabaseNote.fromRow(note.first);
  }

  Future<Iterable<DatabaseNote>> getAllNote() async {
    final db = getDatabaseorthrow();
    final note = await db.query(noteTabel);
    return note.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = getDatabaseorthrow();

    final updateCount = await db
        .update(noteTabel, {textColumn: text, isSyncedWithCloudColumn: 0});
    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    }
    return await getNote(id: note.id);
  }
}

const idColumn = 'id';
const emailColumn = 'email';
const userTable = 'user';
const noteTabel = 'note';
const userIdColumn = 'userId';
const isSyncedWithCloudColumn = 'isSyncedWithCloud';
const textColumn = 'text';
const dbName = 'notes.db';
const createUserTable = ''' CREATE TABLE IF NOT EXISTS "user" (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "email" TEXT NOT NULL UNIQUE
''';
const createNoteTable = ''' CREAT TABLE IF NOT EXISTS "note"(
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "userID" INTEGER,
      "text" TEXT,
      "isSyncedWithCloud" INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY ("userID) REFERENCES "user"("id")
      )
''';