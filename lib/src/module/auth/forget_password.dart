import '../../../src_exports.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final AuthController c = Get.put(AuthController());

  ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      url: AppAssets.loginGif,
      body: GetBuilder<AuthController>(
        builder: (c) {
          return SingleChildScrollView(
            child: Column(
              children: [
                AppAssets.asImage(AppAssets.login),
                Obx(() {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      AppTextField(
                        obsecureText: false,
                        hint: '   .... ',
                        onChanged: (p0) async {
                          c.verify.value = await c.isVerifyed();
                        },
                        textController: c.forgetEmailController,
                        readOnly: false,
                        title: '  EMAIL ADDRESS'.tr,
                      ).paddingSymmetric(
                        horizontal: 20,
                      ),
                      getValidations(
                        validation:
                            AppValidation.email(c.forgetEmailController.text),
                      ).paddingSymmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                    ],
                  );
                }),
                SizedBox(
                  height: context.height * 0.05,
                ),
                c.isLoading
                    ? LoaderView()
                    : AppElevatedButton(
                        width: context.width * 0.90,
                        height: 50,
                        callback: () async {
                          c.isValidate.value = !checkValidationForAllFields();
                          logger.w(c.isValidate.value);
                          if (c.isValidate.value) {
                            await c.forgetPassword();
                            c.isValidate(false);
                          }
                        },
                        title: 'Send Link'.tr,
                      ).paddingSymmetric(horizontal: 20, vertical: 10),
                AppElevatedButton(
                  width: context.width * 0.90,
                  height: 50,
                  callback: () {
                    Get.back();
                    // c.edit(false);
                  },
                  title: 'Back'.tr,
                ).paddingSymmetric(horizontal: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getValidations({String? validation}) {
    if (!c.isValidate.value || validation == null) {
      return const SizedBox();
    }
    return Row(
      children: [
        const SizedBox(width: 5),
        Text(
          validation,
          style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
            fontSize: 10,
            color: AppColors.appWhiteColor,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.start,
        )
      ],
    );
  }

  bool checkValidationForAllFields() {
    if (AppValidation.email(c.signupEmailController.text) == null) {
      return true;
    } else {
      return false;
    }
  }
}
