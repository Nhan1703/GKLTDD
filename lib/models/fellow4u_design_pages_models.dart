import 'package:flutter/foundation.dart';

/// Dữ liệu trang 9 (Guide profile) — khớp tham số [GuidePageScreen].
@immutable
class Fellow4UGuideProfilePayload {
  const Fellow4UGuideProfilePayload({
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
}

/// Ngữ cảnh trang 10 (Trip information) — các trường hiện [TripInformationScreen] nhận từ bên ngoài.
@immutable
class Fellow4UTripContextPayload {
  const Fellow4UTripContextPayload({
    required this.guideName,
    required this.guideLocation,
  });

  final String guideName;
  final String guideLocation;
}

/// Kết quả trang 12 (New attractions) — danh mục + lựa chọn ban đầu.
@immutable
class Fellow4UAttractionsPagePayload {
  const Fellow4UAttractionsPagePayload({
    required this.initialSelected,
    required this.catalogPlaceNames,
  });

  final List<String> initialSelected;
  final List<String> catalogPlaceNames;
}
