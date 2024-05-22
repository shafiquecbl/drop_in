import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropin/src/models/sub_category_model.dart';
import 'package:dropin/src/utils/widgets/common_functions.dart';
import 'package:dropin/src_exports.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/category_model.dart';
import '../../utils/widgets/app_images.dart';
import 'package:dropin/src/models/bussiness_model.dart' as b;
import '../authprofile/profilescreen_controller.dart';

class AddBusiness extends StatelessWidget {
  AddBusiness({Key? key}) : super(key: key);
  final ProfileController c = Get.put(ProfileController());
  bool isBussiness = (Get.arguments ?? false);

  @override
  Widget build(BuildContext context) {
    if (isBussiness) {
      logger.w(app.bussiness.id);
      c.categoryList.forEach((CategoryModel element) {
        if (element.id == app.bussiness.catId) {
          c.selectedCategoryModelID = element;
        }
      });
    }
    return WillPopScope(
      onWillPop: () {
        app.isBusiness = false;
        c.selectedCategoryModelID = null;
        c.locationCTRl.clear();
        c.businessNameCtrl.clear();
        // c.businessAddress.clear();
        c.descriptionCtrl.clear();
        c.selectedSubCat = [];

        return Future<bool>(() => true);
      },
      child: GestureDetector(
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
          body: GetBuilder<ProfileController>(
            builder: (ProfileController controller) {
              if (controller.isLoading) {
                return LoaderView();
              } else {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: controller
                                    .selectedCategoryModelIDfocus.value.hasFocus
                                ? AppColors.appWhiteColor
                                : AppColors.appWhiteColor.withOpacity(0.8),
                            border: Border.all(
                              color: AppColors.appButtonColor,
                            ),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: DropdownButtonFormField2<CategoryModel>(
                            isExpanded: true,
                            focusNode: c.selectedCategoryModelIDfocus.value,
                            value: controller.selectedCategoryModelID,
                            dropdownStyleData: DropdownStyleData(
                              useSafeArea: false,
                              width: 300,
                              direction: DropdownDirection.right,
                            ),
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
                                        ),
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
                                                UrlConst.otherMediaBase +
                                                    e.icon,
                                                height: 30,
                                                width: 30,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  .toList();
                            },
                            autofocus: true,
                            onChanged: (CategoryModel? value) async {
                              controller.verify = controller.isVerifyLogin();
                              if (c.verify.value) {
                                c.update();
                              }
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
                              labelText: 'CATEGORY',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),

                              // labelText: 'CATEGORY',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                            ),
                          ),
                        ).paddingOnly(bottom: 10),
                      ),
                      if (controller.selectedCategoryModelID != null) ...[
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
                            c.currentAddress.value =
                                controller.locationCTRl.text;
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
                        ).paddingOnly(bottom: 5 ),
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          textController: controller.businessNameCtrl,
                          // fillColor: controller.bussinessFocus.value.hasFocus
                          //     ? AppColors.appWhiteColor
                          //     : AppColors.appWhiteColor.withOpacity(0.8),
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
                            FocusScope.of(context).requestFocus(
                                controller.descriptionfocus.value);
                          },
                          onChanged: (String p0) async {
                            controller.verify = controller.isVerifyLogin();
                          },
                        ).paddingOnly(bottom: 10),
                        Visibility(
                          visible: !isBussiness,
                          child: Column(
                            children: [
                              AppTextField(
                                height: 150,
                                maxLines: 5,
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
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(250),
                                ],
                                onChanged: (String value) async {
                                  controller.verify =
                                      controller.isVerifyLogin();
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
                GetBuilder<ProfileController>(
                  builder: (ProfileController c) {
                    return AppElevatedButton(
                      color: c.verify.value
                          ? AppColors.appButtonColor
                          : AppColors.appButtonColor.withOpacity(0.8),
                      callback: () async {
                        if (!isBussiness) {
                          if (c.selectedCategoryModelID != null) {
                            logger.w(isBussiness);
                            c.navigateTo(
                              isBussiness,
                              0,
                            );
                          } else {
                            showSnackBar('Please select category');
                          }
                          // Get.toNamed(
                          //   Routes.BusinessAddPhotos,
                          //   arguments: [isBussiness, app.bussiness.id],
                          // );
                        } else {
                          c.updateBussinessDetails();
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
                    app.isBusiness = false;
                    c.selectedCategoryModelID = null;
                    c.locationCTRl.clear();
                    c.businessNameCtrl.clear();
                    c.descriptionCtrl.clear();
                    c.selectedSubCat = [];
                  },
                  title: 'Back',
                ).paddingOnly(bottom: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BusinessPhotos extends StatefulWidget {
  BusinessPhotos({Key? key}) : super(key: key);

  @override
  State<BusinessPhotos> createState() => _BusinessPhotosState();
}

class _BusinessPhotosState extends State<BusinessPhotos> {
  ProfileController c = Get.find<ProfileController>();

  /// flag for edit business
  bool isBussiness = (Get.arguments ?? false);

  @override
  void initState() {
    c.businessCoverPhotos.addAll(app.bussiness.coverPhoto);
    logger.w(c.businessCoverPhotos);
    super.initState();
  }

  @override
  void dispose() {
    c.businessCoverPhotos.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.w(isBussiness);

    return CustomScaffold(
      gradient:
          isBussiness ? AppColors.background : AppColors.backgroundTransperent,
      appBar: CustomAppBar.getAppBar(
        isBussiness ? 'Photos' : 'Business Setup',
        titleColor:
            isBussiness ? AppColors.appBlackColor : AppColors.appWhiteColor,
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.symmetric(horizontal: ),
        child: GetBuilder<ProfileController>(
          builder: (ProfileController controller) {
            return Column(
              children: [
                Obx(
                  () => SizedBox(
                    height: 230,
                    child: Stack(
                      children: [
                        c.imgList2.isEmpty && !isBussiness
                            ? Container(
                                clipBehavior: Clip.hardEdge,
                                height: 220,
                                width: 350,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.coverphotocolor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              )
                            : SizedBox(
                                height: 210,
                                child: ListView.builder(
                                  clipBehavior: Clip.hardEdge,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: isBussiness
                                      ? c.businessCoverPhotos.length
                                      : c.imgList2.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      clipBehavior: Clip.hardEdge,
                                      child: Stack(
                                        children: [
                                          isBussiness
                                              ? c.businessCoverPhotos[index]
                                                      .coverPhoto
                                                      .contains('data')
                                                  ? Image.file(
                                                      File(
                                                        c
                                                            .businessCoverPhotos[
                                                                index]
                                                            .coverPhoto,
                                                      ),
                                                      width: Get.width * 0.9,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl: c
                                                          .businessCoverPhotos[
                                                              index]
                                                          .coverPhoto,
                                                      fit: BoxFit.cover,
                                                      // height: 200,
                                                      width: Get.width * 0.9,
                                                    )
                                              : Image.file(
                                                  File(
                                                    c.imgList2[index]
                                                        .coverPhoto,
                                                  ),
                                                  width: Get.width * 0.9,
                                                  fit: BoxFit.cover,
                                                ),
                                          Positioned(
                                            top: 0,
                                            right: 10,
                                            child: IconButton(
                                              hoverColor: AppColors.transparent,
                                              splashColor:
                                                  AppColors.transparent,
                                              focusColor: AppColors.transparent,
                                              onPressed: () {
                                                if (isBussiness) {
                                                  c.businessRemovedImages.add(
                                                    c.businessCoverPhotos[index]
                                                        .id,
                                                  );
                                                  logger.i(
                                                      c.businessRemovedImages);

                                                  c.businessCoverPhotos
                                                      .removeAt(index);
                                                } else {
                                                  c.imgList2.removeAt(index);
                                                }
                                                setState(() {});
                                                // c.imgList2.removeAt(index);
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                size: 30,
                                                color: AppColors.appWhiteColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).paddingSymmetric(horizontal: 15);
                                  },
                                ),
                              ).paddingOnly(bottom: 10),
                        Positioned(
                          bottom: 0,
                          right: 6,
                          child: InkWell(
                            hoverColor: AppColors.transparent,
                            splashColor: AppColors.transparent,
                            focusColor: AppColors.transparent,
                            onTap: () async {
                              if (!isBussiness) {
                                if (c.imgList2.value.length < 10) {
                                  await c.pickedImage(isProfile: false);
                                } else {
                                  c.onError(
                                      'You can select only 10 images', () {});
                                }
                              } else {
                                if (c.businessCoverPhotos.length < 10) {
                                  final String foo =
                                      await c.pickedImage(isProfile: true);
                                  c.businessCoverPhotos.add(
                                    b.CoverPhoto(coverPhoto: foo),
                                  );
                                  c.imgList2.add(
                                    b.CoverPhoto(coverPhoto: foo),
                                  );
                                  setState(() {});
                                } else {
                                  c.onError(
                                    'You can select only 10 images',
                                    () {},
                                  );
                                }
                              }
                            },
                            child: AppAssets.asImage(
                              AppAssets.gallary,
                              height: 60,
                              width: 70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.height * 0.30),
                c.isLoading
                    ? LoaderView()
                    : AppElevatedButton(
                        width: context.width,
                        height: 50,
                        callback: () {
                          logger
                              .w('business====>$c.businessCoverPhotos.length');
                          if (c.imgList2.isNotEmpty) {
                            c.addBussiness(false);
                            Get.back();
                            Get.back();
                            Fluttertoast.showToast(
                              msg: 'Business added',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: AppColors.appButtonColor,
                              textColor: AppColors.appBlackColor,
                            );
                          } else {
                            c.updateCoverPhotoBusiness();

                            c.onError(' please select coverPhoto', () {});
                          }
                        },
                        title:
                            c.isBussiness.value ? 'Update' : 'Create Business!',
                      ).paddingSymmetric(horizontal: 20, vertical: 5),
                Visibility(
                  visible: c.isBussiness.isTrue,
                  child: AppElevatedButton(
                    width: context.width,
                    height: 50,
                    callback: () {
                      // Get.offNamed(Routes.BusinessFinalSetup);
                    },
                    title: 'back',
                  ).paddingSymmetric(horizontal: 20, vertical: 5),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
