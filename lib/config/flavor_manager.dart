import 'package:flutter/foundation.dart';
import 'package:islamic_content_pdf/config/app_config.dart';
import 'package:islamic_content_pdf/config/surah_rehman_config.dart'
    as surah_rehman;

import 'package:islamic_content_pdf/config/surah_mulk_config.dart' as surah_mulk;
import 'package:islamic_content_pdf/config/surah_yaseen_config.dart'
    as surah_yaseen;

/// Flavor manager: resolves `AppConfig` by flavor key.
class FlavorManager {
  static const String defaultFlavor = 'surah_yaseen';

  static final Map<String, AppConfig> _flavors = {
    'surah_yaseen': surah_yaseen.kAppConfig,
    'surah_rehman': surah_rehman.kAppConfig,
    'surah_mulk': surah_mulk.kAppConfig,
  };

  static String normalize(String flavor) => flavor.trim().toLowerCase();

  static AppConfig getConfig(String flavor) {
    // Handle empty or whitespace-only flavor
    if (flavor.isEmpty || flavor.trim().isEmpty) {
      debugPrint(
        '[FlavorManager] ⚠ Empty flavor provided, using default: $defaultFlavor',
      );
      return _flavors[defaultFlavor]!;
    }

    final normalized = normalize(flavor);
    final config = _flavors[normalized];
    if (config == null) {
      debugPrint(
        '[FlavorManager] ⚠ Unknown flavor: "$flavor", using default: $defaultFlavor',
      );
      debugPrint(
        '[FlavorManager] Available flavors: ${_flavors.keys.join(", ")}',
      );
      assert(
        false,
        'FlavorManager: Unknown flavor "$flavor". '
        'Add it to _flavors map in flavor_manager.dart',
      );
      return _flavors[defaultFlavor]!;
    }
    return config;
  }
}
