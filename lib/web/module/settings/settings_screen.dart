import 'package:dropin/src/utils/widgets/web_textfield.dart';
import 'package:dropin/web/module/settings/settings_screen_controller.dart';

import '../../../src/models/category_model.dart';
import '../../../src/models/drop_in_category.dart';
import '../../../src/utils/widgets/app_images.dart';
import '../../../src/utils/widgets/custom_dialog.dart';
import '../../../src/utils/widgets/web_button.dart';
import '../../../src_exports.dart';
import '../homescreen/homescreen_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController controller = Get.put(SettingsController());
  final AdminController c = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SettingsController>(
        builder: (SettingsController controller) {
          if (controller.isLoading || controller.lodingMore) {
            return SizedBox(height: Get.height * 0.61, child: LoaderView());
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Settings',
                    style: AppThemes.lightTheme.textTheme.headlineLarge
                        ?.copyWith(fontSize: 32),
                  ).paddingSymmetric(horizontal: 8),

                  ///  Category User ///
                  Text(
                    'Category User',
                    style: AppThemes.lightTheme.textTheme.headlineLarge
                        ?.copyWith(fontSize: 28),
                  ).paddingOnly(left: 50),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CategoryView(categoryModel: controller.categoryList[0]),
                      CategoryView(categoryModel: controller.categoryList[1]),
                      Spacer(),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      EditCategoryButton(category: controller.categoryList[0]),
                      EditCategoryButton(category: controller.categoryList[1]),
                      Spacer(),
                    ],
                  ).paddingSymmetric(vertical: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CategoryView(categoryModel: controller.categoryList[2]),
                      CategoryView(categoryModel: controller.categoryList[3]),
                      Spacer(),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      EditCategoryButton(category: controller.categoryList[2]),
                      EditCategoryButton(category: controller.categoryList[3]),
                      Spacer(),
                    ],
                  ).paddingSymmetric(vertical: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CategoryView(categoryModel: controller.categoryList[4]),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      EditCategoryButton(category: controller.categoryList[4]),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  ).paddingSymmetric(vertical: 10),

                  SizedBox(
                    height: 20,
                  ),

                  ///  Category Business ///
                  Text(
                    'Category Business',
                    style: AppThemes.lightTheme.textTheme.headlineLarge
                        ?.copyWith(fontSize: 28),
                  ).paddingOnly(left: 60),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      BusinessCategory(business: controller.dropInList[0]),
                      BusinessCategory(business: controller.dropInList[1]),
                      Spacer(),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      BusinessCategoryButton(
                        business: controller.dropInList[0],
                      ),
                      BusinessCategoryButton(
                        business: controller.dropInList[1],
                      ),
                      Spacer(),
                    ],
                  ).paddingSymmetric(vertical: 10),
                  Row(
                    children: <Widget>[
                      BusinessCategory(business: controller.dropInList[2]),
                      BusinessCategory(business: controller.dropInList[3]),
                      Spacer(),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      BusinessCategoryButton(
                        business: controller.dropInList[2],
                      ),
                      BusinessCategoryButton(
                        business: controller.dropInList[3],
                      ),
                      Spacer(),
                    ],
                  ).paddingSymmetric(vertical: 10),
                  Row(
                    children: <Widget>[
                      BusinessCategory(business: controller.dropInList[4]),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      BusinessCategoryButton(
                        business: controller.dropInList[4],
                      ),
                      Spacer(flex: 2),
                    ],
                  ).paddingSymmetric(vertical: 10),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'User Settings',
                    style: AppThemes.lightTheme.textTheme.bodySmall?.copyWith(
                      fontSize: 28,
                      color: AppColors.appBlackColor,
                    ),
                  ).paddingOnly(left: 50, bottom: 10),
                  InkWell(
                    splashColor: AppColors.transparent,
                    focusColor: AppColors.transparent,
                    hoverColor: AppColors.transparent,
                    highlightColor: AppColors.transparent,
                    onTap: () {
                      c.currentPage(NavigationEnum.ChangePassword);
                      logger.w(
                        c.currentPage(NavigationEnum.ChangePassword),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.lock,
                          color: AppColors.appBlackColor,
                        ),
                        Text(
                          'Change password',
                          style: AppThemes.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            fontSize: 28,
                            color: AppColors.appBlackColor,
                          ),
                        ),
                      ],
                    ).paddingOnly(left: 20, bottom: 50),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({required this.categoryModel, super.key});
  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          // color: AppColors.textFieldColor.withOpacity(0.8),
          border: Border.all(color: AppColors.appButtonColor),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'CATEGORY',
              style: AppThemes.lightTheme.textTheme.headlineMedium
                  ?.copyWith(fontSize: 8),
            ).paddingSymmetric(horizontal: 10, vertical: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${categoryModel.name}',
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontSize: 16,
                    color: AppColors.dark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    AppImages.asImage(
                      UrlConst.otherMediaBase + '${categoryModel.icon}',
                      height: 30,
                      width: 30,
                    ),
                    Icon(Icons.keyboard_arrow_down_sharp),
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: 15, vertical: 5),
          ],
        ),
      ).paddingOnly(left: 20, right: 20),
    );
  }
}

