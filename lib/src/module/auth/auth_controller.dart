import 'package:dropin/src/service/device_info.dart';
import 'package:dropin/src/utils/widgets/common_functions.dart';
import 'package:dropin/src_exports.dart';

import '../../models/check_usermodel.dart';
import '../../service/network_service.dart';

class AuthController extends BaseController {
  bool isTextFieldError = false;
  final GlobalKey<AppTextFieldState> uNameKey = GlobalKey<AppTextFieldState>();
  final GlobalKey<AppTextFieldState> signUpkey = GlobalKey<AppTextFieldState>();
  final GlobalKey<AppTextFieldState> webUpkey = GlobalKey<AppTextFieldState>();

  RxBool showPassword = false.obs;
  RxBool forgotPassword = false.obs;
  RxBool showloginpass = false.obs;
  RxBool showloginusername = false.obs;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController forgetEmailController = TextEditingController();
  TextEditingController firstNameCTRL = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController lastNameCTRL = TextEditingController();
  TextEditingController passwordCTRL = TextEditingController();

  TextEditingController conformpasswordCTRL = TextEditingController();
  TextEditingController conformnewPasswordCTRL = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController signupPasswordCTRL = TextEditingController();
  TextEditingController uNameController = TextEditingController();
  TextEditingController loginUNameController = TextEditingController();

  RxBool verify = false.obs;
  RxBool showvalue = false.obs;
  RxBool isValidate = false.obs;
  RxBool edit = false.obs;
  RxBool isUnameAvailable = false.obs;

  CheckUser checkUser = CheckUser();

  @override
  void onInit() async {
    if (kIsWeb) {
      if (kDebugMode) {
        webEmailController.text = 'admin@dropin.com';
        webPasswordController.text = '12345678';
      }
    }
    super.onInit();
  }

