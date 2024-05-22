import '../../../../src_exports.dart';
import '../../authprofile/profilescreen_controller.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropin/src/models/sub_category_model.dart';

import '../../../models/category_model.dart';
import '../../../utils/widgets/app_images.dart';

class UpdateBussiness extends StatelessWidget {
  // final controller = Get.lazyPut(() => ProfileController());

  UpdateBussiness({Key? key}) : super(key: key);
  final ProfileController c = Get.put(ProfileController());
  bool isBussiness = (Get.arguments ?? false);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        app.isBusiness = false;
        return Future(() => true);
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
        body: GetBuilder<ProfileController>(
          builder: (ProfileController controller) {
            if (controller.isLoading) {
              return LoaderView();
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.textFieldColor.withOpacity(0.8),
                        border: Border.all(color: AppColors.appButtonColor),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: DropdownButtonFormField2<CategoryModel>(
                        isExpanded: true,
                        value: controller.selectedCategoryModelID,
                        items: controller.categoryList
                            .map((CategoryModel e) => DropdownMenuItem(
                                  value: e,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(e.name).paddingOnly(left: 20),
                                      AppImages.asImage(
                                          UrlConst.otherMediaBase + e.icon,
                                          height: 30,
                                          width: 30)
                                    ],
                                  ),
                                ))
                            .toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return controller.categoryList
                              .map(
                                (CategoryModel e) =>
                                    Builder(builder: (BuildContext context) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          e.name,
                                          style: const TextStyle(
                                            color: AppColors.dark,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ).paddingOnly(
                                            left: 2,
                                            right: context.width * 0.05),
                                        AppImages.asImage(
                                          UrlConst.otherMediaBase + e.icon,
                                          height: 30,
                                          width: 30,
                                        )
                                      ],
                                    ),
                                  );
                                }),
                              )
                              .toList();
                        },
                        hint: const Text(
                          'Choose Your Category',
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (CategoryModel? value) {
                          controller.selectedCategoryModelID = value;
                          controller.update();
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
                          hintText: '...',
                          labelText: 'Category',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: AppThemes
                              .lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            fontSize: 16,
                            color: AppColors.appBlackColor,
                          ),
                          labelStyle: AppThemes
                              .lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            fontSize: 14,
                            color: AppColors.appBlackColor,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                      ).paddingOnly(bottom: 10),
                    ).paddingOnly(bottom: 15),
                    if (controller.selectedCategoryModelID != null) ...[
                      AppTextField(
                        height: 70,
                        title: 'LOCATION',
                        textController: controller.locationCTRl,
                        hint: '...',
                        maxLines: 3,
                        readOnly: true,
                        onChanged: (String p0) {
                          controller.getAddress(
                              lat: app.currentPosition.latitude,
                              long: app.currentPosition.longitude);
                          c.currentAddress.value = controller.locationCTRl.text;
                        },
                        onTap: () {
                          Get.toNamed(Routes.BusinessMaps);
                        },
                      ).paddingOnly(bottom: 10),
                      AppTextField(
                        title: 'BUSINESS NAME',
                        hint: 'Not Written Yet',
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                        ],
                        textController: controller.businessNameCtrl,
                      ).paddingOnly(bottom: 10),
                      Visibility(
                        visible: !isBussiness,
                        child: Column(
                          children: [
                            AppTextField(
                              height: 150,
                              maxLines: 5,
                              title: 'DESCRIPTION',
                              hint:
                                  "'Write a description for others to see here'",
                              textController: controller.descriptionCtrl,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(250),
                              ],
                              onChanged: (String value) {
                                controller.descCount.value = value.length;
                              },
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
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
                            children: [
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
                              Text(
                                cat.name,
                                style: const TextStyle(
                                  color: AppColors.appWhiteColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(builder: (BuildContext con) {
                if (c.isLoading) {
                  return LoaderView();
                } else {
                  return AppElevatedButton(
                    callback: () async {
                      if (!isBussiness) {
                        c.addBussiness();
                      } else {
                        c.updateBussinessDetails();
                      }
                    },
                    title: isBussiness ? 'Update' : 'Continue',
                  );
                }
              }).paddingOnly(bottom: 10),
              AppElevatedButton(
                callback: () {
                  app.isBusiness = false;
                  Get.back();
                },
                title: 'Back',
              ).paddingOnly(bottom: 50),
            ],
          ),
        ),
      ),
    );
  }
}
