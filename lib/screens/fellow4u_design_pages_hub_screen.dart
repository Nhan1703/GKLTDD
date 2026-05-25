import 'package:flutter/material.dart';

import '../api/fellow4u_design_pages_api.dart';
import '../features/api_console/presentation/api_test_screen.dart';
import '../app_theme.dart';
import 'guide_page_screen.dart';
import 'new_attractions_screen.dart';
import 'trip_information_screen.dart';

/// Hub mở nhanh ba khung Figma Fellow4U (trang 9, 10, 12) với dữ liệu lấy từ API mock.
/// Không thay thế luồng Explore; dùng để kiểm tra API và UI song song.
class Fellow4UDesignPagesHubScreen extends StatefulWidget {
  const Fellow4UDesignPagesHubScreen({super.key});

  @override
  State<Fellow4UDesignPagesHubScreen> createState() => _Fellow4UDesignPagesHubScreenState();
}

class _Fellow4UDesignPagesHubScreenState extends State<Fellow4UDesignPagesHubScreen> {
  String _guideId = 'tuan_tran';
  bool _loading = false;

  Future<void> _withLoading(Future<void> Function() job) async {
    setState(() => _loading = true);
    try {
      await job();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openPage9() async {
    await _withLoading(() async {
      final data = await Fellow4UDesignPage9Api.fetchGuideProfile(guideId: _guideId);
      if (!mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => GuidePageScreen(
            name: data.name,
            location: data.location,
            stars: data.stars,
            reviews: data.reviews,
            avatarAsset: data.avatarAsset,
            headerAsset: data.headerAsset,
          ),
        ),
      );
    });
  }

  Future<void> _openPage10() async {
    await _withLoading(() async {
      final ctx = await Fellow4UDesignPage10Api.fetchTripContextForGuide(guideId: _guideId);
      if (!mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => TripInformationScreen(
            guideName: ctx.guideName,
            guideLocation: ctx.guideLocation,
          ),
        ),
      );
    });
  }

  Future<void> _openPage12() async {
    await _withLoading(() async {
      final sheet = await Fellow4UDesignPage12Api.fetchAttractionsSheet(
        currentSelection: const ['Dragon Bridge', 'My Khe Beach'],
      );
      if (!mounted) return;
      await Navigator.of(context).push<List<String>>(
        MaterialPageRoute<List<String>>(
          builder: (_) => NewAttractionsScreen(initialSelected: sheet.initialSelected),
          fullscreenDialog: true,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Figma trang 9 · 10 · 12 (API mock)'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Chọn guide cho API trang 9–10:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textGray),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'tuan_tran', label: Text('Tuan')),
                  ButtonSegment(value: 'emmy', label: Text('Emmy')),
                  ButtonSegment(value: 'linh', label: Text('Linh')),
                ],
                selected: {_guideId},
                onSelectionChanged: (s) => setState(() => _guideId = s.first),
              ),
              const SizedBox(height: 24),
              _HubTile(
                title: 'Trang 9 — Guide profile',
                subtitle: 'GET /guides/{id} (mock)',
                onTap: _loading ? null : _openPage9,
              ),
              const SizedBox(height: 12),
              _HubTile(
                title: 'Trang 10 — Trip information',
                subtitle: 'GET /guides/{id}/trip-context (mock)',
                onTap: _loading ? null : _openPage10,
              ),
              const SizedBox(height: 12),
              _HubTile(
                title: 'Trang 12 — New attractions',
                subtitle: 'GET /attractions/sheet (mock)',
                onTap: _loading ? null : _openPage12,
              ),
              const SizedBox(height: 24),
              _HubTile(
                title: 'Kiểm tra API thật (Dio)',
                subtitle: 'JSONPlaceholder + ReqRes — CRUD, 10 trang',
                onTap: _loading
                    ? null
                    : () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(builder: (_) => const ApiTestScreen()),
                        );
                      },
              ),
            ],
          ),
          if (_loading)
            const Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: CircularProgressIndicator(color: AppTheme.authHeaderTeal),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  const _HubTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.authHeaderTeal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.layers_outlined, color: AppTheme.authHeaderTeal),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppTheme.textLightGray),
            ],
          ),
        ),
      ),
    );
  }
}
