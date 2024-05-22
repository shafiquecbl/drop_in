import 'package:dropin/src_exports.dart';

Future<bool> popScope() async {
  return (await showDialog(
    context: Get.context!,
    builder: (context) => AlertDialog(
      title: Text('Are you sure?'),
      content: Text('Do you want to exit'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: Text('Yes'),
        ),
      ],
    ),
  )) ??
      false;
}