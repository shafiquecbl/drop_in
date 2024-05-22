import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:dropin/src/models/map_model.dart';
import 'package:universal_html/html.dart' as html;
import '';
import 'package:dropin/src/module/base_controller.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

// import 'package:number_paginator/number_paginator.dart';
import '../../../src/models/bussiness_model.dart';
import '../../../src/models/news_feed_model.dart';
import '../../../src/models/staticetics_model.dart';
import '../../../src/service/network_service.dart';
import '../../../src_exports.dart';

import '../../../src_exports.dart';

class ProfileCtrl extends BaseController {
  RxBool isShow = false.obs;
  RxBool showvalue = false.obs;
  RxList<UserModel> user = <UserModel>[].obs;
  RxList<UserModel> searchUserList = <UserModel>[].obs;
  Rx<UserModel> users = UserModel().obs;

  RxInt isUserIndex = 0.obs;
  RxInt isBusinessIndex = 0.obs;

  ///Used for pagination
  double numberOfPageForUser = 0;
  double numberOfPageForBusiness = 0;

  // NumberPaginatorController numberPageController = NumberPaginatorController();

  int numberOfPage = 10;
  RxInt currentPage = 0.obs;
  int totalPages = 0;
  RxInt count = 1.obs;
  TextEditingController searchController = TextEditingController();
  TextEditingController searchControllerBusiness = TextEditingController();

  RxList<BussinessModel> businessList = <BussinessModel>[].obs;
  RxList<BussinessModel> searchBusinessList = <BussinessModel>[].obs;
  Rx<StatModel> statisticsModel = StatModel().obs;
  Rx<NewsFeedModel> news = NewsFeedModel().obs;

  final List<ChartData> chartData = <ChartData>[];
  final List<ChartData> chartData1 = <ChartData>[];

  @override
  void onInit() {
    getAllUsers();
    getAllUsers(isUser: false);
    statisticAnalytics();

    super.onInit();
  }

