import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodel/notes_viewmodel.dart';
import '../widget/highlight.dart';

class SearchView extends ConsumerWidget {
  const SearchView({super.key});

  static const bg = Color(0xff202124);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);
    final tags = ref.watch(allTagsProvider);

    return CupertinoPageScaffold(
      backgroundColor: bg,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: bg,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => context.go('/'),
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.white),
        ),
        middle: CupertinoTextField(
          autofocus: true,
          onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
          style: const TextStyle(color: CupertinoColors.white),
          placeholder: "Search your notes",
          placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey),
          decoration: const BoxDecoration(color: bg),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _filters(ref),

            // 🔥 TAG BAR
            if (tags.isNotEmpty)
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: tags.map<Widget>((tag) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(searchQueryProvider.notifier).state = tag;
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff303134),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text(
                        "No matches",
                        style: TextStyle(color: CupertinoColors.systemGrey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, i) {
                        final note = results[i];

                        return GestureDetector(
                          onTap: () => context.go('/edit/${note.id}'),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: CupertinoColors.white,
                                      fontSize: 18,
                                    ),
                                    children: highlight(note.title, query),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: CupertinoColors.systemGrey,
                                    ),
                                    children: highlight(note.content, query),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filters(WidgetRef ref) {
    final filter = ref.watch(searchFilterProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CupertinoSlidingSegmentedControl<SearchFilter>(
        groupValue: filter,
        onValueChanged: (v) =>
            ref.read(searchFilterProvider.notifier).state = v!,
        children: const {
          SearchFilter.all: Text("All"),
          SearchFilter.pinned: Text("Pinned"),
          SearchFilter.archived: Text("Archived"),
        },
      ),
    );
  }
}
