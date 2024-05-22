import 'dart:convert';
import 'package:dropin/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../src_exports.dart';
import 'package:http/http.dart' as http;



Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  logger.e('Handling a background message ${message.messageId}');
  logger.e('Notification Message: ${message.data}');
  /*await FlutterLocalNotificationsPlugin().show(
    message.data.hashCode,
    message.data['title'],
    message.data['body'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channelId, channelId,
        //'channel_desc',
        priority: Priority.high,
        importance: Importance.max,
      ),
    ),
  );*/
}

class NotificationService {
  FirebaseMessaging? firebaseMessaging;
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String channelId = 'dropin_channel';

  DateTime d = DateTime.now();

  void fcmInit() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    try {
        AndroidNotificationDetails android = AndroidNotificationDetails(
          'dropin_channel', 'dropin_channel',
          //'channel_desc',
          priority: Priority.high,
          importance: Importance.max,
        );

        DarwinNotificationDetails iOS =
            const DarwinNotificationDetails(presentSound: true);

        NotificationDetails platform =
            NotificationDetails(android: android, iOS: iOS);

        const InitializationSettings settings = InitializationSettings(
          android: AndroidInitializationSettings('@drawable/logo'),
          iOS: DarwinInitializationSettings(defaultPresentSound: true),
        );

        await notificationsPlugin.initialize(
          settings,
          onDidReceiveNotificationResponse:
              (NotificationResponse payload) async {
            if (payload.payload != null) {
              Map<String, dynamic> msg = jsonDecode(payload.payload!);
              logger.d(msg);
            }
          },
        );

        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        await FirebaseMessaging.instance
            .getInitialMessage()
            .then((RemoteMessage? remoteMessage) async {
          if (remoteMessage != null && remoteMessage.data.isNotEmpty) {
            Map<String, dynamic> msg = remoteMessage.data;
            logger.d(msg, error: 'getInitialMessage');
          }
        });
        //IN UI
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          try {
            Map<String, dynamic> msg = message.data;
            await notificationsPlugin.show(
              d.year + d.month + d.day + d.hour + d.minute + d.second,
              message.notification!.title,
              message.notification!.body,
              platform,
              payload: json.encode(msg),
            );
            logger.d(msg, error: 'onMessage');
            // Get.toNamed(Routes.InBoxScreen);
          } catch (e, t) {
            logger.e('$e\n$t');
          }
        });

        FirebaseMessaging.onMessageOpenedApp
            .listen((RemoteMessage message) async {
          logger.e(message.toMap().toString(), error: 'onMessage');

          try {
            Map<String, dynamic> msg = message.data;
            logger.d(msg, error: 'onMessageOpenedApp');
          } catch (e) {
            logger.e(e);
          }
        });
    } catch (e, t) {
      logger.e('$e\n$t');
    }
  }

  Future<void> removeNotification() async {
    await notificationsPlugin.cancelAll();
  }


  String serverToken =
      'AAAAdrk8jVI:APA91bExjVrZcaHRd3Uo4dFsATs0p6Ee5NWWdTQnyN6-Af-DDtxtEnOefH4KSFtndFs6OvzbW5QWWPRVIKsmw8pSfWc9fd2h5Q_BPv6MiGASny8g9NzHNih-DqAJtnJzW8qfgfO86qi9';

  sendAndRetrieveMessage(
      {contactPushToken,
      title,
      message,
      required int type,
      dynamic Data}) async {
    // logger.v('NOTIFCATION ID => ${UniqueKey().hashCode}');
    logger.w('sendAndRetrieveMessage');
    await FirebaseMessaging.instance.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: false,
    );

    Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': '$message', 'title': title},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '${d.hour+d.minute+d.second}',
            'status': 'done',
            'sound': 'default',
            'body': message,
            'title': title,
            'type': type,
            'channelId': channelId,
          },
          'to': contactPushToken,
        },
      ),
    );
  }
}
