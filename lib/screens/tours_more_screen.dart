import 'package:flutter/material.dart';

import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';
import 'tour_detail_screen.dart';

class ToursMoreScreen extends StatefulWidget {
  const ToursMoreScreen({super.key});

  @override
  State<ToursMoreScreen> createState() => _ToursMoreScreenState();
}

class _ToursMoreScreenState extends State<ToursMoreScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Fellow4uSqlApi.getTours().catchError((_) => <Map<String, dynamic>>[]);
  }

  static const _allTours = [
    (
      title: 'Da Nang - Ba Na - Hoi An',
      date: 'Jan 30, 2020',
      days: '3 days',
      price: '\$400.00',
      km: '120 km',
      imageAsset: 'assets/images/journey_danang.png',
    ),
    (
      title: 'Melbourne - Sydney',
      date: 'Jan 30, 2020',
      days: '7 days',
      price: '\$600.00',
      km: '2817 km',
      imageAsset: 'assets/images/tour_sydney.png',
    ),
    (
      title: 'Hanoi - Ha Long Bay',
      date: 'Jan 30, 2020',
      days: '5 days',
      price: '\$300.00',
      km: '1247 km',
      imageAsset: 'assets/images/tour_halong.png',
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
    final tours = _allTours
        .where(
          (t) => query.isEmpty || t.title.toLowerCase().contains(query),
        )
        .toList();

    final repeated = [...tours, ...tours];

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
                  title: 'Plenty of amazing of tours\nare waiting for you',
                  controller: _controller,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final t = repeated[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TourMoreCard(
                        title: t.title,
                        date: t.date,
                        days: t.days,
                        price: t.price,
                        km: t.km,
                        imageAsset: t.imageAsset,
                      ),
                    );
                  },
                  childCount: repeated.length,
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

class _TourMoreCard extends StatelessWidget {
  const _TourMoreCard({
    required this.title,
    required this.date,
    required this.days,
    required this.price,
    required this.km,
    required this.imageAsset,
  });

  final String title;
  final String date;
  final String days;
  final String price;
  final String km;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
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
                    height: 150,
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
                        ...List.generate(
                          5,
                          (_) => const Icon(Icons.star, size: 14, color: Colors.amber),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          km,
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(Icons.favorite_border, size: 18, color: AppTheme.authHeaderTeal),
                  ),
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
                      const SizedBox(width: 8),
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
}
