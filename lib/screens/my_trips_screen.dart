import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'chat_detail_screen.dart';
import 'trip_detail_screen.dart';

/// Tab **Trips** trên Explore — My Trips (Current / Next / Past / Wish List).
class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  bool _showCheckoutBanner = false;

  static const _tagsHanoi = ['Ho Guom', 'Ho Hoan Kiem', 'Pho 12 Pho Kim Ma'];
  static const _tagsDanang = ['Dragon Bridge', 'My Khe Beach', 'Ba Na Hills'];
  static const _tagsHcm = ['Notre-Dame Cathedral', 'Ben Thanh Market', 'Bitexco Skydeck'];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _openTripPaid() {
    Navigator.of(context)
        .push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => const TripDetailScreen(
          heroAsset: 'assets/images/exp_grid_2.png',
          location: 'Hanoi, Vietnam',
          dateLabel: 'Feb 2, 2020',
          timeRange: '8:00 AM - 10:00 AM',
          guideName: 'Emmy',
          guideAvatarAsset: 'assets/images/guide_emmy.png',
          travelers: 2,
          attractionTags: _tagsHanoi,
          feeLabel: '\$20.00',
          footer: TripDetailFooter.chatAndPay,
        ),
      ),
    )
        .then((v) {
      if (mounted && v == true) setState(() => _showCheckoutBanner = true);
    });
  }

  void _openTripWaiting() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const TripDetailScreen(
          heroAsset: 'assets/images/exp_grid_3.png',
          location: 'Hanoi, Vietnam',
          dateLabel: 'Feb 2, 2020',
          timeRange: '8:00 AM - 10:00 AM',
          guideName: 'Emmy',
          guideAvatarAsset: 'assets/images/guide_emmy.png',
          travelers: 2,
          attractionTags: _tagsHanoi,
          feeLabel: '\$20.00',
          footer: TripDetailFooter.waiting,
        ),
      ),
    );
  }

  void _openTripOffers() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => TripDetailScreen(
          heroAsset: 'assets/images/exp_grid_1.png',
          location: 'Ho Chi Minh, Vietnam',
          dateLabel: 'Feb 2, 2020',
          timeRange: '8:00 AM - 10:00 AM',
          guideName: 'Emmy',
          guideAvatarAsset: 'assets/images/guide_emmy.png',
          travelers: 2,
          attractionTags: _tagsHcm,
          offers: const [
            TripOfferGuide(
              name: 'Khai Ho',
              avatarAsset: 'assets/images/exp_grid_4.png',
              starsLabel: '★★★★★  210 Reviews',
              bioSnippet: 'Local guide with 5 years experience. Lorem ipsum is simply dummy text.',
              offerFee: '\$10/hour',
            ),
            TripOfferGuide(
              name: 'Tran Thao',
              avatarAsset: 'assets/images/guide_linh_hana.png',
              starsLabel: '★★★★☆  98 Reviews',
              bioSnippet: 'Food tours and night markets. Lorem ipsum has been the industry standard.',
              offerFee: '\$12/hour',
            ),
            TripOfferGuide(
              name: 'Hennry',
              avatarAsset: 'assets/images/guide_tuan_tran.png',
              starsLabel: '★★★★★  156 Reviews',
              bioSnippet: 'History walks and museums. Reader will be distracted by the readable content.',
              offerFee: '\$11/hour',
            ),
          ],
          feeLabel: '\$20.00',
          footer: TripDetailFooter.none,
        ),
      ),
    );
  }

  void _openTripMarkFinished() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const TripDetailScreen(
          heroAsset: 'assets/images/explore_header_danang.png',
          location: 'Danang, Vietnam',
          dateLabel: 'Feb 2, 2020',
          timeRange: '8:00 AM - 10:00 AM',
          guideName: 'Emmy',
          guideAvatarAsset: 'assets/images/guide_emmy.png',
          travelers: 2,
          attractionTags: _tagsDanang,
          feeLabel: '\$20.00',
          footer: TripDetailFooter.markFinished,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const TripDetailScreen(
                heroAsset: 'assets/images/explore_header_danang.png',
                location: 'Danang, Vietnam',
                dateLabel: 'Feb 2, 2020',
                timeRange: '8:00 AM - 10:00 AM',
                guideName: 'Emmy',
                guideAvatarAsset: 'assets/images/guide_emmy.png',
                travelers: 2,
                attractionTags: _tagsDanang,
                feeLabel: '\$20.00',
                footer: TripDetailFooter.markFinished,
              ),
            ),
          );
        },
        backgroundColor: AppTheme.authHeaderTeal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text('My Trips', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
          ),
          if (_showCheckoutBanner)
            Material(
              color: const Color(0xFFE8F5E9),
              child: InkWell(
                onTap: () => setState(() => _showCheckoutBanner = false),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Thanks! Check out successfully. Enjoy your trip!',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF2E7D32)),
                        ),
                      ),
                      Icon(Icons.close, size: 18, color: Colors.green.shade800),
                    ],
                  ),
                ),
              ),
            ),
          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tabs,
              isScrollable: true,
              labelColor: AppTheme.authHeaderTeal,
              unselectedLabelColor: AppTheme.textLightGray,
              indicatorColor: AppTheme.authHeaderTeal,
              tabs: const [
                Tab(text: 'Current Trips'),
                Tab(text: 'Next Trips'),
                Tab(text: 'Past Trips'),
                Tab(text: 'Wish List'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _currentTripsTab(),
                _nextTripsTab(),
                _emptyTab('No past trips'),
                _emptyTab('Wish list is empty'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyTab(String msg) {
    return Center(child: Text(msg, style: TextStyle(color: AppTheme.textLightGray)));
  }

  Widget _currentTripsTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _tripCard(
          title: 'Da Nang — City highlights',
          image: 'assets/images/explore_header_danang.png',
          dateLine: 'Feb 2, 2020 · 8:00 AM - 10:00 AM',
          guideAsset: 'assets/images/guide_emmy.png',
          statusLabel: 'In progress',
          statusColor: AppTheme.authHeaderTeal,
          onDetail: _openTripMarkFinished,
          onChat: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ChatDetailScreen(title: 'Emmy', avatarAsset: 'assets/images/guide_emmy.png'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _nextTripsTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
            _tripCard(
              title: 'Ho Guom',
              image: 'assets/images/exp_grid_2.png',
              dateLine: 'Feb 2, 2020 · 8:00 AM - 10:00 AM',
              guideAsset: 'assets/images/guide_emmy.png',
              statusLabel: 'Paid 50%',
              statusColor: AppTheme.authHeaderTeal,
              onDetail: _openTripPaid,
              onChat: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ChatDetailScreen(title: 'Emmy', avatarAsset: 'assets/images/guide_emmy.png'),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _tripCard(
              title: 'Ho Chi Minh Mausoleum',
              image: 'assets/images/exp_grid_3.png',
              dateLine: 'Feb 2, 2020 · 8:00 AM - 10:00 AM',
              guideAsset: 'assets/images/guide_emmy.png',
              statusLabel: 'Waiting',
              statusColor: const Color(0xFFFFA000),
              onDetail: _openTripWaiting,
              onChat: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ChatDetailScreen(title: 'Emmy', avatarAsset: 'assets/images/guide_emmy.png'),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _tripCard(
              title: 'Saigon Notre-Dame',
              image: 'assets/images/exp_grid_1.png',
              dateLine: 'Feb 2, 2020 · 8:00 AM - 10:00 AM',
              guideAsset: 'assets/images/guide_emmy.png',
              statusLabel: 'Offers',
              statusColor: const Color(0xFF3F8CFF),
              onDetail: _openTripOffers,
              onChat: () {},
            ),
          ],
        );
  }

  Widget _tripCard({
    required String title,
    required String image,
    required String dateLine,
    required String guideAsset,
    required String statusLabel,
    required Color statusColor,
    required VoidCallback onDetail,
    required VoidCallback onChat,
  }) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(14),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: CircleAvatar(radius: 22, backgroundImage: AssetImage(guideAsset)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(dateLine, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: onDetail,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF333333),
                        side: const BorderSide(color: Color(0xFFBDBDBD)),
                      ),
                      child: const Text('Detail'),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: onChat,
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: const Text('Chat'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF333333),
                        side: const BorderSide(color: Color(0xFFBDBDBD)),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
