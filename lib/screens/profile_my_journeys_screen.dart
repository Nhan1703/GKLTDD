import 'package:flutter/material.dart';

import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';
import 'profile_add_journey_screen.dart';

class ProfileMyJourneysScreen extends StatefulWidget {
  const ProfileMyJourneysScreen({super.key});

  @override
  State<ProfileMyJourneysScreen> createState() => _ProfileMyJourneysScreenState();
}

class _ProfileMyJourneysScreenState extends State<ProfileMyJourneysScreen> {
  @override
  void initState() {
    super.initState();
    Fellow4uSqlApi.getTrips().catchError((_) => <Map<String, dynamic>>[]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('My Journeys', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => const ProfileAddJourneyScreen()));
            },
            icon: Icon(Icons.add, color: AppTheme.authHeaderTeal),
            label: Text('Add Journey', style: TextStyle(color: AppTheme.authHeaderTeal, fontWeight: FontWeight.w700)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.authHeaderTeal, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          _card(
            title: 'A memory in Danang',
            location: 'Danang, Vietnam',
            date: 'Jan 20, 2020',
            a: 'assets/images/journey_danang.png',
            b: 'assets/images/exp_ba_na.png',
            c: 'assets/images/exp_hoian_bicycle.png',
          ),
          const SizedBox(height: 12),
          _card(
            title: 'Sapa in spring',
            location: 'Sapa, Vietnam',
            date: 'Jan 18, 2020',
            a: 'assets/images/exp_grid_5.png',
            b: 'assets/images/exp_grid_6.png',
            c: 'assets/images/exp_grid_1.png',
          ),
        ],
      ),
    );
  }

  Widget _card({
    required String title,
    required String location,
    required String date,
    required String a,
    required String b,
    required String c,
  }) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _t(a)),
                const SizedBox(width: 6),
                Expanded(child: _t(b)),
                const SizedBox(width: 6),
                Expanded(child: _t(c)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_horiz, color: AppTheme.textLightGray),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'e', child: Text('Edit')),
                    PopupMenuItem(value: 'd', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.place_outlined, size: 14, color: AppTheme.authHeaderTeal),
                const SizedBox(width: 4),
                Text(location, style: const TextStyle(fontSize: 12, color: AppTheme.authHeaderTeal)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(date, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
                const Spacer(),
                Icon(Icons.favorite_border, size: 16, color: AppTheme.authHeaderTeal),
                const SizedBox(width: 4),
                Text('234 Likes', style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _t(String asset) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.asset(asset, fit: BoxFit.cover),
      ),
    );
  }
}
