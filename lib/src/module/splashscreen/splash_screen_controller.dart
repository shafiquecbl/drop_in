import 'package:dropin/src/models/bussiness_model.dart';
import 'package:dropin/src/service/network_service.dart';
import 'package:dropin/src/utils/widgets/common_functions.dart';
import 'package:dropin/src_exports.dart';

class SplashScreenController extends BaseController {
  @override
  void onInit() async {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) async {
      await authCheck();
      await app.networkCheck();
    });
    super.onInit();
  }

  Future<void> authCheck() async {
    await 1.delay();
    var user = prefs.getValue(key: 'user');
    logger.w('user $user');
    print('user $user');
    if (user == null) {
      Get.offAllNamed(Routes.LoginScreen);
    } else {
      UserModel u = await getUserById(user['id']);
      if (u.id > 0) {
        app.user = u;
        net.init(app.user);
        Get.offAllNamed(Routes.HomeScreen);
      } else {
        prefs.removeValue('user');
        Get.offAllNamed(Routes.LoginScreen);
      }
    }
  }

  Future<UserModel> getUserById(int id) async {
    try {
      onUpdate(status: Status.LOADING);
      Map<String, dynamic> params = {'id': id};
      ResponseModel res = await net.get(UrlConst.userGetById, params);
      print('step-1---->>>>:${res.data}');
      if (res.isSuccess) {
        print('Data-getUserById:::${res.data}');
        if (res.data is Map) {
          UserModel tempUser = UserModel.fromJson(res.data ?? {});
          return tempUser;
        }else if(res.data == null){
          Get.snackbar(
            'Account Deleted',
            'Your account is deleted by admin, kindly contact admin.',
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 5),
            colorText: AppColors.appWhiteColor,
          );
          return UserModel();
        }
        onUpdate(status: Status.SCUSSESS);
        // logger.wtf(app.user);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), () {
        getUserById(id);
      });
    }
    return UserModel();
  }
}
