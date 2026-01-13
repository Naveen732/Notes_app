import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/notes_viewmodel.dart';
import 'widget/sidebar.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  bool isGrid = true;

  static const bg = Color(0xff202124);

  @override
  Widget build(BuildContext context) {
    final pinned = ref.watch(pinnedNotesProvider);
    final others = ref.watch(otherNotesProvider);
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
                    data: (_) {
                      return ListView(
                        children: [
                          if (pinned.isNotEmpty) _section("Pinned", pinned),
                          if (others.isNotEmpty) _section("Others", others),
                        ],
                      );
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
                onPressed: () => context.go('/edit?from=home'),
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
            onPressed: () => _openSidebar(context),

            child: const Icon(
              CupertinoIcons.bars,
              color: CupertinoColors.white,
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () => context.go('/search'),
              child: const Text(
                "Search your notes",
                style: TextStyle(color: CupertinoColors.systemGrey),
              ),
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

  void _openSidebar(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Sidebar",
      barrierColor: CupertinoColors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) {
        return const Sidebar();
      },
      transitionBuilder: (_, anim, __, child) {
        final slide = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));

        return SlideTransition(position: slide, child: child);
      },
    );
  }

  Widget _section(String title, List notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            title,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 13,
            ),
          ),
        ),
        isGrid ? _grid(notes) : _list(notes),
      ],
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
        itemBuilder: (context, i) => _noteTile(notes[i].id),
      ),
    );
  }

  Widget _list(List notes) {
    return ListView.builder(
      itemCount: notes.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) => _noteTile(notes[i].id));
  }

  Widget _noteTile(int noteId) {
  return Consumer(
    builder: (context, ref, _) {
      final note = ref.watch(noteByIdProvider(noteId));

      if (note == null) return const SizedBox.shrink();

      return _noteCard(note, ref);
    },
  );
}


  Widget _noteCard(note, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: CupertinoColors.systemOrange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          CupertinoIcons.archivebox,
          color: CupertinoColors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) {
        ref.read(repoProvider).toggleArchive(note);
      },
      child: GestureDetector(
        onTap: () => context.go('/note/${note.id}?from=home'),
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      ref.read(repoProvider).togglePin(note);
                    },
                    child: Icon(
                      note.pinned
                          ? CupertinoIcons.pin_fill
                          : CupertinoIcons.pin,
                      color: note.pinned
                          ? CupertinoColors.systemYellow
                          : CupertinoColors.systemGrey,
                      size: 20,
                    ),
                  ),
                ],
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
