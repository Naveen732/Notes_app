import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const bg = Color(0xff202124);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: bg,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: bg,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => context.go('/'),
          child: const Icon(
            CupertinoIcons.back,
            color: CupertinoColors.white,
          ),
        ),
        middle: const Text(
          "Settings",
          style: TextStyle(color: CupertinoColors.white),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            _section("General"),
            _tile(
              icon: CupertinoIcons.paintbrush,
              title: "Theme",
              subtitle: "Dark (Default)",
              onTap: () {},
            ),
            _tile(
              icon: CupertinoIcons.square_grid_2x2,
              title: "Default view",
              subtitle: "Grid",
              onTap: () {},
            ),

            const SizedBox(height: 20),

            _section("Notes"),
            _tile(
              icon: CupertinoIcons.pin,
              title: "Show pinned notes on top",
              subtitle: "Always keep pinned notes first",
              onTap: () {},
            ),
            _tile(
              icon: CupertinoIcons.archivebox,
              title: "Archived notes",
              subtitle: "Manage archived notes",
              onTap: () => context.go('/archive'),
            ),

            const SizedBox(height: 20),

            _section("About"),
            _tile(
              icon: CupertinoIcons.info,
              title: "App version",
              subtitle: "1.0.0",
            ),
            _tile(
              icon: CupertinoIcons.chevron_left_slash_chevron_right,
              title: "Built with Flutter",
              subtitle: "Riverpod + Drift",
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: CupertinoColors.systemGrey,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: CupertinoColors.white, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: CupertinoColors.white, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          color: CupertinoColors.systemGrey, fontSize: 13)),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(CupertinoIcons.chevron_forward,
                  color: CupertinoColors.systemGrey),
          ],
        ),
      ),
    );
  }
}
