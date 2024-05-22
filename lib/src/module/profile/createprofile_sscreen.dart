import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropin/src_exports.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../authprofile/profilescreen_controller.dart';

class CreateProfileScreen extends StatefulWidget {
  CreateProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final ProfileController c = Get.find<ProfileController>();

  @override
  void initState() {
    if (isEditProfile) {
      logger.wtf(app.user.skillId);
      logger.i(SkillLevel.values);
      c.birthdateCTRl.text = DateFormat('dd/MM/yyyy').format(app.user.dob!);
      c.displayNameNoCountryCode.value = app.user.country;
      SkillLevel.values.forEach((SkillLevel e) {
        logger.w(e.id == app.user.skillId);
        if (e.id == app.user.skillId) {
          c.selectedSkillLevel = e;
          logger.w(c.selectedSkillLevel = e);
        }
      });
    }
    super.initState();
  }

  bool isEditProfile = (Get.arguments ?? false);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (ProfileController c) {
      return CustomScaffold(
        gradient: !isEditProfile
            ? AppColors.backgroundTransperent
            : AppColors.background,
        appBar: CustomAppBar.getAppBar(
          isEditProfile ? 'Details' : 'Profile Setup',
          titleColor:
              isEditProfile ? AppColors.appBlackColor : AppColors.appWhiteColor,
          showBackButton: false,
        ),
        body: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Visibility(
                  visible: !isEditProfile,
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 150,
                      width: 200,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Positioned(
                            top: 0,
                            child: InkWell(
                              splashColor: AppColors.transparent,
                              focusColor: AppColors.transparent,
                              hoverColor: AppColors.transparent,
                              highlightColor: AppColors.transparent,
                              onTap: () {
                                if (c.pickedPath.value.isEmpty) {
                                  Get.toNamed(Routes.EditProfileScreen);
                                } else {
                                  c.imagePicker(isProfile: true);
                                }
                              },
                              child: Obx(() {
                                if (c.pickedPath.isEmpty) {
                                  return const CircleAvatar(
                                    backgroundColor: AppColors.coverphotocolor,
                                    radius: 60,
                                    child: InkWell(
                                      child: CircleAvatar(
                                        backgroundColor: AppColors.appWhiteColor,
                                        radius: 25,
                                        backgroundImage:
                                            AssetImage(AppAssets.gallary),
                                      ),
                                    ),
                                  );
                                } else {
                                  return CircleAvatar(
                                    backgroundColor: AppColors.appWhiteColor,
                                    radius: 60,
                                    backgroundImage: FileImage(
                                      File(
                                        c.pickedPath(),
                                      ),
                                    ),
                                  );
                                }
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Column(
                    children: [
                      AppTextField(
                        title: 'COUNTRY OF ORIGIN',
                        hint: !isEditProfile ? null : '${app.user.country}',
                        readOnly: true,
                        textController: c.contryCTRl,
                        focusNode: c.countryfocus.value,
                        autofocus: true,
                        onTap: () {
                          FocusScope.of(context)
                              .requestFocus(c.countryfocus.value);
                          c.update();
                          c.countryPicker();
                        },
                        onChanged: (String p0) async {
                          c.verify.value = await c.createProfile();
                        },
                        onFieldSubmitted: (String term) {
                          c.countryfocus.value.unfocus();
                          FocusScope.of(context)
                              .requestFocus(c.datebirthfocus.value);
                          c.update();
                        },
                        suffixIcon: IconButton(
                          onPressed: c.countryPicker,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: AppColors.appBlackColor,
                            size: 30,
                          ),
                        ),
                      ).paddingOnly(bottom: 20),
                      getValidations(
                              validation:
                                  AppValidation.country(c.contryCTRl.text))
                          .paddingSymmetric(horizontal: 20),
                    ],
                  ),
                ),
                Obx(
                  () => AppTextField(
                    onChanged: (String p0) async {
                      c.verify.value = await c.createProfile();
                    },
                    keyboardType: TextInputType.number,
                    focusNode: c.datebirthfocus.value,
                    autofocus: true,
                    textController: c.birthdateCTRl,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      MaskTextInputFormatter(
                        mask: '##/##/####',
                        filter: {'#': RegExp(r'[0-9]')},
                      ),
                    ],
                    title: 'DATE OF BIRTH',
                    hint: 'dd/mm/yyyy',
                    onFieldSubmitted: (String term) {
                      c.datebirthfocus.value.unfocus();
                      FocusScope.of(context)
                          .requestFocus(c.skilllevelfocus.value);
                    },
                    onTap: () {
                      FocusScope.of(context).requestFocus(c.datebirthfocus.value);
                      c.update();
                    },
                  ).paddingOnly(bottom: 20),
                ),
                Obx(
                  () => Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: c.skilllevelfocus.value.hasFocus
                              ? AppColors.appWhiteColor
                              : AppColors.appWhiteColor.withOpacity(
                                  0.8,
                                ),
                          border: Border.all(color: AppColors.appButtonColor),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: DropdownButtonFormField2<SkillLevel>(
                          focusNode: c.skilllevelfocus.value,
                          autofocus: true,
                          dropdownStyleData: DropdownStyleData(
                            useSafeArea: false,
                            width: 300,
                            direction: DropdownDirection.right,
                          ),
                          alignment: Alignment.topLeft,
                          iconStyleData: IconStyleData(
                            iconSize: 30,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: AppColors.appBlackColor,
                            ),
                          ),
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: AppThemes
                                .lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              fontSize: 16,
                              color: AppColors.appBlackColor,
                            ),
                            labelText: 'SKILL LEVEL',
                            labelStyle: AppThemes
                                .lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              fontSize: 14,
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                          ),
                          items: SkillLevel.values
                              .map(
                                (SkillLevel e) => DropdownMenuItem<SkillLevel>(
                                  value: e,
                                  child: Text(
                                    e.title,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              )
                              .toList(),
                          value: c.selectedSkillLevel,
                          onChanged: (SkillLevel? value) async {
                            FocusScope.of(context)
                                .requestFocus(c.skilllevelfocus.value);

                            c.selectedSkillLevel = value;
                            c.verify.value = await c.createProfile();
                            c.skilllevelfocus.value.unfocus();
                            FocusScope.of(context).requestFocus(c.submit.value);

                            c.update();
                          },
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: 10),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              c.isLoading
                  ? LoaderView()
                  : AppElevatedButton(
                      color: c.verify.value
                          ? AppColors.appButtonColor
                          : AppColors.appButtonColor.withOpacity(0.8),
                      focusNode: c.submit.value,
                      callback: () async {
                        FocusScope.of(context).unfocus();
                        logger.w(isEditProfile);
                        if (!isEditProfile) {
                          c.isValidate.value = checkValidationForAllFields();

                          if (c.isValidate.isFalse) {
                            c.navigate();
                          }

                          c.isValidate(false);
                        } else {
                          c.updatecategory();
                          c.update();
                          app.update();
                        }
                      },
                      title: isEditProfile ? 'Update' : 'Continue',
                    ).paddingOnly(bottom: 10),
              AppElevatedButton(
                callback: () {
                  Get.back();
                  if (isEditProfile) {
                    c.pickedPath.value = '';
                    c.contryCTRl.clear();
                    c.birthdateCTRl.clear();
                    c.selectedSkillLevel = null;
                  }
                },
                title: 'Back',
              ).paddingOnly(bottom: 80),
            ],
          ),
        ),
      );
    });
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
    if (AppValidation.dateValidation(birthDate: c.birthdateCTRl.text) == null &&
        AppValidation.dateValidation(birthDate: c.birthdateCTRl.text) == null) {
      return false;
    } else {
      return true;
    }
  }
}
