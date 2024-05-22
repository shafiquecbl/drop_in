import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropin/firebase_options.dart';
import 'package:dropin/src/models/bussiness_model.dart';
import 'package:dropin/src/service/NotificationService.dart';
import 'package:dropin/src/service/network_service.dart';
import 'package:dropin/src/utils/widgets/common_functions.dart';
import 'package:dropin/src_exports.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/address_model.dart';
import 'package:dio/dio.dart' as dio;

import '../models/autocomplete_address_model.dart';
import '../models/place_api_model.dart';

final AppService app = Get.find<AppService>();

class AppService extends BaseController {
  static final AppService instance = AppService();
  bool isBusiness = false;
  LatLng pickedLocation = LatLng(0.0, 0.0);
  bool showDialog = false;
  String currentAddress = '';

  Position currentPosition = Position(
    headingAccuracy: 0,
    altitudeAccuracy: 0,
    longitude: 10.1,
    latitude: 10.1,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  UserModel user = UserModel();

  BussinessModel get bussiness => user.bussiness!;

  set bussiness(BussinessModel b) {
    user.bussiness = b;
  }

  String packageName = 'Not Available';
  String packageVersion = '0.0.0+0';
  String path = '';
  String deviceModel = 'Not Available';
  String deviceOs = 'Not Available';
  RxBool showBusinessChat = false.obs;
  RxInt totalUnReadCount = 0.obs;
  StreamController<QuerySnapshot?> streamController = StreamController();
  StreamController<QuerySnapshot?> streamController1 = StreamController();

  @override
  Future<void> onInit() async {
    await init();
    super.onInit();
  }

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    NotificationService().fcmInit();
    await getPackageInfo();
    Get.put(PrefService());

    await GetStorage.init();
    var tempUser = prefs.getValue(key: 'user');
    logger.i('user-?>>>>>>$tempUser');

    user = UserModel.fromJson(tempUser ?? {});
    await net.init(user);
    if (!kIsWeb) {
      try {
        logger.w('Getting location ${app.user.id}');
        if (app.user.id != 0) {
          logger.w('Getting location call');
          await determinePosition();
        }
      } catch (e) {
        logger.e(e.toString());
      }
    }
    logger.w('Total Unread Count:::${totalUnReadCount.value}');
  }

  /// this api will get address from lat long
  Future<String> getAddress({
    required double lat,
    required double long,
  }) async {
    String url = UrlConst.addressGetFromText;
    onUpdate(status: Status.LOADING_MORE);
    try {
      Response response = await dio.Dio().get(url + '$lat,$long');
      logger.wtf(response.data);
      if (response.data['status'] == 'OK') {
        final AddressResults address = AddressResults.fromJson(response.data);
        if (address.results.isNotEmpty) {
          currentAddress = address.results.first.formattedAddress;
        } else {
          showSnackBar('No address found');
        }
      } else if (response.data['status'] == 'ZERO_RESULTS') {
        showSnackBar('No address found');
      }
    } catch (e) {}

    return currentAddress;
  }

