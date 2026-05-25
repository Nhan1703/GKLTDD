import 'package:flutter/material.dart';

import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';
import 'profile_add_photos_screen.dart';

class ProfileMyPhotosScreen extends StatefulWidget {
  const ProfileMyPhotosScreen({super.key});

  @override
  State<ProfileMyPhotosScreen> createState() => _ProfileMyPhotosScreenState();
}

class _ProfileMyPhotosScreenState extends State<ProfileMyPhotosScreen> {
  @override
  void initState() {
    super.initState();
    Fellow4uSqlApi.getPhotos().catchError((_) => <Map<String, dynamic>>[]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('My Photos', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: InkWell(
                  onTap: () => Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => const ProfileAddPhotosScreen())),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.authHeaderTeal, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: AppTheme.authHeaderTeal, size: 24),
                            const SizedBox(height: 2),
                            Text(
                              'Add Photos',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppTheme.authHeaderTeal, fontWeight: FontWeight.w600, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
              const SizedBox(width: 8),
              Expanded(child: _sq('assets/images/exp_grid_2.png')),
              const SizedBox(width: 8),
              Expanded(child: _sq('assets/images/exp_grid_3.png')),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 16 / 7,
              child: Image.asset('assets/images/exp_hoian_bicycle.png', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _sq('assets/images/exp_grid_4.png')),
              const SizedBox(width: 8),
              Expanded(child: _sq('assets/images/exp_grid_5.png')),
              const SizedBox(width: 8),
              Expanded(child: _sq('assets/images/exp_grid_6.png')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sq(String a) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(a, fit: BoxFit.cover),
      ),
    );
  }
}