class EditCategoryButton extends StatelessWidget {
  EditCategoryButton({required this.category, super.key});
  final CategoryModel category;
  final SettingsController controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: WebElevatedButton(
        textAlign: TextAlign.start,
        alignment: Alignment.centerLeft,
        borderRadius: BorderRadius.circular(11),
        color: AppColors.textFieldColor.withOpacity(0.8),
        callback: () {
          showDialog(
            context: Get.context!,
            builder: (BuildContext context) => DialogContainer(
              body: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.appWhiteColor,
                ),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Category User',
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppColors.appButtonColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ).paddingOnly(top: 10, bottom: 10),
                    ),
                    SizedBox(
                      width: 400,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          // color: AppColors.textFieldColor.withOpacity(0.8),
                          border: Border.all(color: AppColors.appButtonColor),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'CATEGORY',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(fontSize: 8),
                            ).paddingSymmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${category.name}',
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontSize: 16,
                                    color: AppColors.dark,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 15,
                                    ),
                                    AppImages.asImage(
                                      UrlConst.otherMediaBase +
                                          '${category.icon}',
                                      height: 25,
                                      width: 25,
                                    ),
                                    Icon(Icons.keyboard_arrow_down_sharp),
                                  ],
                                ),
                              ],
                            ).paddingSymmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                          ],
                        ),
                      ).paddingOnly(
                        left: 20,
                        right: 20,
                      ),
                    ).paddingSymmetric(vertical: 10),
                    SizedBox(
                      width: 400,
                      child: WebTextFields(
                        hint: 'Edit',
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(
                            22,
                          ),
                        ],
                        onChanged: (String p0) {
                          controller.updateTextFieldValue1 = p0;
                          // final String value = controller
                          //     .categoryList[0].name = p0;
                          //
                          // controller.updateTextFieldValue1 =
                          //     value;
                        },
                        onFieldSubmitted: (String p0) {
                          controller.updateBussinessCategoriessy<CategoryModel>(
                              cat: category);
                        },
                        fillColor: AppColors.textFieldColor.withOpacity(0.8),
                        radius: 11,
                      ).paddingSymmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AppElevatedButton(
                          color: AppColors.redcolor,
                          height: 50,
                          borderRadius: BorderRadius.circular(8),
                          width: 180,
                          callback: () {
                            logger.w(category.toJson());
                            controller
                                .updateBussinessCategoriessy<CategoryModel>(
                                    cat: category);
                          },
                          title: 'Confirm',
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        AppElevatedButton(
                          color: AppColors.greyColor,
                          height: 50,
                          borderRadius: BorderRadius.circular(8),
                          width: 180,
                          callback: () {
                            Get.back();
                          },
                          title: 'Cancel',
                          style: AppThemes.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: AppColors.appBlackColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 10),
                  ],
                ),
              ),
              maxHei: 250,
              minHei: 250,
              maxWid: 420,
              minWid: 420,
            ),
          );
        },
        title: 'Edit',
        style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
          fontSize: 16,
          color: AppColors.appBlackColor,
        ),
      ).paddingSymmetric(horizontal: 18),
    );
  }
}

class BusinessCategory extends StatelessWidget {
  const BusinessCategory({required this.business, super.key});
  final DropCategoryModel business;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          // color: AppColors.textFieldColor.withOpacity(0.8),
          border: Border.all(color: AppColors.appButtonColor),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'CATEGORY',
              style: AppThemes.lightTheme.textTheme.headlineMedium
                  ?.copyWith(fontSize: 8),
            ).paddingSymmetric(horizontal: 10, vertical: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${business.name}',
                  style:
                      AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontSize: 16,
                    color: AppColors.dark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    AppImages.asImage(
                      UrlConst.otherMediaBase + '${business.icon}',
                      height: 25,
                      width: 25,
                    ),
                    Icon(Icons.keyboard_arrow_down_sharp),
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: 15, vertical: 5),
          ],
        ),
      ).paddingOnly(left: 20, right: 20),
    );
  }
}

