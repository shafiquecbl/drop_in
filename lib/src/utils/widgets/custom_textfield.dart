import 'package:dropin/src_exports.dart';

abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState(this.animationDuration);

  final Duration animationDuration;
  late final AnimationController animationController =
      AnimationController(vsync: this, duration: animationDuration);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class AppTextField extends StatefulWidget {
  AppTextField({
    required this.title,
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
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.height = 60,
    this.hintStyle,
    this.focusNode,
    this.errorText,
    this.autofocus = false,
    this.onFieldSubmitted,
    this.isTextFieldError = false,
    this.maxLengthEnforcement,
    this.curve = Curves.bounceOut,
    this.labelStyle,
    this.enabled,
  }) : super(key: key);

  final int maxLines;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  void Function(String)? onChanged;

  void Function(String)? onFieldSubmitted;
  void Function()? onTap;
  final bool obsecureText;
  String? errorText;
  final TextEditingController? textController;
  final String? Function(String?)? validator;
  final bool readOnly;
  bool? enabled;
  bool? autofocus;
  final Color? fillColor;
  FocusNode? focusNode;
  final TextInputType? keyboardType;
  final double height;
  MaxLengthEnforcement? maxLengthEnforcement;

  String title;
  bool isTextFieldError;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Curve curve;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;

  @override
  State<AppTextField> createState() => AppTextFieldState();
}

class AppTextFieldState extends State<AppTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController? animationController;

  // Key key = UniqueKey();

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
      borderRadius: BorderRadius.all(Radius.circular(11)),
      borderSide: BorderSide(color: AppColors.appButtonColor),
    );
  }

  double shake(double animation) =>
      2 * (0.5 - (0.5 - widget.curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(20 * shake(animationController?.value ?? 0), 0),
      child: Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: (widget.focusNode?.hasFocus ?? false)
              ? AppColors.appWhiteColor
              : AppColors.appWhiteColor.withOpacity(0.8),
          border: Border.all(color: AppColors.appButtonColor),
          borderRadius: BorderRadius.circular(11),
        ),
        child: TextFormField(
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          onTapOutside: (_) {
            FocusScope.of(Get.context!).unfocus();
          },
          validator: (String? v) {
            if (widget.validator != null) {
              String? r = widget.validator!(v);
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
          onChanged: (String value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
            setState(() {});
          },
          onTap: widget.onTap,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus ?? false,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          obscureText: widget.obsecureText,
          cursorColor: AppColors.appButtonColor,
          decoration: InputDecoration(
            labelText: widget.title,
            fillColor: widget.fillColor,
            labelStyle: widget.labelStyle ??
                AppThemes.lightTheme.textTheme.headlineLarge?.copyWith(
                  fontSize: 14,
                ),
            errorStyle: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
              fontSize: 0,
              height: 0,
              color: AppColors.transparent,
            ),
            border: InputBorder.none,
            hintText: widget.hint,
            hintStyle: widget.hintStyle ??
                AppThemes.lightTheme.textTheme.bodyMedium
                    ?.copyWith(fontSize: 14, color: AppColors.appBlackColor),
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            errorText: widget.errorText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            counter: const SizedBox(),
          ),
        ),
      ),
    );
  }
}
