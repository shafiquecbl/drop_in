import '../../../src_exports.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback? callback;
  final String message;
  final String description;
  const ErrorView({
    Key? key,
    this.callback,
    required this.message,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(message),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: callback,
            child: const Text('Retry again'),
          )
        ],
      ),
    );
  }
}
