import '../../../src/utils/widgets/web_textfield.dart';
import '../../../src_exports.dart';

class WebLogin extends GetResponsiveView {
  WebLogin({super.key});
  final AuthController c = Get.put(AuthController());

  /*final GlobalKey<FormState> _formKey = GlobalKey<FormState>();*/

  @override
  Widget desktop() {
    return Scaffold(
      // backgroundColor: AppColors.appButtonColor,
      body: GetBuilder<AuthController>(
        builder: (AuthController c) {
          return Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: SizedBox(
                        height: Get.context!.height,
                        child: AppAssets.asImage(
                          AppAssets.backgroundimage,
                          fit: BoxFit.cover,
                          width: Get.width / 2.1,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            getValidations(
                              validation: AppValidation.password(
                                c.webPasswordController.text.trim(),
                              ),
                            ).paddingSymmetric(horizontal: 20),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Sign in',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineLarge
                                  ?.copyWith(fontSize: 30),
                            ).paddingSymmetric(horizontal: 22, vertical: 30),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Email',
                                style: AppThemes
                                    .lightTheme.textTheme.headlineLarge
                                    ?.copyWith(fontSize: 12),
                              ).paddingSymmetric(horizontal: 28),
                            ),
                            Obx(
                              () => Column(
                                children: <Widget>[
                                  WebTextField(
                                    height: 45,
                                    hint: 'Email',
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.deny(
                                        RegExp(r'\s'),
                                      ),
                                    ],
                                    validator: (String? p0) =>
                                        AppValidation.email(
                                      c.webEmailController.text,
                                    ),
                                    textController: c.webEmailController,
                                    onChanged: (String p0) async {
                                      c.verify.value = await c.isVerifyedWeb();
                                    },
                                  ).paddingSymmetric(
                                      horizontal: 30, vertical: 5),
                                  getValidations(
                                    validation: AppValidation.email(
                                      c.webEmailController.text.trim(),
                                    ),
                                  ).paddingSymmetric(
                                    horizontal: 25,
                                    vertical: 8,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Password',
                                style: AppThemes
                                    .lightTheme.textTheme.headlineLarge
                                    ?.copyWith(fontSize: 12),
                              ).paddingSymmetric(
                                horizontal: 28,
                              ),
                            ),
                            Obx(
                              () => Column(
                                children: <Widget>[
                                  WebTextField(
                                    height: 45,
                                    hint: 'password',
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.deny(
                                        RegExp(r'\s'),
                                      ),
                                    ],
                                    textController: c.webPasswordController,
                                    obsecureText: c.showloginpass.isFalse,
                                    onChanged: (String p0) async {
                                      c.verify.value = await c.isVerifyedWeb();
                                    },
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        c.showloginpass.value =
                                            !c.showloginpass.value;
                                      },
                                      icon: Icon(
                                        c.showloginpass.value
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                  ).paddingSymmetric(
                                      horizontal: 30, vertical: 5),
                                  getValidations(
                                    validation: AppValidation.password(
                                      c.webPasswordController.text.trim(),
                                    ),
                                  ).paddingSymmetric(horizontal: 25),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            c.isLoading
                                ? LoaderView()
                                : AppElevatedButton(
                                    width: 120,
                                    height: 50,
                                    borderRadius: BorderRadius.circular(2),
                                    key: c.webUpkey,
                                    color: c.verify.value
                                        ? Colors.blueAccent
                                        : Colors.grey,
                                    callback: () async {
                                      c.webUpkey.currentState
                                          ?.animationController
                                          ?.forward();
                                      c.isValidate.value =
                                          checkValidationForAllFields();

                                      if (c.isValidate.value) {
                                      } else {
                                        if (c.webEmailController.text.isEmpty) {
                                          c.isTextFieldError = true;
                                          c.webUpkey.currentState
                                              ?.animationController
                                              ?.forward();
                                        } else {}
                                        await c.adminLogin();
                                        c.isValidate(false);
                                        c.webPasswordController.clear();
                                      }

                                      logger.wtf(Routes.NavigationScreen);
                                    },
                                    title: 'Sign in',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: c.verify.value
                                          ? Colors.white
                                          : Colors.white70,
                                    ),
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ).paddingOnly(
                            top: 60, bottom: 60, left: 120, right: 120),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget tablet() {
    return GetBuilder<AuthController>(
      builder: (AuthController c) {
        return Scaffold(
          body: Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: SizedBox(
                        height: Get.context!.height,
                        child: AppAssets.asImage(
                          AppAssets.backgroundimage,
                          fit: BoxFit.cover,
                          width: Get.width / 2,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Sign in',
                            style: AppThemes.lightTheme.textTheme.headlineLarge
                                ?.copyWith(fontSize: 30),
                          ).paddingSymmetric(horizontal: 22, vertical: 30),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Email',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineLarge
                                  ?.copyWith(fontSize: 12),
                            ).paddingSymmetric(horizontal: 20),
                          ),
                          Obx(
                            () => Column(
                              children: <Widget>[
                                WebTextField(
                                  height: 45,
                                  hint: 'Email',
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    ),
                                  ],
                                  validator: (String? p0) =>
                                      AppValidation.email(
                                    c.webEmailController.text,
                                  ),
                                  textController: c.webEmailController,
                                  onChanged: (String p0) async {
                                    c.verify.value = await c.isVerifyedWeb();
                                  },
                                ).paddingSymmetric(horizontal: 20, vertical: 5),
                                getValidations(
                                  validation: AppValidation.email(
                                    c.webEmailController.text.trim(),
                                  ),
                                ).paddingSymmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Password',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineLarge
                                  ?.copyWith(fontSize: 12),
                            ).paddingSymmetric(
                              horizontal: 20,
                            ),
                          ),
                          Obx(
                            () => Column(
                              children: <Widget>[
                                WebTextField(
                                  height: 45,
                                  radius: 0,
                                  hint: 'Password',
                                  inputFormatters: <TextInputFormatter>[
                                    // this will deny space input
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    ),
                                  ],
                                  textController: c.webPasswordController,
                                  obsecureText: c.showloginpass.isFalse,
                                  onChanged: (String p0) async {
                                    c.verify.value = await c.isVerifyedWeb();
                                  },
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      c.showloginpass.value =
                                          !c.showloginpass.value;
                                    },
                                    icon: Icon(
                                      c.showloginpass.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ).paddingSymmetric(horizontal: 20, vertical: 5),
                                getValidations(
                                  validation: AppValidation.password(
                                    c.webPasswordController.text.trim(),
                                  ),
                                ).paddingSymmetric(horizontal: 20),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          c.isLoading
                              ? LoaderView()
                              : AppElevatedButton(
                                  width: 120,
                                  height: 50,
                                  borderRadius: BorderRadius.circular(2),
                                  key: c.webUpkey,
                                  color: c.verify.value
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                  callback: () async {
                                    c.webUpkey.currentState?.animationController
                                        ?.forward();
                                    c.isValidate.value =
                                        checkValidationForAllFields();

                                    if (c.isValidate.value) {
                                    } else {
                                      if (c.webEmailController.text.isEmpty) {
                                        c.isTextFieldError = true;
                                        c.webUpkey.currentState
                                            ?.animationController
                                            ?.forward();
                                      } else {}
                                      await c.adminLogin();
                                      c.isValidate(false);
                                    }

                                    logger.wtf(Routes.NavigationScreen);
                                  },
                                  title: 'Sign in',
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: c.verify.value
                                        ? Colors.white
                                        : Colors.white70,
                                  ),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'forgot password?',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ).paddingOnly(top: 60, bottom: 60, left: 120, right: 120),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getValidations({String? validation}) {
    if (!c.isValidate.value || validation == null) {
      return const SizedBox();
    }
    return Row(
      children: <Widget>[
        const SizedBox(width: 5),
        Text(
          validation,
          style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
            fontSize: 10,
            color: AppColors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  bool checkValidationForAllFields() {
    if (AppValidation.email(c.webEmailController.text) == null &&
        AppValidation.password(c.webPasswordController.text) == null) {
      return false;
    } else {
      return true;
    }
  }
}
