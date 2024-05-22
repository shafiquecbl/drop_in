import 'package:dropin/src_exports.dart';
import 'package:flutter/gestures.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController c = Get.put(AuthController());

  FocusNode focusUsername = FocusNode();
  FocusNode focusfirstname = FocusNode();
  FocusNode focuslastname = FocusNode();
  FocusNode focusemail = FocusNode();
  FocusNode focuspassword = FocusNode();
  FocusNode focusconfirmpass = FocusNode();
  FocusNode submit = FocusNode();

  @override
  void initState() {
    super.initState();
    focusUsername = FocusNode();
    focusfirstname = FocusNode();
    focuslastname = FocusNode();
    focusemail = FocusNode();
    focuspassword = FocusNode();
    focusconfirmpass = FocusNode();
    submit = FocusNode();
  }

  final GlobalKey<FormState> signupkey = GlobalKey<FormState>();

  @override
  void dispose() {
    focusUsername.dispose();
    focusfirstname.dispose();
    focuslastname.dispose();
    focusemail.dispose();
    focuspassword.dispose();
    focusconfirmpass.dispose();
    submit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Create Account'.tr,
          style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
            fontSize: 25,
            color: AppColors.appWhiteColor,
          ),
        ),
      ),
      body: GetBuilder<AuthController>(builder: (c) {
        return SingleChildScrollView(
          child: Form(
            key: signupkey,
            child: Column(
              children: [
                Obx(() {
                  return Column(
                    children: [
                      AppTextField(
                        // fillColor: focusUsername.hasFocus
                        //     ? AppColors.appWhiteColor
                        //     : AppColors.appWhiteColor.withOpacity(0.8),
                        textInputAction: TextInputAction.next,
                        // hint: '....'.tr,
                        enabled: true,
                        focusNode: focusUsername,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('[a-z A-Z 0-9]'),
                          ),
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        validator: (String? p0) {
                          AppValidation.userField(c.uNameController.text);
                          return null;
                        },

                        onTap: () {
                          FocusScope.of(context).requestFocus(focusUsername);
                          c.update();
                        },
                        textController: c.uNameController,

                        keyboardType: TextInputType.name,

                        onChanged: (String value) async {
                          c.verify.value = await c.isVerifyed();
                          c.checkUserName(value);
                        },
                        onFieldSubmitted: (term) {
                          focusUsername.unfocus();
                          FocusScope.of(context).requestFocus(focusfirstname);
                          c.update();
                        },
                        title: 'USERNAME'.tr,
                      ).paddingSymmetric(horizontal: 15),
                      getValidations(
                              validation: AppValidation.userField(
                                  c.uNameController.text.trim()))
                          .paddingSymmetric(
                        horizontal: 20,
                        vertical: 8,
                      )
                    ],
                  );
                }),
                Obx(() {
                  return Column(
                    children: [
                      AppTextField(
                        // fillColor: focusfirstname.hasFocus
                        //     ? AppColors.appWhiteColor
                        //     : AppColors.appWhiteColor.withOpacity(0.8),
                        obsecureText: false,
                        enabled: true,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-z A-Z]')),
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        focusNode: focusfirstname,
                        // hint: '....'.tr,
                        validator: (p0) => AppValidation.firstname(
                            c.firstNameCTRL.text.trim()),
                        textController: c.firstNameCTRL,
                        readOnly: false,

                        // textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,

                        onChanged: (p0) async {
                          c.verify.value = await c.isVerifyed();
                        },
                        onTap: () {
                          FocusScope.of(context).requestFocus(focusfirstname);
                          c.update();
                        },
                        onFieldSubmitted: (String term) {
                          focusfirstname.unfocus();
                          FocusScope.of(context).requestFocus(focuslastname);
                          c.update();
                        },
                        title: 'FIRST NAME'.tr,
                      ).paddingSymmetric(horizontal: 15),
                      getValidations(
                        validation: AppValidation.firstname(
                          c.firstNameCTRL.text..trim(),
                        ),
                      ).paddingSymmetric(
                        horizontal: 20,
                        vertical: 8,
                      )
                    ],
                  );
                }),
                Obx(() {
                  return Column(
                    children: [
                      AppTextField(
                        // fillColor: focuslastname.hasFocus
                        //     ? AppColors.appWhiteColor
                        //     : AppColors.appWhiteColor.withOpacity(0.8),
                        onTap: () {
                          FocusScope.of(context).requestFocus(focuslastname);
                          c.update();
                        },
                        obsecureText: false,
                        enabled: true,
                        textInputAction: TextInputAction.next,
                        // hint: '....',
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-z A-Z]')),
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        validator: (p0) =>
                            AppValidation.lastname(c.lastNameCTRL.text.trim()),
                        focusNode: focuslastname,
                        keyboardType: TextInputType.name,

                        textController: c.lastNameCTRL,
                        readOnly: false,
                        onChanged: (p0) async {
                          c.verify.value = await c.isVerifyed();
                        },
                        onFieldSubmitted: (term) {
                          focuslastname.unfocus();
                          FocusScope.of(context).requestFocus(focusemail);
                          c.update();
                        },
                        title: 'LAST NAME'.tr,
                      ).paddingSymmetric(horizontal: 15),
                      getValidations(
                              validation: AppValidation.lastname(
                                  c.lastNameCTRL.text.trim()))
                          .paddingSymmetric(
                        horizontal: 20,
                        vertical: 8,
                      )
                    ],
                  );
                }),
                Obx(() {
                  return Column(
                    children: [
                      AppTextField(
                        onTap: () {
                          FocusScope.of(context).requestFocus(focusemail);
                          c.update();
                        },
                        textInputAction: TextInputAction.next,
                        obsecureText: false,
                        enabled: true,
                        validator: (p0) => AppValidation.email(
                            c.signupEmailController.text.trim()),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        focusNode: focusemail,
                        keyboardType: TextInputType.emailAddress,

                        // hint: '....',
                        onChanged: (p0) async {
                          c.verify.value = await c.isVerifyed();
                        },
                        onFieldSubmitted: (String term) {
                          focusemail.unfocus();
                          FocusScope.of(context).requestFocus(focuspassword);
                          c.update();
                        },
                        textController: c.signupEmailController,
                        readOnly: false,
                        title: 'EMAIL ADDRESS'.tr,
                      ).paddingSymmetric(horizontal: 15),
                      getValidations(
                        validation: AppValidation.email(
                          c.signupEmailController.text.trim(),
                        ),
                      ).paddingSymmetric(
                        horizontal: 20,
                        vertical: 8,
                      )
                    ],
                  );
                }),
                Obx(() {
                  return Column(
                    children: [
                      AppTextField(
                        onTap: () {
                          FocusScope.of(context).requestFocus(focuspassword);
                          c.update();
                        },
                        // fillColor: focuspassword.hasFocus
                        //     ? AppColors.appWhiteColor
                        //     : AppColors.appWhiteColor.withOpacity(0.8),

                        obsecureText: c.showPassword.isFalse,
                        onChanged: (p0) async {
                          c.verify.value = await c.isVerifyed();
                        },
                        // hint: '....',
                        enabled: true,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        validator: (p0) => AppValidation.password(
                            c.signupPasswordCTRL.text.trim()),
                        focusNode: focuspassword,
                        textController: c.signupPasswordCTRL,

                        readOnly: false,
                        suffixIcon: IconButton(
                          onPressed: () {
                            c.showPassword.value = !c.showPassword.value;
                          },
                          icon: Icon(
                            c.showPassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        title: 'PASSWORD'.tr,
                        onFieldSubmitted: (term) {
                          focuspassword.unfocus();
                          FocusScope.of(context).requestFocus(focusconfirmpass);
                          c.update();
                        },
                      ).paddingSymmetric(horizontal: 15),
                      getValidations(
                        validation: AppValidation.password(
                          c.signupPasswordCTRL.text.trim(),
                        ),
                      ).paddingSymmetric(
                        horizontal: 20,
                        vertical: 8,
                      )
                    ],
                  );
                }),
                Obx(() {
                  return Column(
                    children: [
                      AppTextField(
                        onTap: () {
                          FocusScope.of(context).requestFocus(focusconfirmpass);
                          c.update();
                        },

                        onChanged: (p0) async {
                          c.verify.value = await c.isVerifyed();
                        },
                        enabled: true,
                        textInputAction: TextInputAction.next,
                        obsecureText: c.edit.isFalse,
                        validator: (p0) => AppValidation.conformPass(
                          c.conformpasswordCTRL.text.trim(),
                          c.signupPasswordCTRL.text.trim(),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            c.edit.value = !c.edit.value;
                          },
                          icon: Icon(
                            c.edit.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        // hint: '....',
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        textController: c.conformpasswordCTRL,
                        readOnly: false,
                        focusNode: focusconfirmpass,
                        title: 'CONFIRM PASSWORD'.tr,

                        onFieldSubmitted: (term) {
                          focusconfirmpass.unfocus();
                          FocusScope.of(context).requestFocus(submit);
                          c.update();
                        },
                      ).paddingSymmetric(horizontal: 15),
                      getValidations(
                              validation: AppValidation.conformPass(
                                  c.conformpasswordCTRL.text.trim(),
                                  c.signupPasswordCTRL.text.trim()))
                          .paddingSymmetric(
                        horizontal: 20,
                        vertical: 8,
                      )
                    ],
                  );
                }),
                Row(
                  children: [
                    Obx(() {
                      return Checkbox(
                        checkColor: Colors.white,
                        activeColor: AppColors.appButtonColor,
                        fillColor:
                            MaterialStateProperty.resolveWith(c.getColor),
                        value: c.showvalue.value,
                        onChanged: (bool? value) {
                          FocusScope.of(context).unfocus();
                          c.showvalue.value = value!;
                        },
                      );
                    }),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'I agree to the user ',
                          style: AppThemes.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: AppColors.appWhiteColor,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.toNamed(Routes.privacyPolicy),
                            ),
                            TextSpan(
                              text: ' & ',
                            ),
                            TextSpan(
                              text: 'EULA',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.toNamed(
                                      Routes.privacyPolicy,
                                      arguments: UrlConst.termsAndConditions,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ).paddingSymmetric(horizontal: 15),
                c.isLoading
                    ? LoaderView()
                    : AppElevatedButton(
                        color: c.verify.value
                            ? AppColors.appButtonColor
                            : AppColors.appButtonColor.withOpacity(0.8),
                        key: c.signUpkey,
                        focusNode: submit,
                        width: context.width * 0.90,
                        height: 50,
                        callback: () async {
                          c.signUpkey.currentState?.animationController
                              ?.forward();
                          c.isValidate.value = checkValidationForAllFields();
                          if (signupkey.currentState!.validate()) {}
                          if (c.isValidate.value) {
                          } else {
                            if (c.uNameController.text.isEmpty) {
                              c.isTextFieldError = true;
                              c.signUpkey.currentState?.animationController
                                  ?.forward();
                              // c.textFieldErrorShakeKey.currentState?.shakeWidget();
                            }
                            c.showvalue.value
                                ? await c.signupMethod()
                                : c.onError('please select privacy', () {});
                            c.isValidate(false);
                          }
                        },
                        title: 'Register'.tr,
                      ).paddingSymmetric(horizontal: 20),
                InkWell(
                  splashColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    'Already have an account? Log in.'.tr,
                    style: AppThemes.lightTheme.textTheme.headlineMedium
                        ?.copyWith(color: AppColors.appWhiteColor),
                  ).paddingSymmetric(horizontal: 35, vertical: 20),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget getValidations({String? validation}) {
    if (!c.isValidate.value || validation == null) {
      return const SizedBox();
    }
    return Row(
      children: [
        const SizedBox(width: 5),
        Text(validation,
            style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                fontSize: 10,
                color: AppColors.appWhiteColor,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.start)
      ],
    );
  }

  bool checkValidationForAllFields() {
    if (AppValidation.userField(c.uNameController.text) == null &&
        AppValidation.firstname(c.firstNameCTRL.text) == null &&
        AppValidation.lastname(c.lastNameCTRL.text) == null &&
        AppValidation.email(c.signupEmailController.text) == null &&
        AppValidation.password(c.signupPasswordCTRL.text) == null &&
        AppValidation.conformPass(
                c.conformpasswordCTRL.text, c.signupPasswordCTRL.text) ==
            null) {
      return false;
    } else {
      return true;
    }
  }
}
