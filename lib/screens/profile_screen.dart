import 'package:flutter/material.dart';

import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';
import '../core/session/user_session.dart';
import '../widgets/user_avatar.dart';
import 'profile_add_photos_screen.dart';
import 'profile_my_journeys_screen.dart';
import 'profile_my_photos_screen.dart';
import 'profile_settings_screen.dart';

const double _profileHeaderHeight = 200;
const double _profileAvatarOuterR = 48;

/// Tab Profile — header ảnh, My Photos, My Journeys (theo mockup Fellow4U).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    UserSession.instance.addListener(_onSessionChanged);
    _refreshFromApi();
  }

  @override
  void dispose() {
    UserSession.instance.removeListener(_onSessionChanged);
    super.dispose();
  }

  void _onSessionChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _refreshFromApi() async {
    try {
      await Fellow4uSqlApi.getProfile();
    } catch (_) {}
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final session = UserSession.instance;
    final displayName = session.displayName;
    final email = session.email.isNotEmpty ? session.email : '—';
    return ColoredBox(
      color: Colors.white,
      child: CustomScrollView(
        clipBehavior: Clip.none,
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProfileHeader(
                      onSettings: () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(builder: (_) => const ProfileSettingsScreen()),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(20, 52, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: _profileAvatarOuterR * 2 + 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF333333)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  email,
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          _sectionRow(context, 'My Photos', () {
                            Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => const ProfileMyPhotosScreen()));
                          }),
                          const SizedBox(height: 12),
                          _photoMosaic(context),
                          const SizedBox(height: 28),
                          _sectionRow(context, 'My Journeys', () {
                            Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => const ProfileMyJourneysScreen()));
                          }),
                          const SizedBox(height: 12),
                          _journeyCard(
                            context,
                            title: 'A memory in Danang',
                            location: 'Danang, Vietnam',
                            date: 'Jan 20, 2020',
                            likes: '234',
                            left: 'assets/images/journey_danang.png',
                            mid: 'assets/images/exp_ba_na.png',
                            right: 'assets/images/exp_hoian_bicycle.png',
                          ),
                          const SizedBox(height: 14),
                          _journeyCard(
                            context,
                            title: 'Sapa in spring',
                            location: 'Sapa, Vietnam',
                            date: 'Jan 18, 2020',
                            likes: '234',
                            left: 'assets/images/exp_grid_5.png',
                            mid: 'assets/images/exp_grid_6.png',
                            right: 'assets/images/exp_grid_1.png',
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 20,
                  top: _profileHeaderHeight - _profileAvatarOuterR,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const UserAvatar(radius: 44, backgroundColor: Color(0xFFBDBDBD)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionRow(BuildContext context, String title, VoidCallback onSeeAll) {
    return InkWell(
      onTap: onSeeAll,
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const Spacer(),
          Icon(Icons.chevron_right, color: AppTheme.textLightGray),
        ],
      ),
    );
  }

  Widget _photoMosaic(BuildContext context) {
    return Column(
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
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/images/exp_grid_2.png', fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/images/exp_grid_3.png', fit: BoxFit.cover),
                ),
              ),
            ),
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
            Expanded(child: _smallPhoto('assets/images/exp_grid_4.png')),
            const SizedBox(width: 8),
            Expanded(child: _smallPhoto('assets/images/exp_grid_2.png')),
            const SizedBox(width: 8),
            Expanded(child: _smallPhoto('assets/images/exp_grid_3.png')),
          ],
        ),
      ],
    );
  }

  Widget _smallPhoto(String a) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(a, fit: BoxFit.cover),
      ),
    );
  }

  Widget _journeyCard(
    BuildContext context, {
    required String title,
    required String location,
    required String date,
    required String likes,
    required String left,
    required String mid,
    required String right,
  }) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => const ProfileMyJourneysScreen())),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _journeyThumb(left)),
                  const SizedBox(width: 6),
                  Expanded(child: _journeyThumb(mid)),
                  const SizedBox(width: 6),
                  Expanded(child: _journeyThumb(right)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_horiz, color: AppTheme.textLightGray),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'share', child: Text('Share')),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.place_outlined, size: 14, color: AppTheme.authHeaderTeal),
                  const SizedBox(width: 4),
                  Text(location, style: const TextStyle(fontSize: 12, color: AppTheme.authHeaderTeal, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(date, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
                  const Spacer(),
                  Icon(Icons.favorite_border, size: 16, color: AppTheme.authHeaderTeal),
                  const SizedBox(width: 4),
                  Text('$likes Likes', style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _journeyThumb(String asset) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.asset(asset, fit: BoxFit.cover),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.onSettings});

  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: _profileHeaderHeight,
          width: double.infinity,
          child: Image.asset('assets/images/exp_grid_5.png', fit: BoxFit.cover),
        ),
        Container(
          height: _profileHeaderHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.25),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.35),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            onPressed: onSettings,
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
            child: Icon(Icons.camera_alt_outlined, size: 18, color: AppTheme.authHeaderTeal),
          ),
        ),
      ],
    );
  }
}
