import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../src_exports.dart';

class PrivacyPolicy extends StatelessWidget {
  PrivacyPolicy({super.key});

  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          color: Colors.black,
          onPressed: Get.back,
        ),
      ),
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri.uri(
              Uri.parse(
                Get.arguments ?? UrlConst.privacyPolicy,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
