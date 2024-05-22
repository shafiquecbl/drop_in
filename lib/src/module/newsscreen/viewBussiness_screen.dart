import 'package:dropin/src/utils/widgets/custom_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../src_exports.dart';
import '../../models/sub_category_model.dart';
import '../../utils/widgets/app_images.dart';
import '../mapscreen/map_screen_controller.dart';

class ViewBussinessScreen extends StatelessWidget {
  ViewBussinessScreen({super.key});

  final MapsController c = Get.find<MapsController>();

  // final UserController c = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      decoration: BoxDecoration(gradient: AppColors.background),
      child: GetBuilder<MapsController>(
        builder: (MapsController c) {
          if (c.isLoading) {
            return LoaderView();
          } else
            return Scaffold(
              backgroundColor: AppColors.transparent,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: [
                          c.bussiness.value.coverPhoto.isEmpty
                              ? Container(
                                  clipBehavior: Clip.hardEdge,
                                  height: 200,
                                  width: Get.width,
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
                                    // padding: EdgeInsets.symmetric(horizontal: 5),
                                    itemCount:
                                        c.bussiness.value.coverPhoto.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: AppImages.asImage(
                                          c.bussiness.value.coverPhoto[index]
                                              .photos,
                                          fit: BoxFit.cover,
                                          width: Get.width * 0.95,
                                          height: 200,
                                        ),
                                      ).paddingOnly(right: 8);
                                    },
                                  ),
                                ).paddingOnly(bottom: 20),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: PopupMenuButton<int>(
                              child: Icon(Icons.more_vert),
                              onSelected: (int value) async {
                                if (value == 1) {
                                  dynamic reason =
                                      await Get.dialog(ReportDialog());
                                  if (reason is String) {
                                    //c.reportUser(reason: reason);
                                  }
                                } else if (value == 2) {
                                  //c.blockUser();
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuItem<int>>[
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: Text('Report & Hide!'),
                                  ),
                                  // PopupMenuItem<int>(
                                  //   value: 2,
                                  //   child: Text('Block'),
                                  // ),
                                ];
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  c.bussiness.value.businessName,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 15,
                                  ),
                                ).paddingSymmetric(horizontal: 10, vertical: 8),
                                Text(
                                  c.bussiness.value.location,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.greyColor,
                                    fontSize: 9.5,
                                  ),
                                ).paddingSymmetric(horizontal: 10),
                                Text(
                                  BusinessCategoryType.businessCategoryType(c.bussiness.value.catId).title,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.greyColor,
                                    fontSize: 9.5,
                                  ),
                                ).paddingSymmetric(horizontal: 10),
                              ],
                            ),
                          ),
                          AppElevatedButton(
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
                              c.createBusinessChat();
                            },
                          ),
                        ],
                      ).paddingOnly(bottom: 20),
                      Container(
                        height: 200,
                        width: Get.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xffebeb26).withOpacity(0.05),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            c.bussiness.value.description,
                            style: AppThemes.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.appWhiteColor,
                            ),
                          ),
                        ),
                      ).paddingSymmetric(horizontal: 5),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              height: 90,
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                shrinkWrap: true,
                                itemCount: c.bussiness.value.subCategory.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final SubCategory cat =
                                      c.bussiness.value.subCategory[index];
                                  return InkWell(
                                    onTap: () {
                                      logger.wtf(
                                        c.bussiness.value.subCategory[index]
                                            .name,
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: UrlConst.iconPath + cat.icon,
                                              height: 20,
                                              width: 20,
                                            ).paddingOnly(right: 5),
                                            Text(
                                              cat.name,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.appWhiteColor,
                                              ),
                                            ),
                                          ],
                                        ).paddingOnly(bottom: 10),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            width: 190,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: AppColors.greyColor),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Get.dialog(
                                        DialogContainer(
                                          minWid: 220,
                                          maxWid: 220,
                                          minHei: 110,
                                          maxHei: 110,
                                          body: rateMyBusinessDialog(),
                                        ),
                                      ).then(
                                        (dynamic value) =>
                                            c.addBussinessRate(c.rate),
                                      );
                                    },
                                    child: RatingBar.builder(
                                      initialRating:
                                          c.bussiness.value.businessRating,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      ignoreGestures: true,
                                      itemSize: 30,
                                      itemPadding: EdgeInsets.symmetric(
                                        horizontal: 2.0,
                                        vertical: 5,
                                      ),
                                      itemBuilder: (BuildContext context, _) =>
                                          AppAssets.asIcon(
                                        AppAssets.star,
                                        color: AppColors.appWhiteColor,
                                      ),
                                      onRatingUpdate: (double rating) {},
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '${c.bussiness.value.businessRating.toStringAsFixed(1)} /5',
                                      style: AppThemes
                                          .lightTheme.textTheme.headlineMedium
                                          ?.copyWith(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 11.35,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: Get.width * 0.10,
                                        ),
                                        Text(
                                          c.bussiness.value.ratedByCount
                                              .toString(),
                                          style: AppThemes.lightTheme.textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                            color: AppColors.appWhiteColor,
                                            fontSize: 11.35,
                                          ),
                                        ),
                                        AppAssets.asImage(
                                          AppAssets.profile,
                                          height: 10,
                                          width: 25,
                                        ),
                                      ],
                                    ),
                                  ],
                                ).paddingSymmetric(horizontal: 10, vertical: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
        },
      ),
    );
  }

  Widget rateMyBusinessDialog() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: AppColors.rateBussinesscolor,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Rate My Business!',
            style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppColors.appWhiteColor,
              fontSize: 12,
            ),
          ).paddingOnly(top: 10),
          RatingBar.builder(
            initialRating: 5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            glow: true,
            itemPadding: EdgeInsets.symmetric(
              horizontal: 4.0,
              vertical: 10,
            ),
            itemBuilder: (BuildContext context, _) => AppAssets.asIcon(
              AppAssets.star,
              color: AppColors.appWhiteColor,
            ),
            onRatingUpdate: (double rating) {
              c.rate = rating;
            },
            updateOnDrag: true,
          ),
        ],
      ),
    );
  }
}
