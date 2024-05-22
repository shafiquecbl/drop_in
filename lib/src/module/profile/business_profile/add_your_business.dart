import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropin/src/models/sub_category_model.dart';
import 'package:dropin/src/utils/widgets/common_functions.dart';
import 'package:dropin/src_exports.dart';

import '../../../models/bussiness_model.dart';
import '../../../models/category_model.dart';
import '../../../utils/widgets/app_images.dart';
import '../../../utils/widgets/custom_dialog.dart';
import '../../authprofile/profilescreen_controller.dart';

class AddYourBusiness extends StatefulWidget {
  AddYourBusiness({Key? key}) : super(key: key);

  @override
  State<AddYourBusiness> createState() => _AddYourBusinessState();
}

class _AddYourBusinessState extends State<AddYourBusiness> {
  final ProfileController c = Get.put(ProfileController());
  BussinessModel oldBusiness = BussinessModel.fromJson(app.bussiness.toJson());

  bool isBussiness = (Get.arguments ?? false);

  @override
  void initState() {
    logger.w('app.bussiness.catId ${app.bussiness.catId}');
    if (isBussiness) {
      c.locationCTRl.text = app.bussiness.location;
      c.businessNameCtrl.text = app.bussiness.businessName;
      c.businessAddress.text = app.bussiness.businessAddress;
      c.selectedSubCat =
          app.bussiness.subCategory.map((SubCategory e) => e.catId).toList();
      logger.i(app.bussiness.subCategory.map((SubCategory e) => e.toJson()));
      c.categoryList.forEach((CategoryModel element) {
        if (element.id == app.bussiness.catId) {
          c.selectedCategoryModelID = element;
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    app.isBusiness = false;
    c.selectedCategoryModelID = null;
    c.locationCTRl.clear();
    c.businessNameCtrl.clear();
    // c.businessAddress.clear();
    c.descriptionCtrl.clear();
    c.selectedSubCat = <int>[];
    c.pickedLocationForBusiness = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        gradient: isBussiness
            ? AppColors.background
            : AppColors.backgroundTransperent,
        appBar: CustomAppBar.getAppBar(
          isBussiness ? 'Details' : 'Business Setup',
          titleColor:
              isBussiness ? AppColors.appBlackColor : AppColors.appWhiteColor,
        ),
        body: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: GetBuilder<ProfileController>(
            builder: (ProfileController controller) {
              if (controller.isLoading) {
                return LoaderView();
              } else {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Obx(
                        () => Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: controller
                                    .selectedCategoryModelIDfocus.value.hasFocus
                                ? AppColors.appWhiteColor
                                : AppColors.appWhiteColor.withOpacity(0.8),
                            border: Border.all(color: AppColors.appButtonColor),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: DropdownButtonFormField2<CategoryModel>(
                            isExpanded: true,
                            focusNode: c.selectedCategoryModelIDfocus.value,
                            value: controller.selectedCategoryModelID,
                            dropdownStyleData: DropdownStyleData(
                                useSafeArea: false,
                                width: 300,
                                direction: DropdownDirection.right),
                            items: controller.categoryList
                                .map(
                                  (CategoryModel e) =>
                                      DropdownMenuItem<CategoryModel>(
                                    value: e,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(e.name).paddingOnly(left: 10),
                                        AppImages.asImage(
                                          UrlConst.otherMediaBase + e.icon,
                                          height: 30,
                                          width: 30,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return controller.categoryList
                                  .map(
                                    (CategoryModel e) => Builder(
                                      builder: (BuildContext context) {
                                        return DropdownMenuItem<CategoryModel>(
                                          value: e,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                e.name,
                                                style: const TextStyle(
                                                  color: AppColors.dark,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              AppImages.asImage(
                                                UrlConst.otherMediaBase + e.icon,
                                                height: 30,
                                                width: 30,
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  .toList();
                            },
                            onChanged: (CategoryModel? value) async {
                              controller.verify = controller.isVerifyLogin();
                              if (c.verify.value) {
                                c.update();
                              }
                              controller.selectedCategoryModelID = value;
                              controller.update();
                              oldBusiness.catId = value!.id;
                              logger.i(oldBusiness);
                              logger.w(app.bussiness.catId);
                              controller.selectedSubCat.clear();
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              errorStyle: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 13,
                                color: AppColors.appWhiteColor,
                              ),
                              labelText: 'CATEGORY',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),

                              // labelText: 'CATEGORY',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 16,
                                color: AppColors.appBlackColor,
                              ),

                              labelStyle: AppThemes
                                  .lightTheme.textTheme.headlineLarge
                                  ?.copyWith(
                                fontSize: 14,
                              ),

                              // contentPadding: EdgeInsets.zero
                              // contentPadding: const EdgeInsets.symmetric(
                              //     horizontal: 5, vertical: 5),
                            ),
                          ),
                        ).paddingOnly(bottom: 10),
                      ),
                      if (controller.selectedCategoryModelID != null) ...<Widget>[
                        AppTextField(
                          title: 'LOCATION',

                          focusNode: controller.locationFocus.value,
                          autofocus: true,
                          textController: controller.locationCTRl,
                          // hint: '...',
                          maxLines: 3,
                          readOnly: true,
                          onChanged: (String p0) async {
                            controller.verify = controller.isVerifyLogin();
                            controller.getAddress(
                              lat: app.currentPosition.latitude,
                              long: app.currentPosition.longitude,
                            );
                            c.currentAddress.value = controller.locationCTRl.text;
                          },
                          onTap: () {
                            FocusScope.of(context).requestFocus(
                              controller.locationFocus.value,
                            );
                            controller.update();
                            Get.toNamed(Routes.BusinessMaps);
                          },
                          onFieldSubmitted: (String term) {
                            controller.locationFocus.value.unfocus();
                            FocusScope.of(context)
                                .requestFocus(controller.bussinessFocus.value);
                            controller.update();
                          },
                        ).paddingOnly(bottom: 5),
                        /*AppTextField(
                          title: 'BUSINESS ADDRESS',
                          // hint: 'Not Written Yet',
                          textController: controller.businessAddress,
                          // fillColor: controller.bussinessFocus.value.hasFocus
                          //     ? AppColors.appWhiteColor
                          //     : AppColors.appWhiteColor.withOpacity(0.8),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          focusNode: controller.bussinessAddressFocus.value,
                          autofocus: true,
                          onTap: () {
                            FocusScope.of(context).requestFocus(
                              controller.bussinessAddressFocus.value,
                            );
                            controller.update();
                          },
                          onFieldSubmitted: (String term) {
                            controller.bussinessAddressFocus.value.unfocus();
                            FocusScope.of(context)
                                .requestFocus(controller.bussinessFocus.value);
                          },
                          onChanged: (String p0) async {
                            controller.verify = controller.isVerifyLogin();
                          },
                        ).paddingOnly(bottom: 10),*/
                        Text(
                          '*Please select your business address',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                        ).paddingOnly(bottom: 8,left: 5),
                        AppTextField(
                          title: 'BUSINESS NAME',
                          // hint: 'Not Written Yet',
                          textController: controller.businessNameCtrl,
                          // fillColor: controller.bussinessFocus.value.hasFocus
                          //     ? AppColors.appWhiteColor
                          //     : AppColors.appWhiteColor.withOpacity(0.8),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          focusNode: controller.bussinessFocus.value,
                          autofocus: true,
                          onTap: () {
                            FocusScope.of(context).requestFocus(
                              controller.bussinessFocus.value,
                            );
                            controller.update();
                          },
                          onFieldSubmitted: (String term) {
                            controller.bussinessFocus.value.unfocus();
                            FocusScope.of(context)
                                .requestFocus(controller.descriptionfocus.value);
                          },
                          onChanged: (String p0) async {
                            controller.verify = controller.isVerifyLogin();
                          },
                        ).paddingOnly(bottom: 10),
                        Visibility(
                          visible: !isBussiness,
                          child: Column(
                            children: <Widget>[
                              AppTextField(
                                height: 150,
                                maxLines: 10,
                                title: 'DESCRIPTION',
                                // hint:
                                //     "'Write a description for others to see here'",
                                textController: controller.descriptionCtrl,
                                // fillColor: controller
                                //         .descriptionfocus.value.hasFocus
                                //     ? AppColors.appWhiteColor
                                //     : AppColors.appWhiteColor.withOpacity(0.8),
                                focusNode: controller.descriptionfocus.value,
                                autofocus: true,
                                onTap: () {
                                  FocusScope.of(context).requestFocus(
                                    controller.descriptionfocus.value,
                                  );
                                  controller.update();
                                },
                                onFieldSubmitted: (String term) {
                                  controller.descriptionfocus.value.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(controller.submit.value);
                                },
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(250),
                                ],
                                onChanged: (String value) async {
                                  controller.verify = controller.isVerifyLogin();
                                  controller.descCount.value = value.length;
                                },
                                hintStyle: AppThemes
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  fontSize: 12,
                                  color: AppColors.appBlackColor,
                                ),
                              ),
                              SizedBox(
                                width: Get.width,
                                child: Obx(
                                  () {
                                    return Text(
                                      '${controller.descCount.value}/250',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                ).paddingOnly(bottom: 10, right: 5),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          itemCount: controller
                              .selectedCategoryModelID!.subCategory.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (_, int index) {
                            final SubCategory cat = controller
                                .selectedCategoryModelID!.subCategory[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  splashColor: AppColors.transparent,
                                  focusColor: AppColors.transparent,
                                  hoverColor: AppColors.transparent,
                                  highlightColor: AppColors.transparent,
                                  onTap: () {
                                    if (controller.selectedSubCat
                                        .contains(cat.id)) {
                                      controller.selectedSubCat.remove(cat.id);
                                    } else {
                                      controller.selectedSubCat.add(cat.id);
                                    }
                                    logger.w(c.selectedSubCat);
                                    controller.update();
                                  },
                                  child:
                                      controller.selectedSubCat.contains(cat.id)
                                          ? const CircleAvatar(
                                              radius: 14,
                                              backgroundColor:
                                                  AppColors.appButtonColor,
                                            ).paddingOnly(right: 13)
                                          : const CircleAvatar(
                                              radius: 14,
                                              backgroundColor:
                                                  AppColors.appButtonColor,
                                              child: CircleAvatar(
                                                radius: 13,
                                                backgroundColor:
                                                    AppColors.appWhiteColor,
                                              ),
                                            ).paddingOnly(right: 13),
                                ),
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: UrlConst.iconPath + cat.icon,
                                      height: 20,
                                      width: 20,
                                    ).paddingOnly(right: 8),
                                    Text(
                                      cat.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.appWhiteColor,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ).paddingOnly(bottom: 6);
                          },
                        ),
                      ]
                    ],
                  ),
                );
              }
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GetBuilder<ProfileController>(
                builder: (ProfileController c) {
                  return AppElevatedButton(
                    color: c.verify.value
                        ? AppColors.appButtonColor
                        : AppColors.appButtonColor.withOpacity(0.8),
                    focusNode: c.submit.value,
                    callback: () async {
                      if (c.selectedCategoryModelID != null) {
                        if (!isBussiness) {
                          c.navigateTo(isBussiness);
                        } else {
                          if (app.bussiness.catId == oldBusiness.catId) {
                            c.updateBussinessDetails();
                          } else {
                            Get.dialog(
                              editBussinessCategoryDialgo(),
                            );
                          }
                        }
                      } else {
                        showSnackBar('Please select category');
                      }
                    },
                    title: isBussiness ? 'Update' : 'Continue',
                  ).paddingOnly(bottom: 10);
                },
              ),
              AppElevatedButton(
                callback: () {
                  app.isBusiness = false;
                  Get.back();
                  c.selectedCategoryModelID = null;
                  c.locationCTRl.clear();
                  c.businessNameCtrl.clear();
                  c.descriptionCtrl.clear();
                  c.selectedSubCat = <int>[];
                },
                title: 'Back',
              ).paddingOnly(bottom: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget editBussinessCategoryDialgo() {
    return DialogContainer(
      maxHei: 200,
      minHei: 200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'You are going to update Category so your old data like business description and images will be lost.. Are you sure to proceed?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                title: 'Yes',
                callback: () {
                  Get.back();
                  c.forceUpdateBusiness();
                },
                height: 30,
                width: 100,
              ),
              AppButton(
                title: 'No',
                callback: Get.back,
                height: 30,
                width: 100,
              ),
            ],
          ),
        ],
      ).paddingOnly(
        top: 20,
        left: 20,
        right: 20,
      ),
    );
  }
}
