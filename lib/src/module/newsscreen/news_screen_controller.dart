import 'dart:convert';

import 'package:dropin/src/models/chat_details_model.dart';
import 'package:dropin/src/models/news_feed_model.dart';
import 'package:dropin/src/service/network_service.dart';
import 'package:dropin/src/utils/widgets/common_functions.dart';
import 'package:dropin/src_exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/autocomplete_address_model.dart';
import '../../models/chat_model2.dart';
import '../../utils/const/common_functions.dart';
import '../chatscreen/chat_screen_controller.dart';

class NewsScreenController extends BaseController {
  RxInt currentIndex = 0.obs;
  RxSet<Marker> markers = <Marker>{}.obs;
  Rx<AutoCompleteAddress> addressResults = AutoCompleteAddress().obs;
  TextEditingController searchController = TextEditingController();
  RxList<NewsFeedModel> newsFeedList = <NewsFeedModel>[].obs;
  Rx<NewsFeedModel> news = NewsFeedModel().obs;
  LatLng currentLocation = LatLng(
    app.currentPosition.latitude,
    app.currentPosition.longitude,
  );
  String message = '';
  FirebaseFirestore db = FirebaseFirestore.instance;
  RxBool report = false.obs;
  TextEditingController controller = TextEditingController();
  RxBool state1 = false.obs;

  RxList<String> imgList = [
    AppAssets.carImage,
    AppAssets.carImage,
    AppAssets.carImage,
  ].obs;

  @override
  Future<void> onInit() async {
    await app.determinePosition();
    currentLocation = LatLng(
      app.currentPosition.latitude,
      app.currentPosition.longitude,
    );
    await getNewsFeed();
    super.onInit();
  }

  GoogleMapController? gMapsController;

  Future<void> onMapCreate() async {
    if (gMapsController != null) {
      final String style =
          await rootBundle.loadString(AppAssets.gMapsDefaultStyle);
      await gMapsController!.setMapStyle(style);
      gMapsController!.moveCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            currentLocation.latitude,
            currentLocation.longitude,
          ),
          15,
        ),
      );
    }
  }

  Future<void> addMarker(LatLng latLang) async {
    markers.clear();
    final Uint8List markerIcon = await getMarker(AppAssets.dropinPin);
    markers.add(
      Marker(
        markerId: MarkerId('${latLang.latitude}${latLang.longitude}'),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        position: latLang,
      ),
    );
    update();
  }

  //get news feed api call in init
  // int is_filter = 0;

  /// this function will create chat
  Future<void> createChat(String name) async {
    try {
      onUpdate(status: Status.LOADING);
      Map<String, dynamic> body = {
        'u_one': app.user.id,
        'u_two': news.value.userId,
        'type': 1
      };
      ResponseModel response = await net.post(UrlConst.createChat, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        ChatDetailsModel detailedChat =
            ChatDetailsModel.fromJson(response.data ?? {});
        detailedChat.user = news.value.user;
        detailedChat.user!.firstName = name;
        ChatModel chatUser = ChatModel(
          chatID: '${detailedChat.id}',
          sender_id: app.user.id.toString(),
          message_type: 1,
          chatUser: detailedChat.user,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          last_message: '',
          isChatLiked: detailedChat.liked,
          users: <String>[
            jsonEncode({
              'isBusiness': false,
              'id': app.user.id.toString(),
            }),
            jsonEncode({
              'isBusiness': false,
              'id': news.value.userId.toString(),
            }),
          ],
        );
        chatUser.user = detailedChat.user!;
        String messageDocID =
            FirebaseFirestore.instance.collection('messages').doc().id;
        MessageModel messageUser = MessageModel(
          created_at: DateTime.now(),
          sender_id: app.user.id.toString(),
          status: 1,
          message: '',
          message_type: 1,
        );

        if (response.message != 'chat_id already exist') {
          logger.v(
            'Adding data to chat\n doc -> ${'${response.data}'}\ndata -> ${chatUser.toJson()}',
          );
          await FirebaseFirestore.instance
              .collection('chat')
              .doc('${detailedChat.id}')
              .set(chatUser.toJson());
          // logger.v(
          //     'Adding data to chat\\message \n doc -> ${'${response.data}'}\ndata -> ${messageUser.toJson()}');
          // await FirebaseFirestore.instance
          //     .collection('chat')
          //     .doc('${detailedChat.id}')
          //     .collection('messages')
          //     .doc(messageDocID)
          //     .set(messageUser.toJson());
        }
        Get.find<ChatScreenController>().chatlist.add(detailedChat);
        onUpdate(status: Status.SCUSSESS);
        Get.toNamed(Routes.InBoxScreen, arguments: chatUser);
      } else {
        if (response.message == 'chat_id already exist') {
          logger.w('chat id exists');
          ChatModel chatUser = ChatModel(
            chatID: '${response.data}',
            sender_id: app.user.id.toString(),
            message_type: 1,
            created_at: DateTime.now(),
            updated_at: DateTime.now(),
            chatUser: news.value.user,
            users: <String>[
              jsonEncode({
                'isBusiness': false,
                'id': app.user.id.toString(),
              }),
              jsonEncode({
                'isBusiness': false,
                'id': news.value.userId.toString(),
              }),
            ],
          );

          await FirebaseFirestore.instance
              .collection('chat')
              .doc('${response.data}')
              .set(
                chatUser.toJson2(),
                SetOptions(merge: true),
              );
          ChatDetailsModel detailsModel = ChatDetailsModel(
            id: response.data,
            uOne: app.user.id,
            uTwo: news.value.userId,
            user: news.value.user,
            type: 1,
          );
          onUpdate(status: Status.SCUSSESS);
          Get.find<ChatScreenController>().chatlist.add(detailsModel);
          Get.toNamed(Routes.InBoxScreen, arguments: chatUser);
          return;
        } else {
          throw response.message;
        }
      }
    } catch (e) {
      onError(e.toString(), () {
        createChat(name);
      });
    }
  }

  Future<void> getNewsFeed([bool isFilter = false]) async {
    try {
      onUpdate(status: Status.LOADING);
      Map<String, dynamic> params = {
        'lat': currentLocation.latitude,
        'lang': currentLocation.longitude,
        'is_filter': 1
      };
      ResponseModel res = await net.get(UrlConst.newsFeed, params);
      if (res.isSuccess) {
        final List<NewsFeedModel> newsList = List<NewsFeedModel>.from(
          (res.data ?? []).map(
            (e) => NewsFeedModel.fromJson(e),
          ),
        );
        if (isFilter) {
          newsFeedList.value = newsList;
        } else {
          newsFeedList.addAll(newsList);
        }
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), getNewsFeed);
    }
  }

  Future<void> dropInGetId({required int id}) async {
    try {
      onUpdate(status: Status.LOADING_MORE);
      Map<String, dynamic> params = {'id': id};
      ResponseModel res = await net.get(UrlConst.dropinid, params);
      if (res.isSuccess) {
        news.value = NewsFeedModel.fromJson(res.data ?? {});
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), () {});
    }
  }

  ///report DropIn

  Future<void> reportDropIn({
    required int id,
    required String reportReason,
  }) async {
    try {
      onUpdate(status: Status.LOADING_MORE);
      final body = {
        'dropin_id': id,
        'reason': reportReason,
      };

      ResponseModel response = await net.post(
        UrlConst.reportDropin,
        body,
      );
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        newsFeedList.removeWhere((NewsFeedModel element) {
          return element.id == id;
        });

        showSnackBar('DropIn reported');
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(
        e.toString(),
        () {},
      );
    }
  }
}
