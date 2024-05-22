import '../../../src_exports.dart';

void showSnackBar(String title, [String subtitle = '']) {
  Get.snackbar(
    title,
    subtitle,
    backgroundColor: AppColors.appButtonColor,
    snackPosition: SnackPosition.BOTTOM,
    colorText: Colors.white,
    margin: EdgeInsets.zero,
    borderRadius: 0,
  );
}
