import 'package:flutter/material.dart';

import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';
import 'explore_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Fellow4uSqlApi.getNotifications().catchError((_) => <Map<String, dynamic>>[]);
  }

  void _goExplore(BuildContext context, int tabIndex) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ExploreScreen(initialBottomNavIndex: tabIndex),
      ),
    );
  }

  static const _items = [
    _NotificationItem(
      avatarAsset: 'assets/images/guide_tuan_tran.png',
      message:
          'Tuan Tran accepted your request for the trip in Danang, Vietnam on Jan 20, 2020',
      date: 'Jan 16',
      accentColor: Color(0xFF8BC34A),
      badgeIcon: Icons.check,
    ),
    _NotificationItem(
      avatarAsset: 'assets/images/guide_emmy.png',
      message:
          'Emmy sent you an offer for the trip in Ho Chi Minh, Vietnam on Feb 12, 2020',
      date: 'Jan 16',
      accentColor: Color(0xFFFFC107),
      badgeIcon: Icons.attach_money,
    ),
    _NotificationItem(
      avatarAsset: 'assets/images/app_icon.png',
      message:
          'Thanks! Your trip in Danang, Vietnam on Jan 20, 2020 has been finished. Please leave a review for the guide Tuan Tran.',
      date: 'Jan 24',
      accentColor: Color(0xFF3F8CFF),
      badgeIcon: Icons.rate_review,
      showReviewButton: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            _NotificationsHeader(
              onSearchTap: () {},
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: _items.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.14),
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return _NotificationTile(item: item);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _NotificationsBottomNav(
        onExploreTap: () => _goExplore(context, 0),
        onTripsTap: () => _goExplore(context, 1),
        onChatTap: () => _goExplore(context, 2),
        onProfileTap: () => _goExplore(context, 4),
      ),
    );
  }
}

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader({required this.onSearchTap});

  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 138,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/explore_header_danang.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.10),
                  Colors.black.withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: onSearchTap,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.search, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final _NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NotificationAvatar(item: item),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.message,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
                if (item.showReviewButton) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.authHeaderTeal,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: AppTheme.authHeaderTeal.withOpacity(0.35),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Leave Review',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationAvatar extends StatelessWidget {
  const _NotificationAvatar({required this.item});

  final _NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: Image.asset(
              item.avatarAsset,
              width: 42,
              height: 42,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: item.accentColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Icon(
                item.badgeIcon,
                size: 10,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsBottomNav extends StatelessWidget {
  const _NotificationsBottomNav({
    required this.onExploreTap,
    required this.onTripsTap,
    required this.onChatTap,
    required this.onProfileTap,
  });

  final VoidCallback onExploreTap;
  final VoidCallback onTripsTap;
  final VoidCallback onChatTap;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomItem(icon: Icons.explore_outlined, label: 'Explore', onTap: onExploreTap),
              _BottomItem(icon: Icons.location_on_outlined, label: 'Trips', onTap: onTripsTap),
              _BottomItem(icon: Icons.chat_bubble_outline, label: 'Chat', onTap: onChatTap),
              const _BottomItem(
                icon: Icons.notifications,
                label: 'Notifications',
                active: true,
                badge: '2',
              ),
              _BottomItem(icon: Icons.person_outline, label: 'Profile', onTap: onProfileTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.badge,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppTheme.authHeaderTeal : const Color(0xFF9E9E9E);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 24, color: color),
                if (badge != null)
                  Positioned(
                    top: -4,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4B4B),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.avatarAsset,
    required this.message,
    required this.date,
    required this.accentColor,
    required this.badgeIcon,
    this.showReviewButton = false,
  });

  final String avatarAsset;
  final String message;
  final String date;
  final Color accentColor;
  final IconData badgeIcon;
  final bool showReviewButton;
}

