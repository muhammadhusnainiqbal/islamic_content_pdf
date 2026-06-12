import 'package:islamic_content_pdf/config/app_config.dart';
import 'package:islamic_content_pdf/config/content_type.dart';
import 'package:islamic_content_pdf/secrets/secrets.dart';

/// Surah Waqiah Configuration
const kAppConfig = AppConfig(
  nameArabic: 'سورة الواقعة',
  nameEnglish: 'Surah Waqiah',
  admobBannerUnitId: Secrets.surahWaqiahBannerUnitId,
  contentType: ContentType.surah,
);
