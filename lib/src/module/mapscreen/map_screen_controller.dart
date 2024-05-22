import 'dart:async';
import 'dart:convert';

import 'package:custom_marker/marker_icon.dart';
import 'package:dropin/src/models/live_location_model.dart';
import 'package:dropin/src/utils/widgets/app_images.dart';
import 'package:dropin/src/utils/widgets/maps_view.dart';
import 'package:dropin/src/utils/widgets/profile_sheet.dart';
import 'package:dropin/src_exports.dart';
import 'package:dio/dio.dart' as dio;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/Business_rating.dart';
import '../../models/address_model.dart';
import '../../models/autocomplete_address_model.dart';
import '../../models/bussiness_model.dart';
import '../../models/category_model.dart';
import '../../models/chat_details_model.dart';
import '../../models/chat_model2.dart';
import '../../models/drop_in_category.dart';
import '../../models/map_model.dart';

import '../../models/news_feed_model.dart';
import '../../service/network_service.dart';
import '../../utils/const/common_functions.dart';
import '../../utils/widgets/bussiness_bottomsheet.dart';
import '../../utils/widgets/custom_bottom_sheet.dart';
import '../chatscreen/chat_screen_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapsController extends BaseController with GetTickerProviderStateMixin {
  double? zoomLevel;
  AnimationController? animationController;
  int catId = 0;
  List<int> businessFilters = <int>[];
  List<int> userFilters = <int>[];
  Animation<double>? animation;
  late Timer timer;
  RxInt descCount = 0.obs;
  Rx<MapModel> mapModel = MapModel().obs;
  Rx<MapModel> nearByPins = MapModel().obs;
  Rx<AutoCompleteAddress> address = AutoCompleteAddress().obs;
  Rx<MapModel> searchMapModel = MapModel().obs;
  List<LiveLocationModel> liveUsers = <LiveLocationModel>[];
  RxDouble liveLocationRadius = 13.0.obs;
  RxList<DropCategoryModel> dropInList = <DropCategoryModel>[].obs;
  RxList<CategoryModel> catList = <CategoryModel>[].obs;
  Rx<NewsFeedModel> news = NewsFeedModel().obs;
  Rx<BussinessModel> bussiness = BussinessModel().obs;
  bool? isBusinessSearch;
  TextEditingController searchController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  GoogleMapController? gMapsController;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Marker> liveMarkers = <Marker>{}.obs;
  RxSet<Marker> tempMarkers = <Marker>{}.obs;
  AddressResults addressModel = AddressResults();
  LatLng movementLatLong = LatLng(
    app.currentPosition.latitude,
    app.currentPosition.longitude,
  );
  bool filterOpen = false;
  double rate = 1.0;

  @override
  void onInit() async {
    await app.determinePosition();
    // await getMap();
    if (!kIsWeb) {
      liveLocationStreamSub = FirebaseFirestore.instance
          .collection('live_location')
          .where('is_live', isEqualTo: true)
          .snapshots();
      liveLocationStreamSub.listen(
        (QuerySnapshot<Map<String, dynamic>> snapshot) {
          if (animationController != null) {
            liveUsers.clear();
            List<QueryDocumentSnapshot<Map<String, dynamic>>> t = snapshot.docs;
            liveUsers = List<LiveLocationModel>.from(
              (t).map(
                (QueryDocumentSnapshot<Map<String, dynamic>> e) {
                  logger.wtf(e.data());
                  return LiveLocationModel.fromJson(e.data());
                },
              ).toList(),
            );
            liveUsers.forEach((user) async {
              user.marker = Marker(
                markerId: MarkerId('${user.userId}'),
                position: LatLng(user.lat, user.long),
                icon: await MarkerIcon.downloadResizePictureCircle(
                  user.image,
                  size: 90,
                  addBorder: true,
                  borderColor: Colors.white,
                  borderSize: 9,
                ),
                onTap: () {
                  customBottomSheet(
                    child: LiveLocationBottomSheet(
                      user: user,
                    ),
                  );
                },
              );
              liveMarkers.add(
                user.marker,
              );
            });
          } else {
            liveMarkers.clear();
            liveUsers.clear();
          }
        },
      );
      final Uint8List markerIcon = await getMarker(AppAssets.currentLocation);
      markers.add(
        Marker(
          markerId: MarkerId(
            'currentLocation',
          ),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          draggable: true,
          position: LatLng(
            app.currentPosition.latitude,
            app.currentPosition.longitude,
          ),
        ),
      );
    }
    super.onInit();
  }

  @override
  void dispose() {
    stopLiveLocation();
    timer.cancel();
    super.dispose();
  }

  late Stream<QuerySnapshot<Map<String, dynamic>>> liveLocationStreamSub;

  Future<void> getLocationFromMap() async {
    String url = UrlConst.addressGetFromText;
    onUpdate(status: Status.LOADING_MORE);
    try {
      Response response =
          await dio.Dio().get(url + searchController.text.trim());
      logger.i(url + searchController.text.trim());
      logger.wtf(response.data);
      if (response.data['status'] == 'OK') {
        addressModel = AddressResults.fromJson(response.data);
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw 'Something went wrong';
      }
    } catch (error) {
      onError(
        error.toString(),
        getLocationFromMap,
      );
    }
  }

  Future<void> onMapCreate() async {
    if (gMapsController != null) {
      // loading maps style
      String mapsStyle =
          await rootBundle.loadString(AppAssets.gMapsDefaultStyle);
      await gMapsController!.setMapStyle(mapsStyle);
      await gMapsController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            app.currentPosition.latitude,
            app.currentPosition.longitude,
          ),
          17,
        ),
      );
    }
  }

  void _getMarkers() async {
    markers
        .removeWhere((element) => element.markerId.value == 'currentLocation');
    final Uint8List markerIcon = await getMarker(AppAssets.currentLocation);
    markers.add(
      Marker(
        markerId: MarkerId(
          'currentLocation',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        draggable: true,
        position: LatLng(
          app.currentPosition.latitude,
          app.currentPosition.longitude,
        ),
      ),
    );
    for (BusinessDetail element in mapModel.value.businessDetails) {
      final Uint8List markerIcon = await getMarker(element.iconPath);
      markers.add(
        Marker(
          markerId: MarkerId('${element.lat}${element.lang}'),
          icon: BitmapDescriptor.fromBytes(
            markerIcon,
            size: Size(25, 25),
          ),
          draggable: true,
          position: LatLng(element.lat, element.lang),
          onTap: () async {
            await Get.showOverlay(
              asyncFunction: () {
                return getNearByPins(latLng: LatLng(element.lat, element.lang));
              },
              loadingWidget: LoaderView(),
            );
            List<BusinessDetail> pins = [];
            pins.addAll(nearByPins.value.businessDetails);
            pins.addAll(nearByPins.value.userDropin);
            if (pins.length > 1) {
              logger.i('Near By Pins');
              showDialog(
                context: Get.context!,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    backgroundColor: AppColors.purpale,
                    title: Text('Choose one of the pin'),
                    content: SizedBox(
                      width: Get.width - 40,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: pins.length,
                        itemBuilder: (context, index) {
                          var pin = pins[index];
                          return ListTile(
                            minVerticalPadding: 8.0,
                            tileColor: AppColors.purpale,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: AppColors.appWhiteColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onTap: () async {
                              Get.back();
                              if (pin.isBusiness) {
                                await getBussinessByID(pin.id);
                                customBottomSheet(
                                    child: BussinessBottomSheet());
                              } else {
                                await dropInGetId(id: pin.id);
                                customBottomSheet(
                                  child: ProfileSheet(),
                                );
                              }
                            },
                            leading: pin.isBusiness
                                ? AppImages.asImage(
                                    UrlConst.coverImg +
                                        pin.coverImages.first.image,
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,
                                  )
                                : CachedNetworkImage(
                                    height: 50,
                                    width: 50,
                                    imageUrl: UrlConst.dropinBaseUrl +
                                        pin.dropinImages.first.image,
                                    fit: BoxFit.cover,
                                  ),
                            title: Text(pin.isBusiness
                                ? 'Business - ${pin.businessName}'
                                : 'Dropin - ${pin.title}'),
                            subtitle: RichText(
                              text: TextSpan(
                                text: '${pin.description} - ',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black),
                                children: [
                                  TextSpan(
                                    text: '${pin.loc}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w200,
                                        color: AppColors.black),
                                  ),
                                ],
                              ),
                            ),
                          ).paddingOnly(bottom: 10);
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              await getBussinessByID(element.id);
              customBottomSheet(
                child: BussinessBottomSheet(),
              );
            }
          },
        ),
      );
    }

    for (BusinessDetail element in mapModel.value.userDropin) {
      final Uint8List markerIcon = await getMarker(element.iconPath);

      markers.add(
        Marker(
          markerId: MarkerId('${element.lat}${element.lang}'),
          icon: BitmapDescriptor.fromBytes(
            markerIcon,
            size: Size(25, 25),
          ),
          position: LatLng(element.lat, element.lang),
          onTap: () async {
            logger.w('Dropin Pins');
            await Get.showOverlay(
              asyncFunction: () {
                return getNearByPins(latLng: LatLng(element.lat, element.lang));
              },
              loadingWidget: LoaderView(),
            );
            List<BusinessDetail> pins = [];
            pins.addAll(nearByPins.value.businessDetails);
            pins.addAll(nearByPins.value.userDropin);
            if (pins.length > 1) {
              showDialog(
                context: Get.context!,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    backgroundColor: AppColors.purpale,
                    title: Text('Choose one of the pin'),
                    content: SizedBox(
                      width: Get.width - 40,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: pins.length,
                        itemBuilder: (context, index) {
                          var pin = pins[index];
                          return ListTile(
                            minVerticalPadding: 8.0,
                            tileColor: AppColors.purpale,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: AppColors.appWhiteColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onTap: () async {
                              Get.back();
                              if (pin.isBusiness) {
                                await getBussinessByID(pin.id);
                                customBottomSheet(
                                    child: BussinessBottomSheet());
                              } else {
                                await dropInGetId(id: pin.id);
                                customBottomSheet(
                                  child: ProfileSheet(),
                                );
                              }
                            },
                            leading: pin.isBusiness
                                ? AppImages.asImage(
                                    UrlConst.coverImg +
                                        pin.coverImages.first.image,
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,
                                  )
                                : CachedNetworkImage(
                                    height: 50,
                                    width: 50,
                                    imageUrl: UrlConst.dropinBaseUrl +
                                        pin.dropinImages.first.image,
                                    fit: BoxFit.cover,
                                  ),
                            title: Text(pin.isBusiness
                                ? 'Business - ${pin.businessName}'
                                : 'Dropin - ${pin.title}'),
                            subtitle: RichText(
                              text: TextSpan(
                                text: '${pin.description} - ',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black),
                                children: [
                                  TextSpan(
                                    text: '${pin.loc}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w200,
                                        color: AppColors.black),
                                  ),
                                ],
                              ),
                            ),
                          ).paddingOnly(bottom: 10);
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              dropInGetId(id: element.id);
              customBottomSheet(
                child: ProfileSheet(),
              );
            }
          },
        ),
      );
    }
  }

  Future<void> animateToCurrentLoc([LatLng? location]) async {
    if (gMapsController != null) {
      gMapsController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          location ??
              LatLng(
                app.currentPosition.latitude,
                app.currentPosition.longitude,
              ),
          14,
        ),
      );
    }
  }

  Future<void> showNorth() async {
    if (gMapsController != null) {
      try {
        gMapsController!.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(
                (app.currentPosition.latitude - 1).toDouble(),
                (app.currentPosition.longitude - 1).toDouble(),
              ),
              northeast: LatLng(
                (app.currentPosition.latitude + 1).toDouble(),
                (app.currentPosition.longitude + 1).toDouble(),
              ),
            ),
            10.0,
          ),
        );
      } catch (e) {
        logger.e(e);
      }
    }
  }

  Future<void> _updateLocation([bool isLive = true]) async {
    try {
      await app.determinePosition();
      LiveLocationModel liveLocation = LiveLocationModel(
        id: FirebaseAuth.instance.currentUser!.uid,
        description: '${descriptionController.text.trim()}',
        image: app.user.imageUrl,
        lat: app.currentPosition.latitude,
        long: app.currentPosition.longitude,
        userId: app.user.id,
        isLive: isLive,
        userName: app.user.fullName,
        createdAt: FieldValue.serverTimestamp(),
      );
      logger.i('setting date to firebase ${liveLocation.toJson()}');
      await FirebaseFirestore.instance
          .collection('live_location')
          .doc(liveLocation.id)
          .set(liveLocation.toJson());
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> createChat(String name, {int? userId}) async {
    try {
      onUpdate(status: Status.LOADING_MORE);
      Map<String, dynamic> body = {
        'u_one': app.user.id,
        'u_two': userId ?? news.value.userId,
        'type': 1
      };
      logger.w(name);
      ResponseModel response = await net.post(UrlConst.createChat, body);
      if (response.isSuccess) {
        ChatDetailsModel detailedChat = ChatDetailsModel.fromJson(
          response.data ?? {},
        );
        detailedChat.user = news.value.user;
        detailedChat.user!.firstName = name;

        ChatModel chatUser = ChatModel(
          chatID: '${detailedChat.id}',
          sender_id: app.user.id.toString(),
          message_type: 1,
          isChatLiked: detailedChat.liked,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          last_message: '',
          users: <String>[
            jsonEncode({
              'isBusiness': false,
              'id': app.user.id.toString(),
            }),
            jsonEncode({
              'isBusiness': false,
              'id': userId?.toString() ?? news.value.userId.toString(),
            }),
          ],
          chatUser: detailedChat.user!,
        );
        chatUser.user = detailedChat.user!;
        chatUser.user.isBusiness = false;
        String messageDocID =
            FirebaseFirestore.instance.collection('messages').doc().id;
        // MessageModel messageUser = MessageModel(
        //   created_at: DateTime.now(),
        //   sender_id: app.user.id.toString(),
        //   status: 1,
        //   message: '',
        //   message_type: 1,
        // );

        if (response.message != 'chat_id already exist') {
          logger.v(
              'Adding data to chat\n doc -> ${'${response.data}'}\ndata -> ${chatUser.toJson()}');
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
        throw response.message;
      }
    } catch (e) {
      onError(e.toString(), () {
        createChat(name);
      });
    }
  }

  Future<dynamic> getNearByPins({required LatLng latLng}) async {
    try {
      Map<String, dynamic> params = {
        'lat': latLng.latitude,
        "lang": latLng.longitude,
      };
      ResponseModel response = await net.get(UrlConst.getNearByPins, params);
      if (response.isSuccess) {
        nearByPins.value = MapModel.fromJson(response.data ?? {});
        logger.w('NEAR BY PINS::::${nearByPins.value.toJson()}');
      } else {
        throw response.message;
      }
    } catch (error, t) {
      logger.e('Trace:::$t');
      onError(error, () {});
    }
  }

  Future<void> createBusinessChat() async {
    try {
      onUpdate(status: Status.LOADING_MORE);
      Map<String, dynamic> body = {
        'u_one': app.user.id,
        'u_two': bussiness.value.id,
        'type': 2,
      };
      ResponseModel response = await net.post(UrlConst.createChat, body);
      if (response.isSuccess) {
        ChatDetailsModel detailedChat =
            ChatDetailsModel.fromJson(response.data ?? {});
        detailedChat.user = bussiness.value.getFakeUser;
        ChatModel chatUser = ChatModel(
          chatID: '${detailedChat.id}',
          sender_id: app.user.id.toString(),
          message_type: 1,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          last_message: '',
          users: <String>[
            jsonEncode({
              'isBusiness': false,
              'id': app.user.id.toString(),
            }),
            jsonEncode({
              'isBusiness': true,
              'id': bussiness.value.id.toString(),
            }),
          ],
          chatUser: bussiness.value.getFakeUser,
        );
        chatUser.chatUser!.isBusiness = true;
        String messageDocID =
            FirebaseFirestore.instance.collection('messages').doc().id;
        MessageModel messageUser = MessageModel(
          created_at: DateTime.now(),
          sender_id: app.user.id.toString(),
          status: 1,
          message: 'hi',
          message_type: 1,
        );
        if (response.message != 'chat_id already exist') {
          logger.v(
              'Adding data to chat\n doc -> ${'${response.data}'}\ndata -> ${chatUser.toJson()}');
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
        onUpdate(status: Status.SCUSSESS);
        Get.toNamed(Routes.InBoxScreen, arguments: chatUser);
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(e.toString(), () {
        createBusinessChat();
      });
    }
  }

  void startLiveLocation() async {
    await _updateLocation();
    RxInt hourlyStop = 0.obs;
    animate();

    liveUsers.add(
      LiveLocationModel(
        id: FirebaseAuth.instance.currentUser!.uid,
        description: '${descriptionController.text.trim()}',
        image: app.user.imageUrl,
        lat: app.currentPosition.latitude,
        long: app.currentPosition.longitude,
        userId: app.user.id,
        isLive: true,
        userName: app.user.fullName,
        createdAt: FieldValue.serverTimestamp(),
      ),
    );
    liveUsers.forEach((LiveLocationModel user) async {
      markers.removeWhere(
        (Marker marker) {
          return marker.markerId.value == user.id;
        },
      );

      user.marker = Marker(
        markerId: MarkerId('${user.userId}'),
        position: LatLng(user.lat, user.long),
        icon: await MarkerIcon.downloadResizePictureCircle(
          user.image,
          size: 90,
          addBorder: true,
          borderColor: Colors.white,
          borderSize: 9,
        ),
        onTap: () {
          customBottomSheet(
            child: LiveLocationBottomSheet(
              user: user,
            ),
          );
        },
      );
      logger.w(animationController);
      if (user.isLive && animationController != null) {
        liveMarkers.add(
          user.marker,
        );
      }
    });
    onUpdate();
    timer = Timer.periodic(
      Duration(seconds: 5),
      (Timer timer) async {
        hourlyStop(hourlyStop.value + 5);
        logger.d('hourlyStop ${hourlyStop.value}');
        await _updateLocation();
        if (hourlyStop.value == 3600) {
          stopLiveLocation();
          hourlyStop(0);
        }
      },
    );
    onUpdate();
  }

  void stopLiveLocation() async {
    await stopAnimation();
    descCount.value = 0;
    descriptionController.clear();
    liveMarkers.clear();
    await _updateLocation(false);
    timer.cancel();
  }

  Future<void> getMap() async {
    try {
      if (userFilters.isEmpty && businessFilters.isEmpty) {
        onUpdate(
          status: (markers.isEmpty && tempMarkers.isEmpty)
              ? Status.LOADING
              : Status.LOADING_MORE,
        );
      }

      Map<String, dynamic> params = {
        'lat': movementLatLong.latitude,
        'lang': movementLatLong.longitude,
        if (businessFilters.isNotEmpty &&
            userFilters.isEmpty) ...<String, dynamic>{
          'user_cat_id': 0,
        } else ...<String, dynamic>{
          'user_cat_id': userFilters.join(','),
        },
        if (businessFilters.isEmpty &&
            userFilters.isNotEmpty) ...<String, dynamic>{
          'business_cat_id': 0,
        } else ...<String, dynamic>{
          'business_cat_id': businessFilters.join(','),
        },
        'apikey': app.user.apikey,
        'token': app.user.token,
      };
      logger.w(params);
      ResponseModel res = await net.get(UrlConst.getMap, params);
      if (res.isSuccess) {
        mapModel.value = MapModel.fromJson(res.data ?? {});
        logger.w('GET MAP:::${businessFilters.length}=====${userFilters.length}');
        /*if (businessFilters.isNotEmpty || userFilters.isNotEmpty) {
          markers.clear();
        }*/
        markers.clear();
        _getMarkers();

        onUpdate(status: Status.SCUSSESS);
      } else {
        if (res.message != 'No Data Found') {
          throw res.message;
        } else {
          onUpdate(status: Status.SCUSSESS);
        }
      }
    } catch (e) {
      onError(e.toString(), getMap);
    }
  }

  Future<void> searchLocation() async {
    try {
      Position? location;
      onUpdate(status: Status.LOADING_MORE);
      if (searchController.text.toLowerCase().contains('surf school')) {
        catId = 1;
        isBusinessSearch = true;
      } else if (searchController.text
          .toLowerCase()
          .contains('going surfing')) {
        catId = 1;
        isBusinessSearch = false;
      } else if (searchController.text.toLowerCase().contains('surf shop')) {
        catId = 2;
        isBusinessSearch = true;
      } else if (searchController.text.toLowerCase().contains('surf trip') ||
          searchController.text.toLowerCase().contains('rideshare')) {
        catId = 2;
        isBusinessSearch = false;
      } else if (searchController.text
          .toLowerCase()
          .contains('surf accommodation')) {
        catId = 3;
        isBusinessSearch = true;
      } else if (searchController.text.toLowerCase().contains('meet others')) {
        isBusinessSearch = false;
        catId = 3;
      } else if (searchController.text
          .toLowerCase()
          .contains('wanting photographer')) {
        catId = 4;
        isBusinessSearch = false;
      } else if (searchController.text.toLowerCase().contains('surf camp')) {
        catId = 4;
        isBusinessSearch = true;
      } else if (searchController.text.toLowerCase().contains('photographer')) {
        catId = 5;
        isBusinessSearch = true;
      } else if (searchController.text.toLowerCase().contains('buy and sell')) {
        catId = 5;
        isBusinessSearch = false;
      }
      if (searchController.text.toLowerCase().contains('me ')) {
        location = app.currentPosition;
      } else if (searchController.text.toLowerCase().contains('near ') ||
          searchController.text.toLowerCase().contains('in ')) {
        await getLocationFromMap();
        if (addressModel.results.isNotEmpty) {
          final foo = addressModel.results.first.geometry.location;
          location = Position(
            headingAccuracy: 0,
            altitudeAccuracy: 0,
            latitude: foo.lat,
            longitude: foo.lng,
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            floor: 0,
            isMocked: false,
            timestamp: DateTime.now(),
          );
          searchController.clear();
        }
      }

      Map<String, dynamic> params = <String, dynamic>{
        if (searchController.text.isNotEmpty) 'search': searchController.text,
        if (catId != 0) 'cat_id': catId,
        'lat': location?.latitude ?? app.currentPosition.latitude,
        'lang': location?.longitude ?? app.currentPosition.longitude,
      };
      ResponseModel res = await net.get(UrlConst.searchLocation, params);
      logger.wtf(res.toJson());
      if (res.isSuccess) {
        searchMapModel = MapModel.fromJson(res.data ?? {}).obs;
        location = null;
        catId = 0;
        onUpdate(status: Status.SCUSSESS);
      } else {
        if (res.message != 'No Data Found') {
          throw res.message;
        } else {
          onUpdate(status: Status.SCUSSESS);
        }
      }
    } catch (e) {
      onError(e.toString(), getMap);
    }
  }

  void animate() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animationController?.repeat(reverse: true);
    animation = Tween<double>(
      begin: 2.0,
      end: 15.0,
    ).animate(animationController!)
      ..addListener(
        () {
          liveLocationRadius.value = animation?.value ?? 13.0;
          // update();
        },
      );
  }

  Future<void> stopAnimation() async {
    liveLocationRadius.value = 13.0;
    if (animation != null) {
      animationController?.dispose();
      await _updateLocation(false);
      animation?.removeListener(
        () {
          update();
        },
      );
      animationController = null;
      animation = null;
      update();
    }
  }

  Future<void> getDropInList() async {
    try {
      onUpdate(status: Status.LOADING);
      ResponseModel res = await net.get(UrlConst.getDropIn, {});
      if (res.isSuccess) {
        List<DropCategoryModel> foo = List<DropCategoryModel>.from(
          (res.data ?? []).map(
            (e) => DropCategoryModel.fromJson(e),
          ),
        );
        dropInList.addAll(foo);

        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
      onUpdate(status: Status.SCUSSESS);
    } catch (e) {
      // onError(e.toString(), getCategoryApi);
    }
  }

  Future<void> getSearchList() async {
    try {
      onUpdate(status: Status.LOADING);

      ResponseModel res = await net.get(UrlConst.getSearchApi, {});
      logger.wtf(res.toJson());
      if (res.isSuccess) {
        logger.v(res.data);
        mapModel.value = MapModel.fromJson(res.data ?? {});
        _getMarkers();
        onUpdate(status: Status.SCUSSESS);
      } else {
        if (res.message != 'No Data Found') {
          throw res.message;
        } else {
          onUpdate(status: Status.SCUSSESS);
        }
      }
    } catch (e) {
      onError(e.toString(), getSearchList);
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
      onError(e.toString(), () {
        dropInGetId(id: id);
      });
    }
  }

  Future<void> getBussinessByID(int id) async {
    try {
      onUpdate(status: Status.LOADING_MORE);
      Map<String, dynamic> params = {'id': id};
      ResponseModel res = await net.get(UrlConst.getbyIdBussiness, params);
      if (res.isSuccess) {
        logger.d(res.toJson());
        // if (app.bussiness.id != 0) {
        bussiness.value = BussinessModel.fromJson(res.data ?? {});
        app.bussiness = bussiness.value;
        logger.w(bussiness.value.toJson());
        onUpdate(status: Status.SCUSSESS);
        // }
        // Get.toNamed(Routes.ViewBussinessScreen);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(
        e.toString(),
        () {
          getBussinessByID;
        },
      );
    }
  }

  Future<void> addBussinessRate(double rating) async {
    try {
      Map<String, dynamic> body = {
        'business_id': bussiness.value.id,
        'rate': rating,
      };
      logger.i('body =>${body}');

      ResponseModel response = await net.post(UrlConst.addBussinessRate, body);

      if (response.isSuccess) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        final BusinessRating rating =
            BusinessRating.fromJson(response.data ?? {});
        bussiness.value.ratedByCount = rating.rated_by_count;
        bussiness.value.businessRating = rating.business_rating;
        rate = 1.0;
        Get.snackbar(
          'Business rated',
          '',
          backgroundColor: AppColors.appButtonColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        logger.wtf(rating.toJson());
        onUpdate(status: Status.SCUSSESS);
        Get.back();
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(
        e.toString(),
        () => addBussinessRate(rating),
      );
    }
  }
}
