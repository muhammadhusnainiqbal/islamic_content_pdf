import 'package:islamic_content_pdf/config/app_config.dart';
import 'package:islamic_content_pdf/config/content_type.dart';
import 'package:islamic_content_pdf/secrets/secrets.dart';

/// Surah Mulk Configuration
const kAppConfig = AppConfig(
  nameArabic: 'سورۃ الملک',
  nameEnglish: 'Surah Mulk',
  admobBannerUnitId: Secrets.surahMulkBannerUnitId,
  contentType: ContentType.surah,
);
