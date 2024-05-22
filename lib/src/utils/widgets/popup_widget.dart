import 'package:dropin/src_exports.dart';

class PopupMenuWidget<T> extends PopupMenuEntry<T> {
  const PopupMenuWidget({
    required this.height,
    required this.width,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  final Widget child;

  @override
  final double height;

  @override
  final double width;

  bool get enabled => false;

  @override
  _PopupMenuWidgetState createState() => _PopupMenuWidgetState();

  @override
  bool represents(T? value) {
    // TODO: implement represents
    return false;
  }
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) => widget.child;
}
