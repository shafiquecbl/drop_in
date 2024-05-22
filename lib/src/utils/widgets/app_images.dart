import 'package:dropin/src_exports.dart';

class AppImages {
  AppImages._();

  static Widget asImage(
    String url, {
    BoxFit? fit,
    double? height,
    double? width,
    Color? color,
    // Clip clip = Clip.antiAlias,
    // BorderRadiusGeometry? borderRadius,
  }) {
    return ClipRRect(
      // clipBehavior: clip,
      // borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        fit: fit,
        color: color,
        errorWidget: (BuildContext context, String url, error) {
          logger.e(error);
          return AppAssets.asImage(
            AppAssets.noImage,
            width: width,
            height: height,
            fit: fit,
            color: color,
          );
        },
      ),
    );
  }

  static ImageProvider asProvider(
    String url, {
    int? height,
    int? width,
  }) {
    return CachedNetworkImageProvider(
      url,
      maxHeight: height,
      maxWidth: width,
    );
  }
}
