import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../models/note_model.dart';

NoteModel fromDrift(Note n) {
  return NoteModel(
    id: n.id,
    title: n.title,
    content: n.content,
    pinned: n.pinned,
    archived: n.archived,
    createdAt: n.createdAt,
  );
}

NotesCompanion toDrift(NoteModel n) {
  return NotesCompanion(
    id: n.id == null ? const Value.absent() : Value(n.id!),
    title: Value(n.title),
    content: Value(n.content),
    pinned: Value(n.pinned),
    archived: Value(n.archived),
    createdAt: Value(n.createdAt),
  );
}