  bool isVerifyed() {
    if (signupEmailController.text.isNotEmpty ||
        firstNameCTRL.text.isNotEmpty ||
        lastNameCTRL.text.isNotEmpty ||
        passwordCTRL.text.isNotEmpty ||
        conformpasswordCTRL.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool isVerifyLogin() {
    if (loginUNameController.text.isNotEmpty || passwordCTRL.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isVerifyedWeb() async {
    if (loginUNameController.text.isNotEmpty || passwordCTRL.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
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

  FirebaseAuth _auth = FirebaseAuth.instance;

  ///Login Api
  Future<void> loginWithEmail() async {
    try {
      await checkUserName(loginUNameController.text);
      logger.w('USERNAME AVAIALABLE::::${isUnameAvailable.value}');
      if (isUnameAvailable.isFalse) {
        onUpdate(status: Status.LOADING);
        logger.w('CHECK USER------${checkUser.toJson()}');
        UserCredential fbUser = await _auth.signInWithEmailAndPassword(
          email: checkUser.email,
          password: passwordCTRL.text.trim(),
        );
        logger.w('FIREBASE--USER:::${fbUser.user!}');
        await app.determinePosition();
        Map<String, dynamic> body = {
          'f_id': fbUser.user?.uid ?? '',
        };
        ResponseModel response = await net.post(UrlConst.login, body);
        if (response.isSuccess) {
          logger.i('User-Login::${response.data}');
          UserModel tempUser = UserModel.fromJson(response.data ?? {});
          logger.i('User-Login2222::${tempUser.toJson()}');
          logger.v("FID=>${_auth.currentUser?.uid ?? ''}");
          Get.put(PrefService());
          prefs.setValue(key: 'user', value: tempUser.toJson());
          net.init(tempUser);
          logger.w(tempUser.toJson());
          app.user = tempUser;
          onUpdate(status: Status.SCUSSESS);
          Get.offAllNamed(Routes.HomeScreen);
          FCM_services().updateToken();
        } else {
          throw response.message;
        }
      } else {
        throw 'No account with this username';
      }
    } on FirebaseAuthException catch (e) {
      logger.e(e.code);
      if (e.code == 'weak-password') {
        onError('This is weak password', () {});
      } else if (e.code == 'email-already-in-use') {
        onError('Account already exist with this account', () {});
      } else if (e.code == 'user-not-found') {
        onError('No account exist with this email address', () {});
      } else {
        onError(e.message, () {});
      }
    } catch (e) {
      onError(e.toString(), loginWithEmail);
    }
  }

  Future<void> checkUserName(String uName) async {
    try {
      final Map<String, dynamic> param = {
        'check': uName,
      };
      ResponseModel res = await net.post(UrlConst.checkUser, param);
      if (res.isSuccess) {
        logger.w('Username unavailable');
        isUnameAvailable.value = false;
        checkUser = CheckUser.fromJson(res.data ?? {});
        update();
      } else {
        logger.w('Username available');
        isUnameAvailable.value = true;
        // checkUser = CheckUser.fromJson(res.data ?? {});
        update();
      }
    } catch (e) {
      onError(e, () {
        checkUserName(uName);
      });
    }
  }

  ///SignUp Api
  Future<void> createAccountWithEmailAndPassword() async {
    try {
      if (isUnameAvailable.isTrue) {
        onUpdate(status: Status.LOADING);
        await app.determinePosition();
        await _auth.createUserWithEmailAndPassword(
          email: signupEmailController.text,
          password: signupPasswordCTRL.text,
        );
        Map<String, dynamic> body = {
          'email': signupEmailController.text.trim(),
          'f_id': _auth.currentUser?.uid ?? '',
          'first_name': firstNameCTRL.text.trim(),
          'last_name': lastNameCTRL.text.trim(),
          'user_name': uNameController.text.trim().toLowerCase(),
          'lat': app.currentPosition.latitude,
          'lang': app.currentPosition.longitude,
          'password': signupPasswordCTRL.text.trim(),
        };
        ResponseModel response = await net.post(UrlConst.signUp, body);
        if (response.isSuccess) {
          final UserModel tempUser = UserModel.fromJson(response.data);
          net.init(tempUser);
          logger.v("FID=>${_auth.currentUser?.uid ?? ''}");
          logger.w(tempUser.toJson());
          app.user = tempUser;
          Get.put(PrefService());
          prefs.setValue(key: 'user', value: tempUser.toJson());
          logger.wtf('User data ->${prefs.getValue(key: 'user')}');
          onUpdate(status: Status.SCUSSESS);
          Get.toNamed(Routes.ChooseAccount);
          FCM_services().updateToken();
        } else {
          throw response.message;
        }
      } else {
        throw 'Username already exist';
      }
    } on FirebaseAuthException catch (e) {
      logger.e(e.code);
      if (e.code == 'weak-password') {
        onError('This is weak password', () {});
      } else if (e.code == 'email-already-in-use') {
        onError('Account already exist with this email', () {});
      } else if (e.code == 'user-not-found') {
        onError('No account exist with this email address', () {});
      } else {
        onError(e.message, () {});
      }
    } catch (e) {
      onError(e.toString(), createAccountWithEmailAndPassword);
    }
  }

  ///Signup Node Function
  Future<void> signupMethod() async {
    /*Map<String, dynamic> body = {
      'email': signupEmailController.text.trim(),
      'first_name': firstNameCTRL.text.trim(),
      'last_name': lastNameCTRL.text.trim(),
      'user_name': uNameController.text.trim().toLowerCase(),
      'lat': app.currentPosition.latitude.toString(),
      'lang': app.currentPosition.longitude.toString(),
      'password': signupPasswordCTRL.text.trim(),
    };
    logger.w(body);*/
    onUpdate(status: Status.LOADING);
    try {
     HttpsCallableResult<dynamic> result = await FirebaseFunctions.instance
          .httpsCallableFromUrl('https://signup-abf527n5cq-uc.a.run.app?'
              'email=${signupEmailController.text.trim()}'
              '&password=${signupPasswordCTRL.text.trim()}'
              '&first_name=${firstNameCTRL.text.trim()}'
              '&last_name=${lastNameCTRL.text.trim()}'
              '&user_name=${uNameController.text.trim().toLowerCase()}'
              '&lat=${app.currentPosition.latitude.toString()}'
              '&lang=${app.currentPosition.longitude.toString()}')
          .call();

     ResponseModel res = ResponseModel.fromJson(result.data);

      if (res.isSuccess) {
        logger.w('HTTPSCALL::::${res.data}');
        final UserModel tempUser = UserModel.fromJson(res.data);
        logger.w(tempUser.toJson());
        print(tempUser.toJson());
        onUpdate(status: Status.SCUSSESS);
        await net.init(tempUser);
        app.user = tempUser;
        await Get.put(PrefService());
        await prefs.setValue(key: 'user', value: tempUser.toJson());
        var u = prefs.getValue(key: 'user');
        print('Sign-up User::::$u');
        onUpdate(status: Status.SCUSSESS);
        Get.toNamed(Routes.ChooseAccount);
        signupEmailController.clear();
        signupPasswordCTRL.clear();
        conformpasswordCTRL.clear();
        firstNameCTRL.clear();
        lastNameCTRL.clear();
        uNameController.clear();
        showvalue.value = false;
        FCM_services().updateToken();
      } else {
        print('Error-Else:::${res.data['m']}');
        Get.snackbar(
          'Failed',
          res.data['m'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        onUpdate(status: Status.FAILED);
      }
      return (res.data);
    } on FirebaseFunctionsException catch (e) {
      print('Error-Catch:::${e}');
      Get.snackbar(
        'Failed',
        e.message ?? '',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      logger.e('Caught firebase functions exception---->> ${e}');
      onUpdate(status: Status.FAILED);
      return null;
    } catch (e) {
      onUpdate(status: Status.FAILED);
      logger.e('caught generic exception::::${e}');
      return null;
    }
  }

  ///ForgetPassword
  Future<void> forgetPassword() async {
    try {
      onUpdate(status: Status.LOADING);
      logger.i('sending mail to ${forgetEmailController.text.trim()}');
      await _auth.sendPasswordResetEmail(
        email: forgetEmailController.text.trim(),
      );
      onUpdate(status: Status.SCUSSESS);
      edit(false);
      Get.back();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        onError(
          'No account found with this email'.tr,
          () {},
        );
      } else {
        onError(
          e.message,
          () {},
        );
      }
    } catch (e) {
      onError(e.toString(), forgetPassword);
    }
    forgetEmailController.clear();
  }

  Future<void> changePassword() async {
    try {
      if (passwordCTRL.text.trim().isEmpty) {
        throw 'Please enter old password';
      }
      if (newPassword.text.trim().isEmpty) {
        throw 'Please enter new password';
      }
      if (newPassword.text.trim().length <= 7) {
        throw 'Password should be 8 characters long';
      }
      if (conformnewPasswordCTRL.text.trim().isEmpty) {
        throw 'Please enter confirm password';
      }
      if (conformnewPasswordCTRL.text.trim() != newPassword.text.trim()) {
        throw 'New password and confirm password must be same';
      }
      if (passwordCTRL.text.trim() == newPassword.text.trim()) {
        throw 'Password and New password must be different';
      }
      onUpdate(status: Status.LOADING);
      User? user = _auth.currentUser;

      await _auth.signInWithEmailAndPassword(
        email: app.user.email,
        password: passwordCTRL.text.trim(),
      );

      await user!.updatePassword(newPassword.text.trim());
      onUpdate(status: Status.SCUSSESS);
      Get.back();
      Get.dialog(
        AlertDialog(
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          shadowColor: AppColors.black,
          backgroundColor: AppColors.transparent,
          elevation: 0,
          title: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              gradient: AppColors.buttonColor,
              borderRadius: BorderRadius.circular(12),
            ),
            // height: 20,
            child: Text(
              textAlign: TextAlign.center,
              'Password updated',
              style: AppThemes.lightTheme.textTheme.headlineMedium
                  ?.copyWith(color: AppColors.appWhiteColor),
            ),
          ),
        ),
        barrierDismissible: false,
      );
      await 2.delay();
      Get.back();
    } on FirebaseAuthException catch (e) {
      logger.e(e.code);
      if (e.code == 'wrong-password') {
        onError('You have entered wrong password...', () {});
      } else if (e.code == 'weak-password') {
        onError('This is weak password', () {});
      } else {
        onError(e.message, () {});
      }
    } catch (e) {
      onError(e, () {});
    }
  }

  /// admin Apis

  TextEditingController webEmailController = TextEditingController();
  TextEditingController webPasswordController = TextEditingController();
  TextEditingController webNewpasswordController = TextEditingController();
  TextEditingController webConfirmPasswordController = TextEditingController();

  Future<void> adminLogin() async {
    try {
      onUpdate(status: Status.LOADING);
      Map<String, dynamic> body = {
        'email': webEmailController.text.trim(),
        'password': webPasswordController.text.trim()
      };
      ResponseModel response = await net.post(UrlConst.adminLogin, body);
      if (response.isSuccess) {
        UserModel tempUser = UserModel.fromJson(response.data);
        Get.put(PrefService());
        await prefs.setValue(key: 'user', value: tempUser.toJson());
        app.user = tempUser;
        logger.d(prefs.getValue(key: 'user'));
        net.init(tempUser);
        logger.w(tempUser.toJson());
        Get.offAllNamed(Routes.NavigationScreen);
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(e.toString(), adminLogin);
    }
  }

  Future<void> changePasswordApi() async {
    try {
      onUpdate(status: Status.LOADING);
      Map<String, dynamic> body = {
        'old_password': webPasswordController.text,
        'new_password': webNewpasswordController.text,
      };
      logger.w(body);
      ResponseModel res = await net.post(UrlConst.changePassword, body);
      logger.wtf(res.data);
      if (res.isSuccess) {
        onUpdate(status: Status.SCUSSESS);
        Get.back();
        showSnackBar('Password Updated');
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), () {
        changePasswordApi();
      });
    }
  }

  Future<void> forgetPasswordAdmin() async {
    try {
      onUpdate(status: Status.LOADING);
      await _auth.sendPasswordResetEmail(
        email: webEmailController.text.trim(),
      );
      onUpdate(status: Status.SCUSSESS);
      Get.back();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        onError(
          'No account found with this email'.tr,
          () {},
        );
      } else {
        onError(
          e.message,
          () {},
        );
      }
    } catch (e) {
      onError(e.toString(), forgetPassword);
    }
  }
}
