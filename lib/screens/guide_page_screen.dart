import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'trip_information_screen.dart';

class GuidePageScreen extends StatelessWidget {
  const GuidePageScreen({
    super.key,
    required this.name,
    required this.location,
    required this.stars,
    required this.reviews,
    required this.avatarAsset,
    required this.headerAsset,
  });

  final String name;
  final String location;
  final int stars;
  final String reviews;
  final String avatarAsset;
  final String headerAsset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Image.asset(headerAsset, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.bookmark_border, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  Positioned(
                    bottom: 14,
                    left: 16,
                    right: 16,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(avatarAsset, width: 56, height: 56, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  ...List.generate(stars, (_) => Icon(Icons.star, size: 14, color: Colors.amber[700])),
                                  const SizedBox(width: 6),
                                  Text(
                                    reviews,
                                    style: const TextStyle(color: Colors.white, fontSize: 12, shadows: [Shadow(color: Colors.black45, blurRadius: 6)]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      location,
                                      style: const TextStyle(color: Colors.white, fontSize: 12, shadows: [Shadow(color: Colors.black45, blurRadius: 6)]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TripInformationScreen(
                                    guideName: name,
                                    guideLocation: location,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.92),
                              foregroundColor: AppTheme.authHeaderTeal,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('CHOOSE THIS GUIDE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Short introduction: Lorem ipsum is simply dummy text of the printing and typesetting industry.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textGray,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lorem ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textGray,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Container(
                            height: 170,
                            width: double.infinity,
                            color: const Color(0xFFEFEFEF),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.18,
                                    child: Image.asset(avatarAsset, fit: BoxFit.cover),
                                  ),
                                ),
                                Center(
                                  child: Image.asset(
                                    avatarAsset,
                                    height: 170,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.85),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.play_arrow, color: AppTheme.authHeaderTeal, size: 28),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          _priceRow('1 - 3 Travelers', '\$10/ hour'),
                          Divider(height: 1, color: AppTheme.dividerGray),
                          _priceRow('4 - 6 Travelers', '\$14/ hour'),
                          Divider(height: 1, color: AppTheme.dividerGray),
                          _priceRow('7 - 9 Travelers', '\$17/ hour'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text('My Experiences', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                    const SizedBox(height: 10),
                    ..._buildMyExperiences(),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                        Text('SEE MORE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.authHeaderTeal)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _reviewTile('Pena Valdez', 'Aug 21, 2020'),
                    const SizedBox(height: 12),
                    _reviewTile('Daehyun', 'Jun 22, 2020'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(left, style: const TextStyle(fontSize: 12, color: Color(0xFF333333)))),
          Text(right, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textGray)),
        ],
      ),
    );
  }

  Widget _experienceTile({
    required String image,
    required String title,
    required String location,
    required String date,
    required String likes,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(image, height: 120, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: AppTheme.authHeaderTeal),
                    const SizedBox(width: 4),
                    Expanded(child: Text(location, style: TextStyle(fontSize: 12, color: AppTheme.authHeaderTeal))),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: AppTheme.textLightGray),
                    const SizedBox(width: 4),
                    Text(date, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
                    const Spacer(),
                    Icon(Icons.favorite_border, size: 16, color: AppTheme.textLightGray),
                    const SizedBox(width: 4),
                    Text(likes, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewTile(String name, String date) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.authHeaderTeal.withOpacity(0.15),
            child: Text(name.isNotEmpty ? name[0] : '?', style: TextStyle(color: AppTheme.authHeaderTeal, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)))),
                    Text(date, style: TextStyle(fontSize: 11, color: AppTheme.textLightGray)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem ipsum has been the industry\'s standard dummy text ever since.',
                  style: TextStyle(fontSize: 12, color: AppTheme.textGray, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMyExperiences() {
    final cards = switch (name) {
      'Emmy' => const [
          _ExperienceMosaicCard(
            leftImage: 'assets/images/exp_grid_2.png',
            rightTopImage: 'assets/images/exp_grid_3.png',
            rightBottomImage: 'assets/images/exp_grid_4.png',
            title: 'Street food in Hanoi',
            location: 'Hanoi, Vietnam',
            date: 'Feb 10, 2020',
            likes: '98 Likes',
          ),
          SizedBox(height: 14),
          _ExperienceMosaicCard(
            leftImage: 'assets/images/exp_grid_1.png',
            rightTopImage: 'assets/images/exp_grid_5.png',
            rightBottomImage: 'assets/images/exp_grid_6.png',
            title: 'Coffee hopping',
            location: 'Hanoi, Vietnam',
            date: 'Jan 28, 2020',
            likes: '312 Likes',
          ),
        ],
      'Linh Hana' => const [
          _ExperienceMosaicCard(
            leftImage: 'assets/images/exp_grid_6.png',
            rightTopImage: 'assets/images/exp_grid_1.png',
            rightBottomImage: 'assets/images/exp_grid_5.png',
            title: 'Local market tour',
            location: 'Danang, Vietnam',
            date: 'Feb 2, 2020',
            likes: '451 Likes',
          ),
          SizedBox(height: 14),
          _ExperienceMosaicCard(
            leftImage: 'assets/images/exp_grid_3.png',
            rightTopImage: 'assets/images/exp_grid_2.png',
            rightBottomImage: 'assets/images/exp_grid_4.png',
            title: 'Family food class',
            location: 'Danang, Vietnam',
            date: 'Jan 18, 2020',
            likes: '210 Likes',
          ),
        ],
      'Khai Ho' => const [
          _ExperienceMosaicCard(
            leftImage: 'assets/images/exp_grid_5.png',
            rightTopImage: 'assets/images/exp_grid_6.png',
            rightBottomImage: 'assets/images/exp_grid_2.png',
            title: 'Saigon food tour',
            location: 'Ho Chi Minh, Vietnam',
            date: 'Feb 14, 2020',
            likes: '530 Likes',
          ),
          SizedBox(height: 14),
          _ExperienceMosaicCard(
            leftImage: 'assets/images/exp_grid_4.png',
            rightTopImage: 'assets/images/exp_grid_1.png',
            rightBottomImage: 'assets/images/exp_grid_3.png',
            title: 'Riverside walk',
            location: 'Ho Chi Minh, Vietnam',
            date: 'Jan 12, 2020',
            likes: '144 Likes',
          ),
        ],
      _ => const [
          _ExperienceMosaicCard(
            leftImage: 'assets/images/exp_grid_6.png',
            rightTopImage: 'assets/images/exp_grid_5.png',
            rightBottomImage: 'assets/images/exp_grid_1.png',
            title: '2 Hour Bicycle Tour exploring Hoian',
            location: 'Hoian, Vietnam',
            date: 'Jan 25, 2020',
            likes: '1234 Likes',
          ),
          SizedBox(height: 14),
          _ExperienceMosaicCard(
            leftImage: 'assets/images/exp_grid_4.png',
            rightTopImage: 'assets/images/exp_grid_2.png',
            rightBottomImage: 'assets/images/exp_grid_3.png',
            title: 'Food tour in Danang',
            location: 'Danang, Vietnam',
            date: 'Jan 20, 2020',
            likes: '234 Likes',
          ),
        ],
    };

    return [...cards];
  }
}

class _ExperienceImageTile extends StatelessWidget {
  const _ExperienceImageTile(this.assetPath);

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.asset(assetPath, fit: BoxFit.cover),
      ),
    );
  }
}

class _ExperienceMosaicCard extends StatelessWidget {
  const _ExperienceMosaicCard({
    required this.leftImage,
    required this.rightTopImage,
    required this.rightBottomImage,
    required this.title,
    required this.location,
    required this.date,
    required this.likes,
  });

  final String leftImage;
  final String rightTopImage;
  final String rightBottomImage;
  final String title;
  final String location;
  final String date;
  final String likes;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 1.9,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              leftImage,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: DecoratedBox(
                            decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    rightTopImage,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: DecoratedBox(
                            decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    rightBottomImage,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: AppTheme.authHeaderTeal),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(fontSize: 12, color: AppTheme.authHeaderTeal, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(date, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
                    const Spacer(),
                    Icon(Icons.favorite_border, size: 18, color: AppTheme.textLightGray),
                    const SizedBox(width: 6),
                    Text(likes, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
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

