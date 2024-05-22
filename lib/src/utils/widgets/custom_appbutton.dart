import 'package:dropin/src_exports.dart';

class AppElevatedButton extends StatelessWidget {
  AppElevatedButton({
    required this.callback,
    required this.title,
    Key? key,
    this.focusNode,
    this.color,
    this.style,
    this.borderRadius,
    this.height,
    this.side,
    this.icon,
    this.width,
    this.elevation = 2,
  }) : super(key: key);
  final VoidCallback callback;
  final String title;
  final Color? color;
  FocusNode? focusNode;
  final double? width;
  final double? height;
  BorderRadiusGeometry? borderRadius;
  TextStyle? style;
  BorderSide? side;
  Widget? icon;
  double elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      focusNode: focusNode,
      onPressed: callback,
      // autofocus: true,

      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.appButtonColor,
        padding: EdgeInsets.symmetric(horizontal: 15),
        elevation: elevation,
        minimumSize: Size(width ?? context.width, height ?? 60),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(27),
          side: side ?? BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: style ??
                AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.appWhiteColor,
                  fontSize: 16,
                ),
          ).paddingOnly(right: icon != null ? 5 : 0),
          icon ?? SizedBox(),
        ],
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    required this.title,
    required this.callback,
    Key? key,
    this.color,
    this.height,
    this.width,
    this.radius = const BorderRadius.all(Radius.circular(30)),
    this.padding = const EdgeInsets.all(12),
    this.style,
  }) : super(key: key);
  final EdgeInsetsGeometry padding;
  final String title;
  final VoidCallback callback;
  final Color? color;
  final double? width;
  final double? height;
  final BorderRadiusGeometry radius;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(width ?? context.width, height ?? 60),
          shape: RoundedRectangleBorder(
            borderRadius: radius,
          ),
          backgroundColor: color ?? AppColors.black,
        ),
        onPressed: callback,
        child: Text(
          title,
          style: style ??
              AppThemes.lightTheme.textTheme.headlineMedium
                  ?.copyWith(color: AppColors.appWhiteColor),
        ),
      ),
    );
  }
}
