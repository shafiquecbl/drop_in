import '../../../src_exports.dart';

class CustomContainer extends StatelessWidget {
  CustomContainer({required this.title, this.onTap, super.key});

  String title;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 150,
        decoration: BoxDecoration(
          color: AppColors.appWhiteColor,
          border: Border.all(color: AppColors.appBlackColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.appWhiteColor,
              offset: Offset(0.5, 0.5),
              spreadRadius: 0.8,
              blurRadius: 5,
            ),
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          title,
          style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppColors.appBlackColor,
          ),
          textAlign: TextAlign.center,
        ).paddingSymmetric(vertical: 8),
      ),
    );
  }
}
