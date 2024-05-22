import 'dart:async';
import 'dart:convert';

import 'package:dropin/src/models/chat_model2.dart';
import 'package:dropin/src/service/NotificationService.dart';
import 'package:rxdart/rxdart.dart';

import '../../../src_exports.dart';
import 'home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final HomeScreenController c = Get.put(HomeScreenController());

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.w('APP $state');
    switch (state) {
      case AppLifecycleState.resumed:
        NotificationService().removeNotification();
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          children: c.screens,
          index: c.selectedIndex.value,
        );
        // return c.screens[c.selectedIndex.value];
      }),
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
        child: Obx(() {
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppColors.appGradientColor,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0.0,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              backgroundColor: Colors.transparent,
              currentIndex: c.selectedIndex.value,
              selectedItemColor: AppColors.appWhiteColor,
              unselectedItemColor: AppColors.appWhiteColor,
              selectedLabelStyle: TextStyle(
                fontSize: 10,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 10,
              ),
              onTap: (int value) async {
                c.onItemTapped(value, context);
                if (value == 1) {
                  if (app.showDialog) {
                    app.showDialog = false;
                    showDialog(
                      context: Get.context!,
                      barrierDismissible: false,
                      builder: (BuildContext context) => AlertDialog(
                        // clipBehavior: Clip.antiAliasWithSaveLayer,
                        shadowColor: AppColors.black,
                        backgroundColor: AppColors.transparent,
                        elevation: 0,
                        title: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // height: 20,
                          child: Text(
                            textAlign: TextAlign.center,
                            'Welcome to DropIn!',
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              color: AppColors.appWhiteColor,
                            ),
                          ),
                        ),
                      ),
                    );
                    await 2.delay();
                    Get.back();
                  }
                }
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: c.selectedIndex.value == 0
                          ? AppColors.appWhiteColor
                          : Colors.transparent,
                      child: AppAssets.asIcon(
                        AppAssets.home,
                        size: 25,
                        color: c.selectedIndex.value == 0
                            ? AppColors.locationcolor
                            : Colors.white,
                      ),
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: c.selectedIndex.value == 1
                          ? AppColors.appWhiteColor
                          : Colors.transparent,
                      child: AppAssets.asIcon(
                        AppAssets.map,
                        size: 25,
                        color: c.selectedIndex.value == 1
                            ? AppColors.mapColor
                            : Colors.white,
                      ),
                    ),
                  ),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: c.selectedIndex.value == 2
                          ? AppColors.appWhiteColor
                          : Colors.transparent,
                      child: AppAssets.asImage(
                        c.selectedIndex.value == 2
                            ? AppAssets.dropinSelected
                            : AppAssets.dropin,
                        height: 36,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  label: 'Dropin',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: c.selectedIndex.value == 3
                          ? AppColors.appWhiteColor
                          : Colors.transparent,
                      child: c.selectedIndex.value == 3
                          ? AppAssets.asIcon(
                              AppAssets.profile1,
                              size: 25,
                              color: AppColors.chatColor2,
                            )
                          : UnreadMessageUI(),
                    ),
                  ),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: c.selectedIndex.value == 4
                          ? AppColors.appWhiteColor
                          : Colors.transparent,
                      child: AppAssets.asIcon(
                        AppAssets.profile1,
                        size: 25,
                        color: c.selectedIndex.value == 4
                            ? AppColors.appButtonColor
                            : Colors.white,
                      ),
                    ),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          );
        }),
      ).paddingSymmetric(horizontal: 10),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProfileUnreadCount() {
    return FirebaseFirestore.instance
        .collection('chat')
        .where(
          'users',
          arrayContains: jsonEncode(<String, Object>{
            'isBusiness': false,
            'id': app.user.id.toString(),
          }),
        )
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBusinessUnreadCount() {
    return FirebaseFirestore.instance
        .collection('chat')
        .where(
          'users',
          arrayContains: jsonEncode(<String, Object>{
            'isBusiness': true,
            'id': app.bussiness.id.toString(),
          }),
        )
        .snapshots();
  }

  Widget UnreadMessageUI() {
    return StreamBuilder<List<QuerySnapshot<Map<String, dynamic>>>>(
      stream: CombineLatestStream
          .list(<Stream<QuerySnapshot<Map<String, dynamic>>>>[
        getProfileUnreadCount(),
        getBusinessUnreadCount(),
      ]),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<QuerySnapshot<Map<String, dynamic>>>> snapshot,
      ) {
        if (snapshot.hasData) {
          final QuerySnapshot<Map<String, dynamic>> data0 = snapshot.data![0];
          final QuerySnapshot<Map<String, dynamic>> data1 = snapshot.data![1];
          List<ChatModel> profileChat = List<ChatModel>.from(
            data0.docs.map(
              (QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                  ChatModel.fromJson(e.data(), false),
            ),
          );
          logger.w('Profile Chat::${profileChat.length}');
          List<ChatModel> businessChat = List<ChatModel>.from(
            data1.docs.map(
              (QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                  ChatModel.fromJson(e.data(), true),
            ),
          );
          logger.w('Business Chat::${businessChat.length}');

          int p = profileChat
              .where((ChatModel element) => element.unreadCount > 0)
              .length;
          int b = businessChat
              .where((ChatModel element) => element.unreadCount > 0)
              .length;
          app.totalUnReadCount.value = p + b;
          logger.wtf(
            'TOTAL UNREAD COUNT HOME:${p}---$b',
          );
          return Stack(
            children: <Widget>[
              SizedBox(
                height: Get.height * 0.045,
                width: Get.width * 0.12,
              ),
              Positioned(
                right: 10,
                top: 0.0,
                child: AppAssets.asIcon(
                  AppAssets.message,
                  color: AppColors.appWhiteColor,
                  size: 26,
                ).paddingOnly(top: 7),
              ),
              Positioned(
                top: 0.0,
                right: 0,
                child: Visibility(
                  visible: app.totalUnReadCount.value > 0,
                  replacement: SizedBox(),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.messageNotificationColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${app.totalUnReadCount.value}',
                        style: TextStyle(
                          color: AppColors.appWhiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return AppAssets.asIcon(
          AppAssets.message,
          color: AppColors.appWhiteColor,
          size: 26,
        );
      },
    );
  }
}
