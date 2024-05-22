import 'package:dropin/src_exports.dart';
import 'package:intl/intl.dart';

import '../../module/mapscreen/map_screen_controller.dart';
import 'app_images.dart';

class ProfileSheet extends StatelessWidget {
  ProfileSheet({Key? key}) : super(key: key);
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
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: AppImages.asProvider(
                              c.news.value.user!.imageUrl,
                            ),
                          ),
                        ),
                        CachedNetworkImage(
                          height: 30,
                          width: 30,
                          imageUrl: UrlConst.otherMediaBase + c.news.value.icon,
                        ),
                      ],
                    ).paddingOnly(left: 10, right: 10, top: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.news.value.user!.userName,
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(fontSize: 15),
                          ).paddingOnly(left: 10),
                          Text(
                            c.news.value.location,
                            style: AppThemes.lightTheme.textTheme.titleMedium!
                                .copyWith(
                              fontSize: 9.5,
                            ),
                          ).paddingSymmetric(horizontal: 16),
                          Text(
                            DateFormat('MMM dd, yyyy').format(
                              c.news.value.createdAt ?? DateTime.now(),
                            ),
                            style: AppThemes.lightTheme.textTheme.titleMedium!
                                .copyWith(
                              fontSize: 9.5,
                            ),
                          ).paddingSymmetric(horizontal: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    reverse: false,
                    clipBehavior: Clip.hardEdge,
                    scrollDirection: Axis.horizontal,
                    itemCount: c.news.value.dropinImages.length,
                    itemBuilder: (BuildContext context, int index) {
                      logger.w(c.news.value.dropinImages.length);
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: AppImages.asImage(
                          c.news.value.dropinImages[index].url,
                          fit: BoxFit.cover,
                          width: Get.width * 0.90,
                          height: 200,
                        ),
                      ).paddingSymmetric(horizontal: 16);
                    },
                  ),
                ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(18),
                //   child: AppImages.asImage(
                //     UrlConst.mediaBase + c.news.value.image,
                //     fit: BoxFit.cover,
                //     width: Get.width,
                //     height: 200,
                //   ),
                // ).paddingSymmetric(
                //   horizontal: 16,
                // ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    c.news.value.title,
                    style: AppThemes.lightTheme.textTheme.headlineMedium
                        ?.copyWith(fontSize: 18),
                  ),
                ).paddingOnly(left: 30, right: 25, top: 10, bottom: 5),
                Container(
                  height: 120,
                  width: Get.width,
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.appWhiteColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: 10,
                      right: 10,
                      left: 5,
                      bottom: 10,
                    ),
                    child: Text(c.news.value.description),
                  ),
                ).paddingSymmetric(horizontal: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IgnorePointer(
                      ignoring: app.user.id == c.news.value.user!.id,
                      child: AppElevatedButton(
                        height: 35,
                        width: 120,
                        callback: () {
                          Get.toNamed(
                            Routes.ViewProfile,
                            arguments: c.news.value.user!.id,
                          );
                        },
                        title: 'View Profile',
                        color: AppColors.appBlackColor,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: app.user.id == c.news.value.user!.id,
                      child: AppElevatedButton(
                        height: 35,
                        width: 120,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        color: AppColors.appBlackColor,
                        title: 'Message',
                        callback: () {
                          c.createChat(c.news.value.user!.userName);
                        },
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 22, vertical: 10)
              ],
            ),
          );
        }
      },
    );
  }
}
