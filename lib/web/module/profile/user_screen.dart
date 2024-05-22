import 'package:dropin/src/models/news_feed_model.dart';
import 'package:dropin/src/utils/widgets/app_images.dart';
import 'package:dropin/src/utils/widgets/web_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
// import 'package:number_paginator/number_paginator.dart';

import '../../../src/module/user_controller.dart';

import '../../../src/utils/widgets/custom_dialog.dart';
import '../../../src/utils/widgets/popup_widget.dart';
import '../../../src/utils/widgets/web_button.dart';
import '../../../src_exports.dart';
import 'comon_controller.dart';

class UserScreen extends GetResponsiveView {
  final ProfileCtrl c = Get.put(ProfileCtrl());
  final UserController controller = Get.put(UserController());

  @override
  Widget desktop() {
    logger.w(c.user.length);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Users',
            style: AppThemes.lightTheme.textTheme.headlineMedium
                ?.copyWith(color: AppColors.appBlackColor, fontSize: 32),
          ).paddingOnly(left: 10, bottom: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 700,
                    child: WebTextField(
                      width: 600,
                      textController: c.searchController,
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
                          CupertinoIcons.search,
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
                          c.searchUserList.clear();
                        },
                        icon: const Icon(
                          CupertinoIcons.clear,
                          color: AppColors.grey,
                        ),
                      ),
                      inputFormatters: [
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.appWhiteColor,
                  backgroundColor: AppColors.appWhiteColor,
                  elevation: 10,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.appBlackColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  c.createCSV(
                    userList: c.user(),
                    isUSER: true,
                    businessList: [],
                  );
                },
                child: Text(
                  'Export',
                  style: AppThemes.lightTheme.textTheme.titleSmall
                      ?.copyWith(color: AppColors.appBlackColor),
                ),
              ).paddingOnly(right: 50),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey.shade100,
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Row(
                  children: [
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
                        showMenu(
                          elevation: 0,
                          color: Colors.transparent,
                          constraints: const BoxConstraints(
                            maxWidth: double.infinity,
                          ),
                          context: Get.context!,
                          position: RelativeRect.fromLTRB(200, 200, 200, 200),
                          items: <PopupMenuWidget>[
                            PopupMenuWidget(
                              height: 100,
                              width: 200,
                              child: listView(),
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
              ).paddingOnly(right: 60, left: 25),
              SizedBox(
                width: 100,
              ),
              Container(
                width: 230,
                height: 40,
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                margin: EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(2, 4),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: AppColors.appBlackColor, width: 1.5),
                ),
                child: Obx(
                  () => Text(
                    c.selected.value,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.appBlackColor,
                      height: 19 / 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: FixedColumnWidth(50),
              1: FixedColumnWidth(30),
              2: FlexColumnWidth(2.5),
              3: FlexColumnWidth(2.5),
              4: FlexColumnWidth(2.5),
              5: FlexColumnWidth(2.5),
              6: FlexColumnWidth(2.5),
              7: FlexColumnWidth(1.5),
              8: FlexColumnWidth(1.5),
              9: FlexColumnWidth(1.5),
              10: FlexColumnWidth(1.5),
              11: FlexColumnWidth(1.5),
            },
            children: [
              TableRow(
                children: [
                  Obx(
                    () => Checkbox(
                      value: c.showvalue.value,
                      checkColor: AppColors.appWhiteColor,
                      activeColor: AppColors.appButtonColor,
                      side: BorderSide(
                        color: AppColors.black,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      fillColor: MaterialStateProperty.resolveWith(c.getColor),
                      onChanged: (bool? value) {
                        c.showvalue.value = value!;
                      },
                    ),
                  ),
                  SizedBox(),
                  Text(
                    'First & Last Name ',
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Username',
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Email Address',
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Country of Origin',
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Date of Birth',
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Skill Level',
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Activity',
                    textAlign: TextAlign.center,
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Liked',
                    textAlign: TextAlign.center,
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Reported',
                    textAlign: TextAlign.center,
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ],
          ),
          Divider(height: 20),
          Expanded(
            child: GetBuilder<ProfileCtrl>(
              builder: (ProfileCtrl c) {
                if (c.isLoading || c.lodingMore) {
                  return SizedBox(
                    height: Get.height * 0.61,
                    child: LoaderView(),
                  );
                } else if (c.searchUserList.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: c.searchUserList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final UserModel userList = c.searchUserList[index];
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
                            columnWidths: {
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(30),
                              2: FlexColumnWidth(2.5),
                              3: FlexColumnWidth(2.5),
                              4: FlexColumnWidth(2.5),
                              5: FlexColumnWidth(2.5),
                              6: FlexColumnWidth(2.5),
                              7: FlexColumnWidth(1.5),
                              8: FlexColumnWidth(1.5),
                              9: FlexColumnWidth(1.5),
                              10: FlexColumnWidth(1.5),
                              11: FlexColumnWidth(1.5),
                            },
                            children: [
                              TableRow(
                                children: [
                                  Obx(
                                    () {
                                      return Checkbox(
                                        checkColor: AppColors.appWhiteColor,
                                        activeColor: AppColors.appButtonColor,
                                        side: BorderSide(
                                          color: AppColors.black,
                                          width: 2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                          c.getColor,
                                        ),
                                        value: userList.isSelected.value ||
                                            c.showvalue.value,
                                        onChanged: (bool? value) {
                                          FocusScope.of(Get.context!).unfocus();
                                          userList.isSelected.value = value!;
                                        },
                                      );
                                    },
                                  ),
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundImage:
                                        AppImages.asProvider(userList.imageUrl),
                                  ),
                                  Text(
                                    '${userList.firstName} ${userList.lastName}',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.appBlackColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    userList.userName,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.appBlackColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    userList.email,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    userList.country,
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(userList.dob!),
                                    style: AppThemes
                                        .lightTheme.textTheme.titleMedium!
                                        .copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    userList.skillLevel,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    userList.isActive.toString(),
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    userList.like_count.toString(),
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    userList.report_count.toString(),
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  IconButton(
                                    highlightColor: AppColors.transparent,
                                    splashColor: AppColors.transparent,
                                    hoverColor: AppColors.transparent,
                                    focusColor: AppColors.transparent,
                                    onPressed: () {
                                      final RenderBox renderBox = Get.context!
                                          .findRenderObject() as RenderBox;
                                      final Offset offset =
                                          renderBox.localToGlobal(Offset.zero);
                                      showMenu(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        constraints: const BoxConstraints(
                                          maxWidth: double.infinity,
                                        ),
                                        context: Get.context!,
                                        position: RelativeRect.fromLTRB(
                                          500,
                                          320,
                                          offset.dx - Get.width,
                                          offset.dy,
                                        ),
                                        // position: RelativeRect.fromLTRB(
                                        //   500,
                                        //   320,
                                        //   60,
                                        //   320,
                                        // ),
                                        // position: RelativeRect.fromLTRB(left, top, right, bottom),
                                        items: <PopupMenuWidget>[
                                          PopupMenuWidget(
                                            height: 100,
                                            width: 200,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Obx(
                                                  () => WebElevatedButton(
                                                    callback: () {
                                                      c.isShow(true);

                                                      showDialog(
                                                        context: Get.context!,
                                                        builder: (
                                                          BuildContext context,
                                                        ) =>
                                                            DialogContainer(
                                                          body: DecoratedBox(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .appWhiteColor,
                                                            ),
                                                            child: Obx(
                                                              () => Column(
                                                                children: <Widget>[
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child:
                                                                        IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .close,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  AppAssets
                                                                      .asImage(
                                                                    AppAssets
                                                                        .deletaccount,
                                                                    height: 60,
                                                                  ),
                                                                  Text(
                                                                    c.isShow.value
                                                                        ? 'Are you sure want to unblock this user?'
                                                                        : 'Are you sure want to block this user?',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color:
                                                                          Color(
                                                                        0xff4f4f4f,
                                                                      ),
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ).paddingOnly(
                                                                    top: 10,
                                                                    bottom: 10,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      AppElevatedButton(
                                                                        color: AppColors
                                                                            .redcolor,
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            70,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                        callback:
                                                                            () {
                                                                          c.profileSetupsBlockEmailAndUser(
                                                                            id: userList.id,
                                                                          );
                                                                          // c.isShow.value
                                                                          //     ? c.profileSetupsBlockEmailAndUser(
                                                                          //         id: userList.id,
                                                                          //         isBlock: false,
                                                                          //       )
                                                                          //     : c.profileSetupsBlockEmailAndUser(id: userList.id);
                                                                        },
                                                                        title:
                                                                            'Yes, I’m sure',
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      AppElevatedButton(
                                                                        color: AppColors
                                                                            .greyColor,
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            70,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        callback:
                                                                            () {
                                                                          Get.back();
                                                                        },
                                                                        title:
                                                                            'No, cancel',
                                                                        style: AppThemes
                                                                            .lightTheme
                                                                            .textTheme
                                                                            .headlineMedium
                                                                            ?.copyWith(
                                                                          color:
                                                                              AppColors.appBlackColor,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ).paddingSymmetric(
                                                                    horizontal:
                                                                        10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          maxHei: 250,
                                                          minHei: 250,
                                                          maxWid: 330,
                                                          minWid: 330,
                                                        ),
                                                      );
                                                      // c.isShow(false);
                                                    },
                                                    width: 100,
                                                    height: 40,
                                                    title: c.isShow.value
                                                        ? 'Unblock Email'
                                                        : 'Block Email',
                                                  ),
                                                ),
                                                WebElevatedButton(
                                                  callback: () {
                                                    logger.w(userList.id);
                                                    c.getUserById(
                                                      id: userList.id,
                                                    );
                                                    Dialog();
                                                  },
                                                  width: 100,
                                                  height: 40,
                                                  title: 'View Profile',
                                                ),
                                                WebElevatedButton(
                                                  callback: () {
                                                    showDialog(
                                                      context: Get.context!,
                                                      builder: (
                                                        BuildContext context,
                                                      ) =>
                                                          DialogContainer(
                                                        body: DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .appWhiteColor,
                                                          ),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.close,
                                                                  ),
                                                                ),
                                                              ),
                                                              AppAssets.asImage(
                                                                AppAssets
                                                                    .deletaccount,
                                                                height: 60,
                                                              ),
                                                              Text(
                                                                'Are you sure want to delete this user?',
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Futura',
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                    0xff4f4f4f,
                                                                  ),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ).paddingOnly(
                                                                top: 10,
                                                                bottom: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  AppElevatedButton(
                                                                    color: AppColors
                                                                        .redcolor,
                                                                    height: 50,
                                                                    width: 70,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    callback:
                                                                        () {
                                                                      c.deleteUser(
                                                                        id: userList
                                                                            .id,
                                                                      );
                                                                      c.user
                                                                          .removeAt(
                                                                        index,
                                                                      );
                                                                    },
                                                                    title:
                                                                        'Yes, I’m sure',
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  AppElevatedButton(
                                                                    color: AppColors
                                                                        .greyColor,
                                                                    height: 50,
                                                                    width: 70,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    callback:
                                                                        () {
                                                                      Get.back();
                                                                    },
                                                                    title:
                                                                        'No, cancel',
                                                                    style: AppThemes
                                                                        .lightTheme
                                                                        .textTheme
                                                                        .headlineMedium
                                                                        ?.copyWith(
                                                                      color: AppColors
                                                                          .appBlackColor,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ).paddingSymmetric(
                                                                horizontal: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        maxHei: 250,
                                                        minHei: 250,
                                                        maxWid: 330,
                                                        minWid: 330,
                                                      ),
                                                    );
                                                  },
                                                  width: 100,
                                                  height: 40,
                                                  title: 'Delete User',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    icon: Icon(
                                      Icons.more_vert_outlined,
                                      color: AppColors.admingreycolor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).paddingOnly(bottom: 5, left: 5, right: 5),
                      );
                    },
                  );
                } else if (c.searchController.text.isNotEmpty &&
                    c.searchUserList.isEmpty) {
                  return Center(child: Text("No matches found"));
                }
                //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: c.user.length,
                    itemBuilder: (BuildContext context, int index) {
                      final UserModel userList = c.user[index];
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
                            columnWidths: {
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(30),
                              2: FlexColumnWidth(2.5),
                              3: FlexColumnWidth(2.5),
                              4: FlexColumnWidth(2.5),
                              5: FlexColumnWidth(2.5),
                              6: FlexColumnWidth(2.5),
                              7: FlexColumnWidth(1.5),
                              8: FlexColumnWidth(1.5),
                              9: FlexColumnWidth(1.5),
                              10: FlexColumnWidth(1.5),
                              11: FlexColumnWidth(1.5),
                            },
                            children: [
                              TableRow(
                                children: [
                                  Obx(
                                    () {
                                      return Checkbox(
                                        checkColor: AppColors.appWhiteColor,
                                        activeColor: AppColors.appButtonColor,
                                        side: BorderSide(
                                          color: AppColors.black,
                                          width: 2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                          c.getColor,
                                        ),
                                        value: userList.isSelected.value ||
                                            c.showvalue.value,
                                        onChanged: (bool? value) {
                                          FocusScope.of(Get.context!).unfocus();
                                          userList.isSelected.value = value!;
                                        },
                                      );
                                    },
                                  ),
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundImage:
                                        AppImages.asProvider(userList.imageUrl),
                                  ),
                                  Text(
                                    '${userList.firstName} ${userList.lastName}',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.appBlackColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    userList.userName,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.appBlackColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    userList.email,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    userList.country,
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(userList.dob!),
                                    style: AppThemes
                                        .lightTheme.textTheme.titleMedium!
                                        .copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    userList.skillLevel,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    userList.isActive.toString(),
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    userList.like_count.toString(),
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    userList.report_count.toString(),
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  IconButton(
                                    highlightColor: AppColors.transparent,
                                    splashColor: AppColors.transparent,
                                    hoverColor: AppColors.transparent,
                                    focusColor: AppColors.transparent,
                                    onPressed: () {
                                      final RenderBox renderBox = Get.context!
                                          .findRenderObject() as RenderBox;
                                      final Offset offset =
                                          renderBox.localToGlobal(Offset.zero);
                                      showMenu(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        constraints: const BoxConstraints(
                                          maxWidth: double.infinity,
                                        ),
                                        context: Get.context!,
                                        position: RelativeRect.fromLTRB(
                                          500,
                                          320,
                                          offset.dx - Get.width,
                                          offset.dy,
                                        ),
                                        // position: RelativeRect.fromLTRB(
                                        //   500,
                                        //   320,
                                        //   60,
                                        //   320,
                                        // ),
                                        // position: RelativeRect.fromLTRB(left, top, right, bottom),
                                        items: <PopupMenuWidget>[
                                          PopupMenuWidget(
                                            height: 100,
                                            width: 200,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Obx(
                                                  () => WebElevatedButton(
                                                    callback: () {
                                                      c.isShow(true);

                                                      showDialog(
                                                        context: Get.context!,
                                                        builder: (
                                                          BuildContext context,
                                                        ) =>
                                                            DialogContainer(
                                                          body: DecoratedBox(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .appWhiteColor,
                                                            ),
                                                            child: Obx(
                                                              () => Column(
                                                                children: <Widget>[
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child:
                                                                        IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .close,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  AppAssets
                                                                      .asImage(
                                                                    AppAssets
                                                                        .deletaccount,
                                                                    height: 60,
                                                                  ),
                                                                  Text(
                                                                    c.isShow.value
                                                                        ? 'Are you sure want to unblock this user?'
                                                                        : 'Are you sure want to block this user?',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color:
                                                                          Color(
                                                                        0xff4f4f4f,
                                                                      ),
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ).paddingOnly(
                                                                    top: 10,
                                                                    bottom: 10,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      AppElevatedButton(
                                                                        color: AppColors
                                                                            .redcolor,
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            70,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                        callback:
                                                                            () {
                                                                          c.profileSetupsBlockEmailAndUser(
                                                                            id: userList.id,
                                                                          );
                                                                        },
                                                                        title:
                                                                            'Yes, I’m sure',
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      AppElevatedButton(
                                                                        color: AppColors
                                                                            .greyColor,
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            70,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        callback:
                                                                            () {
                                                                          Get.back();
                                                                        },
                                                                        title:
                                                                            'No, cancel',
                                                                        style: AppThemes
                                                                            .lightTheme
                                                                            .textTheme
                                                                            .headlineMedium
                                                                            ?.copyWith(
                                                                          color:
                                                                              AppColors.appBlackColor,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ).paddingSymmetric(
                                                                    horizontal:
                                                                        10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          maxHei: 250,
                                                          minHei: 250,
                                                          maxWid: 330,
                                                          minWid: 330,
                                                        ),
                                                      );
                                                      // c.isShow(false);
                                                    },
                                                    width: 100,
                                                    height: 40,
                                                    title: c.isShow.value
                                                        ? 'Unblock Email'
                                                        : 'Block Email',
                                                  ),
                                                ),
                                                WebElevatedButton(
                                                  callback: () {
                                                    logger.w(userList.id);
                                                    c.getUserById(
                                                      id: userList.id,
                                                    );
                                                    Dialog();
                                                  },
                                                  width: 100,
                                                  height: 40,
                                                  title: 'View Profile',
                                                ),
                                                WebElevatedButton(
                                                  callback: () {
                                                    showDialog(
                                                      context: Get.context!,
                                                      builder: (
                                                        BuildContext context,
                                                      ) =>
                                                          DialogContainer(
                                                        body: DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .appWhiteColor,
                                                          ),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.close,
                                                                  ),
                                                                ),
                                                              ),
                                                              AppAssets.asImage(
                                                                AppAssets
                                                                    .deletaccount,
                                                                height: 60,
                                                              ),
                                                              Text(
                                                                'Are you sure want to delete this user?',
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Futura',
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                    0xff4f4f4f,
                                                                  ),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ).paddingOnly(
                                                                top: 10,
                                                                bottom: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  AppElevatedButton(
                                                                    color: AppColors
                                                                        .redcolor,
                                                                    height: 50,
                                                                    width: 70,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    callback:
                                                                        () {
                                                                          c.user
                                                                              .removeAt(
                                                                            index,
                                                                          );
                                                                      c.deleteFirebaseUser(
                                                                          fId: userList
                                                                              .fId,
                                                                          userId:
                                                                              userList.id);
                                                                      logger.w(
                                                                          'DELETE USER');
                                                                    },
                                                                    title:
                                                                        'Yes, I’m sure',
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  AppElevatedButton(
                                                                    color: AppColors
                                                                        .greyColor,
                                                                    height: 50,
                                                                    width: 70,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    callback:
                                                                        () {
                                                                      Get.back();
                                                                    },
                                                                    title:
                                                                        'No, cancel',
                                                                    style: AppThemes
                                                                        .lightTheme
                                                                        .textTheme
                                                                        .headlineMedium
                                                                        ?.copyWith(
                                                                      color: AppColors
                                                                          .appBlackColor,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ).paddingSymmetric(
                                                                horizontal: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        maxHei: 250,
                                                        minHei: 250,
                                                        maxWid: 330,
                                                        minWid: 330,
                                                      ),
                                                    );
                                                  },
                                                  width: 100,
                                                  height: 40,
                                                  title: 'Delete User',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    icon: Icon(
                                      Icons.more_vert_outlined,
                                      color: AppColors.admingreycolor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).paddingOnly(bottom: 5, left: 5, right: 5),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              c.numberOfPageForUser.round(),
              (int index) => Center(
                child: Obx(
                  () => InkWell(
                    onTap: () {
                      c.getAllUsers(paginationCount: index * 10);

                      c.isUserIndex.value = index;
                      logger.w(c.isUserIndex.value);
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c.isUserIndex.value == index
                            ? AppColors.selectdeaweclr
                            : AppColors.appWhiteColor,
                        border: Border.all(
                          color: AppColors.appBlackColor,
                        ),
                      ),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: c.isUserIndex.value == index
                              ? AppColors.appWhiteColor
                              : AppColors.appBlackColor,
                        ),
                        textAlign: TextAlign.center,
                      ).paddingSymmetric(vertical: 0),
                    ),
                  ),
                ),
              ),
            ),
          ).paddingOnly(bottom: 10),
        ],
      ),
    );
  }

  Widget listView() {
    return SizedBox(
      height: 350,
      width: 230,
      child: ListView.builder(
        itemCount: c.tileModelUser.length,
        padding: EdgeInsets.only(top: 40, left: 30),
        itemBuilder: (BuildContext context, int index) {
          final TileModel title = c.tileModelUser[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: title.callback,
                child: Container(
                  width: 230,
                  height: 40,
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(4, 4),
                      ),
                    ],
                    border:
                        Border.all(color: AppColors.appBlackColor, width: 1.5),
                  ),
                  child: Text(
                    '${title.title}',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.appBlackColor,
                      height: 19 / 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
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
          child: GetBuilder<ProfileCtrl>(
            builder: (ProfileCtrl c) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 290,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 220,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: c.users.value.coverPhotos.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: 330,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: AppImages.asImage(
                                          c.users.value.coverPhotos[index].url,
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
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 42,
                                            backgroundImage:
                                                AppImages.asProvider(
                                              c.users.value.imageUrl,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ).paddingOnly(
                                      left: 8,
                                    ),
                                    Text(
                                      c.users.value.userName,
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
                                  children: [
                                    Obx(
                                      () => IconButton(
                                        onPressed: () {
                                          c.users.value.is_like;

                                          c.userLike(user: c.users.value);
                                        },
                                        icon: AppAssets.asImage(
                                          c.users.value.is_like
                                              ? AppAssets.star1
                                              : AppAssets.star,
                                          height: 35,
                                          width: 35,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          c.users.value.like_count.toString(),
                                          textAlign: TextAlign.end,
                                          style: AppThemes.lightTheme.textTheme
                                              .headlineMedium
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
                          children: [
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
                                  c.users.value.bio,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 13,
                                          backgroundImage: AppAssets.asProvider(
                                            '${AppAssets.countryIcon}${c.users.value.country.split(' ').last.replaceAll('(', '').replaceAll(')', '').toLowerCase()}.png',
                                          ),
                                        ).paddingOnly(right: 10),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: Get.width * 0.22,
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Text(
                                                    c.users.value.country,
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
                                                c.users.value.skillLevel,
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
                          itemCount: c.users.value.dropIns.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final NewsFeedModel user =
                                c.users.value.dropIns[index];
                            return InkWell(
                              child: Stack(
                                children: [
                                  Card(
                                    color: AppColors.listviewcolor,
                                    elevation: 5,
                                    child: Row(
                                      children: [
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
                                            children: [
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
