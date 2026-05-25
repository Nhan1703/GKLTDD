import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_theme.dart';
import 'guide_page_screen.dart';
import 'tour_detail_screen.dart';
import 'search_screen.dart';
import 'notifications_screen.dart';
import 'guides_more_screen.dart';
import 'tours_more_screen.dart';
import 'chat_list_screen.dart';
import 'my_trips_screen.dart';
import 'profile_screen.dart';
import '../core/session/user_session.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, this.initialBottomNavIndex = 0});

  /// 0 Explore, 1 Trips, 2 Chat, 3 Notifications, 4 Profile
  final int initialBottomNavIndex;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late int _currentIndex;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialBottomNavIndex.clamp(0, 4);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesQuery(String text) {
    if (_searchQuery.isEmpty) return true;
    return text.toLowerCase().contains(_searchQuery);
  }

  Widget _buildMainBody() {
    if (_currentIndex == 4) {
      return ProfileScreen(key: ValueKey<String>(UserSession.instance.email));
    }
    if (_currentIndex == 2) return const ChatListScreen();
    if (_currentIndex == 1) return const MyTripsScreen();
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderWithSearch(),
          const SizedBox(height: 20),
          _buildSectionHeader('Top Journeys'),
          const SizedBox(height: 12),
          _buildTopJourneys(),
          const SizedBox(height: 24),
          _buildSectionHeader(
            'Best Guides',
            seeMore: true,
            onSeeMore: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GuidesMoreScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildBestGuides(),
          const SizedBox(height: 24),
          _buildSectionTitle('Top Experiences'),
          const SizedBox(height: 12),
          _buildTopExperiences(),
          const SizedBox(height: 24),
          _buildSectionHeader(
            'Featured Tours',
            seeMore: true,
            onSeeMore: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ToursMoreScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildFeaturedTours(),
          const SizedBox(height: 24),
          _buildSectionHeader('Travel News', seeMore: true),
          const SizedBox(height: 12),
          _buildTravelNews(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildMainBody()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeaderWithSearch() {
    return Stack(
      children: [
        SizedBox(
          height: 165,
          width: double.infinity,
          child: Image.asset(
            'assets/images/explore_header_danang.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 165,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.12),
                Colors.black.withOpacity(0.04),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.location_on, size: 18, color: Colors.white),
                  const SizedBox(width: 4),
                  const Text(
                    'Da Nang',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '26Â°C',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.cloud, size: 18, color: Colors.white),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppTheme.textLightGray, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Hi, where do you want to explore?',
                        style: TextStyle(fontSize: 14, color: AppTheme.textLightGray),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool seeMore = false, VoidCallback? onSeeMore}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          if (seeMore)
            GestureDetector(
              onTap: onSeeMore,
              child: Text(
                'SEE MORE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.authHeaderTeal,
                ),
              ),
            ),
        ],
      ),
    );
  }

  static final List<({String imageAsset, String title, String date, String days, String price, String? km, int stars, bool bookmark})> _allJourneys = [
    (imageAsset: 'assets/images/journey_danang.png', title: 'Da Nang - Ba Na - Hoi An', date: 'Jan 30, 2020', days: '3 days', price: '\$400.00', km: '120 km', stars: 5, bookmark: true),
    (imageAsset: 'assets/images/journey_thailand.png', title: 'Thailand', date: 'Jan 30, 2020', days: '3 days', price: '\$1000.00', km: null, stars: 5, bookmark: false),
  ];

  Widget _buildTopJourneys() {
    final list = _allJourneys.where((j) => _matchesQuery(j.title)).toList();
    if (list.isEmpty) return _buildEmptySection();
    return SizedBox(
      height: 240,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (int i = 0; i < list.length; i++) ...[
            if (i > 0) const SizedBox(width: 12),
            _journeyCard(
              imageAsset: list[i].imageAsset,
              title: list[i].title,
              date: list[i].date,
              days: list[i].days,
              price: list[i].price,
              km: list[i].km,
              stars: list[i].stars,
              bookmark: list[i].bookmark,
              likes: null,
            ),
          ],
        ],
      ),
    );
  }

  Widget _journeyCard({
    String? imageAsset,
    Color? imageColor,
    required String title,
    required String date,
    required String days,
    required String price,
    String? km,
    required int stars,
    required bool bookmark,
    String? likes,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TourDetailScreen(
              title: title,
              imageAsset: imageAsset ?? 'assets/images/journey_danang.png',
              price: price,
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
          SizedBox(
            height: 130,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: imageAsset != null
                        ? Image.asset(
                            imageAsset,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: imageColor ?? const Color(0xFF81D4FA),
                          ),
                  ),
                ),
                if (km != null)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(stars, (_) => Icon(Icons.star, size: 14, color: Colors.amber[700])),
                          const SizedBox(width: 4),
                          Text(km, style: const TextStyle(color: Colors.white, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                if (km == null)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Row(
                      children: List.generate(stars, (_) => Icon(Icons.star, size: 16, color: Colors.amber[700])),
                    ),
                  ),
                if (bookmark)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.bookmark_border, color: Colors.white, size: 24),
                  ),
                if (likes != null)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Text(
                      likes,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1))],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: AppTheme.textLightGray),
                    const SizedBox(width: 4),
                    Text(date, style: TextStyle(fontSize: 11, color: AppTheme.textLightGray)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 12, color: AppTheme.textLightGray),
                    const SizedBox(width: 4),
                    Text(days, style: TextStyle(fontSize: 11, color: AppTheme.textLightGray)),
                    const Spacer(),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.authHeaderTeal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  static final List<({String name, String location, int stars, String reviews, String imageAsset, String headerAsset})> allGuides = [
    (
      name: 'Tuan Tran',
      location: 'Danang, Vietnam',
      stars: 5,
      reviews: '127 Reviews',
      imageAsset: 'assets/images/guide_tuan_tran.png',
      headerAsset: 'assets/images/explore_header_danang.png',
    ),
    (
      name: 'Emmy',
      location: 'Hanoi, Vietnam',
      stars: 4,
      reviews: '89 Reviews',
      imageAsset: 'assets/images/guide_emmy.png',
      headerAsset: 'assets/images/journey_thailand.png',
    ),
    (
      name: 'Linh Hana',
      location: 'Danang, Vietnam',
      stars: 4,
      reviews: '127 Reviews',
      imageAsset: 'assets/images/guide_linh_hana.png',
      headerAsset: 'assets/images/tour_halong.png',
    ),
    (
      name: 'Khai Ho',
      location: 'Ho Chi Minh, Vietnam',
      stars: 5,
      reviews: '127 Reviews',
      imageAsset: 'assets/images/guide_khai_ho.png',
      headerAsset: 'assets/images/tour_sydney.png',
    ),
  ];

  Widget _buildBestGuides() {
    final list = allGuides.where((g) => _matchesQuery(g.name) || _matchesQuery(g.location)).toList();
    if (list.isEmpty) return _buildEmptySection();
    return SizedBox(
      height: 155,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (int i = 0; i < list.length; i++) ...[
            if (i > 0) const SizedBox(width: 16),
            _guideCard(list[i].name, list[i].location, list[i].stars, list[i].reviews, list[i].imageAsset, list[i].headerAsset),
          ],
        ],
      ),
    );
  }

  Widget _guideCard(String name, String location, int stars, String reviews, String imageAsset, String headerAsset) {
    const double size = 88;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GuidePageScreen(
              name: name,
              location: location,
              stars: stars,
              reviews: reviews,
              avatarAsset: imageAsset,
              headerAsset: headerAsset,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SizedBox(
          width: size,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: Image.asset(
                        imageAsset,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(stars, (_) => Icon(Icons.star, size: 10, color: Colors.amber[700])),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            reviews,
                            style: const TextStyle(color: Colors.white, fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: size,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                width: size,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, size: 12, color: AppTheme.authHeaderTeal),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        location,
                        style: TextStyle(fontSize: 11, color: AppTheme.authHeaderTeal, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final List<({String imageAsset, String title, String location, String guideName})> _allExperiences = [
    (imageAsset: 'assets/images/exp_hoian_bicycle.png', title: '2 Hour Bicycle Tour exploring Hoian', location: 'Hoian, Vietnam', guideName: 'Tuan Tran'),
    (imageAsset: 'assets/images/exp_ba_na.png', title: '1 Day Ba Na Hill', location: 'Da Nang, Vietnam', guideName: 'HikiDaya'),
  ];

  Widget _buildTopExperiences() {
    final list = _allExperiences.where((e) => _matchesQuery(e.title) || _matchesQuery(e.location)).toList();
    if (list.isEmpty) return _buildEmptySection();
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (int i = 0; i < list.length; i++) ...[
            if (i > 0) const SizedBox(width: 12),
            _experienceCard(
              imageAsset: list[i].imageAsset,
              title: list[i].title,
              location: list[i].location,
              guideName: list[i].guideName,
            ),
          ],
        ],
      ),
    );
  }

  Widget _experienceCard({
    required String imageAsset,
    required String title,
    required String location,
    required String guideName,
  }) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Image.asset(imageAsset, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Text(
                    guideName.isNotEmpty ? guideName[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.authHeaderTeal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: AppTheme.textLightGray),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(fontSize: 11, color: AppTheme.textLightGray),
                        overflow: TextOverflow.ellipsis,
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

  static final List<({String title, String date, String days, String price, String km, String imageAsset})> allTours = [
    (title: 'Da Nang - Ba Na - Hoi An', date: 'Jan 30, 2020', days: '3 days', price: '\$400.00', km: '120 km', imageAsset: 'assets/images/journey_danang.png'),
    (title: 'Melbourne - Sydney', date: 'Jan 30, 2020', days: '7 days', price: '\$600.00', km: '2817 km', imageAsset: 'assets/images/tour_sydney.png'),
    (title: 'Hanoi - Ha Long Bay', date: 'Jan 30, 2020', days: '5 days', price: '\$300.00', km: '1247 km', imageAsset: 'assets/images/tour_halong.png'),
  ];

  Widget _buildFeaturedTours() {
    final list = allTours.where((t) => _matchesQuery(t.title)).toList();
    if (list.isEmpty) return _buildEmptySection();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (final t in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _featuredTourCard(
                imageAsset: t.imageAsset,
                title: t.title,
                date: t.date,
                days: t.days,
                price: t.price,
                km: t.km,
              ),
            ),
        ],
      ),
    );
  }

  Widget _featuredTourCard({
    required String imageAsset,
    required String title,
    required String date,
    required String days,
    required String price,
    required String km,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TourDetailScreen(
              title: title,
              imageAsset: imageAsset,
              price: price,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Image.asset(imageAsset, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(5, (_) => Icon(Icons.star, size: 14, color: Colors.amber[700])),
                      const SizedBox(width: 4),
                      Text(km, style: const TextStyle(color: Colors.white, fontSize: 11)),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.bookmark_border, color: Colors.white, size: 24),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.favorite, size: 20, color: AppTheme.authHeaderTeal),
                    const SizedBox(width: 6),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.authHeaderTeal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: AppTheme.textLightGray),
                    const SizedBox(width: 4),
                    Text(date, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 12, color: AppTheme.textLightGray),
                    const SizedBox(width: 4),
                    Text(days, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
                  ],
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }

  static final List<({String title, String date, String imageAsset})> _allNews = [
    (title: 'New Destination in Danang City', date: 'Feb 15, 2020', imageAsset: 'assets/images/news_danang.png'),
    (title: '\$1 Flight Ticket', date: 'Feb 8, 2020', imageAsset: 'assets/images/news_flight.png'),
    (title: 'Visit Hoian In this Tet Holiday', date: 'Jan 26, 2020', imageAsset: 'assets/images/news_tet_korea.png'),
  ];

  Widget _buildTravelNews() {
    final list = _allNews.where((n) => _matchesQuery(n.title)).toList();
    if (list.isEmpty) return _buildEmptySection();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (final n in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n.date,
                    style: TextStyle(fontSize: 12, color: AppTheme.textLightGray),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 140,
                      child: Image.asset(
                        n.imageAsset,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Center(
        child: Text(
          _searchQuery.isEmpty ? '' : 'No results for "$_searchQuery"',
          style: TextStyle(fontSize: 14, color: AppTheme.textLightGray),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.explore, 'Explore'),
              _navItem(1, Icons.location_on, 'Trips'),
              _navItem(2, Icons.chat_bubble_outline, 'Chat'),
              _navItem(3, Icons.notifications_none, 'Notifications'),
              _navItem(4, Icons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          );
          return;
        }
        setState(() => _currentIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? AppTheme.authHeaderTeal : AppTheme.textLightGray,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? AppTheme.authHeaderTeal : AppTheme.textLightGray,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}


