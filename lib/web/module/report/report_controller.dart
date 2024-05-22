import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:dropin/src/models/report_model.dart';
import 'package:universal_html/html.dart' as html;
import '../../../src/models/news_feed_model.dart';
import '../../../src/service/network_service.dart';
import '../../../src_exports.dart';

class ReportController extends BaseController {
  RxBool isShow = false.obs;
  RxBool showvalue = false.obs;
  int numberOfPageForReport = 0;
  RxInt isReportIndex = 0.obs;
  Rx<NewsFeedModel> news = NewsFeedModel().obs;
  Rx<UserModel> reportedUser = UserModel().obs;

  RxList<ReportModel> reportedUsers = <ReportModel>[].obs;
  RxList<ReportModel> reportedDropins = <ReportModel>[].obs;
  RxList<ReportModel> reportedChats = <ReportModel>[].obs;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    getReportedUserList(
      type: 1,
    );
    getReportedUserList(
      type: 2,
    );
    super.onInit();
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.selected,
      MaterialState.focused,
      MaterialState.pressed,
    };
    if (states.any(interactiveStates.contains)) {
      return AppColors.appButtonColor;
    }
    return AppColors.appWhiteColor;
  }

  Future<void> getReportedUserList({
    int s_type = 0,
    int paginationCount = 0,
    int type = 1,
  }) async {
    try {
      onUpdate(status: Status.LOADING);
      Map<String, dynamic> params = {
        'type': type,
        'count': paginationCount,
        's_type': s_type,
      };
      ResponseModel res = await net.get(UrlConst.getReportUser, params);
      if (res.isSuccess) {
        List<ReportModel> foo = List<ReportModel>.from(
          (res.data ?? []).map(
            (e) => ReportModel.fromJson(e),
          ),
        );
        if (type == 1) {
          reportedUsers.addAll(foo);
        } else if (type == 2) {
          reportedDropins.addAll(foo);
        } else if (type == 3) {
          reportedChats.addAll(foo);
        }
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.data;
      }
    } catch (e) {
      onError(e.toString(), getReportedUserList);
    }
  }

  Future<void> searchApi() async {
    try {
      onUpdate(status: Status.LOADING);

      Map<String, dynamic> params = {
        'type': 1,
        'search': searchController.text,
      };
      logger.v(params);

      ResponseModel res = await net.get(UrlConst.searchApi, params);
      logger.d(res.data);
      if (res.isSuccess) {
        List<UserModel> foo = List<UserModel>.from(
          (res.data ?? []).map(
            (e) => UserModel.fromJson(e),
          ),
        );
        reportedUsers.clear();
        /*reportedUser.addAll(foo);*/

        onUpdate(status: Status.SCUSSESS);
      } else {}
      onUpdate(status: Status.SCUSSESS);
    } catch (e) {
      onError(e.toString(), searchApi);
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

  Future<void> getUserById({required int id}) async {
    try {
      onUpdate(status: Status.LOADING_MORE);
      Map<String, dynamic> params = {'id': id};
      ResponseModel res = await net.get(UrlConst.userGetById, params);
      logger.w(Get.arguments);
      if (res.isSuccess) {
        UserModel tempUser = UserModel.fromJson(res.data ?? {});
        logger.v(res.data);
        reportedUser.value = tempUser;
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), () {
        getUserById(id: id);
      });
    }
  }

  void createCSV({
    required List<UserModel> userList,
  }) {
    List<String> rowHeader = [
      'Owner First and Last Name',
      'Email Address',
      'Dropin Reported',
      'Chat Reported',
      'Total Account Reports'
    ];

    List<List<dynamic>> rows = [];
    rows.add(rowHeader);

    for (int i = 0; i < userList.length; i++) {
      //everytime loop executes we need to add new row
      List<dynamic> dataRow = [];
      dataRow.add(userList[i].firstName + userList[i].lastName);
      dataRow.add(userList[i].email);
      dataRow.add(userList[i].report_count);

      rows.add(dataRow);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final List<int> bytes = utf8.encode(csv);
    final html.Blob blob = html.Blob([bytes]);
    final String url = html.Url.createObjectUrlFromBlob(blob);
    final html.AnchorElement anchor =
        html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = 'Record.csv';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }
}

class TileModel {
  TileModel({
    required this.title,
    required this.onTap,
  });

  String title;
  void Function() onTap;
}
