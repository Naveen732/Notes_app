import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/notes_viewmodel.dart';

class NoteView extends ConsumerWidget {
  final int id;
  final String from; 

  const NoteView({
    super.key,
    required this.id,
    required this.from,
  });

  static const bg = Color(0xff202124);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNotes = ref.watch(notesProvider);

    return asyncNotes.when(
      loading: () => const CupertinoPageScaffold(
        backgroundColor: bg,
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (e, _) => CupertinoPageScaffold(
        backgroundColor: bg,
        child: Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: CupertinoColors.white),
          ),
        ),
      ),
      data: (notes) {
        final matches = notes.where((n) => n.id == id).toList();

        if (matches.isEmpty) {
          return CupertinoPageScaffold(
            backgroundColor: bg,
            navigationBar: CupertinoNavigationBar(
              backgroundColor: bg,
              border: null,
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (from == 'archive') {
                    context.go('/archive');
                  } else {
                    context.go('/');
                  }
                },
                child: const Icon(
                  CupertinoIcons.back,
                  color: CupertinoColors.white,
                ),
              ),
            ),
            child: const Center(
              child: Text(
                "Note not found",
                style: TextStyle(color: CupertinoColors.systemGrey),
              ),
            ),
          );
        }

        final note = matches.first;

        return CupertinoPageScaffold(
          backgroundColor: bg,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: bg,
            border: null,
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (from == 'archive') {
                  context.go('/archive');
                } else {
                  context.go('/');
                }
              },
              child: const Icon(
                CupertinoIcons.back,
                color: CupertinoColors.white,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    ref.read(repoProvider).togglePin(note);
                  },
                  child: Icon(
                    note.pinned
                        ? CupertinoIcons.pin_fill
                        : CupertinoIcons.pin,
                    color: CupertinoColors.white,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    await ref.read(repoProvider).toggleArchive(note);

                    if (from == 'archive') {
                      context.go('/archive');
                    } else {
                      context.go('/');
                    }
                  },
                  child: const Icon(
                    CupertinoIcons.archivebox,
                    color: CupertinoColors.white,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    context.go('/edit/${note.id}?from=$from');
                  },
                  child: const Icon(
                    CupertinoIcons.pencil,
                    color: CupertinoColors.white,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    await ref.read(repoProvider).delete(note.id!);

                    if (from == 'archive') {
                      context.go('/archive');
                    } else {
                      context.go('/');
                    }
                  },
                  child: const Icon(
                    CupertinoIcons.delete,
                    color: CupertinoColors.white,
                  ),
                ),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 24,
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        note.content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
