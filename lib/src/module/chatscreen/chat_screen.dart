import 'dart:convert';
import 'dart:ui';

import 'package:dropin/src/models/bussiness_model.dart';
import 'package:dropin/src/module/mapscreen/map_screen_controller.dart';
import 'package:dropin/src/utils/widgets/app_images.dart';
import 'package:shimmer/shimmer.dart';

import '../../../src_exports.dart';
import '../../models/chat_model2.dart';
import '../../service/network_service.dart';
import 'chat_screen_controller.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  final ChatScreenController c = Get.put(ChatScreenController());
  final RxList<ChatModel> chatList = <ChatModel>[].obs;
  final List<UserModel> userList = <UserModel>[];
  final List<BussinessModel> businessList = <BussinessModel>[];

  RxInt unreadCount = 0.obs;

  bool isBusinessUnread = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height,
      decoration: BoxDecoration(gradient: AppColors.background),
      child: GetBuilder<ChatScreenController>(
        builder: (ChatScreenController controller) {
          if (controller.isLoading) {
            return Center(child: LoaderView());
          } else {
            return Scaffold(
              backgroundColor: AppColors.transparent,
              appBar: AppBar(
                backgroundColor: AppColors.transparent,
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Obx(
                      () => Text(
                        app.showBusinessChat.value ? 'BUSINESS' : 'CHATS',
                        style: AppThemes.lightTheme.textTheme.headlineLarge
                            ?.copyWith(
                          color: AppColors.appBlackColor,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
                toolbarHeight: 80,
                actions: <Widget>[
                  Obx(() => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('chat')
                            .where(
                              'users',
                              arrayContains: jsonEncode(<String, Object>{
                                'isBusiness': !app.showBusinessChat.value,
                                'id': !app.showBusinessChat.value
                                    ? app.bussiness.id.toString()
                                    : app.user.id.toString(),
                              }),
                            )
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          loggerNoStack.i('##Builder##');
                          if (snapshot.hasData) {
                            logger.wtf('DATA0122::${snapshot.data!.docs}');
                            List<ChatModel> chat = List<ChatModel>.from(
                              snapshot.data!.docs.map(
                                (
                                  QueryDocumentSnapshot<Map<String, dynamic>> e,
                                ) {
                                  return ChatModel.fromJson(
                                      e.data(), !app.showBusinessChat.value);
                                },
                              ),
                            );
                            var chats = chat
                                .where((ChatModel element) =>
                                    element.unreadCount > 0)
                                .toList();
                            logger.wtf(
                                'Hellooo:::${chat.length}------${chat.where((ChatModel element) => element.unreadCount > 0).toList().isNotEmpty}');
                            return SizedBox(
                              height: 30,
                              width: Get.width * 0.42,
                              child: Obx(
                                () => Stack(
                                  children: [
                                    Container(
                                      height: 80,
                                      width: Get.width * 0.5,
                                    ),
                                    AppElevatedButton(
                                      height: 30,
                                      width: Get.width * 0.42,
                                      color: AppColors.black,
                                      title: !app.showBusinessChat.value
                                          ? 'Business Chat'
                                          : 'Profile Chat',
                                      style: AppThemes
                                          .lightTheme.textTheme.headlineMedium
                                          ?.copyWith(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 14,
                                      ),
                                      callback: () {
                                        app.showBusinessChat.toggle();
                                      },
                                    ),
                                    chat
                                            .where(
                                              (ChatModel element) =>
                                                  element.unreadCount > 0,
                                            )
                                            .toList()
                                            .isNotEmpty
                                        ? Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .messageNotificationColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${chats.length}',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.appWhiteColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            ).paddingAll(10);
                          }
                          return SizedBox();
                        },
                      ))
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Obx(
                        () => Text(
                          app.showBusinessChat.value
                              ? app.bussiness.businessName
                              : app.user.userName,
                          style: AppThemes.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: AppColors.appWhiteColor,
                          ),
                        ),
                      ),
                    ).paddingOnly(left: 20, bottom: 5),
                    Expanded(
                      child: Obx(
                        () {
                          return StreamBuilder<
                              QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('chat')
                                .where(
                                  'users',
                                  arrayContains: jsonEncode(<String, Object>{
                                    'isBusiness': app.showBusinessChat.value,
                                    'id': !app.showBusinessChat.value
                                        ? app.user.id.toString()
                                        : app.bussiness.id.toString(),
                                  }),
                                )
                                .orderBy('created_at', descending: true)
                                .snapshots(),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot,
                            ) {
                              if (snapshot.hasData) {
                                chatList.value = List<ChatModel>.from(
                                  snapshot.data!.docs.map(
                                    (QueryDocumentSnapshot<Map<String, dynamic>>
                                        e) {
                                      logger.w('Chat screen::${e.data()}');
                                      return ChatModel.fromJson(
                                          e.data(), app.showBusinessChat.value);
                                    },
                                  ),
                                );
                                return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (_, int index) {
                                    logger.w(snapshot.data!.docs[index].data());
                                    ChatModel chat = ChatModel.fromJson(
                                      snapshot.data!.docs[index].data(),
                                      app.showBusinessChat.value,
                                    );
                                    logger.w('Chats::${chat.toJson()}');
                                    return Slidable(
                                      key: ValueKey<int>(index),
                                      endActionPane: ActionPane(
                                        extentRatio: 0.3,
                                        dragDismissible: false,
                                        dismissible: DismissiblePane(
                                          dismissThreshold: 0.3,
                                          onDismissed: () {},
                                        ),
                                        motion: const DrawerMotion(),
                                        children: <Widget>[
                                          SlidableAction(
                                            onPressed: (BuildContext context) {
                                              Get.dialog(
                                                ChatDialog(chat: chat),
                                                barrierColor:
                                                    Colors.transparent,
                                              );
                                            },
                                            icon: Icons.priority_high,
                                            autoClose: true,
                                            backgroundColor: AppColors.red,
                                          ),
                                          SlidableAction(
                                            onPressed: (BuildContext context) {
                                              Get.dialog(
                                                ChatDialog(chat: chat),
                                                barrierColor:
                                                    Colors.transparent,
                                              );
                                            },
                                            icon: Icons.close,
                                            autoClose: true,
                                            backgroundColor: AppColors.red,
                                          ),
                                        ],
                                      ),
                                      startActionPane: ActionPane(
                                        extentRatio: 0.2,
                                        dragDismissible: false,
                                        dismissible: DismissiblePane(
                                          onDismissed: () {},
                                        ),
                                        motion: const DrawerMotion(),
                                        children: <Widget>[
                                          SlidableAction(
                                            flex: 1,
                                            padding: EdgeInsets.all(20),
                                            onPressed:
                                                (BuildContext context) async {
                                              if (chat.user.isBusiness) {
                                                await Get.find<MapsController>()
                                                    .getBussinessByID(
                                                  chat.user.id,
                                                );
                                                Get.toNamed(
                                                  Routes.ViewBussinessScreen,
                                                  arguments: chat.user.id,
                                                );
                                              } else {
                                                Get.toNamed(
                                                  Routes.ViewProfile,
                                                  arguments: chat.user.id,
                                                );
                                              }
                                            },
                                            label: 'P',
                                            autoClose: true,
                                            backgroundColor:
                                                AppColors.chatcolors,
                                          ),
                                        ],
                                      ),
                                      child: FutureBuilder<UserModel>(
                                        future: getUser(
                                          chat.user.id,
                                          isBusiness: chat.user.isBusiness,
                                        ),
                                        builder: (
                                          _,
                                          AsyncSnapshot<UserModel> snapShot,
                                        ) {
                                          logger.wtf(
                                              'DATAAAA::${snapShot.data?.toJson()}');
                                          if (snapShot.hasData) {
                                            chat.chatUser = snapShot.data;
                                            chat.is_like.value =
                                                chat.chatUser!.is_like;
                                            return Visibility(
                                              visible: chat.chatUser!.id != 0,
                                              replacement: SizedBox(),
                                              child: InkWell(
                                                focusColor:
                                                    AppColors.transparent,
                                                highlightColor:
                                                    AppColors.transparent,
                                                hoverColor:
                                                    AppColors.transparent,
                                                splashColor:
                                                    AppColors.transparent,
                                                onTap: () {
                                                  Get.toNamed(
                                                    Routes.InBoxScreen,
                                                    arguments: chat,
                                                  );
                                                },
                                                child: Visibility(
                                                  visible: chat
                                                      .last_message.isNotEmpty,
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.tileColor,
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor:
                                                              (kDebugMode &&
                                                                      chat.user
                                                                          .isBusiness)
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                          child: CircleAvatar(
                                                            radius: 26,
                                                            backgroundImage:
                                                                AppImages
                                                                    .asProvider(
                                                              chat.chatUser!
                                                                  .img,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                chat.chatUser!
                                                                    .firstName,
                                                                style: AppThemes
                                                                    .lightTheme
                                                                    .textTheme
                                                                    .headlineMedium
                                                                    ?.copyWith(
                                                                  fontSize: 15,
                                                                ),
                                                              ).paddingOnly(
                                                                  left: 10),
                                                              Text(
                                                                chatList[index]
                                                                    .last_message,
                                                                maxLines: 1,
                                                                style: AppThemes
                                                                    .lightTheme
                                                                    .textTheme
                                                                    .titleMedium,
                                                              ).paddingSymmetric(
                                                                horizontal: 15,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              chat.unreadCount !=
                                                                  0,
                                                          child: CircleAvatar(
                                                            radius: 12,
                                                            backgroundColor:
                                                                AppColors
                                                                    .appButtonColor,
                                                            child: Text(
                                                              chat.displayUnreadCount,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ).paddingSymmetric(
                                                      horizontal: 10,
                                                      vertical: 5,
                                                    ),
                                                  ).paddingAll(1),
                                                ),
                                              ),
                                            );
                                          } else if (snapShot.hasError) {
                                            logger.e(
                                                'ERROR PHASE::${snapShot.stackTrace}');
                                            return DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: AppColors.tileColor,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor:
                                                        (kDebugMode &&
                                                                chat.user
                                                                    .isBusiness)
                                                            ? Colors.black
                                                            : Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 26,
                                                      backgroundColor:
                                                          Colors.black,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'User Deleted',
                                                          style: AppThemes
                                                              .lightTheme
                                                              .textTheme
                                                              .headlineMedium
                                                              ?.copyWith(
                                                            fontSize: 15,
                                                          ),
                                                        ).paddingOnly(left: 10),
                                                        Text(
                                                          'User Deleted',
                                                          maxLines: 1,
                                                          style: AppThemes
                                                              .lightTheme
                                                              .textTheme
                                                              .titleMedium,
                                                        ).paddingSymmetric(
                                                          horizontal: 15,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  /*Visibility(
                                                    visible:
                                                        chat.unreadCount != 0,
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          AppColors
                                                              .appButtonColor,
                                                      child: Text(
                                                        chat.displayUnreadCount,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),*/
                                                ],
                                              ).paddingSymmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                            );
                                          } else {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey,
                                              highlightColor:
                                                  Colors.grey.shade300,
                                              child: const ListTile(
                                                leading: CircleAvatar(),
                                                title: SizedBox(
                                                  height: 10,
                                                  width: 100,
                                                  child: ColoredBox(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                subtitle: SizedBox(
                                                  height: 10,
                                                  width: 100,
                                                  child: ColoredBox(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    'No Chats Found',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<BussinessModel> getBusiness(int uid) async {
    BussinessModel bussiness;
    bussiness = businessList.firstWhere(
        (BussinessModel element) => element.id == uid,
        orElse: () => BussinessModel(id: 0));
    if (bussiness.id == 0) {
      ResponseModel res = await net.get(
        UrlConst.getbyIdBussiness,
        <String, dynamic>{'id': uid},
      );
      logger.w(res.data);
      if (res.isSuccess) {
        bussiness = BussinessModel.fromJson(res.data ?? <String, dynamic>{});
        businessList.add(bussiness);
        return bussiness;
      } else {
        return BussinessModel(id: 0);
      }
    } else {
      return bussiness;
    }
  }

  Future<UserModel> getUser(int uid, {bool isBusiness = false}) async {
    UserModel user = UserModel();
    user = userList.firstWhere(
      (UserModel element) =>
          element.id == uid && element.isBusiness == isBusiness,
      orElse: () => UserModel(id: 0),
    );
    if (user.id == 0) {
      if (isBusiness) {
        BussinessModel bussiness = await getBusiness(uid);
        user = bussiness.getFakeUser;
        user.isBusiness = true;
        userList.add(user);
        return user;
      } else {
        ResponseModel res = await net.get(
          UrlConst.userGetById,
          <String, dynamic>{'id': uid},
        );
        if (res.isSuccess) {
          user = UserModel.fromJson(res.data ?? {});
          logger.w('Chat User::::${res.data}');
          userList.add(user);
          return user;
        } else {
          return UserModel(id: 0);
        }
      }
    } else {
      return user;
    }
  }
}

class ChatDialog extends StatelessWidget {
  const ChatDialog({
    required this.chat,
    Key? key,
  }) : super(key: key);
  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatScreenController>(
      builder: (ChatScreenController controller) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 5,
            sigmaX: 5,
          ),
          child: Column(
            children: <Widget>[
              AppButton(
                title: 'Delete',
                callback: () {
                  Get.back();

                  controller.update();
                  FirebaseFirestore.instance
                      .collection('chat')
                      .doc('${chat.chatID}')
                      .set(
                    <String, dynamic>{
                      'users': FieldValue.arrayRemove(
                        <String>[
                          jsonEncode(<String, Object>{
                            'isBusiness': app.showBusinessChat.value,
                            'id': app.user.id.toString(),
                          })
                        ],
                      ),
                    },
                    SetOptions(merge: true),
                  );
                },
                height: 40,
              ).paddingOnly(
                top: 100,
              ),
              AppButton(
                title: 'Report & Hide!',
                callback: () async {
                  dynamic reason = await Get.dialog(
                    ReportDialog(),
                  );

                  if (reason is String) {
                    Get.back();
                    controller.reportUser(
                      chat: chat,
                      reason: reason,
                    );
                  }
                },
                height: 40,
              ),
              AppButton(
                title: 'View Profile',
                callback: () async {
                  Get.back();
                  if (chat.user.isBusiness) {
                    await Get.find<MapsController>().getBussinessByID(
                      chat.user.id,
                    );
                    Get.toNamed(
                      Routes.ViewBussinessScreen,
                      arguments: chat.user.id,
                    );
                  } else {
                    Get.toNamed(
                      Routes.ViewProfile,
                      arguments: chat.user.id,
                    );
                  }
                  // Get.toNamed(
                  //   Routes.ViewProfile,
                  //   arguments: chat.user.id,
                  // );
                },
                height: 40,
              ),
            ],
          ).paddingSymmetric(horizontal: 35),
        );
      },
    );
  }
}
