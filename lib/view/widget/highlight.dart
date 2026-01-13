import 'package:flutter/cupertino.dart';

List<TextSpan> highlight(String source, String query) {
  if (query.isEmpty) {
    return [TextSpan(text: source)];
  }

  final lowerSource = source.toLowerCase();
  final lowerQuery = query.toLowerCase();

  List<TextSpan> spans = [];
  int start = 0;

  while (true) {
    final index = lowerSource.indexOf(lowerQuery, start);
    if (index < 0) {
      spans.add(TextSpan(text: source.substring(start)));
      break;
    }

    if (index > start) {
      spans.add(TextSpan(text: source.substring(start, index)));
    }

    spans.add(
      TextSpan(
        text: source.substring(index, index + query.length),
        style: const TextStyle(
          backgroundColor: CupertinoColors.systemBlue,
          color: CupertinoColors.black,
        ),
      ),
    );

    start = index + query.length;
  }

  return spans;
}
