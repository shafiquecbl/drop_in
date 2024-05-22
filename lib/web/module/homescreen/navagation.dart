import 'package:animate_do/animate_do.dart';
import 'package:dropin/src_exports.dart';
import 'package:dropin/web/module/report/report_chat.dart';
import 'package:dropin/web/module/report/report_dropin.dart';
import 'package:dropin/web/module/report/report_user.dart';
import 'package:flutter/cupertino.dart';

import '../billing/billing_screen.dart';
import '../general/general_screen.dart';
import '../profile/bussiness_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/statistic_screen.dart';
import '../profile/user_screen.dart';
import '../report/report_screen.dart';
import '../settings/settings_screen.dart';
import 'homescreen_controller.dart';

class NavigationScreen extends GetResponsiveView<AdminController> {
  NavigationScreen({Key? key}) : super(key: key);
  final AdminController c = Get.put(AdminController());

  @override
  Widget desktop() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appWhiteColor,
        elevation: 0,
        toolbarHeight: 80,
        leading: Row(
          children: <Widget>[
            SizedBox(
              width: 30,
            ),
            CircleAvatar(
              backgroundColor: AppColors.appButtonColor,
              radius: 35,
              child: CircleAvatar(
                backgroundColor: AppColors.appBlackColor,
                radius: 28,
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Text(
              'Zak S.',
              style: AppThemes.lightTheme.textTheme.headlineMedium
                  ?.copyWith(fontSize: 20),
            ),
            SizedBox(
              width: 30,
            ),
            IconButton(
              splashColor: AppColors.transparent,
              hoverColor: AppColors.transparent,
              focusColor: AppColors.transparent,
              highlightColor: AppColors.transparent,
              onPressed: () {},
              icon: Icon(
                Icons.arrow_drop_down_outlined,
                size: 30,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        leadingWidth: 270,
        title: TextField(
          controller: c.searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(CupertinoIcons.search),
            hintText: 'Quick search',
            suffixIcon: IconButton(
              highlightColor: AppColors.transparent,
              splashColor: AppColors.transparent,
              hoverColor: AppColors.transparent,
              focusColor: AppColors.transparent,
              icon: Icon(
                CupertinoIcons.clear,
                color: AppColors.grey,
              ),
              onPressed: () {},
            ),
            border: InputBorder.none,
          ),
        ),
      ),
      backgroundColor: AppColors.drawerColor,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      AppAssets.dropIn,
                      width: 50,
                      height: 50,
                    ),
                    Text(
                      'DropIn',
                      style: AppThemes.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: AppColors.appBlackColor,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ).paddingOnly(top: 20),
                SizedBox(
                  height: 30,
                ),
                ItemsWidget(
                  title: 'General',
                  img: AppAssets.general,
                  page: NavigationEnum.General,
                ),
                ItemsWidget(
                  title: 'Settings',
                  img: AppAssets.settings,
                  page: NavigationEnum.Settings,
                  page2: NavigationEnum.ChangePassword,
                ),
                ItemsWidget(
                  title: 'Profiles',
                  callback: () {
                    logger.i('message');
                    c.isShow.value = !c.isShow();
                    c.selecteSubmanu(0);
                    c.currentPage(NavigationEnum.Statistic);
                  },
                  img: AppAssets.profileUser,
                  page: NavigationEnum.Profiles,
                  page2: NavigationEnum.Statistic,
                ),
                Obx(
                  () => c.isShow.value
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              hoverColor:
                                  AppColors.selectdeaweclr.withOpacity(0.5),
                              onTap: () {
                                c.selecteSubmanu(0);
                                c.currentPage(NavigationEnum.Statistic);
                              },
                              onHover: (bool value) {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: c.selecteSubmanu() == 0
                                      ? AppColors.selectdeaweclr
                                          .withOpacity(0.5)
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 50,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    'Statistic',
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.appBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              hoverColor:
                                  AppColors.selectdeaweclr.withOpacity(0.5),
                              onTap: () {
                                c.selecteSubmanu(1);
                                c.currentPage(NavigationEnum.Users);
                              },
                              onHover: (bool value) {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: c.selecteSubmanu() == 1
                                      ? AppColors.selectdeaweclr
                                          .withOpacity(0.5)
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 50,
                                width: 100,
                                child: Text(
                                  'Users',
                                  textAlign: TextAlign.center,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.appBlackColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              hoverColor:
                                  AppColors.selectdeaweclr.withOpacity(0.5),
                              onTap: () {
                                c.selecteSubmanu(2);
                                c.currentPage(NavigationEnum.Businesses);
                              },
                              onHover: (bool value) {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: c.selecteSubmanu() == 2
                                      ? AppColors.selectdeaweclr
                                          .withOpacity(0.5)
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 50,
                                width: 110,
                                child: Text(
                                  'Businesses',
                                  textAlign: TextAlign.center,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.appBlackColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                ),
                SizedBox(
                  height: 10,
                ),
                ItemsWidget(
                  title: 'Billing',
                  img: AppAssets.billing,
                  page: NavigationEnum.Billing,
                ),
                ItemsWidget(
                  title: 'Reports',
                  img: AppAssets.report,
                  page: NavigationEnum.Reports,
                  callback: () {
                    c.isShowForReport.value = !c.isShowForReport();
                    c.selecteSubmanuForReport(0);
                    c.currentPage(NavigationEnum.ReportUser);
                  },
                ),
                Obx(
                  () => c.isShowForReport.value
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              hoverColor:
                                  AppColors.selectdeaweclr.withOpacity(0.5),
                              onTap: () {
                                c.selecteSubmanuForReport(0);
                                c.currentPage(NavigationEnum.ReportUser);
                              },
                              onHover: (bool value) {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: c.selecteSubmanuForReport() == 0
                                      ? AppColors.selectdeaweclr
                                          .withOpacity(0.5)
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 50,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    'User',
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.appBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              hoverColor:
                                  AppColors.selectdeaweclr.withOpacity(0.5),
                              onTap: () {
                                c.selecteSubmanuForReport(1);
                                c.currentPage(NavigationEnum.ReportDropIn);
                              },
                              onHover: (bool value) {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: c.selecteSubmanuForReport() == 1
                                      ? AppColors.selectdeaweclr
                                          .withOpacity(0.5)
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 50,
                                width: 100,
                                child: Text(
                                  'DropIn',
                                  textAlign: TextAlign.center,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.appBlackColor,
                                  ),
                                ),
                              ),
                            ),
                            /*SizedBox(
                              height: 10,
                            ),*/
                            /*InkWell(
                              borderRadius: BorderRadius.circular(10),
                              hoverColor:
                                  AppColors.selectdeaweclr.withOpacity(0.5),
                              onTap: () {
                                c.selecteSubmanuForReport(2);
                                c.currentPage(NavigationEnum.ReportChat);
                              },
                              onHover: (bool value) {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: c.selecteSubmanuForReport() == 2
                                      ? AppColors.selectdeaweclr
                                          .withOpacity(0.5)
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 50,
                                width: 110,
                                child: Text(
                                  'Chat',
                                  textAlign: TextAlign.center,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.appBlackColor,
                                  ),
                                ),
                              ),
                            ),*/
                          ],
                        )
                      : SizedBox(),
                ),
                SizedBox(height: Get.height * 0.20),
                ItemsWidget(
                  title: 'Sign Out',
                  img: AppAssets.signOut,
                  page: NavigationEnum.SignOut,
                ),
              ],
            ),
          ),
          Expanded(
            child: MainPage(),
          ),
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final AdminController c = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (c.currentPage()) {
        case NavigationEnum.General:
          return GeneralScreen();
        case NavigationEnum.Settings:
          return SettingsScreen();
        case NavigationEnum.ChangePassword:
          return ChangePassword();
        case NavigationEnum.ForgetPassword:
          return ForgetPassword();
        case NavigationEnum.Profiles:
          return ProfileScreenWeb();
        case NavigationEnum.Statistic:
          return StatisticScreen();
        case NavigationEnum.Users:
          return UserScreen();
        case NavigationEnum.Businesses:
          return BussinessScreen();
        case NavigationEnum.Billing:
          return BillingScreen();
        case NavigationEnum.Reports:
          return ReportScreen();
        case NavigationEnum.ReportUser:
          return ReportUser();
        case NavigationEnum.ReportDropIn:
          return ReportedDropIn();
        /*case NavigationEnum.ReportChat:
          return ReportedChat();*/
        case NavigationEnum.SignOut:
          return Center(
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.primary),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Log-Out',
                  style: Get.textTheme.titleLarge
                      ?.copyWith(color: AppColors.appWhiteColor),
                ),
              ),
            ),
          ).paddingOnly(left: 0.5);
      }
    });
  }
}

class ItemsWidget extends StatelessWidget {
  ItemsWidget({
    required this.page,
    required this.title,
    super.key,
    this.img = '',
    this.height,
    this.child,
    this.width,
    this.callback,
    this.page2,
  });

  final NavigationEnum page;
  final NavigationEnum? page2;
  final String img;
  final String title;
  final double? height;
  final Widget? child;
  final void Function()? callback;

  final double? width;

  final AdminController c = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool selected = (c.currentPage() == page) || (c.currentPage() == page2);
      return Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 10),
        child: Container(
          height: height ?? 60,
          width: width ?? 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color:
            // selected ? AppColors.selectdeaweclr : AppColors.searchBgColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onHover: (bool value) {},
            hoverColor: AppColors.selectdeaweclr.withOpacity(0.5),
            onTap: callback ??
                () {
                  c.currentPage(page);
                },
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    selected ? AppColors.selectdeaweclr : AppColors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ImageIcon(
                    AssetImage(
                      img,
                    ),
                    color: selected
                        ? AppColors.appWhiteColor
                        : AppColors.appBlackColor,
                    size: 24,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: selected
                        ? const TextStyle(
                            color: AppColors.appWhiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )
                        : const TextStyle(
                            color: AppColors.appBlackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
