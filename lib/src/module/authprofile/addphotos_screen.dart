import 'package:dropin/src/module/authprofile/profilescreen_controller.dart';

import '../../../src_exports.dart';

class AddPhotos extends StatefulWidget {
  AddPhotos({Key? key}) : super(key: key);

  @override
  State<AddPhotos> createState() => _AddPhotosState();
}

class _AddPhotosState extends State<AddPhotos> {
  final ProfileController c = Get.put(ProfileController());

  bool isEditProfile = (Get.arguments ?? false);

  /// this var is create for edit profile only
  ///
  @override
  void initState() {
    c.imgList1.addAll(app.user.coverPhotos);
    c.coverPhotos.addAll(app.user.coverPhotos);

    super.initState();
  }

  @override
  void dispose() {
    if (isEditProfile) {
      c.imgList1.clear();
      c.coverPhotos.clear();
      c.pickedPath.value = '';
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      gradient: !isEditProfile
          ? AppColors.backgroundTransperent
          : AppColors.background,
      appBar: CustomAppBar.getAppBar(
        'Photos',
        titleColor:
            isEditProfile ? AppColors.appBlackColor : AppColors.appWhiteColor,
      ),
      body: GetBuilder<ProfileController>(
        builder: (ProfileController c) {
          return Column(
            children: [
              Obx(
                () => SizedBox(
                  height: 230,
                  child: Stack(
                    children: [
                      c.imgList1.isEmpty
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
                                itemCount: isEditProfile
                                    ? c.coverPhotos.length
                                    : c.imgList1.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    clipBehavior: Clip.hardEdge,
                                    child: Stack(
                                      children: [
                                        isEditProfile
                                            ? c.coverPhotos[index].isFileImage
                                                ? Image.file(
                                                    File(
                                                      c.coverPhotos[index]
                                                          .coverPhoto,
                                                    ),
                                                    width: Get.width * 0.9,
                                                    height: 210,
                                                    fit: BoxFit.cover,
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: c
                                                        .coverPhotos[index].url,
                                                    fit: BoxFit.cover,
                                                    height: 210,
                                                    width: Get.width * 0.9,
                                                  )
                                            : Image.file(
                                                File(
                                                  c.imgList1[index].coverPhoto,
                                                ),
                                                width: Get.width * 0.9,
                                                fit: BoxFit.cover,
                                              ),
                                        Positioned(
                                          top: 0,
                                          right: 10,
                                          child: IconButton(
                                            hoverColor: AppColors.transparent,
                                            splashColor: AppColors.transparent,
                                            focusColor: AppColors.transparent,
                                            onPressed: () {
                                              if (isEditProfile) {
                                                if (c.coverPhotos[index].id !=
                                                    0) {
                                                  c.removedImages.add(
                                                    c.coverPhotos[index].id,
                                                  );
                                                }
                                                logger.i(c.removedImages);

                                                c.coverPhotos.removeAt(index);
                                              } else {
                                                c.imgList1.removeAt(index);
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
                            logger.w(c.imgList1.value.length);
                            logger.w(c.coverPhotos.length);

                            /// will execute during auth create account
                            if (!isEditProfile) {
                              if (c.imgList1.value.length < 5) {
                                await c.imagePicker(isProfile: false);
                              } else {
                                c.onError(
                                  'You can select only 5 images',
                                  () {},
                                );
                              }
                            } else {
                              if (c.coverPhotos.length < 5) {
                                final foo =
                                    await c.imagePicker(isProfile: true);
                                logger.w(foo);
                                if (foo.isNotEmpty) {
                                  c.coverPhotos.add(
                                    CoverPhoto(coverPhoto: foo),
                                  );
                                  c.imgList1.add(
                                    CoverPhoto(coverPhoto: foo),
                                  );
                                  setState(() {});
                                }
                              } else {
                                c.onError(
                                  'You can select only 5 images',
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
              SizedBox(
                height: context.height * 0.2,
              ),
              GetBuilder<ProfileController>(
                builder: (c) {
                  return c.isLoading
                      ? LoaderView()
                      : AppElevatedButton(
                          width: context.width * 0.90,
                          height: 50,
                          callback: () async {
                            logger.w(isEditProfile);

                            if (!isEditProfile) {
                              await c.profileSetups();
                              app.showDialog = true;
                            } else {
                              await c.updateCoverPhoto();
                              // Get.back();
                            }

                            // if (c.imgList1.isEmpty) {
                            //   c.onError('please select cover photos', () {});
                            // } else {
                            //   Get.back();
                            // }
                            // // if (!isEditProfile) {
                            // // } else {}
                          },
                          title: isEditProfile ? 'Update' : 'Continue',
                        ).paddingSymmetric(horizontal: 20, vertical: 5);
                },
              ),
              AppElevatedButton(
                width: context.width * 0.90,
                height: 50,
                callback: () {
                  Get.back();
                },
                title: 'Back',
              ).paddingSymmetric(horizontal: 20, vertical: 5),
            ],
          );
        },
      ),
    );
  }
}
