import '../db/app_database.dart';
import '../models/note_model.dart';
import 'note_mapper.dart';

class NotesRepository {
  final AppDatabase db;
  NotesRepository(this.db);

  Stream<List<NoteModel>> watchNotes() =>
      db.watchNotes().map((rows) => rows.map(fromDrift).toList());
  Future<void> add(NoteModel note) async {
    final title = note.title.trim();
    final content = note.content.trim();

    if (title.isEmpty && content.isEmpty) {
      return; 
    }

    await db.insertNote(toDrift(note));
  }

  Future<NoteModel?> getById(int id) async {
    final row = await db.getById(id);
    return row == null ? null : fromDrift(row);
  }

  Future<void> update(NoteModel note) async {
    final title = note.title.trim();
    final content = note.content.trim();

    if (title.isEmpty && content.isEmpty) {
      if (note.id != null) {
        await delete(note.id!);
      }
      return;
    }

    final row = await db.getById(note.id!);
    if (row == null) return;

    await db.updateNote(
      row.copyWith(
        title: title,
        content: content,
        pinned: note.pinned,
        archived: note.archived,
        createdAt: note.createdAt,
        tags: note.tags.join(','),
       
      ),
    );
  }

  Future<void> delete(int id) => db.deleteNote(id);

  Future<void> togglePin(NoteModel n) => update(n.copyWith(pinned: !n.pinned));

  Future<void> toggleArchive(NoteModel n) =>
      update(n.copyWith(archived: !n.archived));
  
  Future<List<NoteModel>> search(String query) async {
  final rows = await db.searchNotes(query);
  return rows.map(fromDrift).toList();
}

}
