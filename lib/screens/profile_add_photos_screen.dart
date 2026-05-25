import 'package:flutter/material.dart';

import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';

class ProfileAddPhotosScreen extends StatefulWidget {
  const ProfileAddPhotosScreen({super.key});

  @override
  State<ProfileAddPhotosScreen> createState() => _ProfileAddPhotosScreenState();
}

class _ProfileAddPhotosScreenState extends State<ProfileAddPhotosScreen> {
  static const _assets = [
    'assets/images/exp_grid_2.png',
    'assets/images/exp_grid_3.png',
    'assets/images/exp_grid_4.png',
    'assets/images/exp_grid_5.png',
    'assets/images/exp_grid_6.png',
    'assets/images/exp_grid_1.png',
    'assets/images/journey_danang.png',
    'assets/images/news_danang.png',
    'assets/images/exp_ba_na.png',
  ];

  final Set<int> _sel = {1, 5, 6};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: const Text('Add Photos', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              for (final i in _sel) {
                if (i < _assets.length) {
                  try {
                    await Fellow4uSqlApi.addPhoto(imageUrl: _assets[i]);
                  } catch (_) {}
                }
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('DONE', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
        itemCount: _assets.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.authHeaderTeal, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera_outlined, color: AppTheme.authHeaderTeal, size: 28),
                    const SizedBox(height: 4),
                    Text('Take Photo', style: TextStyle(fontSize: 11, color: AppTheme.authHeaderTeal, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          }
          final idx = i - 1;
          final selected = _sel.contains(idx);
          return GestureDetector(
            onTap: () => setState(() {
              if (selected) {
                _sel.remove(idx);
              } else {
                _sel.add(idx);
              }
            }),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(_assets[idx], fit: BoxFit.cover),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected ? AppTheme.authHeaderTeal : Colors.white.withValues(alpha: 0.85),
                        border: Border.all(color: selected ? AppTheme.authHeaderTeal : AppTheme.dividerGray, width: 1.5),
                      ),
                      child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
