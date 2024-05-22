import '../../../src_exports.dart';

class DialogContainer extends StatelessWidget {
  const DialogContainer({
    Key? key,
    this.maxHei = 500,
    this.minHei = 400,
    this.minWid = 400,
    this.maxWid = 500,
    this.title = '',
    this.showLeading = false,
    this.showTrailing = false,
    required this.body,
    this.bgColor,
  }) : super(key: key);
  final double maxHei;
  final bool showLeading;
  final double minHei;
  final double minWid;
  final double maxWid;
  final Widget body;
  final String title;
  final Color? bgColor;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: bgColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWid,
          minWidth: minWid,
          minHeight: minHei,
          maxHeight: maxHei,
        ),
        child: body,
      ),
    );
  }
}
