import 'package:dropin/src/module/base_controller.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../src/models/bussiness_model.dart';
import '../../../src/service/network_service.dart';
import '../../../src_exports.dart';

enum NavigationEnum {
  General,
  Settings,
  ChangePassword,
  ForgetPassword,
  Profiles,
  Statistic,
  Users,
  Businesses,
  Billing,
  Reports,
  ReportUser,
  ReportDropIn,
  /*ReportChat,*/
  SignOut
}

class AdminController extends BaseController {
  RxBool isShow = false.obs;
  RxBool isShowForReport = false.obs;
  RxBool selected = false.obs;
  RxInt selecteSubmanu = 0.obs;
  RxInt selecteSubmanuForReport = 0.obs;
  Rx<NavigationEnum> currentPage = NavigationEnum.General.obs;
  TextEditingController searchController = TextEditingController();

  RxList<UserModel> searchUserList = <UserModel>[].obs;
  RxList<BussinessModel> searchBusinessList = <BussinessModel>[].obs;

  Future<void> searchApi({
    bool isUser = true,
  }) async {
    try {
      onUpdate(status: Status.LOADING);

      Map<String, dynamic> params = {
        'type': 3,
        'search': searchController.text,
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
      } else {}
      onUpdate(status: Status.SCUSSESS);
    } catch (e) {
      onError(e.toString(), searchApi);
    }
  }
}
