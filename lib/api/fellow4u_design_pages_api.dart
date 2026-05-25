import '../models/fellow4u_design_pages_models.dart';

/// API mock theo từng trang Figma Fellow4U (node design).
/// Thay nội dung [Future.delayed] + dữ liệu tĩnh bằng `http`/`dio` khi có backend.
abstract final class Fellow4UDesignPage9Api {
  /// Trang 9 — hồ sơ guide (profile header, CTA "Choose this guide").
  static Future<Fellow4UGuideProfilePayload> fetchGuideProfile({String guideId = 'tuan_tran'}) async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return switch (guideId) {
      'emmy' => const Fellow4UGuideProfilePayload(
          name: 'Emmy',
          location: 'Hanoi, Vietnam',
          stars: 5,
          reviews: '120 Reviews',
          avatarAsset: 'assets/images/guide_emmy.png',
          headerAsset: 'assets/images/exp_grid_2.png',
        ),
      'linh' => const Fellow4UGuideProfilePayload(
          name: 'Linh Hana',
          location: 'Danang, Vietnam',
          stars: 5,
          reviews: '98 Reviews',
          avatarAsset: 'assets/images/guide_linh_hana.png',
          headerAsset: 'assets/images/journey_danang.png',
        ),
      _ => const Fellow4UGuideProfilePayload(
          name: 'Tuan Tran',
          location: 'Danang, Vietnam',
          stars: 5,
          reviews: '210 Reviews',
          avatarAsset: 'assets/images/guide_tuan_tran.png',
          headerAsset: 'assets/images/exp_hoian_bicycle.png',
        ),
    };
  }
}

abstract final class Fellow4UDesignPage10Api {
  /// Trang 10 — ngữ cảnh mở form Trip Information (sau khi chọn guide).
  static Future<Fellow4UTripContextPayload> fetchTripContextForGuide({required String guideId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final profile = await Fellow4UDesignPage9Api.fetchGuideProfile(guideId: guideId);
    return Fellow4UTripContextPayload(guideName: profile.name, guideLocation: profile.location);
  }

  /// Gửi thông tin chuyến (stub). Gắn `POST /trips` tại đây.
  static Future<void> submitTripDraft(Map<String, Object?> body) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }
}

abstract final class Fellow4UDesignPage12Api {
  /// Trang 12 — danh sách địa điểm gợi ý + selection ban đầu cho [NewAttractionsScreen].
  static Future<Fellow4UAttractionsPagePayload> fetchAttractionsSheet({
    required List<String> currentSelection,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    const catalog = [
      'Cong Coffee',
      'Cong Hoa Market',
      'Cong Cho',
      'Cong Church',
      'Dragon Bridge',
      'My Khe Beach',
      'Cham Museum',
      'Hoi An Ancient Town',
    ];
    return Fellow4UAttractionsPagePayload(
      initialSelected: List<String>.from(currentSelection),
      catalogPlaceNames: catalog,
    );
  }
}
