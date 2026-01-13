import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/models/note_model.dart';
import '../viewmodel/notes_viewmodel.dart';

class EditorView extends ConsumerStatefulWidget {
  final String? id;
  final String from;
  const EditorView({super.key, this.id, this.from = 'home'});

  @override
  ConsumerState<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends ConsumerState<EditorView> {
  final title = TextEditingController();
  final content = TextEditingController();
  final tagsCtrl = TextEditingController();

  bool _loaded = false;

  static const bg = Color(0xff202124);

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      ref.read(repoProvider).getById(int.parse(widget.id!)).then((note) {
        if (note != null && mounted) {
          title.text = note.title;
          content.text = note.content;
          tagsCtrl.text = note.tags.join(', ');
          setState(() => _loaded = true);
        }
      });
    } else {
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const CupertinoPageScaffold(
        backgroundColor: Color(0xff202124),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: bg,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: bg,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (widget.from == 'archive') {
              context.go('/archive');
            } else {
              context.go('/');
            }
          },

          child: const Icon(CupertinoIcons.back, color: CupertinoColors.white),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _save,
          child: const Icon(
            CupertinoIcons.check_mark,
            color: CupertinoColors.white,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CupertinoTextField(
                controller: title,
                placeholder: "Title",
                style: const TextStyle(
                  fontSize: 24,
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.bold,
                ),
                placeholderStyle: const TextStyle(
                  color: CupertinoColors.systemGrey,
                ),
                decoration: const BoxDecoration(color: bg),
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: tagsCtrl,
                placeholder: "Tags (comma separated)",
                style: const TextStyle(color: CupertinoColors.white),
                placeholderStyle: const TextStyle(
                  color: CupertinoColors.systemGrey,
                ),
                decoration: const BoxDecoration(color: bg),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CupertinoTextField(
                  controller: content,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  placeholder: "Note",
                  style: const TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                  placeholderStyle: const TextStyle(
                    color: CupertinoColors.systemGrey,
                  ),
                  decoration: const BoxDecoration(color: bg),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final repo = ref.read(repoProvider);
    final tags = tagsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (widget.id == null) {
      await repo.add(
        NoteModel(
          title: title.text,
          content: content.text,
          pinned: false,
          archived: false,
          createdAt: DateTime.now(),
          tags: tags,
        ),
      );
    } else {
      final note = await repo.getById(int.parse(widget.id!));
      if (note != null) {
        await repo.update(
          note.copyWith(title: title.text, content: content.text, tags: tags),
        );
      }
    }

    if (widget.from == 'archive') {
      context.go('/archive');
    } else {
      context.go('/');
    }
  }
}
