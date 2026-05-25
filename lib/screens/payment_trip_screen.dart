import 'package:flutter/material.dart';

import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';

/// Thanh toán (stub 2 bước theo mockup Payment).
class PaymentTripScreen extends StatefulWidget {
  const PaymentTripScreen({
    super.key,
    required this.tripTitle,
    required this.totalLabel,
    required this.upfrontLabel,
  });

  final String tripTitle;
  final String totalLabel;
  final String upfrontLabel;

  @override
  State<PaymentTripScreen> createState() => _PaymentTripScreenState();
}

class _PaymentTripScreenState extends State<PaymentTripScreen> {
  int _step = 0;
  final _name = TextEditingController();
  final _number = TextEditingController();
  final _exp = TextEditingController();
  final _cvv = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _number.dispose();
    _exp.dispose();
    _cvv.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
      ),
      body: _step == 0 ? _buildCardStep() : _buildPreviewStep(),
    );
  }

  Widget _stepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 13,
            fontWeight: _step == 0 ? FontWeight.w700 : FontWeight.w400,
            color: _step == 0 ? AppTheme.authHeaderTeal : AppTheme.textLightGray,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.arrow_forward_ios, size: 12, color: AppTheme.textLightGray),
        ),
        Text(
          'Preview & Check out',
          style: TextStyle(
            fontSize: 13,
            fontWeight: _step == 1 ? FontWeight.w700 : FontWeight.w400,
            color: _step == 1 ? AppTheme.authHeaderTeal : AppTheme.textLightGray,
          ),
        ),
      ],
    );
  }

  Widget _buildCardStep() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        _stepIndicator(),
        const SizedBox(height: 8),
        const Text('Card Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        _field('Card Holder\'s Name', _name),
        _field('Card Number', _number),
        _field('Expiration Date', _exp),
        _field('CVV', _cvv),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton(
            onPressed: () => setState(() => _step = 1),
            style: FilledButton.styleFrom(backgroundColor: AppTheme.authHeaderTeal),
            child: const Text('NEXT', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _field(String hint, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF6F6F6),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildPreviewStep() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        _stepIndicator(),
        const SizedBox(height: 16),
        Text(widget.tripTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset('assets/images/exp_grid_2.png', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total', style: TextStyle(fontSize: 15)),
            Text(widget.totalLabel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.authHeaderTeal)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('50% payment', style: TextStyle(fontSize: 15)),
            Text(widget.upfrontLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '(You just need to pay upfront 50%)',
          style: TextStyle(fontSize: 12, color: AppTheme.textLightGray),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton(
            onPressed: () async {
              try {
                await Fellow4uSqlApi.submitPayment({
                  'tripTitle': widget.tripTitle,
                  'totalAmount': 400,
                  'upfrontAmount': 200,
                  'cardHolder': _name.text.isEmpty ? 'Guest' : _name.text,
                });
              } catch (_) {}
              if (context.mounted) Navigator.of(context).pop(true);
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.authHeaderTeal),
            child: const Text('CHECK OUT', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}
