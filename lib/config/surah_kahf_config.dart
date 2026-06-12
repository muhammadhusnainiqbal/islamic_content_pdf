import 'package:islamic_content_pdf/config/app_config.dart';
import 'package:islamic_content_pdf/config/content_type.dart';
import 'package:islamic_content_pdf/secrets/secrets.dart';

/// Surah Kahf Configuration
const kAppConfig = AppConfig(
  nameArabic: 'سورة الكهف',
  nameEnglish: 'Surah Kahf',
  admobBannerUnitId: Secrets.surahKahfBannerUnitId,
  contentType: ContentType.surah,
);
