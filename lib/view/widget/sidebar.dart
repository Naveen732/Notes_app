import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 280,
          color: const Color(0xff202124),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                child: Text(
                  "Notes App",
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),

              Container(height: 0.5, color: CupertinoColors.systemGrey),

              _item(context, CupertinoIcons.lightbulb, "Notes", "/"),
              _item(context, CupertinoIcons.archivebox, "Archive", "/archive"),
              _item(context, CupertinoIcons.settings, "Settings", "/settings"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onPressed: () {
        Navigator.of(context).pop(); // close sidebar
        context.go(route);
      },
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.white),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(color: CupertinoColors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
