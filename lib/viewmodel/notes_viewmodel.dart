import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/note_model.dart';
import '../db/app_database.dart';
import '../repositories/notes_repository.dart';

final dbProvider = Provider<AppDatabase>((ref) {
  try {
    return AppDatabase();
  } catch (e, st) {
    print("dbProvider error: $e");
    print(st);
    rethrow;
  }
});

final repoProvider = Provider<NotesRepository>((ref) {
  try {
    return NotesRepository(ref.watch(dbProvider));
  } catch (e, st) {
    print("repoProvider error: $e");
    print(st);
    rethrow;
  }
});

final notesProvider = StreamProvider<List<NoteModel>>((ref) {
  try {
    return ref.watch(repoProvider).watchNotes();
  } catch (e, st) {
    print("notesProvider error: $e");
    print(st);
    return const Stream.empty();
  }
});

final searchQueryProvider = StateProvider<String>((_) => "");

final searchFilterProvider =
    StateProvider<SearchFilter>((_) => SearchFilter.all);

enum SearchFilter { all, pinned, archived }

final searchResultsProvider = Provider<List<NoteModel>>((ref) {
  try {
    final query = ref.watch(searchQueryProvider).toLowerCase();
    final filter = ref.watch(searchFilterProvider);
    final notes = ref.watch(notesProvider).value ?? [];

    Iterable<NoteModel> result = notes;

    if (filter == SearchFilter.pinned) {
      result = result.where((n) => n.pinned);
    } else if (filter == SearchFilter.archived) {
      result = result.where((n) => n.archived);
    }

    if (query.isNotEmpty) {
      result = result.where((n) =>
          n.title.toLowerCase().contains(query) ||
          n.content.toLowerCase().contains(query));
    }

    return result.toList();
  } catch (e, st) {
    print("searchResultsProvider error: $e");
    print(st);
    return [];
  }
});

final activeNotesProvider = Provider<List<NoteModel>>((ref) {
  try {
    final notes = ref.watch(notesProvider).value ?? [];
    return notes.where((n) => !n.archived).toList();
  } catch (e, st) {
    print("activeNotesProvider error: $e");
    print(st);
    return [];
  }
});

final pinnedNotesProvider = Provider<List<NoteModel>>((ref) {
  try {
    final notes = ref.watch(activeNotesProvider);
    return notes.where((n) => n.pinned).toList();
  } catch (e, st) {
    print("pinnedNotesProvider error: $e");
    print(st);
    return [];
  }
});

final otherNotesProvider = Provider<List<NoteModel>>((ref) {
  try {
    final notes = ref.watch(activeNotesProvider);
    return notes.where((n) => !n.pinned).toList();
  } catch (e, st) {
    print("otherNotesProvider error: $e");
    print(st);
    return [];
  }
});

final noteByIdProvider = Provider.family<NoteModel?, int>((ref, id) {
  try {
    return ref.watch(
      notesProvider.select((async) {
        final notes = async.value ?? [];
        for (final n in notes) {
          if (n.id == id) return n;
        }
        return null;
      }),
    );
  } catch (e, st) {
    print("noteByIdProvider($id) error: $e");
    print(st);
    return null;
  }
});
