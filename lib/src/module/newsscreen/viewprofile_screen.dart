import 'package:dropin/src/models/news_feed_model.dart';
import 'package:intl/intl.dart';

import '../../../src_exports.dart';
import '../../utils/widgets/app_images.dart';
import '../../utils/widgets/custom_bottom_sheet.dart';
import '../authprofile/profilescreen_controller.dart';
import '../user_controller.dart';
import 'news_screen_controller.dart';

class ViewProfile extends StatelessWidget {
  ViewProfile({super.key});

  final UserController c = Get.put(UserController());
  final NewsScreenController controller = Get.find<NewsScreenController>();
  final ProfileController profilecontroller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      decoration: BoxDecoration(gradient: AppColors.background),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: GetBuilder<UserController>(
        builder: (UserController c) {
          if (c.isLoading) {
            return LoaderView();
          } else
            return Scaffold(
              /*appBar: CustomAppBar.getWithLeading(
                '',
                showBackButton: false,
                actions: <Widget>[

                ],
              ),*/
              backgroundColor: AppColors.transparent,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 290,
                        child: Stack(
                          children: <Widget>[
                            c.user.value.coverPhotos.isEmpty
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
                                    height: 220,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          c.user.value.coverPhotos.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          width: context.width * 0.95,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            child: AppImages.asImage(
                                              c.user.value.coverPhotos[index]
                                                  .url,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ).paddingOnly(
                                    bottom: context.height * 0.05,
                                    top: 8,
                                  ),
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
                                      c.reportUser(reason: reason);
                                    }
                                  } else if (value == 2) {
                                    c.blockUser();
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return <PopupMenuItem<int>>[
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Text('Report & Hide!'),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 2,
                                      child: Text('Block'),
                                    ),
                                  ];
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 1,
                              left: 0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 52,
                                          backgroundImage: AppImages.asProvider(
                                            c.user.value.imageUrl,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(
                                    left: 8,
                                  ),
                                  Text(
                                    c.user.value.userName,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineLarge
                                        ?.copyWith(
                                      color: AppColors.appWhiteColor,
                                      fontSize: 15,
                                    ),
                                  ).paddingSymmetric(
                                      horizontal: 5, vertical: 15),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Column(
                                children: <Widget>[
                                  Obx(
                                    () => IconButton(
                                      onPressed: () {
                                        c.userLike(user: c.user.value);
                                      },
                                      icon: AppAssets.asImage(
                                        c.user.value.is_like
                                            ? AppAssets.star1
                                            : AppAssets.star,
                                        height: 35,
                                        width: 35,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        c.user.value.like_count.toString(),
                                        textAlign: TextAlign.end,
                                        style: AppThemes
                                            .lightTheme.textTheme.headlineMedium
                                            ?.copyWith(
                                          color: AppColors.appWhiteColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      AppAssets.asImage(
                                        AppAssets.profile,
                                        height: 15,
                                        width: 15,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: context.height * 0.20,
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
                                  c.user.value.bio,
                                  style: AppThemes
                                      .lightTheme.textTheme.bodySmall
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
                              children: <Widget>[
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 13,
                                        backgroundImage: AppAssets.asProvider(
                                          '${AppAssets.countryIcon}${c.user.value.country.split(' ').last.replaceAll('(', '').replaceAll(')', '').toLowerCase()}.png',
                                        ),
                                      ).paddingOnly(right: 10),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            SizedBox(
                                              width: Get.width * 0.22,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  c.user.value.country,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppThemes.lightTheme
                                                      .textTheme.headlineMedium
                                                      ?.copyWith(
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.appWhiteColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              c.user.value.skillLevel,
                                              style: AppThemes.lightTheme
                                                  .textTheme.headlineMedium
                                                  ?.copyWith(
                                                fontSize: 9,
                                                color: AppColors.appWhiteColor
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            Text(
                                              'Age ${c.user.value.age}',
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
                                ).paddingOnly(bottom: 5, left: 8),
                                AppElevatedButton(
                                  height: 35,
                                  width: 100,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  color: AppColors.appBlackColor,
                                  title: 'Message',
                                  callback: () {
                                    logger.w(
                                      controller.news.value.user!.userName,
                                    );
                                    controller.createChat(
                                      c.user.value.userName,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 10),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Current DropIns',
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
                        itemCount: c.user.value.dropIns.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          /// this is dropin (news feed model)
                          final NewsFeedModel user =
                              c.user.value.dropIns[index];
                          return InkWell(
                            onTap: () {
                              controller.dropInGetId(id: user.id);
                              customBottomSheet(
                                child: NewsFeedSheet(),
                              );
                            },
                            child: Stack(
                              children: <Widget>[
                                Card(
                                  color: AppColors.listviewcolor,
                                  elevation: 5,
                                  child: Row(
                                    children: <Widget>[
                                      ClipRRect(
                                        child: SizedBox(
                                          height: 90,
                                          child: Stack(
                                            children: <Widget>[
                                              AppImages.asImage(
                                                UrlConst.dropinBaseUrl +
                                                    user.image,
                                                height: 90,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ).paddingOnly(right: 20),
                                              Positioned(
                                                right: 0,
                                                bottom: 3,
                                                child: CachedNetworkImage(
                                                  height: 30,
                                                  width: 30,
                                                  imageUrl:
                                                      UrlConst.otherMediaBase +
                                                          user.icon,
                                                ).paddingAll(5),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              user.title,
                                              style: AppThemes.lightTheme
                                                  .textTheme.headlineMedium
                                                  ?.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              user.location,
                                              style:
                                                  context.textTheme.bodySmall,
                                            ).paddingSymmetric(horizontal: 4),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
}

class ViewProfileSheet extends StatelessWidget {
  const ViewProfileSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (UserController c) {
        if (c.lodingMore) {
          return SizedBox(height: Get.height * 0.61, child: LoaderView());
        } else {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 45,
                            // backgroundColor: AppColors.purpale,
                            backgroundImage: AppImages.asProvider(
                              c.user.value.imageUrl,
                            ),
                          ),
                        ),
                        CachedNetworkImage(
                          height: 30,
                          width: 30,
                          imageUrl: UrlConst.otherMediaBase +
                              c.user.value.dropIns.first.icon,
                        ),
                      ],
                    ).paddingOnly(left: 10, right: 10, top: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            c.user.value.userName,
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(fontSize: 15),
                          ).paddingOnly(left: 10),
                          Text(
                            c.user.value.dropIns.first.location,
                            style: AppThemes.lightTheme.textTheme.titleMedium!
                                .copyWith(
                              fontSize: 9.5,
                            ),
                          ).paddingSymmetric(horizontal: 15),
                          // Text(
                          //   DateFormat('MMM dd, yyyy')
                          //       .format(c.news.value.createdAt!),
                          //   style: AppThemes.lightTheme.textTheme.titleMedium!
                          //       .copyWith(
                          //     fontSize: 9.5,
                          //   ),
                          // ).paddingSymmetric(horizontal: 15),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: c.user.value.coverPhotos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: context.width * 0.95,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: AppImages.asImage(
                            c.user.value.coverPhotos[index].url,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ).paddingOnly(
                  bottom: context.height * 0.05,
                  top: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[],
                ).paddingSymmetric(horizontal: 22, vertical: 10)
              ],
            ),
          );
        }
      },
    );
  }
}
