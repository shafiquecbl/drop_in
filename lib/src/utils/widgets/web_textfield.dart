import '../../../src_exports.dart';

class WebTextField extends StatefulWidget {
  WebTextField({
    Key? key,
    this.hint = '',
    this.prefixIcon,
    this.onChanged,
    this.obsecureText = false,
    this.textController,
    this.validator,
    this.suffixIcon,
    this.readOnly = false,
    this.fillColor,
    this.keyboardType,
    this.onTap,
    this.title = '',
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.height = 40,
    this.width,
    this.maxLength = 100,
    this.focusNode,
    this.errorText,
    this.autofocus = false,
    this.onFieldSubmitted,
    this.isTextFieldError = false,
    this.maxLengthEnforcement,
    this.borderRadius,
    this.curve = Curves.bounceOut,
    this.color = AppColors.appBlackColor,
    this.hintStyle,
    this.prefix,
    this.textAlign,
    this.radius,
    this.contentPadding,
  }) : super(key: key);

  final int maxLines;
  final String? hint;
  final Widget? prefixIcon;
  Widget? prefix;
  final Widget? suffixIcon;
  void Function(String)? onChanged;

  void Function(String)? onFieldSubmitted;
  void Function()? onTap;
  final bool obsecureText;
  String? errorText;
  double? radius;
  final TextEditingController? textController;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Color? fillColor;
  FocusNode? focusNode;
  final TextInputType? keyboardType;
  final double height;
  final double? width;
  MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLength;
  final bool autofocus;
  TextAlign? textAlign;
  BorderRadiusGeometry? borderRadius;
  String title;
  bool isTextFieldError;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Curve curve;
  final Color color;
  EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;

  @override
  State<WebTextField> createState() => WebTextFieldState();
}

class WebTextFieldState extends State<WebTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      upperBound: 1,
      lowerBound: 0,
      duration: Duration(milliseconds: 500),
    );
    // animationController.forward();
    animationController?.addListener(() {
      if (mounted) {
        if (animationController?.isCompleted ?? false) {
          animationController?.reset();
        }
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    animationController?.removeListener(() {});
    animationController?.dispose();
    super.dispose();
  }

  OutlineInputBorder get border {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(widget.radius ?? 5),
      ),
      borderSide: BorderSide(color: AppColors.appBlackColor, width: 1),
    );
  }

  double shake(double animation) =>
      2 * (0.5 - (0.5 - widget.curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(20 * shake(animationController?.value ?? 0), 0),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.fillColor ?? AppColors.appWhiteColor,
          border: Border.all(color: widget.color),
          borderRadius: widget.borderRadius,
        ),
        child: TextFormField(
          validator: (v) {
            if (widget.validator != null) {
              var r = widget.validator!(v);
              if (r != null) {
                if (animationController != null && mounted) {
                  animationController?.forward();
                }
              }
              return widget.validator!(v);
            }
            return (v);
          },
          inputFormatters: widget.inputFormatters,
          controller: widget.textController,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          maxLength: widget.maxLength,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          textAlign: widget.textAlign ?? TextAlign.start,
          obscureText: widget.obsecureText,
          cursorColor: AppColors.appButtonColor,
          decoration: InputDecoration(
            labelText: widget.title,
            labelStyle: AppThemes.lightTheme.textTheme.headlineLarge?.copyWith(
              fontSize: 16,
            ),
            errorStyle: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
              fontSize: 0,
              height: 0,
              color: AppColors.transparent,
            ),
            border: InputBorder.none,
            hintText: widget.hint,
            hintStyle: widget.hintStyle ??
                AppThemes.lightTheme.textTheme.headlineMedium
                    ?.copyWith(fontSize: 16, color: AppColors.appBlackColor),
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            prefix: widget.prefix,
            errorText: widget.errorText,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            counter: const SizedBox(),
          ),
        ),
      ),
    );
  }
}

class WebTextFields extends StatelessWidget {
  WebTextFields({
    Key? key,
    this.hint = '',
    this.prefixIcon,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.minLines,
    this.contentPadding,
    this.style,
    this.validator,
    this.keyboardType,
    this.hintStyle,
    this.suffixText,
    this.maxLines,
    this.radius,
    this.textInputAction,
    this.fillColor,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.controller,
    this.obscureText = false,
    this.inputFormatters,
    this.autofocus = false,
    FocusNode? focusNode,
  }) : super(key: key);
  final String hint;
  final bool autofocus;
  FocusNode? focusNode;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  bool readOnly;
  TextInputType? keyboardType;
  TextStyle? style;
  Color? fillColor;
  String? suffixText;
  TextStyle? hintStyle;
  void Function()? onTap;
  TextInputAction? textInputAction;
  String? Function(String?)? validator;
  final bool obscureText;
  int? minLines;
  List<TextInputFormatter>? inputFormatters;
  int? maxLines = 1;
  EdgeInsetsGeometry? contentPadding;
  double? radius;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      style: style,
      onChanged: onChanged,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      onTap: onTap,
      minLines: minLines,
      inputFormatters: inputFormatters,
      maxLines: maxLines ?? 1,
      autofocus: autofocus,
      focusNode: focusNode,
      readOnly: readOnly ?? false,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        disabledBorder: border,
        errorBorder: border,
        enabledBorder: border,
        focusedBorder: border,
        focusedErrorBorder: border,
        border: border,
        suffixText: suffixText,
        contentPadding:
            contentPadding ?? const EdgeInsets.symmetric(horizontal: 20),
        fillColor: fillColor ?? AppColors.appWhiteColor,
        filled: true,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorStyle: context.textTheme.titleLarge?.copyWith(
          color: AppColors.redcolor,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        hintStyle: hintStyle ??
            AppThemes.lightTheme.textTheme.headlineMedium
                ?.copyWith(fontSize: 16, color: AppColors.appBlackColor),
      ),
      textAlign: TextAlign.start,
    );
  }

  OutlineInputBorder get border {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(radius ?? 5),
      ),
      borderSide: BorderSide(color: AppColors.appBlackColor, width: 1),
    );
  }
}
