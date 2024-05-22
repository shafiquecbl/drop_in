import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropin/src/utils/widgets/app_images.dart';
import 'package:dropin/src/models/bussiness_model.dart' as b;
import 'package:dropin/src/utils/widgets/common_functions.dart';
import 'package:dropin/src_exports.dart';

import '../../../models/category_model.dart';
import '../../../models/sub_category_model.dart';
import '../../authprofile/profilescreen_controller.dart';

class BusinessAddPhotos extends StatefulWidget {
  BusinessAddPhotos({Key? key}) : super(key: key);

  @override
  State<BusinessAddPhotos> createState() => _BusinessAddPhotosState();
}

class _BusinessAddPhotosState extends State<BusinessAddPhotos> {
  ProfileController c = Get.find<ProfileController>();

  @override
  void initState() {
    if (Get.arguments != null) {
      isBussiness = Get.arguments[0];
      businessId = Get.arguments[1];
      isForceUpdate = Get.arguments[2];
    }
    if (!isForceUpdate) {
      c.businessCoverPhotos.addAll(app.bussiness.coverPhoto);
    }
    super.initState();
  }

  @override
  void dispose() {
    c.businessCoverPhotos.clear();
    super.dispose();
  }

  bool isBussiness = false;
  int businessId = -1;
  bool isForceUpdate = false;

  @override
  Widget build(BuildContext context) {
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
                        c.imgList2.isEmpty && (!isBussiness || isForceUpdate)
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
                                // height: 210,
                                child: ListView.builder(
                                  clipBehavior: Clip.antiAlias,
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
                                                      .toLowerCase()
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
                                                          .photos,
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
                                                    c.businessRemovedImages,
                                                  );

                                                  c.businessCoverPhotos
                                                      .removeAt(index);
                                                } else {
                                                  c.imgList2.removeAt(index);
                                                }
                                                setState(() {});
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
                              logger.w(c.imgList2.length);
                              if (!isBussiness) {
                                if (c.imgList2.length < 10) {
                                  await c.pickedImage(isProfile: false);
                                } else {
                                  c.onError(
                                      'You can select only 10 images', () {});
                                }
                              } else {
                                if (c.businessCoverPhotos.length < 10) {
                                  final String foo =
                                      await c.pickedImage(isProfile: true);

                                  if (foo.isNotEmpty) {
                                    c.businessCoverPhotos.add(
                                      b.CoverPhoto(coverPhoto: foo),
                                    );
                                    c.imgList2.add(
                                      b.CoverPhoto(coverPhoto: foo),
                                    );
                                    setState(() {});
                                  }
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
                        callback: () async {
                          if (!isForceUpdate) {
                            logger.w('1');
                            logger.w(isBussiness);
                            if (!isBussiness) {
                              logger.w('2');

                              // c.updateBussiness();
                              logger.i(Get.arguments);
                              if (businessId == -1) {
                                logger.w('3');

                                if (c.imgList2.isNotEmpty) {
                                  Get.toNamed(Routes.BusinessFinalSetup);
                                } else {
                                  Get.snackbar(
                                    'Please upload image',
                                    '',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red,
                                    margin: EdgeInsets.zero,
                                    snackPosition: SnackPosition.BOTTOM,
                                    borderRadius: 0,
                                  );
                                }
                              } else {
                                logger.w('4');

                                await c.addBussiness(false);
                                Get.back();
                                Get.back();
                              }
                            } else {
                              logger.w('5');
                              // if (c.imgList2.isNotEmpty) {
                              //   logger.w('6');
                              await c.updateCoverPhotoBusiness();
                              // }

                              Get.back();
                            }
                          } else {
                            if (c.imgList2.isNotEmpty) {
                              Get.back(result: c.imgList2);
                            } else {
                              showSnackBar('Please select images');
                            }
                          }
                        },
                        title: isForceUpdate
                            ? 'Next'
                            : isBussiness
                                ? 'Update'
                                : 'Create Business!',
                      ).paddingSymmetric(horizontal: 20, vertical: 5),
                Visibility(
                  visible: isBussiness,
                  child: AppElevatedButton(
                    width: context.width,
                    height: 50,
                    callback: () {
                      if (isForceUpdate) {
                        Get.back(
                          result: false,
                        );
                      } else {
                        Get.back();
                      }
                    },
                    title: 'Back',
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
            titleColor: isBussiness
                ? AppColors.appBlackColor
                : AppColors.appWhiteColor),
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
                        Get.toNamed(
                          Routes.BusinessAddPhotos,
                          arguments: [isBussiness, app.bussiness.id, false],
                        );
                      } else {
                        // c.updateBussinessDetails();
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
