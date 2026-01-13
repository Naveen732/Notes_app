import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/notes_viewmodel.dart';

class ArchiveView extends ConsumerStatefulWidget {
  const ArchiveView({super.key});

  @override
  ConsumerState<ArchiveView> createState() => _ArchiveViewState();
}

class _ArchiveViewState extends ConsumerState<ArchiveView> {
  bool isGrid = true;

  static const bg = Color(0xff202124);

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesProvider);

    return CupertinoPageScaffold(
      backgroundColor: bg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _topBar(context),
                Expanded(
                  child: notesAsync.when(
                    data: (list) {
                      final archived = list.where((n) => n.archived).toList();

                      if (archived.isEmpty) {
                        return const Center(
                          child: Text(
                            "No archived notes",
                            style: TextStyle(color: CupertinoColors.systemGrey),
                          ),
                        );
                      }

                      return isGrid ? _grid(archived) : _list(archived);
                    },
                    loading: () =>
                        const Center(child: CupertinoActivityIndicator()),
                    error: (e, _) => Center(
                      child: Text(
                        e.toString(),
                        style: const TextStyle(color: CupertinoColors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.go('/edit'),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xff303134),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: CupertinoColors.black,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.add,
                    color: CupertinoColors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _topBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xff303134),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.go('/'),
            child: const Icon(
              CupertinoIcons.back,
              color: CupertinoColors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Archived Notes",
              style: TextStyle(color: CupertinoColors.systemGrey),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => setState(() => isGrid = !isGrid),
            child: Icon(
              isGrid
                  ? CupertinoIcons.list_bullet
                  : CupertinoIcons.square_grid_2x2,
              color: CupertinoColors.white,
            ),
          ),
        ],
      ),
    );
  }
  Widget _grid(List notes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: notes.length,
        itemBuilder: (context, i) => _noteCard(notes[i]),
      ),
    );
  }
  Widget _list(List notes) {
    return ListView.builder(
      itemCount: notes.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) => _noteCard(notes[i]),
    );
  }
  Widget _noteCard(note) {
    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.startToEnd, 
      background: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          CupertinoIcons.arrow_uturn_left,
          color: CupertinoColors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) async {
        await ref.read(repoProvider).toggleArchive(note);
      },
      child: GestureDetector(
        onTap: () => context.go('/note/${note.id}?from=archive'),

        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CupertinoColors.systemGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                note.content,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: CupertinoColors.systemGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
