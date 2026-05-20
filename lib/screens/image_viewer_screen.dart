import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:islamic_content_pdf/config/app_config.dart';

class ImageViewerScreen extends StatefulWidget {
  final AppConfig appConfig;

  const ImageViewerScreen({required this.appConfig, super.key});

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  late PageController _pageController;
  int _currentPage = 0;
  late Future<List<String>> _imageAssetsFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Loads all .jpg/.png images from assets/islamic_content/ folder.
    // Images are copied there by add_flavor.dart script before build.
    // Files must be named numerically: 1.jpg, 2.jpg, etc.
    // Icon files (containing '_icon') are excluded automatically.
    _imageAssetsFuture = _loadImageAssets();
    _initializeBannerAd();
  }

  Future<List<String>> _loadImageAssets() async {
    try {
      // Use AssetManifest API (Flutter 3.1+) instead of deprecated AssetManifest.json
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

      final List<String> imagePaths = manifest
          .listAssets()
          .where((path) => path.startsWith('assets/islamic_content/'))
          .where(
            (path) =>
                path.endsWith('.jpg') ||
                path.endsWith('.jpeg') ||
                path.endsWith('.png'),
          )
          .where((path) => !path.contains('_icon')) // exclude icon files
          .toList();

      // Sort numerically by filename (1.jpg, 2.jpg, ... 10.jpg, 11.jpg)
      imagePaths.sort((a, b) {
        final nameA = a.split('/').last.split('.').first;
        final nameB = b.split('/').last.split('.').first;
        final numA = int.tryParse(nameA) ?? 0;
        final numB = int.tryParse(nameB) ?? 0;
        return numA.compareTo(numB);
      });

      return imagePaths;
    } catch (e) {
      debugPrint('Error loading image assets: $e');
      return [];
    }
  }

  void _precacheNearbyPages(List<String> paths, int currentIndex) {
    // Precache current + next 2 pages only — avoids memory pressure
    final start = (currentIndex - 1).clamp(0, paths.length - 1);
    final end = (currentIndex + 3).clamp(0, paths.length);
    for (final path in paths.sublist(start, end)) {
      precacheImage(AssetImage(path), context);
    }
  }

  void _initializeBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: widget.appConfig.admobBannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('AdMob banner failed: ${error.message}');
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E7F5C), Color(0xFF134E3A)],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.appConfig.nameArabic,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.appConfig.nameEnglish,
                    style: const TextStyle(fontSize: 15, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<List<String>>(
                    future: _imageAssetsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return Text(
                          'Page ${_currentPage + 1} of ${snapshot.data!.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _imageAssetsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1E7F5C),
                      ),
                    );
                  }

                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No images found.\nPlease reinstall the app.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  // Precache first few pages on initial load
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _precacheNearbyPages(snapshot.data!, 0);
                  });

                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Material(
                        elevation: 3,
                        child: PageView.builder(
                          controller: _pageController,
                          reverse: false,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                            _precacheNearbyPages(snapshot.data!, index);
                          },
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.white,
                              width: double.infinity,
                              height: double.infinity,
                              child: Image.asset(
                                snapshot.data![index],
                                fit: BoxFit.contain, // contain = no cropping
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'Could not load image.\nPlease reinstall the app.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isBannerAdReady
          ? SafeArea(
              child: SizedBox(
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            )
          : null,
    );
  }
}
