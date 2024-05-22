import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../src_exports.dart';
import '../../models/drop_in_category.dart';
import '../../models/news_feed_model.dart';
import '../../utils/widgets/app_images.dart';
import 'dropin_controller.dart';

class DropInScreen extends StatelessWidget {
  DropInScreen({Key? key}) : super(key: key);
  final DropinController controller = Get.put(DropinController());
  NewsFeedModel dropin = NewsFeedModel();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (Get.arguments != null &&
          Get.arguments is! bool &&
          controller.descriptionCtrl.text.isEmpty) {
        dropin = Get.arguments[0];
        controller.locationctrl.text = dropin.location;
        controller.titlectrl.text = dropin.title;
        controller.descriptionCtrl.text = dropin.description;
        controller.dropInImage.addAll(dropin.dropinImages);

        logger.w(dropin.dropinImages.map((DropinImages e) => e.toJson()));
        controller.selectedCategoryModelID =
            controller.dropInList.firstWhere((DropCategoryModel element) {
          return element.id == dropin.catId;
        });
      }
      controller.update();
    });

    return WillPopScope(
      onWillPop: () async {
        controller.locationctrl.clear();
        controller.titlectrl.clear();
        controller.descriptionCtrl.clear();
        controller.selectedCategoryModelID = null;
        controller.edit.value = false;
        logger.w(controller.edit.value);
        controller.dropInImage.clear();
        logger.w(controller.dropInImage.length);
        return await true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            title: Text(
              'DROP YOUR PIN',
              style: AppThemes.lightTheme.textTheme.headlineLarge?.copyWith(
                color: AppColors.appBlackColor,
                fontSize: 25,
              ),
            ),
            elevation: 0.0,
          ),
          extendBodyBehindAppBar: true,
          body: GetBuilder<DropinController>(
            builder: (DropinController controller) {
              return Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.background,
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GetBuilder<DropinController>(
                        builder: (DropinController controller) {
                          return Column(
                            children: <Widget>[
                              Obx(
                                () => Container(
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: controller
                                            .selectedCategoryModelidFocus
                                            .value
                                            .hasFocus
                                        ? AppColors.appWhiteColor
                                        : AppColors.appWhiteColor
                                            .withOpacity(0.8),
                                    border: Border.all(
                                      color: AppColors.appButtonColor,
                                    ),
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: DropdownButtonFormField2<
                                      DropCategoryModel>(
                                    isExpanded: true,
                                    focusNode: controller
                                        .selectedCategoryModelidFocus.value,
                                    dropdownStyleData: DropdownStyleData(
                                      useSafeArea: false,
                                      width: 300,
                                      direction: DropdownDirection.right,
                                    ),
                                    value: controller.selectedCategoryModelID,
                                    items: controller.dropInList
                                        .map(
                                          (DropCategoryModel e) =>
                                              DropdownMenuItem<
                                                  DropCategoryModel>(
                                            value: e,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Text(e.name)
                                                    .paddingOnly(left: 20),
                                                AppImages.asImage(
                                                  UrlConst.otherMediaBase +
                                                      e.icon,
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    selectedItemBuilder:
                                        (BuildContext context) {
                                      return controller.dropInList
                                          .map(
                                            (DropCategoryModel e) => Builder(
                                              builder: (BuildContext context) {
                                                return DropdownMenuItem(
                                                  value: e,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        e.name,
                                                        style: const TextStyle(
                                                          color: AppColors.dark,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ).paddingOnly(
                                                        left: 2,
                                                        right: context.width *
                                                            0.05,
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
                                    onChanged:
                                        (DropCategoryModel? value) async {
                                      FocusScope.of(context).requestFocus(
                                        controller
                                            .selectedCategoryModelidFocus.value,
                                      );
                                      controller.verify =
                                          await controller.isVerifyed();
                                      controller.selectedCategoryModelID =
                                          value;
                                      controller.update();
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
                                      ),
                                    ),
                                  ),
                                ).paddingOnly(
                                  bottom: 10,
                                  right: 10,
                                  left: 10,
                                ),
                              ),
                              Obx(
                                () => AppTextField(
                                  title: 'LOCATION',
                                  focusNode: controller.locationfocus.value,
                                  textController: controller.locationctrl,
                                  // hint: '...',
                                  maxLines: 3,
                                  readOnly: true,
                                  onChanged: (String p0) async {
                                    controller.verify = controller.isVerifyed();
                                  },
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(
                                      controller.locationfocus.value,
                                    );

                                    Get.toNamed(Routes.DropInMap);
                                  },
                                  // onFieldSubmitted: (String term) {
                                  //   controller.locationfocus.value.unfocus();
                                  //   FocusScope.of(context).requestFocus(
                                  //     controller.titlefocus.value,
                                  //   );
                                  //   controller.update();
                                  // },
                                ).paddingOnly(right: 10, left: 10),
                              ),
                              Obx(
                                () => getValidations(
                                  validation: AppValidation.loaction(
                                    controller.locationctrl.text,
                                  ),
                                ),
                              ).paddingOnly(bottom: 10, right: 10, left: 10),
                              Obx(
                                () => AppTextField(
                                  title: 'TITLE',
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(30),
                                  ],
                                  focusNode: controller.titlefocus.value,
                                  onChanged: (String p0) async {
                                    controller.verify =
                                        await controller.isVerifyed();
                                  },
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(
                                      controller.titlefocus.value,
                                    );
                                    controller.update();
                                  },
                                  onFieldSubmitted: (String term) {
                                    controller.titlefocus.value.unfocus();
                                    FocusScope.of(context).requestFocus(
                                      controller.descriptionfocus.value,
                                    );
                                    controller.update();
                                  },
                                  textController: controller.titlectrl,
                                ).paddingOnly(right: 10, left: 10),
                              ),
                              Obx(
                                () => getValidations(
                                  validation: AppValidation.title(
                                    controller.titlectrl.text,
                                  ),
                                ),
                              ).paddingOnly(bottom: 10, right: 10, left: 10),
                              Obx(
                                () => Column(
                                  children: <Widget>[
                                    Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: controller
                                                .descriptionfocus.value.hasFocus
                                            ? AppColors.appWhiteColor
                                            : AppColors.appWhiteColor
                                                .withOpacity(0.8),
                                        border: Border.all(
                                          color: AppColors.appButtonColor,
                                        ),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: TextFormField(
                                        maxLines: 10,
                                        focusNode:
                                            controller.descriptionfocus.value,
                                        onTap: () {
                                          FocusScope.of(context).requestFocus(
                                            controller.descriptionfocus.value,
                                          );
                                          controller.update();
                                        },
                                        onFieldSubmitted: (String term) {
                                          controller.descriptionfocus.value
                                              .unfocus();
                                          FocusScope.of(context).requestFocus(
                                            controller.submit.value,
                                          );
                                          controller.update();
                                        },
                                        onChanged: (String p0) async {
                                          controller.verify =
                                              await controller.isVerifyed();
                                          controller.descCount.value =
                                              p0.length;
                                        },
                                        controller: controller.descriptionCtrl,
                                        inputFormatters: <TextInputFormatter>[
                                          LengthLimitingTextInputFormatter(200),
                                        ],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          alignLabelWithHint: true,
                                          labelText: 'DESCRIPTION',
                                          labelStyle: AppThemes.lightTheme
                                              .textTheme.headlineLarge
                                              ?.copyWith(
                                            fontSize: 14,
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 10,
                                          ),
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    getValidations(
                                      validation: AppValidation.description(
                                        controller.descriptionCtrl.text.trim(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width,
                                      child: Text(
                                        '${controller.descCount.value}/200'
                                            .replaceAll('201', '200'),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ).paddingOnly(right: 5),
                                    ),
                                  ],
                                ).paddingOnly(
                                  right: 10,
                                  left: 10,
                                ),
                              ),
                              Obx(
                                () => controller.edit.value
                                    ? SizedBox(
                                        height: 220,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          clipBehavior: Clip.hardEdge,
                                          child: AppImages.asImage(
                                            UrlConst.dropinBaseUrl +
                                                controller
                                                    .dropInImage.first.images,
                                            height: 200,
                                            width: Get.width,
                                            fit: BoxFit.cover,
                                          ),
                                        ).paddingSymmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                      )
                                    : SizedBox(
                                        height: 220,
                                        child: Stack(
                                          children: <Widget>[
                                            controller.dropInImage.isEmpty
                                                ? Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    height: 200,
                                                    width: Get.width,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffE6e6e6),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        15,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 200,
                                                    child: PageView.builder(
                                                      reverse: true,
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      onPageChanged:
                                                          (int value) {},
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: controller
                                                          .dropInImage.length,
                                                      itemBuilder: (
                                                        BuildContext context,
                                                        int index,
                                                      ) {
                                                        return ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          clipBehavior:
                                                              Clip.hardEdge,
                                                          child: Image.file(
                                                            File(
                                                              controller
                                                                  .dropInImage[
                                                                      index]
                                                                  .images,
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ).paddingSymmetric(
                                                          horizontal: 15,
                                                        );
                                                      },
                                                    ),
                                                  ).paddingOnly(bottom: 10),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: InkWell(
                                                onTap: () {
                                                  Get.toNamed(
                                                    Routes.AddDropinPhotos,
                                                  );
                                                },
                                                child: AppAssets.asImage(
                                                  AppAssets.gallary,
                                                  height: 50,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              controller.isLoading
                                  ? LoaderView()
                                  : Obx(
                                      () => AppElevatedButton(
                                        focusNode: controller.submit.value,
                                        color: controller.verify.isTrue
                                            ? AppColors.appButtonColor
                                            : AppColors.appButtonColor
                                                .withOpacity(0.8),
                                        callback: () async {
                                          FocusScope.of(context).unfocus();
                                          controller.isValidate.value =
                                              checkValidationForAllFields();
                                          if (controller.isValidate.value) {
                                          } else {
                                            controller.edit.value
                                                ? await controller.updateDropIn(
                                                    dropin: dropin,
                                                  )
                                                : await controller.addDropIn();
                                            controller.edit(false);

                                            controller.isValidate(false);
                                          }
                                          // Get.toNamed(Routes.DropInMap);
                                        },
                                        title: controller.edit.value
                                            ? 'Update'
                                            : 'DROPIN',
                                      ).paddingOnly(bottom: 10),
                                    ),
                              Obx(
                                () => controller.edit.value
                                    ? AppElevatedButton(
                                        callback: () {
                                          controller.locationctrl.clear();
                                          controller.titlectrl.clear();
                                          controller.descriptionCtrl.clear();

                                          controller.edit.value = false;
                                          controller.selectedCategoryModelID =
                                              null;
                                          controller.dropInImage.clear();
                                          Get.back();
                                        },
                                        title: 'Back',
                                      ).paddingOnly(bottom: 10)
                                    : SizedBox(),
                              ),
                              SizedBox(
                                width: Get.width,
                                child: const Text(
                                  'Deletes after 30 days',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppColors.appWhiteColor,
                                  ),
                                ).paddingOnly(right: 10, bottom: 10),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget getValidations({String? validation}) {
    if (!controller.isValidate.value || validation == null) {
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
    if (AppValidation.title(controller.titlectrl.text) == null &&
        AppValidation.description(controller.descriptionCtrl.text) == null &&
        AppValidation.loaction(controller.locationctrl.text) == null) {
      return false;
    } else {
      return true;
    }
  }
}