  @override
  void onReady() {
    count.refresh();
    super.onReady();
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.selected,
      MaterialState.focused,
      MaterialState.pressed,
    };
    if (states.any(interactiveStates.contains)) {
      return AppColors.selectdeaweclr;
    }
    return AppColors.appWhiteColor;
  }

  RxString selectedBusiness = 'Date Created Newest'.obs;

  RxList<TileModel> get tileModelBussiness => <TileModel>[
        TileModel(
          title: 'Date Created Newest',
          callback: () {
            getAllUsers(isUser: false, s_type: 1);
            selectedBusiness('Date Created Newest');
          },
        ),
        TileModel(
          title: 'Date Created Oldest',
          callback: () {
            getAllUsers(isUser: false, s_type: 2);
            selectedBusiness('Date Created Oldest');
          },
        ),
        TileModel(
          title: 'Rating Highest',
          callback: () {
            getAllUsers(isUser: false, s_type: 3);
            selectedBusiness('Rating Highest');
          },
        ),
        TileModel(
          title: 'Total Visits Highest',
          callback: () {
            getAllUsers(isUser: false, s_type: 4);
            selectedBusiness('Total Visits Highest');
          },
        ),
        TileModel(
          title: 'Category',
          callback: () {
            getAllUsers(isUser: false, s_type: 5);
            selectedBusiness('Category');
          },
        ),
        TileModel(
          title: 'Blocked Email',
          callback: () {
            getAllUsers(isUser: false, s_type: 6);
            selectedBusiness('Blocked Email');
          },
        ),
      ].obs;

  RxString selected = 'Blocked Email'.obs;

  RxList<TileModel> get tileModelUser => <TileModel>[
        TileModel(
          title: 'Date Created Newest',
          callback: () {
            getAllUsers(s_type: 1);
            selected('Date Created Newest');
          },
        ),
        TileModel(
          title: 'Date Created Oldest',
          callback: () {
            getAllUsers(s_type: 2);
            selected('Date Created Oldest');
          },
        ),
        TileModel(
          title: 'Reported Most',
          callback: () {
            getAllUsers(s_type: 5);
            selected('Reported Most');
          },
        ),
        TileModel(
          title: 'Liked Most',
          callback: () {
            getAllUsers(s_type: 4);
            selected('Liked Most');
          },
        ),
        TileModel(
          title: 'Blocked Email',
          callback: () {
            getAllUsers(s_type: 3);
            selected('Blocked Email');
          },
        ),
      ].obs;

  Future<void> getAllUsers({
    bool isUser = true,
    int s_type = 0,
    int paginationCount = 0,
  }) async {
    try {
      onUpdate(status: Status.LOADING);

      // }
      Map<String, dynamic> params = {
        'type': isUser ? 1 : 2,
        'count': paginationCount,
        's_type': s_type,
      };
      logger.v(params);
      ResponseModel res = await net.get(UrlConst.getAllUsers, params);

      await count(res.c.ceil());
      logger.e('RESPONSE>>>>>>>$count');

      if (res.isSuccess) {
        if (isUser) {
          List<UserModel> foo = List<UserModel>.from(
            (res.data ?? []).map(
              (e) => UserModel.fromJson(e),
            ),
          );

          user.clear();
          user.addAll(foo);
          logger.w(currentPage);
          numberOfPageForUser = res.c;
        } else {
          List<BussinessModel> foo = List<BussinessModel>.from(
            (res.data ?? []).map(
              (e) => BussinessModel.fromJson(e),
            ),
          );

          businessList.clear();
          businessList.addAll(foo);
          numberOfPageForBusiness = res.c;
        }
        logger.wtf(user.toJson());

        onUpdate(status: Status.SCUSSESS);
      } else {}
      onUpdate(status: Status.SCUSSESS);
    } catch (e) {
      onError(e.toString(), getAllUsers);
    }
  }

  ///Delete user node function
  Future<void> deleteFirebaseUser(
      {required String fId, required int userId}) async {
    onUpdate(status: Status.LOADING);
    Get.back();
    logger.i('DELETEFIREBASEUSER::::::${fId}-----${userId}');
    HttpsCallable callable = await FirebaseFunctions.instance
        .httpsCallableFromUri(
            Uri.parse('https://deleteuser-abf527n5cq-uc.a.run.app?uid=$fId'));
    /*HttpsCallable callable = await FirebaseFunctions.instance.httpsCallable(
      'deleteUser',
    );*/
    logger.wtf('FirebaseFunctions::::${callable}');
    try {
      HttpsCallableResult<dynamic> result = await callable();
      logger.w('HTTPSCALL::::${result.data}');
      if (result.data['s'] == 1) {
       await deleteUser(id: userId);
        Get.snackbar(
          'success'.tr,
          result.data['m'],
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Failed',
          result.data['m'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return (result.data);
    } on FirebaseFunctionsException catch (e) {
      logger.e('Caught firebase functions exception---->> ${e}');
      return null;
    } catch (e) {
      logger.e('caught generic exception');
      logger.e(e);
      return null;
    }
  }

  Future<void> statisticAnalytics() async {
    try {
      onUpdate(status: Status.LOADING);
      ResponseModel res = await net.get(UrlConst.statistic, {});
      logger.d(res.data);
      if (res.isSuccess) {
        statisticsModel.value = StatModel.fromJson(res.data);
        logger.wtf(statisticsModel.toJson());
        // List<ChartData> foo = List<ChartData>.from(
        //   (res.data ?? []).map(
        //         (e) => ChartData(data),
        //   ),
        // );

        // List<ChartData> data = [
        //   ChartData('Active Users', statisticsModel.value.activeUsers,
        //       AppColors.barcolor),
        //   ChartData(
        //     'Total DropIn',
        //     statisticsModel.value.totalDropins,
        //     AppColors.barcolor1,
        //   ),
        // ];

        chartData.add(
          ChartData(
            'Active Users',
            statisticsModel.value.activeUsers,
            AppColors.barcolor,
          ),
        );
        chartData1.add(
          ChartData(
            'Total DropIn',
            statisticsModel.value.totalDropins,
            AppColors.barcolor1,
          ),
        );

        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), statisticAnalytics);
    }
  }

  Future<void> getUserById({required int id}) async {
    try {
      onUpdate(status: Status.LOADING);
      // 'id': Get.arguments ?? 0
      Map<String, dynamic> params = {'id': id};
      ResponseModel res = await net.get(UrlConst.userGetById, params);
      logger.w(Get.arguments);
      if (res.isSuccess) {
        UserModel tempUser = UserModel.fromJson(res.data ?? {});

        logger.v(res.data);
        users.value = tempUser;
        onUpdate(status: Status.SCUSSESS);

        // logger.wtf(app.user);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), () {
        getUserById(id: id);
      });
    }
  }

  Future<void> userLike({required UserModel user}) async {
    try {
      Map<String, dynamic> params = {
        'from_user': app.user.id,
        'to_user': user.id,
      };
      // onUpdate(status: Status.LOADING);
      ResponseModel res = await net.post(UrlConst.userLike, params);
      if (res.isSuccess) {
        user.is_like = !user.is_like;

        if (user.is_like) {
          logger.i(user.like_count);
          user.like_count++;
          logger.i(user.like_count);
        } else {
          user.like_count--;
        }
        onUpdate();
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(
        e,
        () {
          userLike(user: user);
        },
      );
    }
  }

  Future<void> profileSetupsBlockEmailAndUser({
    bool isBlock = true,
    int id = 0,
  }) async {
    try {
      onUpdate(status: Status.LOADING);

      Map<String, dynamic> body = {
        'status': isBlock ? -1 : 1,
        'uid': id,
      };

      logger.i(body);
      ResponseModel response = await net.post(UrlConst.profileSetup, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        Get.back();
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(
        e.toString(),
        () {
          profileSetupsBlockEmailAndUser();
        },
      );
    }
  }

  Future<void> deleteUser({int id = 0}) async {
    try {
      onUpdate(status: Status.LOADING);

      Map<String, dynamic> body = {
        'status': 0,
        'uid': id,
      };

      logger.i(body);
      ResponseModel response = await net.post(UrlConst.profileSetup, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        user.removeWhere((UserModel element) => element.id == id);
        Get.back();
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(
        e.toString(),
        () {
          deleteUser(id: id);
        },
      );
    }
  }

  Future<void> DeleteBussiness({required int id}) async {
    try {
      onUpdate(status: Status.LOADING_MORE);

      Map<String, dynamic> body = {'id': id};
      ResponseModel response = await net.post(UrlConst.deleteBussiness, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        businessList.removeWhere((element) => element.id == id);
        onUpdate(status: Status.SCUSSESS);
        Get.back();
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

  Future<void> bussinessBlockEmail({
    bool isBlock = true,
    int id = 0,
    int s_type = 0,
  }) async {
    try {
      onUpdate(status: Status.LOADING);

      Map<String, dynamic> body = {
        's_type': s_type,
        'uid': id,
      };

      logger.i(body);
      ResponseModel response = await net.post(UrlConst.profileSetup, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        Get.back();
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(
        e.toString(),
        () {
          bussinessBlockEmail();
        },
      );
    }
  }

  void createCSV({
    required bool isUSER,
    required List<UserModel> userList,
    required List<BussinessModel> businessList,
  }) {
    List<String> rowHeader = isUSER == true
        ? <String>['Name', 'UserName', 'Email', 'DOB']
        : <String>[
            'First Name',
            'Business Name',
            'Email',
            'Location',
            'Category Name',
          ];
    List<List<dynamic>> rows = [];
    rows.add(rowHeader);

    if (isUSER == true) {
      for (int i = 0; i < userList.length; i++) {
        //everytime loop executes we need to add new row
        List<dynamic> dataRow = [];
        dataRow.add(userList[i].firstName + ' ' + userList[i].lastName);
        dataRow.add(userList[i].userName);
        dataRow.add(userList[i].email);
        dataRow.add(userList[i].country);
        dataRow.add(userList[i].skillLevel);
        rows.add(dataRow);
      }
    } else {
      for (int i = 0; i < businessList.length; i++) {
        //everytime loop executes we need to add new row
        List<dynamic> dataRow = [];
        dataRow.add(businessList[i].first_name);
        dataRow.add(businessList[i].businessName);
        dataRow.add(businessList[i].email);
        dataRow.add(businessList[i].location);
        dataRow.add(
          BusinessCategoryType.businessCategoryType(businessList[i].catId)
              .title,
        );
        rows.add(dataRow);
      }
    }

    String csv = const ListToCsvConverter().convert(rows);
    final List<int> bytes = utf8.encode(csv);
    final html.Blob blob = html.Blob([bytes]);
    final String url = html.Url.createObjectUrlFromBlob(blob);
    final html.AnchorElement anchor =
        html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = '${DateTime.now().millisecondsSinceEpoch}.csv';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> searchApi({
    bool isUser = true,
  }) async {
    try {
      onUpdate(status: Status.LOADING);

      Map<String, dynamic> params = {
        'type': isUser ? 1 : 2,
        'search': isUser ? searchController.text : searchControllerBusiness,
      };
      logger.v(params);

      ResponseModel res = await net.get(UrlConst.searchApi, params);
      logger.d(res.data);
      if (res.isSuccess) {
        if (isUser) {
          List<UserModel> foo = List<UserModel>.from(
            (res.data ?? []).map(
              (e) => UserModel.fromJson(e),
            ),
          );

          searchUserList.clear();
          searchUserList.addAll(foo);
          logger.w(currentPage);
        } else {
          List<BussinessModel> foo = List<BussinessModel>.from(
            (res.data ?? []).map(
              (e) => BussinessModel.fromJson(e),
            ),
          );
          searchBusinessList.clear();
          searchBusinessList.addAll(foo);
        }

        onUpdate(status: Status.SCUSSESS);
      }
    } catch (e) {
      onError(e.toString(), searchApi);
    }
  }
}

class TileModel {
  String title;
  final void Function()? callback;

  TileModel({
    required this.title,
    this.callback,
  });
}

class ChartData {
  ChartData(
    this.x,
    this.y,
    this.color,
  );

  final String x;
  final num y;
  final Color? color;
}
