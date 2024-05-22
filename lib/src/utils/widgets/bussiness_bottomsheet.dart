import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../src_exports.dart';
import '../../module/mapscreen/map_screen_controller.dart';
import 'app_images.dart';

class BussinessBottomSheet extends StatelessWidget {
  BussinessBottomSheet({super.key});

  final MapsController controller = Get.find<MapsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapsController>(
      builder: (MapsController c) {
        if (c.lodingMore) {
          return SizedBox(
            height: Get.height * 0.61,
            child: LoaderView(),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: Get.width * 0.3,
                    height: 5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ).paddingOnly(top: 5),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.bussiness.value.businessName,
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(fontSize: 15),
                          ).paddingOnly(left: 20, top: 10),
                          Text(
                            c.bussiness.value.location,
                            style: AppThemes.lightTheme.textTheme.titleMedium!
                                .copyWith(
                              fontSize: 9.5,
                            ),
                          ).paddingOnly(top: 3).paddingSymmetric(horizontal: 28),
                          Text(
                            BusinessCategoryType.businessCategoryType(
                                    c.bussiness.value.catId)
                                .title,
                            style: AppThemes.lightTheme.textTheme.titleMedium!
                                .copyWith(
                              fontSize: 9.5,
                            ),
                          ).paddingSymmetric(horizontal: 28),
                        ],
                      ),
                    ),
                    Icon(Icons.star_border_outlined),
                    Text(
                      '${c.bussiness.value.businessRating.toStringAsFixed(1)} /5',
                      style: AppThemes.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: AppColors.appBlackColor,
                        fontSize: 11.35,
                      ),
                    ).paddingOnly(right: 30),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 100,
                  width: Get.width,
                  margin: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.appWhiteColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      top: 10,
                      right: 5,
                      left: 5,
                      bottom: 10,
                    ),
                    child: Text(
                      c.bussiness.value.description,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 8),
                if (app.user.id != c.bussiness.value.userId)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppElevatedButton(
                        height: 35,
                        width: 120,
                        callback: () {
                          // Get.back();
                          Navigator.of(context)
                              .pushNamed(Routes.ViewBussinessScreen);
                        },
                        title: 'Visit',
                        color: AppColors.appBlackColor,
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppColors.appWhiteColor,
                          fontSize: 12,
                        ),
                      ),
                      AppElevatedButton(
                        height: 35,
                        width: 120,
                        color: AppColors.appBlackColor,
                        title: 'Message',
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppColors.appWhiteColor,
                          fontSize: 12,
                        ),
                        callback: () {
                          loggerNoStack.w(
                              'UserrIdd:::${app.user.id}---${c.bussiness.value.userId}');
                          if (app.user.id == c.bussiness.value.userId) {
                            Get.rawSnackbar(
                                message:
                                    'You can\'t chat with your own business');
                          } else {
                            c.createBusinessChat();
                          }
                        },
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 22, vertical: 10)
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppElevatedButton(
                        height: 28,
                        width: 120,
                        callback: () async {
                          Get.back();
                          // await 0.4.delay();
                          await controller.gMapsController!.animateCamera(
                            CameraUpdate.newLatLngZoom(
                              LatLng(
                                app.user.bussiness?.lat ?? 0.0,
                                app.user.bussiness?.lang ?? 0.0,
                              ),
                              16,
                            ),
                          );
                        },
                        title: 'Location',
                        color: AppColors.appBlackColor,
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppColors.appWhiteColor,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 20),
                      AppElevatedButton(
                        height: 28,
                        width: 120,
                        callback: () {
                          Navigator.of(context)
                              .pushNamed(Routes.EditBussinessProfile);
                        },
                        title: 'Edit Business',
                        color: AppColors.appBlackColor,
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppColors.appWhiteColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 25),
                c.bussiness.value.coverPhoto.isEmpty
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        height: 200,
                        width: 350,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.appWhiteColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      )
                    : SizedBox(
                        height: 200,
                        child: ListView.builder(
                          reverse: false,
                          clipBehavior: Clip.hardEdge,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: c.bussiness.value.coverPhoto.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: AppImages.asImage(
                                c.bussiness.value.coverPhoto[index].photos,
                                fit: BoxFit.cover,
                                width: Get.width * 0.90,
                                height: 200,
                              ),
                            ).paddingOnly(right: 8);
                          },
                        ),
                      ).paddingOnly(bottom: 20),
              ],
            ),
          );
        }
      },
    );
  }
}
