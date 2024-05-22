import 'package:dropin/src_exports.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.leading,
    this.titleColor = Colors.white,
    this.actions,
    this.Style,
  }) : super(key: key);
  final String title;
  final bool showBackButton;
  final Widget? leading;
  final Color titleColor;
  final List<Widget>? actions;
  final TextStyle? Style;

  static PreferredSize getAppBar(String title,
      {bool showBackButton = false,
      Color titleColor = Colors.white,
      TextStyle? Style}) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        title: title,
        Style: Style,
        showBackButton: showBackButton,
        titleColor: titleColor,
      ),
    );
  }

  static PreferredSize getWithLeading(
    String title, {
    Color titleColor = Colors.black,
    TextStyle? Style,
    List<Widget> actions = const <Widget>[],
    bool showBackButton = true,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        title: title,
        Style: Style,
        showBackButton: true,
        titleColor: titleColor,
        actions: actions,
        leading: showBackButton
            ? IconButton(
                onPressed: () => Get.back(),
                icon: AppAssets.asIcon(
                  AppAssets.arrow,
                  color: Colors.black,
                  size: 24,
                ),
              )
            : SizedBox(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: AppColors.black,
      ),
      backgroundColor: AppColors.transparent,
      automaticallyImplyLeading: showBackButton,
      leading: leading,
      title: Text(
        title,
        style: Style ??
            AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
              fontSize: 25,
              color: titleColor,
            ),
      ),
      actions: actions,
    );
  }
}