class BusinessCategoryButton extends StatelessWidget {
  BusinessCategoryButton({required this.business, super.key});
  final DropCategoryModel business;
  final SettingsController controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        // width: 400,
        child: WebElevatedButton(
          textAlign: TextAlign.start,
          alignment: Alignment.centerLeft,
          borderRadius: BorderRadius.circular(11),
          color: AppColors.textFieldColor.withOpacity(0.8),
          callback: () {
            showDialog(
              context: Get.context!,
              builder: (BuildContext context) => DialogContainer(
                body: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.appWhiteColor,
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Category Business',
                          style: AppThemes.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: AppColors.appButtonColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ).paddingOnly(top: 10, bottom: 10),
                      ),
                      SizedBox(
                        width: 400,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            // color: AppColors.textFieldColor.withOpacity(0.8),
                            border: Border.all(color: AppColors.appButtonColor),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'CATEGORY',
                                style: AppThemes
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(fontSize: 8),
                              ).paddingSymmetric(horizontal: 10, vertical: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '${business.name}',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontSize: 16,
                                      color: AppColors.dark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 15,
                                      ),
                                      AppImages.asImage(
                                        UrlConst.otherMediaBase +
                                            '${business.icon}',
                                        height: 30,
                                        width: 30,
                                      ),
                                      Icon(Icons.keyboard_arrow_down_sharp),
                                    ],
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 15, vertical: 5),
                            ],
                          ),
                        ).paddingOnly(left: 20, right: 20),
                      ).paddingSymmetric(vertical: 10),
                      SizedBox(
                        width: 400,
                        child: WebTextFields(
                          hint: 'Edit',
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(
                              22,
                            ),
                          ],
                          onFieldSubmitted: (String p0) {
                            controller
                                .updateBussinessCategoriessy<DropCategoryModel>(
                              cat: business,
                            );
                          },
                          onChanged: (String val) {
                            controller.updateTextFieldValue1 = val;
                            // final res = controller
                            //     .dropInList[0].name = val;
                            //
                            // controller
                            //     .updateTextFieldValue1 =
                            //     res;
                          },
                          fillColor: AppColors.textFieldColor.withOpacity(0.8),
                          radius: 11,
                        ).paddingOnly(left: 20, right: 20, bottom: 15),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AppElevatedButton(
                            color: AppColors.redcolor,
                            height: 50,
                            borderRadius: BorderRadius.circular(8),
                            width: 180,
                            callback: () {
                              controller.updateBussinessCategoriessy<
                                  DropCategoryModel>(
                                cat: business,
                              );
                            },
                            title: 'Confirm',
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          AppElevatedButton(
                            color: AppColors.greyColor,
                            height: 50,
                            borderRadius: BorderRadius.circular(8),
                            width: 180,
                            callback: () {
                              Get.back();
                            },
                            title: 'Cancel',
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              color: AppColors.appBlackColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 10),
                    ],
                  ),
                ),
                maxHei: 250,
                minHei: 250,
                maxWid: 420,
                minWid: 420,
              ),
            );
          },
          title: 'Edit',
          style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
            fontSize: 16,
            color: AppColors.appBlackColor,
          ),
        ),
      ).paddingSymmetric(horizontal: 18),
    );
  }
}

