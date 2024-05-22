import 'dart:ui';

import 'package:dropin/src_exports.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController c = Get.put(AuthController());
  FocusNode loginUNamefocus = FocusNode();
  FocusNode passwordfocus = FocusNode();

  FocusNode submit = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    loginUNamefocus.dispose();
    passwordfocus.dispose();

    submit.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      url: AppAssets.loginGif,
      body: GetBuilder<AuthController>(
        builder: (AuthController c) {
          return Form(
            key: _formkey,
            child: IgnorePointer(
              ignoring: c.isLoading,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          AppAssets.asImage(AppAssets.login),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Login'.tr,
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 25,
                                color: AppColors.appWhiteColor,
                              ),
                            ).paddingSymmetric(horizontal: 20, vertical: 10),
                          ),
                          Obx(() {
                            return Column(
                              children: <Widget>[
                                AppTextField(
                                  validator: (String? p0) =>
                                      AppValidation.userField(
                                    c.loginUNameController.text,
                                  ),
                                  obsecureText: false,
                                  enabled: true,
                                  textInputAction: TextInputAction.next,
                                  focusNode: loginUNamefocus,
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(loginUNamefocus);
                                    c.update();
                                  },
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    ),
                                  ],
                                  textController: c.loginUNameController,
                                  readOnly: false,
                                  hint: 'Username'.tr,
                                  title: 'UESRNAME'.tr,
                                  onFieldSubmitted: (String term) {
                                    loginUNamefocus.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(passwordfocus);
                                  },
                                  onChanged: (String p0) async {
                                    c.verify.value = await c.isVerifyLogin();
                                  },
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      c.showloginusername.value =
                                          !c.showloginusername.value;
                                    },
                                    child: CircleAvatar(
                                      radius: 5,
                                      backgroundColor: AppColors.appButtonColor,
                                      child: Icon(
                                        Icons.person,
                                        color: AppColors.appWhiteColor,
                                      ),
                                    ).paddingOnly(right: 10),
                                  ),
                                ).paddingSymmetric(
                                  horizontal: 20,
                                ),
                                getValidations(
                                  validation: AppValidation.userField(
                                    c.loginUNameController.text.trim(),
                                  ),
                                ).paddingSymmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                              ],
                            );
                          }),
                          Obx(() {
                            return Column(
                              children: <Widget>[
                                AppTextField(
                                  obsecureText: c.showloginpass.isFalse,
                                  onChanged: (String p0) async {
                                    c.verify.value = await c.isVerifyLogin();
                                  },
                                  hint: 'Password'.tr,
                                  focusNode: passwordfocus,
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(passwordfocus);
                                    c.update();
                                  },
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    ),
                                  ],
                                  textController: c.passwordCTRL,
                                  readOnly: false,
                                  validator: (String? p0) =>
                                      AppValidation.password(
                                    c.passwordCTRL.text,
                                  ),
                                  title: 'PASSWORD'.tr,
                                  onFieldSubmitted: (String term) {
                                    passwordfocus.unfocus();
                                    FocusScope.of(context).requestFocus(submit);
                                  },
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      c.showloginpass.value =
                                          !c.showloginpass.value;
                                    },
                                    child: CircleAvatar(
                                      radius: 5,
                                      backgroundColor: AppColors.appButtonColor,
                                      child: Icon(
                                        c.showloginpass.value
                                            ? Icons.lock_rounded
                                            : Icons.lock_open_rounded,
                                        color: AppColors.appWhiteColor,
                                      ),
                                    ).paddingOnly(right: 10),
                                  ),
                                ).paddingSymmetric(horizontal: 20),
                                getValidations(
                                  validation: AppValidation.password(
                                    c.passwordCTRL.text.trim(),
                                  ),
                                ).paddingSymmetric(horizontal: 20),
                              ],
                            );
                          }),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              splashColor: AppColors.transparent,
                              focusColor: AppColors.transparent,
                              onTap: () {
                                c.edit(true);
                                Get.dialog(
                                  barrierColor: Colors.transparent,
                                  barrierDismissible: true,
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 2,
                                      sigmaY: 2,
                                      tileMode: TileMode.decal,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: context.height * 0.40,
                                        ),
                                        SingleChildScrollView(
                                          child: Dialog(
                                            backgroundColor: Colors.transparent,
                                            // color: AppColors.transparent,
                                            child: Center(
                                              child: InkWell(
                                                splashColor:
                                                    AppColors.transparent,
                                                focusColor:
                                                    AppColors.transparent,
                                                hoverColor:
                                                    AppColors.transparent,
                                                highlightColor:
                                                    AppColors.transparent,
                                                onTap: () {
                                                  if (c.edit.isTrue) {
                                                    c.loginUNameController
                                                        .clear();
                                                    c.passwordCTRL.clear();
                                                    Get.toNamed(
                                                      Routes
                                                          .ForgetPasswordScreen,
                                                    );
                                                  } else {
                                                    launchUrl(
                                                      mode: LaunchMode
                                                          .externalApplication,
                                                      Uri.parse(
                                                        'https://mail.google.com/mail/u/0/#inbox',
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Obx(() {
                                                  return Container(
                                                    alignment: Alignment.center,
                                                    height: 60,
                                                    width: context.width * 0.60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        12,
                                                      ),
                                                      gradient:
                                                          AppColors.buttonColor,
                                                    ),
                                                    // color: AppColors.appWhiteColor,
                                                    child: c.edit.value
                                                        ? Text(
                                                            'Forgot Password?',
                                                            style: AppThemes
                                                                .lightTheme
                                                                .textTheme
                                                                .headlineLarge
                                                                ?.copyWith(
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .appWhiteColor,
                                                            ),
                                                          )
                                                        : Text(
                                                            'Check Your Email!',
                                                            style: AppThemes
                                                                .lightTheme
                                                                .textTheme
                                                                .headlineLarge
                                                                ?.copyWith(
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .appWhiteColor,
                                                            ),
                                                          ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Forget password?'.tr,
                                style: AppThemes.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppColors.appWhiteColor,
                                  fontSize: 12,
                                ),
                              ).paddingOnly(
                                right: 22,
                                bottom: 20,
                                top: 5,
                                left: 0,
                              ),
                            ),
                          ),
                          c.isLoading
                              ? LoaderView()
                              : AppElevatedButton(
                                  key: c.uNameKey,
                                  focusNode: submit,
                                  color: c.verify.value
                                      ? AppColors.appButtonColor
                                      : AppColors.appButtonColor
                                          .withOpacity(0.8),
                                  width: context.width * 0.90,
                                  height: 50,
                                  callback: () async {
                                    FocusScope.of(context).unfocus();
                                    c.uNameKey.currentState?.animationController
                                        ?.forward();
                                    c.isValidate.value =
                                        checkValidationForAllFields();
                                    if (_formkey.currentState!.validate()) {}
                                    if (c.isValidate.value) {
                                    } else {
                                      if (c.loginUNameController.text.isEmpty) {
                                        c.isTextFieldError = true;
                                        c.uNameKey.currentState
                                            ?.animationController
                                            ?.forward();
                                      } else {}
                                      await c.loginWithEmail();
                                      c.isValidate(false);
                                    }
                                    /*await FirebaseAuth.instance.signOut();*/
                                  },
                                  title: 'Sign In'.tr,
                                ).paddingSymmetric(horizontal: 20),
                          TextButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Get.toNamed(Routes.SignUpScreen);
                            },
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Don’t have an account yet? '.tr,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Register.'.tr,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.appButtonColor,
                                    decorationThickness: 3,
                                  ),
                                ),
                              ],
                            ),
                          ).paddingSymmetric(horizontal: 30, vertical: 20),
                        ],
                      ),
                    ),
                  ),
                  // RichText(
                  //   textAlign: TextAlign.center,
                  //   text: TextSpan(
                  //     text:
                  //         'By Clicking on "Sign In" or "Register"\n you agree with our ',
                  //     style: AppThemes.lightTheme.textTheme.headlineMedium
                  //         ?.copyWith(
                  //       color: AppColors.appWhiteColor,
                  //       fontSize: 14,
                  //     ),
                  //     children: <TextSpan>[
                  //       TextSpan(
                  //         text: 'Privacy Policy',
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           decoration: TextDecoration.underline,
                  //         ),
                  //         recognizer: TapGestureRecognizer()
                  //           ..onTap = () => Get.toNamed(Routes.privacyPolicy),
                  //       ),
                  //       TextSpan(
                  //         text: ' & ',
                  //       ),
                  //       TextSpan(
                  //         text: 'EULA',
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           decoration: TextDecoration.underline,
                  //         ),
                  //         recognizer: TapGestureRecognizer()
                  //           ..onTap = () => Get.toNamed(
                  //                 Routes.privacyPolicy,
                  //                 arguments: UrlConst.termsAndConditions,
                  //               ),
                  //       ),
                  //     ],
                  //   ),
                  // ).paddingOnly(bottom: 10)
                ],
              ),
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
      children: <Widget>[
        const SizedBox(width: 5),
        Text(
          validation,
          style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
            fontSize: 10,
            color: AppColors.appWhiteColor,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  bool checkValidationForAllFields() {
    if (AppValidation.userField(c.loginUNameController.text) == null &&
        AppValidation.password(c.passwordCTRL.text) == null) {
      return false;
    } else {
      return true;
    }
  }
}
