import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../src_exports.dart';
import 'network_service.dart';

class FCM_services {
  static Future<String?> getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }

  static Future<String?> getToken() async {
    Future<String?> fcmToken = FirebaseMessaging.instance.getToken();
    return fcmToken;
  }

  Future<void> updateToken([bool isLogout = false]) async {
    String? deviceId = await getId();
    String? token = await getToken();
    if (deviceId != null && token != null) {
      try {
        Map<String, dynamic> body = {
          'deviceId': isLogout ? 0 : deviceId,
          'fcmToken': isLogout ? '' : token,
        };
        ResponseModel res = await net.post(UrlConst.postFCM, body);
        logger.w('updateToken ${res.data}');
        if (res.isSuccess) {
          logger.d('updateToken ${res}');
        } else {
          throw res.message;
        }
      } catch (e, t) {
        logger.e('error >>> $e \n trace >>> $t');
      }
    }
  }

  Future<List<String>> getFcmToken({required int id}) async {
    try {
      Map<String, dynamic> params = {
        'u_id': id,
      };
      ResponseModel res = await net.get(UrlConst.getFCM, params);
      if (res.isSuccess) {
        logger.w(res.data.map((e) => e['fcmToken']));
        return res.data.map((e) => e['fcmToken']).toList();
      } else {
        throw res.message;
      }
    } catch (e) {}
    return [];
  }
}
