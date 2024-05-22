import 'package:dropin/src_exports.dart';

class CustomScaffold extends StatelessWidget {
  CustomScaffold({
    Key? key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.gradient,
    this.url = AppAssets.backgroundGif,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  Widget body;
  String url;
  Gradient? gradient;
  Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppAssets.asImage(url, height: context.height, fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(gradient: gradient),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: appBar,
            body: body,
            bottomNavigationBar: bottomNavigationBar,
          ),
        ),
      ],
    );
  }
}
