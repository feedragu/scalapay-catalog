import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    super.key,
    this.cacheManager,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode,
    this.decodeWidth,
    this.errorBuilder,
  });

  final String url;
  final BaseCacheManager? cacheManager;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final int? decodeWidth;
  final WidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      cacheManager: cacheManager,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      memCacheWidth: decodeWidth,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      errorWidget: (context, _, _) =>
          errorBuilder?.call(context) ?? const SizedBox.shrink(),
    );
  }
}
