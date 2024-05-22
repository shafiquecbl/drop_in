import '../../../src_exports.dart';

class WebElevatedButton extends StatelessWidget {
  WebElevatedButton({
    super.key,
    required this.callback,
    required this.title,
    this.focusNode,
    this.color,
    this.style,
    this.borderRadius,
    this.height,
    this.padding,
    this.shape,
    this.textAlign,
    this.alignment,
    this.width,
  });

  final VoidCallback callback;
  final String title;
  final Color? color;
  FocusNode? focusNode;
  final double? width;
  final double? height;
  TextAlign? textAlign;
  BorderRadiusGeometry? borderRadius;
  TextStyle? style;
  EdgeInsetsGeometry? padding;
  OutlinedBorder? shape;
  AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      focusNode: focusNode,
      style: ElevatedButton.styleFrom(
        foregroundColor: color ?? AppColors.appWhiteColor,
        backgroundColor: color ?? AppColors.appWhiteColor,
        elevation: 10,
        padding: padding,
        minimumSize: Size(width ?? context.width, height ?? 60),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.appBlackColor),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
      onPressed: callback,
      child: Align(
        alignment: alignment ?? Alignment.center,
        child: Text(
          title,
          textAlign: textAlign ?? TextAlign.center,
          style: style ??
              AppThemes.lightTheme.textTheme.titleSmall
                  ?.copyWith(color: AppColors.appBlackColor),
        ),
      ),
    );
  }
}
