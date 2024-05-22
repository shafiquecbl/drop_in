import 'dart:ui';

import 'package:dropin/src/models/news_feed_model.dart';
import 'package:dropin/src/module/homescreen/home_screen_controller.dart';
import 'package:dropin/src/module/mapscreen/map_screen_controller.dart';
import 'package:dropin/src/module/profilescreen/profile_screen_controller.dart';
import 'package:dropin/src/utils/widgets/app_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../src_exports.dart';
import '../../models/map_model.dart';
import '../../utils/widgets/bussiness_bottomsheet.dart';
import '../../utils/widgets/custom_bottom_sheet.dart';
import '../authprofile/profilescreen_controller.dart';
import '../dropinscreen/dropin_controller.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileScreenController c = Get.put(ProfileScreenController());

  final ProfileController profilecontroller = Get.put(ProfileController());

  final DropinController controller = Get.find<DropinController>();

  final HomeScreenController homeController = Get.find<HomeScreenController>();

  final MapsController mapController = Get.find<MapsController>();
  GoogleMapController? gMapsController;

  @override
  Widget build(BuildContext context) {
    logger.w('USERDATA:::${app.user.toJson()}');
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: GestureDetector(
        onTap: () {
          c.newsFeedList.forEach((element) {
            element.showReport.value = false;
          });
        },
        child: Container(
          height: context.height,
          decoration: BoxDecoration(gradient: AppColors.background),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: Stack(
                        children: [
                          app.user.coverPhotos.isEmpty
                              ? Container(
                                  height: 220,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
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
                                    itemCount: app.user.coverPhotos.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        width: context.width * 0.9,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                app.user.coverPhotos[index].url,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ).paddingOnly(bottom: context.height * 0.05),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Stack(
                                  children: [
                                    GetBuilder<ProfileController>(
                                      builder: (_) {
                                        return CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 52,
                                            backgroundImage:
                                                profilecontroller.searching
                                                    ? null
                                                    : AppImages.asProvider(
                                                        app.user.imageUrl,
                                                      ),
                                            backgroundColor: AppColors.navyBlue,
                                            child: profilecontroller.searching
                                                ? Center(
                                                    child:
                                                        CupertinoActivityIndicator(
                                                      color: AppColors.mapColor,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (profilecontroller.searching) {
                                            logger.w('searching');
                                          } else {
                                            final foo = await profilecontroller
                                                .pickedImage(isProfile: true);
                                            if (foo.isNotEmpty) {
                                              await profilecontroller
                                                  .profilephoto(true);
                                              setState(() {});
                                            }
                                          }
                                        },
                                        child: AppAssets.asImage(
                                          AppAssets.gallary,
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ).paddingOnly(
                                  left: 5,
                                ),
                                Text(
                                  app.user.userName,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineLarge
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 15,
                                  ),
                                ).paddingSymmetric(horizontal: 5)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: context.height * 0.22,
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color:
                                  const Color(0xFFEBEBEB26).withOpacity(0.05),
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                textAlign: TextAlign.start,
                                app.user.bio,
                                style: AppThemes.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appWhiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: AppColors.containercolor,
                                  ),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: AppAssets.asProvider(
                                        '${AppAssets.countryIcon}${app.user.country.split(' ').last.replaceAll('(', '').replaceAll(')', '').toLowerCase()}.png',
                                      ),
                                      radius: 16.5,
                                    ).paddingOnly(right: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.22,
                                            child: Text(
                                              app.user.country,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.end,
                                              style: AppThemes.lightTheme
                                                  .textTheme.headlineMedium
                                                  ?.copyWith(
                                                fontSize: 11,
                                                color: AppColors.appWhiteColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            app.user.skillLevel,
                                            style: AppThemes.lightTheme
                                                .textTheme.headlineMedium
                                                ?.copyWith(
                                              fontSize: 9,
                                              color: AppColors.appWhiteColor
                                                  .withOpacity(0.6),
                                            ),
                                          ),
                                          Text(
                                            'Age ${app.user.age}',
                                            style: AppThemes.lightTheme
                                                .textTheme.headlineMedium
                                                ?.copyWith(
                                              fontSize: 9,
                                              color: AppColors.appWhiteColor
                                                  .withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ).paddingOnly(bottom: 5),
                              SizedBox(
                                width: 100,
                                child: AppElevatedButton(
                                  height: 35,
                                  color: AppColors.appBlackColor,
                                  callback: () async {
                                    await Get.toNamed(Routes.ProfileEditScreen);
                                    setState(() {});
                                  },
                                  title: 'Edit Profile',
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 140,
                                child: AppElevatedButton(
                                  height: 35,
                                  width: 120,
                                  color: app.bussiness.id != 0
                                      ? AppColors.appBlackColor
                                      : Color(0xFF1E1E1E).withOpacity(0.6),
                                  callback: () async {
                                    logger.w(app.user.toJson());
                                    if (app.user.bussiness!.id != 0) {
                                      /*await Get.toNamed(
                                        Routes.EditBussinessProfile,
                                      );*/
                                      homeController.selectedIndex.value = 1;
                                      await 0.5.delay();
                                      await Get.showOverlay(
                                        asyncFunction: () {
                                          return mapController.getNearByPins(
                                            latLng: LatLng(
                                              app.user.bussiness?.lat ?? 0.0,
                                              app.user.bussiness?.lang ?? 0.0,
                                            ),
                                          );
                                        },
                                        loadingWidget: LoaderView(),
                                      ).then((value) async {
                                        await mapController.getBussinessByID(
                                            app.user.bussiness?.id ?? 0);
                                        customBottomSheet(
                                          child: BussinessBottomSheet(),
                                        );
                                       /* await 0.4.delay();
                                        List<BusinessDetail> pins = [];
                                        pins.addAll(mapController
                                            .nearByPins.value.businessDetails);
                                        pins.addAll(mapController
                                            .nearByPins.value.userDropin);
                                        if (pins.length == 1) {
                                          await mapController.getBussinessByID(
                                              app.user.bussiness?.id ?? 0);
                                          customBottomSheet(
                                            child: BussinessBottomSheet(),
                                          );
                                        } else {
                                          Get.rawSnackbar(
                                              message:
                                                  'There are more than 1 pins near by kindly select one to view.');
                                        }*/
                                      });
                                    } else {
                                      await Get.toNamed(
                                        Routes.AddBusiness,
                                        arguments: false,
                                      )?.then((value){
                                        setState(() {});
                                      });
                                      /*setState(() {});*/
                                    }
                                  },
                                  title: app.bussiness.id > 0
                                      ? 'Business Profile'
                                      : 'Add Business',
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: app.bussiness.id > 0
                                        ? AppColors.appWhiteColor
                                        : AppColors.appWhiteColor
                                            .withOpacity(0.5),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 10),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Your Current DropIns',
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontSize: 15,
                          color: AppColors.appWhiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 20, vertical: 10),
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 15),
                      itemCount: c.newsFeedList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final NewsFeedModel news = c.newsFeedList[index];
                        return Slidable(
                          key: ValueKey<int>(news.id),
                          endActionPane: ActionPane(
                            extentRatio: 0.3,
                            dragDismissible: false,
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                flex: 1,
                                padding: EdgeInsets.all(20),
                                onPressed: (BuildContext context) {
                                  c.newsFeedList.forEach((element) {
                                    element.showDelete.value = false;
                                  });

                                  news.showDelete.value =
                                      !news.showDelete.value;
                                },
                                icon: Icons.delete,
                                autoClose: true,
                                backgroundColor: AppColors.red,
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () async {
                              logger.w('message');
                              c.newsFeedList.forEach((element) {
                                element.showDelete.value = false;
                              });
                              if (news.showDelete.value) {
                                news.showDelete.value = false;
                              } else {
                                controller.edit(true);
                                final newsFeedModel = await Get.toNamed(
                                  Routes.DropInScreen,
                                  arguments: [
                                    c.newsFeedList[index],
                                  ],
                                );
                                if (newsFeedModel != null) {
                                  c.newsFeedList[index] = newsFeedModel;
                                  controller.update();
                                }
                              }

                              setState(() {});
                            },
                            child: Stack(
                              children: <Widget>[
                                Card(
                                  color: AppColors.listviewcolor,
                                  elevation: 5,
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 90,
                                        child: Stack(
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: AppImages.asImage(
                                                UrlConst.dropinBaseUrl +
                                                    news.image,
                                                height: 90,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ).paddingOnly(right: 20),
                                            ),
                                            Positioned(
                                              right: 0,
                                              bottom: 3,
                                              child: CachedNetworkImage(
                                                height: 30,
                                                width: 30,
                                                imageUrl:
                                                    UrlConst.otherMediaBase +
                                                        news.icon,
                                              ).paddingAll(5),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              news.title,
                                              style: AppThemes.lightTheme
                                                  .textTheme.headlineMedium
                                                  ?.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              news.location,
                                              style:
                                                  context.textTheme.bodySmall,
                                            ).paddingSymmetric(horizontal: 4),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              DateFormat("MMM dd'th', yyyy")
                                                  .format(
                                                DateTime.parse(
                                                  news.createdAt.toString(),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Obx(
                                    () => Visibility(
                                      visible: news.showDelete.value,
                                      child: ClipRRect(
                                        clipBehavior: Clip.antiAlias,
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX:
                                                news.showDelete.value ? 2 : 0,
                                            sigmaY:
                                                news.showDelete.value ? 2 : 0,
                                          ),
                                          child: AppButton(
                                            title: 'Delete?',
                                            callback: () {
                                              c.deleteDropIn(id: news.id);
                                              c.newsFeedList.removeAt(index);
                                              setState(() {});
                                            },
                                          ).paddingOnly(
                                            left: 40,
                                            top: 20,
                                            right: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ).paddingOnly(top: 10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
