import 'dart:ui';

import 'package:dropin/src/models/news_feed_model.dart';
import 'package:dropin/src/utils/const/const_strings.dart';
import 'package:dropin/src/utils/widgets/app_images.dart';
import 'package:dropin/src/utils/widgets/custom_dialog.dart';
import 'package:dropin/src/utils/widgets/popup_menu.dart';
import 'package:intl/intl.dart';
import '../../../src_exports.dart';
import '../../utils/widgets/custom_bottom_sheet.dart';
import 'news_screen_controller.dart';

class NewsScreen extends StatelessWidget {
  NewsScreen({Key? key}) : super(key: key);
  final NewsScreenController c = Get.put(NewsScreenController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      c.newsFeedList.forEach((NewsFeedModel element) {
        element.showReport.value = false;
      });
      c.update();
    });
    return Container(
      height: context.height,
      width: context.width,
      decoration: BoxDecoration(gradient: AppColors.background),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          centerTitle: false,
          elevation: 0.0,
          title: Text(
            'NEWS FEED',
            style: AppThemes.lightTheme.textTheme.headlineLarge?.copyWith(
              color: AppColors.appBlackColor,
              fontSize: 25,
            ),
          ),
          actions: <Widget>[
            AppElevatedButton(
              height: 35,
              width: Get.width * 0.38,
              color: AppColors.black,
              borderRadius: BorderRadius.circular(30),
              callback: () async {
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final Offset offset =
                    renderBox.localToGlobal(Offset(-100, -100));
                logger.v(offset);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => GestureDetector(
                    onTap: () => Get.back(),
                    child: PopDialog(),
                  ),
                );
              },
              title: 'Customize',
              style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                color: AppColors.appWhiteColor,
              ),
            ).paddingAll(10),
          ],
        ),
        body: Column(
          children: <Widget>[
            GetBuilder<NewsScreenController>(
              builder: (NewsScreenController c) {
                if (c.isLoading) {
                  return Expanded(
                    child: Center(child: LoaderView()),
                  );
                } else {
                  if (c.newsFeedList.isNotEmpty) {
                    return Expanded(
                      child: RefreshIndicator(
                        color: AppColors.appButtonColor,
                        onRefresh: () async {
                          c.newsFeedList.clear();
                          return await c.getNewsFeed();
                        },
                        child: ListView.builder(
                          itemCount: c.newsFeedList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final NewsFeedModel news = c.newsFeedList[index];
                            return NewsTile(
                              news: news,
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'No DropIns near you',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NewsTile extends StatelessWidget {
  NewsTile({required this.news, Key? key}) : super(key: key);
  final NewsFeedModel news;
  final NewsScreenController c = Get.find<NewsScreenController>();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 1.0,
            spreadRadius: 1.0,
            offset: Offset(1, 1),
            color: AppColors.transparent,
          ),
        ],
      ),
      child: Slidable(
        key: ValueKey<int>(news.id),
        endActionPane: ActionPane(
          extentRatio: 0.3,
          dragDismissible: false,
          dismissible: DismissiblePane(
            onDismissed: () {},
          ),
          motion: const DrawerMotion(),
          children: <Widget>[
            SlidableAction(
              flex: 1,
              padding: EdgeInsets.all(20),
              onPressed: (BuildContext context) {
                c.newsFeedList.forEach((NewsFeedModel element) {
                  element.showReport.value = false;
                });
                news.showReport.value = !news.showReport.value;
              },
              icon: Icons.priority_high,
              autoClose: true,
              backgroundColor: AppColors.red,
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            InkWell(
              onTap: () async {
                if (news.showReport.value) {
                  news.showReport.value = false;
                } else {
                  c.dropInGetId(id: news.id);
                  customBottomSheet(
                    child: NewsFeedSheet(),
                  );
                }
                c.newsFeedList.forEach((NewsFeedModel element) {
                  element.showReport.value = false;
                });
              },
              child: Stack(
                children: <Widget>[
                  Card(
                    elevation: 5,
                    color: AppColors.listviewcolor,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 90,
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AppImages.asImage(
                                  UrlConst.dropinBaseUrl + news.image,
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
                                  imageUrl: UrlConst.otherMediaBase + news.icon,
                                ).paddingAll(5),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                news.title,
                                style: AppThemes
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                news.location,
                                style: context.textTheme.bodySmall,
                              ).paddingSymmetric(horizontal: 4),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                DateFormat("MMM dd'th', yyyy").format(
                                  news.createdAt!,
                                ),
                                style: context.textTheme.bodySmall,
                              ).paddingSymmetric(horizontal: 5),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(
                    () => Positioned.fill(
                      child: Visibility(
                        visible: news.showReport.value,
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5,
                              sigmaY: 5,
                            ),
                            child: AppButton(
                              title: 'Report & Hide!',
                              callback: () async {
                                dynamic reason =
                                    await Get.dialog(ReportDialog());
                                if (reason is String) {
                                  c.reportDropIn(
                                    id: news.id,
                                    reportReason: reason,
                                  );
                                }
                              },
                              height: 30,
                            ).paddingOnly(
                                left: 40, top: 20, right: 40, bottom: 10),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportDialog extends StatelessWidget {
  ReportDialog({super.key});

  // final NewsScreenController c = Get.find<NewsScreenController>();

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
      bgColor: AppColors.searchBgColor,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              IconButton(
                onPressed: Get.back,
                icon: Icon(Icons.close),
                color: Colors.black,
              )
            ],
            title: Text(
              'Report & Hide',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Divider(
            height: 0,
            color: Colors.black,
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 0,
              color: Colors.black,
            ),
            itemCount: AppConstants.reportReasons.length,
            itemBuilder: (BuildContext context, int index) {
              String reason = AppConstants.reportReasons[index];
              return ListTile(
                onTap: () {
                  Get.back(result: reason);
                },
                title: Text(
                  reason,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NewsFeedSheet extends StatelessWidget {
  const NewsFeedSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsScreenController>(
      builder: (NewsScreenController c) {
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
                        children: <Widget>[
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
                          ).paddingSymmetric(horizontal: 15),
                          Text(
                            DateFormat('MMM dd, yyyy')
                                .format(c.news.value.createdAt!),
                            style: AppThemes.lightTheme.textTheme.titleMedium!
                                .copyWith(
                              fontSize: 9.5,
                            ),
                          ).paddingSymmetric(horizontal: 15),
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
                      ).paddingOnly(right: 8);
                    },
                  ),
                ),
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
                    child: Text(c.news.value.description).paddingOnly(
                      top: 10,
                      right: 10,
                      left: 5,
                      bottom: 10,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AppElevatedButton(
                      height: 35,
                      width: 120,
                      callback: () {
                        logger.w(c.news.value.user!.id);
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
                        c.createChat(
                          c.news.value.user!.userName,
                        );
                      },
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
