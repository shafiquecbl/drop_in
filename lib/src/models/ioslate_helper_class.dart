import 'dart:isolate';

import '../../src_exports.dart';

class IsolateHelperClass {
  IsolateHelperClass({
    required this.sendPort,
    this.isLive = false,
    this.description = '',
    this.user,
    this.firebaseUserId = '',
  }) {
    user ??= UserModel();
  }

  final SendPort sendPort;
  final bool isLive;
  final String description;
  UserModel? user;
  String firebaseUserId;
}
