import '../../../src_exports.dart';

void customBottomSheet({required Widget child}) {
  Get.bottomSheet(
    child,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    backgroundColor: AppColors.purpale,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
  );
}
