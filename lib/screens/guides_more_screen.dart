import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'guide_page_screen.dart';

class GuidesMoreScreen extends StatefulWidget {
  const GuidesMoreScreen({super.key});

  @override
  State<GuidesMoreScreen> createState() => _GuidesMoreScreenState();
}

class _GuidesMoreScreenState extends State<GuidesMoreScreen> {
  final TextEditingController _controller = TextEditingController();

  static const _allGuides = [
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim().toLowerCase();
    final guides = _allGuides
        .where(
          (g) =>
              query.isEmpty ||
              g.name.toLowerCase().contains(query) ||
              g.location.toLowerCase().contains(query),
        )
        .toList();

    final repeated = [...guides, ...guides];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 272,
              pinned: true,
              stretch: true,
              automaticallyImplyLeading: false,
              backgroundColor: AppTheme.authHeaderTeal,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: _MoreHeader(
                  title: 'Book your own private local\nGuide and explore the city',
                  controller: _controller,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final g = repeated[index];
                    return _GuideGridCard(
                      name: g.name,
                      location: g.location,
                      stars: g.stars,
                      reviews: g.reviews,
                      imageAsset: g.imageAsset,
                      headerAsset: g.headerAsset,
                    );
                  },
                  childCount: repeated.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreHeader extends StatelessWidget {
  const _MoreHeader({
    required this.title,
    required this.controller,
    required this.onChanged,
  });

  final String title;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.0),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: kToolbarHeight - 12),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_vert, color: Colors.white),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 44,
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
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search, size: 20, color: Color(0xFFB0B0B0)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        onChanged: onChanged,
                        decoration: const InputDecoration(
                          hintText: 'Hi, where do you want to explore?',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GuideGridCard extends StatelessWidget {
  const _GuideGridCard({
    required this.name,
    required this.location,
    required this.stars,
    required this.reviews,
    required this.imageAsset,
    required this.headerAsset,
  });

  final String name;
  final String location;
  final int stars;
  final String reviews;
  final String imageAsset;
  final String headerAsset;

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(
                            stars,
                            (_) => const Icon(Icons.star, size: 12, color: Colors.amber),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            reviews,
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.location_on, size: 12, color: AppTheme.authHeaderTeal),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(fontSize: 11, color: AppTheme.authHeaderTeal),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
