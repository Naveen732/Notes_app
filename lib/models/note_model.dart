class NoteModel {
  final int? id;              
  final String title;
  final String content;
  final bool pinned;
  final bool archived;
  final DateTime createdAt;

  const NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.pinned,
    required this.archived,
    required this.createdAt,
  });

  factory NoteModel.empty() {
    return NoteModel(
      title: '',
      content: '',
      pinned: false,
      archived: false,
      createdAt: DateTime.now(),
    );
  }

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    bool? pinned,
    bool? archived,
    DateTime? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      pinned: pinned ?? this.pinned,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  bool get isEmpty => title.isEmpty && content.isEmpty;

}

class SearchNoteUI {
  final String title;
  final String content;

  SearchNoteUI({required this.title, required this.content});
}

