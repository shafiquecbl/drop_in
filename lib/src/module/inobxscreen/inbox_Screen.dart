import 'package:dropin/src/models/chat_model2.dart';
import 'package:dropin/src/module/mapscreen/map_screen_controller.dart';
import 'package:dropin/src/utils/widgets/app_images.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../src_exports.dart';
import '../newsscreen/news_screen_controller.dart';
import 'inboxScreen_controller.dart';

class InBoxScreen extends StatefulWidget {
  InBoxScreen({Key? key}) : super(key: key);

  @override
  State<InBoxScreen> createState() => _InBoxScreenState();
}

class _InBoxScreenState extends State<InBoxScreen> {
  final InBoxScreenController c = Get.put(InBoxScreenController());

  final NewsScreenController controller = Get.find<NewsScreenController>();

  final Rx<ReplyModel> tempMessage = ReplyModel().obs;

  final RxList<ChatModel> chatList = <ChatModel>[].obs;

  ChatModel chat = Get.arguments ?? ChatModel();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    _db.collection('chat').doc(c.chatMode.chatID).update(<Object, Object?>{
      app.showBusinessChat.value ? '${app.bussiness.id}' : '${app.user.id}': 0,
    });
    super.initState();
  }

  @override
  void dispose() {
    _db.collection('chat').doc(c.chatMode.chatID).update(<Object, Object?>{
      app.showBusinessChat.value ? '${app.bussiness.id}' : '${app.user.id}': 0,
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Container(
        height: context.height,
        decoration: BoxDecoration(gradient: AppColors.background),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: AppAssets.asImage(
                        AppAssets.arrow,
                        height: 30,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: InkWell(
                      onTap: () async {
                        if (c.chatMode.user.isBusiness) {
                          Get.find<MapsController>().getBussinessByID(
                            c.chatMode.user.id,
                          );
                          Get.toNamed(
                            Routes.ViewBussinessScreen,
                            arguments: c.chatMode.user.id,
                          );
                        } else {
                          Get.toNamed(
                            Routes.ViewProfile,
                            arguments: c.chatMode.user.id,
                          );
                        }
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.chatcolor1,
                          border: Border.all(
                            color: AppColors.appBlackColor,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 60,
                              width: 60,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                gradient: AppColors.appGradientColor,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                backgroundColor: AppColors.appWhiteColor,
                                backgroundImage: AppImages.asProvider(
                                  chat.chatUser!.img,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  c.chatMode.chatUser!.userName,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ).paddingOnly(left: 10),
                                Text(
                                  '${c.chatMode.chatUser!.fullName}',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppThemes
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: Color(0xFF404040),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ).paddingSymmetric(horizontal: 10),
                              ],
                            ),
                          ],
                        ).paddingSymmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chat')
                            .doc(c.chatMode.chatID)
                            .collection('messages')
                            .orderBy('created_at', descending: false)
                            .snapshots(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                        ) {
                          /*if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }*/
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Something went wrong...'),
                            );
                          }
                          if (snapshot.hasData) {
                            c.messageList = snapshot.data!.docs
                                .map((QueryDocumentSnapshot<Object?> e) {
                              MessageModel msg = MessageModel.fromJson(
                                e.data() as Map<String, dynamic>,
                              );
                              msg.id = e.id;
                              return msg;
                            }).toList();
                            return GroupedListView<MessageModel, DateTime>(
                              elements: c.messageList,
                              groupBy: (MessageModel element) {
                                return DateTime(
                                  element.created_at!.year,
                                  element.created_at!.month,
                                  element.created_at!.day,
                                );
                              },
                              groupSeparatorBuilder: (DateTime groupByValue) {
                                final DateTime foo = groupByValue;
                                DateTime foo2 = DateTime.now();
                                String displayScreen =
                                    DateFormat('MMMM dd, yyyy').format(foo);
                                if (foo.day == foo2.day &&
                                    foo.month == foo2.month &&
                                    foo.year == foo2.year) {
                                  displayScreen = 'Today';
                                }
                                return SizedBox(
                                  width: Get.width,
                                  child: Text(
                                    displayScreen,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                              itemBuilder: (
                                BuildContext context,
                                MessageModel element,
                              ) {
                                logger.w('Messaggeeeee::${element.toJson()}');
                                return SwipeTo(
                                  onRightSwipe: (DragUpdateDetails onRightSwipe) {
                                    tempMessage.value = ReplyModel(
                                      id: element.id,
                                      message: element.message,
                                      senderId: element.sender_id,
                                    );
                                  },
                                  animationDuration: Duration(
                                    milliseconds: 200,
                                  ),
                                  iconColor: Colors.white,
                                  child: Align(
                                    alignment: element.sender_id !=
                                            app.user.id.toString()
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: 50,
                                        maxWidth: context.width * 0.80,
                                      ),
                                      child: InkWell(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: InkWell(
                                                  splashColor:
                                                      AppColors.transparent,
                                                  highlightColor:
                                                      AppColors.transparent,
                                                  focusColor:
                                                      AppColors.transparent,
                                                  hoverColor:
                                                      AppColors.transparent,
                                                  onTap: () {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                          'chat',
                                                        )
                                                        .doc(
                                                          c.chatMode.chatID,
                                                        )
                                                        .collection(
                                                          'messages',
                                                        )
                                                        .doc(
                                                          element.id,
                                                        )
                                                        .delete();
                                                    Get.back();
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text('Unsend'),
                                                      Icon(Icons.delete)
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            color: element.sender_id !=
                                                    app.user.id.toString()
                                                ? AppColors.chatcolor1
                                                : AppColors.chatcolor,
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                color: AppColors.appBlackColor,

                                                blurRadius: 4.0,
                                                // soften the shadow
                                                // spreadRadius: 5.0,
                                                offset: Offset(0.5, 0.5),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                element.sender_id ==
                                                        app.user.id.toString()
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                            children: <Widget>[
                                              if (element.reply!.id
                                                  .isNotEmpty) ...<Widget>[
                                                DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(
                                                      0.3,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      5,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    element.reply!.message,
                                                    maxLines: 1,
                                                  ).paddingSymmetric(
                                                    horizontal: 5,
                                                    vertical: 3,
                                                  ),
                                                )
                                              ],
                                              Text(
                                                element.message,
                                                style: element.sender_id !=
                                                        app.user.id.toString()
                                                    ? AppThemes.lightTheme
                                                        .textTheme.titleSmall
                                                    : const TextStyle(
                                                        color: AppColors
                                                            .appBlackColor,
                                                      ),
                                              ),
                                              // const SizedBox(height: 5),
                                              Text(
                                                DateFormat('jm').format(
                                                  element.created_at!,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 6,
                                                ),
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ).paddingSymmetric(
                                          vertical: 3,
                                          horizontal: 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              reverse: true,
                              order: GroupedListOrder.DESC,
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Obx(
                    () => Visibility(
                      visible: tempMessage.value.id.isNotEmpty,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                tempMessage.value.message,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 1,
                              onPressed: () {
                                tempMessage.value = ReplyModel();
                              },
                              icon: Icon(
                                Icons.close,
                              ),
                            )
                          ],
                        ).paddingOnly(left: 10),
                      ).paddingSymmetric(horizontal: 16),
                    ),
                  ),
                  TextFormField(
                    controller: c.messageCTRL,
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    style: AppThemes.lightTheme.textTheme.headline2
                        ?.copyWith(fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(22),
                      suffixIconConstraints:
                          const BoxConstraints(maxHeight: 90, minWidth: 60),
                      suffixIcon: InkWell(
                        onTap: () async {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          controller.message = c.messageCTRL.text;
                          MessageModel msg = MessageModel(
                            message_type: 1,
                            message: c.messageCTRL.text.trim(),
                            status: 1,
                            created_at: DateTime.now(),
                            sender_id: app.user.id.toString(),
                            imageUrl: '',
                          );

                          // if (c.token.isNotEmpty && c.token != '') {
                          //   c.notifyToUser(
                          //       message: c.messageCTRL.text,
                          //       title: app.user.userName,
                          //       contactPushToken: c.token);
                          //
                          // }

                          if (tempMessage.value.id.isNotEmpty) {
                            msg.reply = tempMessage.value;
                            tempMessage.value = ReplyModel();
                          }
                          await c.sendMessage(
                            messageModel: msg,
                            chatId: c.chatMode.chatID,
                            id: c.chatMode.user.id,
                            isBusiness: chat.user.isBusiness,
                          );

                          c.messageCTRL.clear();
                        },
                        child: AppAssets.asImage(
                          AppAssets.sendmsg,
                          height: 40,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      errorStyle:
                          AppThemes.lightTheme.textTheme.headline2?.copyWith(
                        fontSize: 13,
                        color: Colors.red,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white70,
                      hintText: 'Type your message here...',
                      helperStyle: context.textTheme.titleMedium
                          ?.copyWith(color: AppColors.grey),
                      counter: const SizedBox(),
                    ),
                  ).paddingSymmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
