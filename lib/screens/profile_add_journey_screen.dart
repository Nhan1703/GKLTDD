import 'package:flutter/material.dart';

import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';

class ProfileAddJourneyScreen extends StatefulWidget {
  const ProfileAddJourneyScreen({super.key});

  @override
  State<ProfileAddJourneyScreen> createState() => _ProfileAddJourneyScreenState();
}

class _ProfileAddJourneyScreenState extends State<ProfileAddJourneyScreen> {
  final _name = TextEditingController();
  final _location = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: const Text('Add Journey', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await Fellow4uSqlApi.addTrip({
                  'title': _name.text.trim().isEmpty ? 'New journey' : _name.text.trim(),
                  'location': _location.text.trim().isEmpty ? 'Vietnam' : _location.text.trim(),
                });
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                }
                return;
              }
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Journey added.')));
            },
            child: const Text('DONE', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Name', style: TextStyle(fontSize: 12, color: AppTheme.textLightGray, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              hintText: "Journey's Name",
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 22),
          Text('Location', style: TextStyle(fontSize: 12, color: AppTheme.textLightGray, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _location,
            decoration: const InputDecoration(
              hintText: 'Location of Journey',
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 28),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: CustomPaint(
              painter: _DashedBorderPainter(color: AppTheme.authHeaderTeal),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera_outlined, size: 36, color: AppTheme.authHeaderTeal),
                    const SizedBox(height: 8),
                    Text('Upload Photos', style: TextStyle(color: AppTheme.authHeaderTeal, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const dash = 6.0;
    const gap = 4.0;
    final path = Path()..addRRect(r);
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        final next = (d + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(d, next), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
