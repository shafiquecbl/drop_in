import 'dart:ui';

import 'package:dropin/src_exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../module/newsscreen/news_screen_controller.dart';

class PopDialog extends StatelessWidget {
  final c = Get.find<NewsScreenController>();

  PopDialog({Key? key}) : super(key: key);

  // TextEditingController controller = TextEditingController();
  // RxBool state1 = false.obs;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 15,
        sigmaY: 15,
        tileMode: TileMode.clamp,
      ),
      child: SizedBox(
        height: 500,
        width: 200,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            centerTitle: false,
            elevation: 0.0,
            actions: <Widget>[
              AppElevatedButton(
                height: 35,
                width: 105,
                color: AppColors.black,
                borderRadius: BorderRadius.circular(30),
                callback: () async {
                  Get.back();
                  await c.getNewsFeed(true);
                },
                title: 'Continue',
                style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.appWhiteColor,
                ),
              ).paddingAll(10),
            ],
          ),
          body: Container(
            width: Get.width,
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.purpaleLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Customize',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: Get.width,
                  child: const Text(
                    '50 Kilometers',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 20).paddingOnly(bottom: 10),
                Row(
                  children: [
                    Transform.scale(
                      scaleY: 0.85,
                      child: Obx(
                        () => CupertinoSwitch(
                          thumbColor: AppColors.brightBlue,
                          activeColor: AppColors.grey,
                          value: !c.state1.value,
                          onChanged: (val) {
                            c.controller.clear();
                            logger.wtf(c.state1.value);
                            if (c.state1.isTrue) {
                              c.searchController.clear();
                              c.addressResults.value.predictions = [];
                              c.markers.clear();
                              c.update();
                            }
                            c.state1.value = !val;
                            c.currentLocation = LatLng(
                              app.currentPosition.latitude,
                              app.currentPosition.longitude,
                            );
                          },
                        ).paddingOnly(right: 6),
                      ),
                    ),
                    const Text(
                      'Distance from you...',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ).paddingOnly(bottom: 10, left: 15),
                Row(
                  children: [
                    Transform.scale(
                      scaleY: 0.85,
                      child: Obx(
                        () => CupertinoSwitch(
                          value: c.state1.value,
                          thumbColor: AppColors.brightBlue,
                          activeColor: AppColors.grey,
                          onChanged: (val) {
                            logger.wtf(c.state1.value);
                            c.state1.value = val;
                            if (val) {
                              Get.toNamed(Routes.LocationMap);
                            } else {
                              c.currentLocation = LatLng(
                                app.currentPosition.latitude,
                                app.currentPosition.longitude,
                              );
                            }

                            logger.wtf(c.currentLocation);
                          },
                        ),
                      ),
                    ).paddingOnly(right: 6),
                    const Text(
                      'Distance from location... ',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ).paddingOnly(bottom: 10, left: 15),
                AppTextField(
                  title: 'LOCATION',
                  textController: c.controller,
                  hint: '...',
                  readOnly: true,
                  onTap: () {
                    c.state1.value = true;
                    Get.toNamed(Routes.LocationMap);
                  },
                ).paddingSymmetric(horizontal: 20, vertical: 10),
                Container(
                  width: Get.width * 0.23,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
