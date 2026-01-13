import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'notes_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  @override
  int get schemaVersion => 1;

  Future<List<Note>> getAllNotes() async {
    try {
      return await select(notes).get();
    } catch (e) {
      print('getAllNotes error: $e');
      return [];
    }
  }

  Stream<List<Note>> watchNotes() {
    try {
      return select(notes).watch();
    } catch (e) {
      print('watchNotes error: $e');
      return const Stream.empty();
    }
  }

  Future<void> insertNote(NotesCompanion note) async {
    try {
      await into(notes).insert(note);
    } catch (e) {
      print('insertNote error: $e');
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await (delete(notes)..where((t) => t.id.equals(id))).go();
    } catch (e) {
      print('deleteNote error: $e');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await update(notes).replace(note);
    } catch (e) {
      print('updateNote error: $e');
    }
  }

  Future<Note?> getById(int id) async {
    try {
      return await (select(notes)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
    } catch (e) {
      print('getById error: $e');
      return null;
    }
  }

  Future<List<Note>> searchNotes(String query) async {
    try {
      final clean = query.replaceAll('#', '');
      final q = '%$query%';

      return await (select(notes)
            ..where((n) => n.title.like(q) | n.content.like(q)| n.tags.like(clean)))
          .get();
    } catch (e) {
      print('searchNotes error: $e');
      return [];
    }
  }
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'notes.db'));

    return NativeDatabase.createInBackground(file);
  });
}