class ChangePassword extends StatelessWidget {
  final AdminController c = Get.put(AdminController());
  final AuthController controller = Get.put(AuthController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: GetBuilder<AuthController>(
          builder: (AuthController controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Settings',
                  style: AppThemes.lightTheme.textTheme.headlineLarge
                      ?.copyWith(fontSize: 32),
                ).paddingSymmetric(horizontal: 12, vertical: 10),
                Row(
                  children: <Widget>[
                    IconButton(
                      splashColor: AppColors.transparent,
                      focusColor: AppColors.transparent,
                      hoverColor: AppColors.transparent,
                      highlightColor: AppColors.transparent,
                      onPressed: () {
                        c.currentPage(NavigationEnum.Settings);
                        logger.w(
                          c.currentPage(NavigationEnum.Settings),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back_sharp,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Change password',
                      style: AppThemes.lightTheme.textTheme.headlineLarge
                          ?.copyWith(fontSize: 24),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 25),
                Text(
                  'Old password',
                  style: AppThemes.lightTheme.textTheme.headlineLarge
                      ?.copyWith(fontSize: 14),
                ).paddingSymmetric(horizontal: 20, vertical: 10),
                SizedBox(
                  width: 500,
                  child: WebTextFields(
                    validator: (String? p0) => AppValidation.password(
                      controller.webPasswordController.text,
                    ),
                    controller: controller.webPasswordController,
                    hint: 'Enter old password',
                  ).paddingOnly(left: 20, bottom: 22),
                ),
                Text(
                  'New password',
                  style: AppThemes.lightTheme.textTheme.headlineLarge
                      ?.copyWith(fontSize: 14),
                ).paddingSymmetric(horizontal: 20, vertical: 10),
                SizedBox(
                  width: 500,
                  child: WebTextFields(
                    validator: (String? p0) => AppValidation.password(
                      controller.webNewpasswordController.text,
                    ),
                    controller: controller.webNewpasswordController,
                    hint: 'Enter new password',
                  ).paddingOnly(left: 20, bottom: 22),
                ),
                Text(
                  'Confirm new password',
                  style: AppThemes.lightTheme.textTheme.headlineLarge
                      ?.copyWith(fontSize: 14),
                ).paddingSymmetric(horizontal: 20, vertical: 10),
                SizedBox(
                  width: 500,
                  child: WebTextFields(
                    validator: (String? p0) => AppValidation.conformPass(
                      controller.webConfirmPasswordController.text.trim(),
                      controller.webNewpasswordController.text.trim(),
                    ),
                    controller: controller.webConfirmPasswordController,
                    hint: 'Enter new password again',
                  ).paddingOnly(left: 20, bottom: 22),
                ),
                Row(
                  children: <Widget>[
                    controller.isLoading
                        ? LoaderView()
                        : WebElevatedButton(
                            height: 45,
                            width: 120,
                            callback: () {
                              if (_formKey.currentState!.validate()) {
                                controller.changePasswordApi();
                              }
                            },
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.selectdeaweclr,
                            title: 'Save',
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(color: AppColors.greyColor),
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        c.currentPage(NavigationEnum.ForgetPassword);
                        logger.w(
                          c.currentPage(NavigationEnum.ForgetPassword),
                        );
                        // controller.forgotPassword(true);
                        // controller.forgetPasswordAdmin();
                      },
                      child: Text('Forgotten password'),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 50, vertical: 50),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ForgetPassword extends StatelessWidget {
  final AdminController c = Get.put(AdminController());
  final AuthController controller = Get.put(AuthController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: GetBuilder<AuthController>(
          builder: (AuthController controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Settings',
                  style: AppThemes.lightTheme.textTheme.headlineLarge
                      ?.copyWith(fontSize: 32),
                ).paddingSymmetric(horizontal: 12, vertical: 10),
                Row(
                  children: <Widget>[
                    IconButton(
                      splashColor: AppColors.transparent,
                      focusColor: AppColors.transparent,
                      hoverColor: AppColors.transparent,
                      highlightColor: AppColors.transparent,
                      onPressed: () {
                        c.currentPage(NavigationEnum.Settings);
                        logger.w(
                          c.currentPage(NavigationEnum.Settings),
                        );
                      },
                      icon: Icon(
                        Icons.lock,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Reset Password',
                      style: AppThemes.lightTheme.textTheme.headlineLarge
                          ?.copyWith(fontSize: 24),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 25),
                Text(
                  'New password',
                  style: AppThemes.lightTheme.textTheme.headlineLarge
                      ?.copyWith(fontSize: 14),
                ).paddingSymmetric(horizontal: 20, vertical: 10),
                SizedBox(
                  width: 500,
                  child: WebTextFields(
                    validator: (String? p0) => AppValidation.password(
                      controller.webNewpasswordController.text,
                    ),
                    controller: controller.webNewpasswordController,
                    hint: 'Enter new password',
                  ).paddingOnly(left: 20, bottom: 22),
                ),
                Text(
                  'Confirm new password',
                  style: AppThemes.lightTheme.textTheme.headlineLarge
                      ?.copyWith(fontSize: 14),
                ).paddingSymmetric(horizontal: 20, vertical: 10),
                SizedBox(
                  width: 500,
                  child: WebTextFields(
                    validator: (String? p0) => AppValidation.conformPass(
                      controller.webConfirmPasswordController.text.trim(),
                      controller.webNewpasswordController.text.trim(),
                    ),
                    controller: controller.webConfirmPasswordController,
                    hint: 'Enter new password again',
                  ).paddingOnly(left: 20, bottom: 22),
                ),
                Row(
                  children: <Widget>[
                    controller.isLoading
                        ? LoaderView()
                        : WebElevatedButton(
                            height: 45,
                            width: 120,
                            callback: () {
                              if (_formKey.currentState!.validate()) {
                                controller.forgetPasswordAdmin();
                              }
                            },
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.selectdeaweclr,
                            title: 'Save',
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(color: AppColors.greyColor),
                          ),
                  ],
                ).paddingSymmetric(horizontal: 50, vertical: 50),
              ],
            );
          },
        ),
      ),
    );
  }
}
