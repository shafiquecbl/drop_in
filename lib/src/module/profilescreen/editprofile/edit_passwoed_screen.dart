import '../../../../src_exports.dart';

class EditPasswordScreen extends StatefulWidget {
  EditPasswordScreen({Key? key}) : super(key: key);

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final c = Get.put(AuthController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode oldPass = FocusNode();
  FocusNode newPass = FocusNode();
  FocusNode confimNewPass = FocusNode();
  FocusNode submit = FocusNode();

  @override
  void initState() {
    super.initState();
    oldPass = FocusNode();
    newPass = FocusNode();
    confimNewPass = FocusNode();
    submit = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (AuthController controller) {
        return Container(
          height: context.height,
          decoration: BoxDecoration(gradient: AppColors.background),
          child: WillPopScope(
            onWillPop: () async {
              c.passwordCTRL.clear();
              c.newPassword.clear();
              c.conformnewPasswordCTRL.clear();
              return await true;
            },
            child: Scaffold(
              backgroundColor: AppColors.transparent,
              appBar: CustomAppBar.getAppBar('Change Password',
                  titleColor: AppColors.appBlackColor, showBackButton: false),
              body: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Old password',
                      style: AppThemes.lightTheme.textTheme.headlineMedium,
                    ).paddingOnly(top: 20, left: 20, bottom: 5),
                    TextFormField(
                      controller: c.passwordCTRL,
                      focusNode: oldPass,

                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter old password',
                        fillColor: oldPass.hasFocus
                            ? AppColors.appWhiteColor
                            : AppColors.appWhiteColor.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // validator: (p0) =>
                      //     AppValidation.password(c.passwordCTRL.text),
                      onTap: () {
                        FocusScope.of(context).requestFocus(oldPass);
                        c.update();
                      },
                      onFieldSubmitted: (String term) {
                        oldPass.unfocus();
                        FocusScope.of(context).requestFocus(newPass);
                      },
                    ).paddingSymmetric(horizontal: 15),
                    Text(
                      'New password',
                      style: AppThemes.lightTheme.textTheme.headlineMedium,
                    ).paddingOnly(top: 20, left: 20, bottom: 5),
                    TextFormField(
                      controller: c.newPassword,
                      focusNode: newPass,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: newPass.hasFocus
                            ? AppColors.appWhiteColor
                            : AppColors.appWhiteColor.withOpacity(0.8),
                        hintText: 'Enter new password',
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      // validator: (String? p0) =>
                      //     AppValidation.password(c.passwordCTRL.text),
                      onTap: () {
                        FocusScope.of(context).requestFocus(newPass);
                        c.update();
                      },
                      onFieldSubmitted: (String term) {
                        newPass.unfocus();
                        FocusScope.of(context).requestFocus(confimNewPass);
                      },
                    ).paddingSymmetric(horizontal: 15),
                    Text(
                      'Confirm new password',
                      style: AppThemes.lightTheme.textTheme.headlineMedium,
                    ).paddingOnly(top: 20, left: 20, bottom: 5),
                    TextFormField(
                      controller: c.conformnewPasswordCTRL,
                      focusNode: confimNewPass,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: confimNewPass.hasFocus
                            ? AppColors.appWhiteColor
                            : AppColors.appWhiteColor.withOpacity(0.8),
                        hintText: 'Enter password again',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // validator: (String? p0) => AppValidation.conformPass(
                      //   c.conformnewPasswordCTRL.text.trim(),
                      //   c.newPassword.text.trim(),
                      // ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(confimNewPass);
                        c.update();
                      },
                      onFieldSubmitted: (String term) {
                        confimNewPass.unfocus();
                        FocusScope.of(context).requestFocus(submit);
                        c.update();
                      },
                    ).paddingSymmetric(horizontal: 15),
                  ],
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: !controller.isLoading,
                      replacement: LoaderView(),
                      child: AppElevatedButton(
                        focusNode: submit,
                        callback: () async {
                          await c.changePassword();
                        },
                        title: 'Update',
                      ),
                    ).paddingOnly(bottom: 10),
                    IgnorePointer(
                      ignoring: controller.isLoading,
                      child: AppElevatedButton(
                        callback: () {
                          Get.back();
                          c.passwordCTRL.clear();
                          c.newPassword.clear();
                          c.conformnewPasswordCTRL.clear();
                        },
                        title: 'Back',
                      ).paddingOnly(bottom: 50),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
