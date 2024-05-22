import '../../../../src_exports.dart';

class ConformPassword extends StatelessWidget {
  const ConformPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height,
      decoration: BoxDecoration(gradient: AppColors.background),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: CustomAppBar.getAppBar(
          'Change Password',
          titleColor: AppColors.appBlackColor,
          showBackButton: false,
        ),
        body: Center(
          child: Container(
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              gradient: AppColors.buttonColor,
              borderRadius: BorderRadius.circular(12),
            ),
            // height: 20,
            child: Text(
              textAlign: TextAlign.center,
              'PASSWORD UPDATED!',
              style: AppThemes.lightTheme.textTheme.headlineMedium
                  ?.copyWith(color: AppColors.appWhiteColor),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
          ),
          child: AppElevatedButton(
            callback: () async {
              Get.back();
            },
            title: 'Return',
          ).paddingOnly(bottom: 60),
        ),
      ),
    );
  }
}
