import 'package:islamic_content_pdf/config/app_config.dart';
import 'package:islamic_content_pdf/config/content_type.dart';
import 'package:islamic_content_pdf/secrets/secrets.dart';

/// Ar-Rahman Configuration
const kAppConfig = AppConfig(
  nameArabic: 'سورۃ الرحمن',
  nameEnglish: 'Surah Rehman',
  admobBannerUnitId: Secrets.surahRehmanBannerUnitId,
  contentType: ContentType.surah,
);
