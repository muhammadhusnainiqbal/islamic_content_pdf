import 'package:islamic_content_pdf/config/app_config.dart';
import 'package:islamic_content_pdf/config/content_type.dart';
import 'package:islamic_content_pdf/secrets/secrets.dart';

/// Surah Testing Configuration
const kAppConfig = AppConfig(
  nameArabic: 'سورۃ ',
  nameEnglish: 'Surah Testing',
  admobBannerUnitId: Secrets.surahTestingBannerUnitId,
  contentType: ContentType.surah,
);
