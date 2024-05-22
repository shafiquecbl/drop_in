import '../../../src_exports.dart';

class LoaderView extends StatelessWidget {
  LoaderView({Key? key, this.color = AppColors.appButtonColor})
      : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitPulse(
        color: color,
      ),
    );
  }
}
