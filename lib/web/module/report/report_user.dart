import 'package:dropin/src/models/report_model.dart';
import 'package:dropin/web/module/report/report_controller.dart';
import 'package:flutter/cupertino.dart';

import '../../../src/models/news_feed_model.dart';
import '../../../src/utils/widgets/app_images.dart';
import '../../../src/utils/widgets/custom_dialog.dart';
import '../../../src/utils/widgets/popup_widget.dart';
import '../../../src/utils/widgets/web_button.dart';
import '../../../src/utils/widgets/web_textfield.dart';
import '../../../src_exports.dart';

class ReportUser extends GetResponsiveView<ReportController> {
  ReportUser({super.key});

  final ReportController c = Get.put(ReportController());

  @override
  Widget desktop() {
    return Scaffold(
      body: GetBuilder<ReportController>(
        builder: (ReportController c) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Reports',
                style: AppThemes.lightTheme.textTheme.headlineMedium
                    ?.copyWith(color: AppColors.appBlackColor, fontSize: 32),
              ).paddingOnly(left: 10, bottom: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 900,
                        child: WebTextField(
                          width: 800,
                          color: AppColors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          hint: 'Search',
                          contentPadding: EdgeInsets.only(bottom: 5),
                          prefixIcon: IconButton(
                            highlightColor: AppColors.transparent,
                            splashColor: AppColors.transparent,
                            hoverColor: AppColors.transparent,
                            focusColor: AppColors.transparent,
                            icon: Icon(
                              Icons.search,
                              color: AppColors.grey,
                            ),
                            onPressed: () {},
                          ),
                          suffixIcon: IconButton(
                            highlightColor: AppColors.transparent,
                            splashColor: AppColors.transparent,
                            hoverColor: AppColors.transparent,
                            focusColor: AppColors.transparent,
                            onPressed: () {
                              c.onUpdate();
                              controller.onUpdate();
                              c.searchController.clear();
                            },
                            icon: const Icon(
                              CupertinoIcons.clear,
                              color: AppColors.grey,
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny(
                              RegExp(r'\s'),
                            ),
                          ],
                          onChanged: (String p0) async {
                            c.searchApi();
                          },
                        ).paddingSymmetric(horizontal: 30),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.greyColor,
                      backgroundColor: AppColors.greyColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.appBlackColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Sort',
                          style: AppThemes.lightTheme.textTheme.titleSmall
                              ?.copyWith(color: AppColors.appBlackColor),
                        ),
                        IconButton(
                          highlightColor: AppColors.transparent,
                          splashColor: AppColors.transparent,
                          hoverColor: AppColors.transparent,
                          focusColor: AppColors.transparent,
                          onPressed: () {
                            final RenderBox renderBox =
                                Get.context!.findRenderObject() as RenderBox;
                            final Offset offset =
                                renderBox.localToGlobal(Offset.zero);
                            logger.w(offset);
                            showMenu(
                              elevation: 0,
                              color: Colors.transparent,
                              constraints: const BoxConstraints(
                                maxWidth: double.infinity,
                              ),
                              context: Get.context!,
                              position:
                                  RelativeRect.fromLTRB(200, 200, 200, 200),
                              items: <PopupMenuWidget<Widget>>[
                                PopupMenuWidget<Widget>(
                                  height: 100,
                                  width: 150,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 100,
                                        width: 200,
                                      ),
                                      WebElevatedButton(
                                        callback: () {
                                          c.reportedUsers.clear();
                                          c.getReportedUserList(s_type: 1);
                                        },
                                        width: 100,
                                        height: 40,
                                        title: 'Newest',
                                      ),
                                      WebElevatedButton(
                                        callback: () {
                                          c.reportedUsers.clear();
                                          c.getReportedUserList(s_type: 2);
                                        },
                                        width: 100,
                                        height: 40,
                                        title: 'Oldest',
                                      ),
                                      WebElevatedButton(
                                        callback: () {
                                          c.reportedUsers.clear();
                                          c.getReportedUserList(s_type: 3);
                                        },
                                        width: 100,
                                        height: 40,
                                        title: 'Most Reported',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: AppColors.appBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ).paddingOnly(right: 50, left: 20),
                  SizedBox(
                    width: 150,
                  ),
                  WebElevatedButton(
                    callback: () {
                      c.createCSV(userList: <UserModel>[]);
                    },
                    title: 'Export',
                    width: 200,
                    height: 40,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  ).paddingOnly(right: 50),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: <int, TableColumnWidth>{
                  0: FixedColumnWidth(50),
                  1: FlexColumnWidth(2.5),
                  2: FlexColumnWidth(2.5),
                  3: FlexColumnWidth(2.5),
                  4: FlexColumnWidth(2.5),
                  5: FlexColumnWidth(2.5),
                },
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Checkbox(
                        value: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: AppColors.selectdeaweclr),
                        ),
                        onChanged: (bool? value) {},
                      ),
                      Text(
                        'Owner First and Last Name ',
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.admingreycolor,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Email Address',
                        textAlign: TextAlign.center,
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.admingreycolor,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Dropin Reported',
                        textAlign: TextAlign.center,
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.admingreycolor,
                          fontSize: 14,
                        ),
                      ).paddingSymmetric(horizontal: 8),
                      /*Text(
                        'Chat Reported',
                        textAlign: TextAlign.center,
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.admingreycolor,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Total Account Reports',
                        textAlign: TextAlign.center,
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.admingreycolor,
                          fontSize: 14,
                        ),
                      ),*/
                      SizedBox(),
                    ],
                  ),
                ],
              ),
              Divider(height: 20),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: c.reportedUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ReportModel userList = c.reportedUsers[index];
                    return Obx(
                      () => DecoratedBox(
                        decoration: BoxDecoration(
                          color: userList.isSelected.value
                              ? Color(0xFFF0F0F5)
                              : AppColors.appWhiteColor,
                          borderRadius: userList.isSelected.value
                              ? BorderRadius.circular(10)
                              : BorderRadius.zero,
                        ),
                        child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: <int, TableColumnWidth>{
                            0: FixedColumnWidth(50),
                            1: FlexColumnWidth(2.5),
                            2: FlexColumnWidth(2.5),
                            3: FlexColumnWidth(2.5),
                            4: FlexColumnWidth(2.5),
                            5: FlexColumnWidth(2.5),
                          },
                          children: <TableRow>[
                            TableRow(
                              children: <Widget>[
                                Obx(() {
                                  return Checkbox(
                                    checkColor: AppColors.appWhiteColor,
                                    activeColor: AppColors.appButtonColor,
                                    side: BorderSide(
                                      color: AppColors.black,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                      c.getColor,
                                    ),
                                    value: userList.isSelected.value,
                                    onChanged: (bool? value) {
                                      FocusScope.of(Get.context!).unfocus();
                                      userList.isSelected.value = value!;
                                    },
                                  );
                                }),
                                Text(
                                  userList.fullName,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.admingreycolor,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  userList.email,
                                  textAlign: TextAlign.center,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.admingreycolor,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${userList.reportCount}',
                                  textAlign: TextAlign.center,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.admingreycolor,
                                    fontSize: 14,
                                  ),
                                ).paddingSymmetric(horizontal: 8),
                                IconButton(
                                  onPressed: () {
                                    c.getUserById(id: userList.id);
                                    Dialog();
                                  },
                                  icon: Icon(Icons.remove_red_eye_outlined),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  c.numberOfPageForReport.round(),
                  (int index) => Center(
                    child: Obx(
                      () => InkWell(
                        highlightColor: AppColors.transparent,
                        splashColor: AppColors.transparent,
                        hoverColor: AppColors.transparent,
                        focusColor: AppColors.transparent,
                        onTap: () {
                          c.isReportIndex == index;
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c.isReportIndex.value == index
                                ? AppColors.selectdeaweclr
                                : AppColors.appWhiteColor,
                            border: Border.all(
                              color: AppColors.appBlackColor,
                            ),
                          ),
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: c.isReportIndex.value == index
                                  ? AppColors.appWhiteColor
                                  : AppColors.appBlackColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ).paddingOnly(bottom: 10),
            ],
          );
        },
      ),
    );
  }

  Future<void> Dialog() {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) => DialogContainer(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.background,
          ),
          child: GetBuilder<ReportController>(
            builder: (ReportController c) {
              if (c.lodingMore) {
                return LoaderView();
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 290,
                            child: Stack(
                              children: <Widget>[
                                SizedBox(
                                  height: 220,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        c.reportedUser.value.coverPhotos.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        width: 330,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          child: AppImages.asImage(
                                            c.reportedUser.value
                                                .coverPhotos[index].url,
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
                                  bottom: 1,
                                  left: 0,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.white,
                                            child: CircleAvatar(
                                              radius: 42,
                                              backgroundImage:
                                                  AppImages.asProvider(
                                                c.reportedUser.value.imageUrl,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ).paddingOnly(
                                        left: 8,
                                      ),
                                      Text(
                                        c.reportedUser.value.userName,
                                        style: AppThemes
                                            .lightTheme.textTheme.headlineLarge
                                            ?.copyWith(
                                          color: AppColors.appWhiteColor,
                                          fontSize: 15,
                                        ),
                                      ).paddingSymmetric(
                                        horizontal: 5,
                                        vertical: 15,
                                      ),
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
                                            // c.reportedUser.value.is_like;

                                            // c.userLike(user: c.users.value);
                                          },
                                          icon: AppAssets.asImage(
                                            c.reportedUser.value.is_like
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
                                            c.reportedUser.value.like_count
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            style: AppThemes.lightTheme
                                                .textTheme.headlineMedium
                                                ?.copyWith(
                                              color: AppColors.appWhiteColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                          AppAssets.asImage(
                                            AppAssets.profile,
                                            height: 15,
                                            width: 15,
                                          ),
                                        ],
                                      ),
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
                                    color: const Color(0xFFEBEBEB26)
                                        .withOpacity(0.05),
                                  ),
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    c.reportedUser.value.bio,
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
                                            backgroundImage:
                                                AppAssets.asProvider(
                                              '${AppAssets.countryIcon}${c.reportedUser.value.country.split(' ').last.replaceAll('(', '').replaceAll(')', '').toLowerCase()}.png',
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
                                                      c.reportedUser.value
                                                          .country,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppThemes
                                                          .lightTheme
                                                          .textTheme
                                                          .headlineMedium
                                                          ?.copyWith(
                                                        fontSize: 11,
                                                        color: AppColors
                                                            .appWhiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  c.reportedUser.value
                                                      .skillLevel,
                                                  style: AppThemes.lightTheme
                                                      .textTheme.headlineMedium
                                                      ?.copyWith(
                                                    fontSize: 9,
                                                    color: AppColors
                                                        .appWhiteColor
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                                Text(
                                                  'Age ${app.user.age}',
                                                  style: AppThemes.lightTheme
                                                      .textTheme.headlineMedium
                                                      ?.copyWith(
                                                    fontSize: 9,
                                                    color: AppColors
                                                        .appWhiteColor
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).paddingOnly(bottom: 5, left: 8),
                                  ],
                                ),
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 10),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Current Dropins',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 15,
                                color: AppColors.appWhiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ).paddingSymmetric(horizontal: 20, vertical: 10),
                          ListView.builder(
                            padding: const EdgeInsets.only(bottom: 15),
                            itemCount: c.reportedUser.value.dropIns.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              final NewsFeedModel user =
                                  c.reportedUser.value.dropIns[index];
                              return InkWell(
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
                                                      imageUrl: UrlConst
                                                              .otherMediaBase +
                                                          user.icon,
                                                    ).paddingAll(5),
                                                  ),
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
                                                  style: context
                                                      .textTheme.bodySmall,
                                                ).paddingSymmetric(
                                                  horizontal: 4,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ),
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
                    ],
                  ),
                );
              }
            },
          ),
        ),
        maxHei: 600,
        minHei: 600,
        maxWid: 350,
        minWid: 350,
      ),
    );
  }
}
