import 'package:flutter/material.dart';

import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';
import 'chat_detail_screen.dart';
import 'guide_page_screen.dart';
import 'payment_trip_screen.dart';

/// Kiểu chân trang màn Trip Detail (theo Figma).
enum TripDetailFooter {
  /// Nút Chat + Pay
  chatAndPay,

  /// Nút Mark Finished (viền)
  markFinished,

  /// Hộp chờ guide xác nhận
  waiting,

  /// Không chân trang (vd. màn offers đủ nội dung)
  none,
}

class TripOfferGuide {
  const TripOfferGuide({
    required this.name,
    required this.avatarAsset,
    required this.starsLabel,
    required this.bioSnippet,
    required this.offerFee,
    this.chosen = false,
  });

  final String name;
  final String avatarAsset;
  final String starsLabel;
  final String bioSnippet;
  final String offerFee;
  final bool chosen;
}

/// Trip Detail — nhiều trạng thái (confirmed / waiting / offers).
class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({
    super.key,
    required this.heroAsset,
    required this.location,
    required this.dateLabel,
    required this.timeRange,
    required this.guideName,
    required this.guideAvatarAsset,
    required this.travelers,
    required this.attractionTags,
    required this.feeLabel,
    this.footer = TripDetailFooter.chatAndPay,
    this.offers = const [],
  });

  final String heroAsset;
  final String location;
  final String dateLabel;
  final String timeRange;
  final String guideName;
  final String guideAvatarAsset;
  final int travelers;
  final List<String> attractionTags;
  final String feeLabel;
  final TripDetailFooter footer;
  final List<TripOfferGuide> offers;

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  late List<TripOfferGuide> _offers;

  @override
  void initState() {
    super.initState();
    _offers = List<TripOfferGuide>.from(widget.offers);
    Fellow4uSqlApi.getTrip(1).catchError((_) => <String, dynamic>{});
  }

  void _openGuide() {
    final loc = switch (widget.location) {
      final s when s.contains('Ho Chi Minh') || s.contains('Saigon') => 'Ho Chi Minh, Vietnam',
      final s when s.contains('Danang') || s.contains('Đà Nẵng') || s.contains('Da Nang') => 'Danang, Vietnam',
      _ => 'Hanoi, Vietnam',
    };
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => GuidePageScreen(
          name: widget.guideName,
          location: loc,
          stars: 5,
          reviews: '120 Reviews',
          avatarAsset: widget.guideAvatarAsset,
          headerAsset: widget.heroAsset,
        ),
      ),
    );
  }

  void _openChatWithGuide() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ChatDetailScreen(
          title: widget.guideName,
          avatarAsset: widget.guideAvatarAsset,
        ),
      ),
    );
  }

  Future<void> _showTripMenu() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit This Trip'),
                onTap: () => Navigator.pop(ctx, 'edit'),
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red.shade700),
                title: Text('Delete This Trip', style: TextStyle(color: Colors.red.shade700)),
                onTap: () => Navigator.pop(ctx, 'delete'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (!mounted || action == null) return;
    if (action == 'delete') {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete This Trip'),
          content: const Text('Are you sure you want to delete this trip?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Delete', style: TextStyle(color: AppTheme.authHeaderTeal, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
      if (ok == true && mounted) Navigator.of(context).pop();
    }
  }

  void _showOfferMenu(TripOfferGuide g, int index) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: Text('Chat with ${g.name}'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => ChatDetailScreen(title: g.name, avatarAsset: g.avatarAsset),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.check_circle_outline, color: AppTheme.authHeaderTeal),
                title: Text('Choose ${g.name}', style: TextStyle(color: AppTheme.authHeaderTeal, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _offers = [
                      for (int i = 0; i < _offers.length; i++)
                        TripOfferGuide(
                          name: _offers[i].name,
                          avatarAsset: _offers[i].avatarAsset,
                          starsLabel: _offers[i].starsLabel,
                          bioSnippet: _offers[i].bioSnippet,
                          offerFee: _offers[i].offerFee,
                          chosen: i == index,
                        ),
                    ];
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasOffers = _offers.isNotEmpty;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  const Expanded(
                    child: Text(
                      'Trip Detail',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.more_horiz), onPressed: _showTripMenu),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 10,
                              child: Image.asset(widget.heroAsset, fit: BoxFit.cover),
                            ),
                            Positioned(
                              left: 12,
                              bottom: 12,
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.white, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.location,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, shadows: [
                                      Shadow(color: Colors.black45, blurRadius: 6),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 12,
                              bottom: 12,
                              child: InkWell(
                                onTap: _openGuide,
                                customBorder: const CircleBorder(),
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage(widget.guideAvatarAsset),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _kv('Date', widget.dateLabel),
                      _kv('Time', widget.timeRange),
                      _kvRowGuide(),
                      _kv('Number of Travelers', '${widget.travelers}'),
                      const SizedBox(height: 6),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Attractions', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final t in widget.attractionTags) _attractionChip(t),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Fee', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          Text(
                            widget.feeLabel,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.authHeaderTeal),
                          ),
                        ],
                      ),
                      if (hasOffers) ...[
                        const SizedBox(height: 22),
                        const Text('Offers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        ...List.generate(_offers.length, (i) => _offerCard(_offers[i], i)),
                      ],
                      const SizedBox(height: 20),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kvRowGuide() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text('Guide', style: TextStyle(fontSize: 13, color: AppTheme.textLightGray)),
          ),
          Expanded(
            child: InkWell(
              onTap: _openGuide,
              child: Text(
                widget.guideName,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.authHeaderTeal),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(k, style: TextStyle(fontSize: 13, color: AppTheme.textLightGray)),
          ),
          Expanded(child: Text(v, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF333333)))),
        ],
      ),
    );
  }

  Widget _attractionChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.authHeaderTeal.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.place_outlined, size: 14, color: AppTheme.authHeaderTeal),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _offerCard(TripOfferGuide g, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.dividerGray),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 26, backgroundImage: AssetImage(g.avatarAsset)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(g.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    ),
                    if (g.chosen)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F8F3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, size: 14, color: AppTheme.authHeaderTeal),
                            const SizedBox(width: 4),
                            Text('Chosen', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.authHeaderTeal)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(g.starsLabel, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray)),
                const SizedBox(height: 6),
                Text(g.bioSnippet, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: AppTheme.textGray, height: 1.3)),
                const SizedBox(height: 8),
                Text('Offer fee: ${g.offerFee}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () => _showOfferMenu(g, index)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    switch (widget.footer) {
      case TripDetailFooter.waiting:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Please wait a minute for your Guide to confirm.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppTheme.textGray, height: 1.35),
          ),
        );
      case TripDetailFooter.markFinished:
        return OutlinedButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip marked as finished.'))),
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Mark Finished'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF333333),
            side: const BorderSide(color: Color(0xFFBDBDBD)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      case TripDetailFooter.chatAndPay:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _openChatWithGuide,
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Chat'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  foregroundColor: const Color(0xFF333333),
                  side: const BorderSide(color: Color(0xFFBDBDBD)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () async {
                  final ok = await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (_) => const PaymentTripScreen(
                        tripTitle: 'Ho Guom',
                        totalLabel: '\$20.00',
                        upfrontLabel: '\$10.00',
                      ),
                    ),
                  );
                  if (!mounted) return;
                  if (ok == true) Navigator.of(context).pop(true);
                },
                icon: const Icon(Icons.payment_outlined, color: Colors.white),
                label: const Text('Pay'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.authHeaderTeal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        );
      case TripDetailFooter.none:
        return const SizedBox.shrink();
    }
  }
}