  Future<void> networkCheck() async {
    await 2.delay();
    await Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      logger.i('Network-Connection: $result');
      if (result == ConnectivityResult.none) {
        Get.showSnackbar(
          GetSnackBar(
            messageText: Text(
              'Network Issue: Reconnect',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            borderRadius: 5,
            duration: Duration(seconds: 2),
            animationDuration: Duration.zero,
            backgroundColor: Colors.white.withOpacity(0.7),
            margin: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: Get.height * 0.4,
            ),
          ),
        );
      }
    });
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    packageName = packageInfo.packageName;
    app.packageVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    currentPosition = await Geolocator.getCurrentPosition();

    logger.w(currentPosition);
  }

  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    switch (Platform.operatingSystem) {
      case 'android':
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceModel = androidInfo.model;
        deviceOs = '${androidInfo.version}';
        break;
      case 'ios':
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceModel = iosInfo.utsname.machine ?? 'Unknown';
        deviceOs = '${iosInfo.systemName} (${iosInfo.systemVersion})';
        break;
      default:
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        deviceModel = webBrowserInfo.userAgent ?? 'Unknown';
        deviceOs = Platform.operatingSystemVersion;
    }
  }

  Future<AutoCompleteAddress> getLocationFromMap(
    String searchText,
    String uuid,
  ) async {
    AutoCompleteAddress addressModel = AutoCompleteAddress();
    String url =
        '${UrlConst.autoComplete}${searchText.trim()}&sessiontoken=$uuid';
    if (searchText.trim().isNotEmpty) {
      onUpdate(status: Status.LOADING_MORE);
      try {
        logger.w(url);
        Response response = await dio.Dio().get(url);
        logger.i(url + searchText.trim() + '&sessiontoken=$uuid');
        if (response.data['status'] == 'OK') {
          addressModel = AutoCompleteAddress.fromJson(response.data);
          onUpdate(status: Status.SCUSSESS);
        } else if (response.data['status'] == 'ZERO_RESULTS') {
          throw 'No results found for specified location';
        } else {
          throw 'Something went wrong';
        }
      } catch (error, t) {
        onError(
          error.toString(),
          () => getLocationFromMap(searchText, uuid),
        );
      }
    }
    return addressModel;
  }

  Future<PlaceApiModel> getLocationFromPlaceID(String placeId) async {
    PlaceApiModel addressModel = PlaceApiModel();
    String url = UrlConst.placeId;
    onUpdate(status: Status.LOADING_MORE);
    try {
      Response response = await dio.Dio().get(url + placeId);
      logger.i(url + placeId.trim());
      logger.wtf(response.data);
      if (response.data['status'] == 'OK') {
        addressModel = PlaceApiModel.fromJson(response.data);
        onUpdate(status: Status.SCUSSESS);
      } else if (response.data['status'] == 'ZERO_RESULTS') {
        throw 'No results found for specified location';
      } else {
        throw 'Something went wrong';
      }
    } catch (error, t) {
      onError(
        error.toString(),
        () => getLocationFromPlaceID(placeId),
      );
    }
    return addressModel;
  }

  /*Future<void> getUnreadCountStream() async {
    logger.i('getUnreadCountStream on');
    streamController.add(
      await FirebaseFirestore.instance
          .collection('chat')
          .where(
            'users',
            arrayContains: jsonEncode(<String, Object>{
              'isBusiness': false,
              'id': app.user.id.toString(),
            }),
          )
          .get(),
    );

    streamController1.add(
      await FirebaseFirestore.instance
          .collection('chat')
          .where(
            'users',
            arrayContains: jsonEncode(<String, Object>{
              'isBusiness': true,
              'id': app.bussiness.id.toString(),
            }),
          )
          .get(),
    );
  }*/

  /*Future<void> getUnReadCount() async {
    streamController.stream.listen((event) {
      logger.w('Stream listening ${event!.size}');
      if (event.size > 0) {
        logger.w('Snap Data::${event.docs.toList()}');
        List<ChatModel> chat = List<ChatModel>.from(
          event.docs.map((e) =>
              ChatModel.fromJson(e.data() as Map<String, dynamic>, false)),
        );
        logger.wtf('PROFILE UNREAD:::${profileUnread}');
        profileUnread = chat.where((element) => element.unreadCount > 0).length;
        logger.wtf('PROFILE UNREAD:::${profileUnread}');
      }
    });

    streamController1.stream.listen((event) {
      logger.w('Stream 1 listening ${event!.size}');
      if (event.size > 0) {
        logger.w('Snap Data 111::${event.docs.toList()}');
        List<ChatModel> chat = List<ChatModel>.from(
          event.docs.map((e) =>
              ChatModel.fromJson(e.data() as Map<String, dynamic>, true)),
        );
        businessUnread =
            chat.where((element) => element.unreadCount > 0).length;
        logger.wtf('BUSINESS UNREAD:::${businessUnread}');
      }
    });
  }*/
}
