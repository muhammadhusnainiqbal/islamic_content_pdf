import 'package:islamic_content_pdf/config/app_config.dart';
import 'package:islamic_content_pdf/config/content_type.dart';
import 'package:islamic_content_pdf/secrets/secrets.dart';

/// Surah Rehman Configuration
const kAppConfig = AppConfig(
  nameArabic: 'سورة الرحمٰن',
  nameEnglish: 'Surah Rehman',
  admobBannerUnitId: Secrets.surahRehmanBannerUnitId,
  contentType: ContentType.surah,
);
