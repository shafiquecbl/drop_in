import 'package:dropin/src/module/mapscreen/map_screen_controller.dart';
import 'package:dropin/src_exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropin/src/models/user_model.dart' as u;
import 'package:dropin/src/models/bussiness_model.dart' as b;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../models/autocomplete_address_model.dart';
import '../../models/bussiness_model.dart';
import '../../models/category_model.dart';
import '../../models/news_feed_model.dart';
import '../../models/sub_category_model.dart';
import '../../service/device_info.dart';
import '../../service/network_service.dart';

import '../../utils/const/common_functions.dart';

class ProfileController extends BaseController {
  CategoryModel? selectedCategoryModelID;
  RxString selectedValue = "".obs;
  RxInt descCount = 0.obs;
  RxBool verify = false.obs;
  TextEditingController contryCTRl = TextEditingController();
  TextEditingController searchContoller = TextEditingController();
  TextEditingController birthdateCTRl = TextEditingController();
  TextEditingController locationCTRl = TextEditingController();
  TextEditingController businessNameCtrl = TextEditingController();
  TextEditingController businessAddress = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController bioController = TextEditingController();
  Rx<FocusNode> countryfocus = FocusNode().obs;
  Rx<FocusNode> datebirthfocus = FocusNode().obs;
  Rx<FocusNode> skilllevelfocus = FocusNode().obs;
  LatLng? pickedLocationForBusiness;

  Rx<FocusNode> locationFocus = FocusNode().obs;
  Rx<FocusNode> bussinessFocus = FocusNode().obs;
  Rx<FocusNode> bussinessAddressFocus = FocusNode().obs;
  Rx<FocusNode> descriptionfocus = FocusNode().obs;
  Rx<FocusNode> submit = FocusNode().obs;
  Rx<AutoCompleteAddress> addressModel = AutoCompleteAddress().obs;

  Rx<FocusNode> selectedCategoryModelIDfocus = FocusNode().obs;
  List<int> selectedSubCat = [];
  RxList<String> addressList = <String>[].obs;
  RxInt selectedAddressIndex = (-1).obs;
  RxList<UserModel> user = <UserModel>[].obs;
  RxList<BussinessModel> Bussiness = <BussinessModel>[].obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String address = '';

  RxBool selected = false.obs;
  RxString countryCode = ''.obs;
  RxString displayNameNoCountryCode = ''.obs;
  RxString countrycode = '91'.obs;
  RxString flagEmoji = ''.obs;
  RxString currentLocales = ''.obs;
  RxBool isValidate = false.obs;
  String locales = '';

  RxBool isEditProfile = false.obs;
  Rx<File> imagePath = File('').obs;
  RxString pickedPath = ''.obs;

  RxnString image = RxnString();
  RxnString image1 = RxnString();

  RxBool isEdit = false.obs;
  RxInt age = 0.obs;

  RxBool isBussiness = false.obs;

  SkillLevel? selectedSkillLevel;

  RxList<String> title = <String>['Beginner', 'Intermediate', 'Advanced'].obs;

  RxInt currentIndexBusiness = 0.obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  Rx<CategoryModel> categort = CategoryModel().obs;
  Rx<BussinessModel> bussiness = BussinessModel().obs;
  RxList<SubCategory> subCategory = <SubCategory>[].obs;
  RxList<NewsFeedModel> newsFeedList = <NewsFeedModel>[].obs;
  RxInt currentIndex = 0.obs;
  List<int> removedImages = <int>[];
  List<int> businessRemovedImages = <int>[];

  // cover photo for user image list
  List<u.CoverPhoto> coverPhotos = <u.CoverPhoto>[];

  List<b.CoverPhoto> businessCoverPhotos = <b.CoverPhoto>[];

  /// for user images
  RxList<u.CoverPhoto> imgList1 = <u.CoverPhoto>[].obs;

  /// for business images
  RxList<b.CoverPhoto> imgList2 = <b.CoverPhoto>[].obs;

  GoogleMapController? gMapsController;
  Set<Marker> markers = <Marker>{};
  Set<Marker> mapMarkers = <Marker>{};

  LatLng pickedLocation = LatLng(0.0, 0.0);

  void navigateTo(bool isBusiness, [int? arg]) {
    try {
      if (locationCTRl.text.trim().isEmpty) {
        throw 'Please enter location';
      }
      if (businessNameCtrl.text.trim().isEmpty) {
        throw 'Please enter business name';
      }
      if (descriptionCtrl.text.trim().isEmpty) {
        throw 'Please enter description';
      }
      Get.toNamed(
        Routes.BusinessAddPhotos,
        arguments: <Object>[
          isBusiness,
          isBusiness ? app.bussiness.id : arg ?? -1,
          false,
        ],
      );
    } catch (e) {
      onError(e, () {});
    }
  }

  RxBool isVerifyLogin() {
    if (selectedCategoryModelID != null ||
        locationCTRl.text.isNotEmpty ||
        businessAddress.text.isNotEmpty ||
        businessNameCtrl.text.isNotEmpty ||
        descriptionCtrl.text.isNotEmpty) {
      return true.obs;
    } else {
      return false.obs;
    }
  }

  Future<void> updateBusinessDescription() async {
    try {
      onUpdate(status: Status.LOADING);
      if (descriptionCtrl.text.trim().isEmpty) {
        throw 'Please enter description';
      }
      Map<String, dynamic> body = {
        'id': app.bussiness.id,
        'description': descriptionCtrl.text.trim(),
      };
      ResponseModel res = await net.post(UrlConst.updatebussiness, body);
      if (res.isSuccess) {
        final foo = b.BussinessModel.fromJson(res.data ?? {});
        app.bussiness = foo;
        Get.back();
        descriptionCtrl.clear();
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
    } catch (e, t) {
      onError(e, () {});
    }
  }

  Future<void> onMapCreate() async {
    if (gMapsController != null) {
      final String style =
          await rootBundle.loadString(AppAssets.gMapsDefaultStyle);
      await gMapsController!.setMapStyle(style);
      gMapsController!.moveCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(app.currentPosition.latitude, app.currentPosition.longitude),
          15,
        ),
      );
    }
  }

  Future<void> addMarker(LatLng latLang) async {
    markers.clear();
    final Uint8List markerIcon = await getMarker(AppAssets.dropinPin);
    markers.add(
      Marker(
        markerId: MarkerId('${latLang.latitude}${latLang.longitude}'),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        position: latLang,
      ),
    );
    update();
  }

  @override
  Future<void> onInit() async {
    locationFocus.value.addListener(() {});
    bussinessFocus.value.addListener(() {});
    descriptionfocus.value.addListener(() {});
    selectedCategoryModelIDfocus.value.addListener(() {});
    countryfocus.value.addListener(() {});
    datebirthfocus.value.addListener(() {});
    skilllevelfocus.value.addListener(() {});

    if (app.user.bussiness!.id != 0) {
      await getBussinessByID();
    }

    if (Get.arguments is bool) {
      isEditProfile(Get.arguments ?? false);
      isBussiness(Get.arguments ?? false);
    }
    selectedSkillLevel == app.user.skillId;
    check();
    app.update();
    update();

    super.onInit();
  }

  @override
  Future<void> onReady() async {
    getCategoryApi();

    super.onReady();
  }

  void check() async {
    var isUser = prefs.getValue(key: 'user');
    if (isUser != null) {
      contryCTRl.text = app.user.country;
      selectedSkillLevel == app.user.skillId;
    } else {}
  }

  RxString currentAddress = ''.obs;

  Future<void> getAddress({
    required double lat,
    required double long,
    String address = '',
  }) async {
    if (address.isEmpty) {
      currentAddress.value = await app.getAddress(lat: lat, long: long);
    } else {
      currentAddress.value = address;
    }
    searchContoller.text = currentAddress.value;
  }

  void navigate() {
    try {
      if (pickedPath.value.isEmpty) {
        throw 'Please Select profile image';
      }
      if (birthdateCTRl.text.trim().isEmpty) {
        throw 'Please Enter DOB';
      }
      if (contryCTRl.text.trim().isEmpty) {
        throw 'Please Country code';
      }

      List<String> dob = birthdateCTRl.text.trim().split('/');
      String val = '';
      val += '${dob[2]}-';
      val += '${dob[1]}-';
      val += dob[0];
      logger.w(val);
      DateTime date = DateTime.parse(val);
      logger.w('$date');
      if (int.parse(dob[0]) > 31) {
        throw 'Date must not be greater that 31';
      }
      if (int.parse(dob[1]) > 12) {
        throw 'Month must not be greater that 12';
      }
      if (DateTime.now().subtract(Duration(days: (16 * 365))).isBefore(date)) {
        throw 'Age must be greater than 16';
      }
      if (DateTime.now().subtract(Duration(days: (80 * 365))).isAfter(date)) {
        throw 'Age must be less than 80';
      }
      if (selectedSkillLevel == null) {
        throw 'Please select skill level';
      }
      Get.toNamed(Routes.AddPhotos); //this place
    } catch (e) {
      onError(e, () {});
    }
  }

  void navigate1() {
    try {
      if (pickedPath.value.isEmpty) {
        throw 'Please Select profile image';
      }

      Get.back();
    } catch (e) {
      onError(e, () {});
    }
  }

  void signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> LogOUtDialog() async {
    return showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: AppAssets.asImage(AppAssets.signOut,
                        height: 60, color: AppColors.appBlackColor)),
                Text(
                  'Are you sure you  want to Logout ?',
                  style: AppThemes.lightTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 20,
                    color: const Color(0xFF4F4F4F),
                  ),
                ).paddingSymmetric(vertical: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'No, cancel',
                        style: AppThemes.lightTheme.textTheme.titleMedium
                            ?.copyWith(
                          color: AppColors.appBlackColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.redcolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onPressed: () {
                        prefs.removeValue('user');
                        prefs.removeValue('Bussiness');
                        FCM_services().updateToken(true);
                        Get.offAllNamed(Routes.LoginScreen);
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: AppColors.appWhiteColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  countryPicker() {
    showCountryPicker(
      showPhoneCode: true,
      context: Get.context!,
      useSafeArea: true,
      showSearch: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        textStyle: TextStyle(fontSize: 16, color: Colors.black),
        margin: EdgeInsets.symmetric(horizontal: 25),
        inputDecoration: InputDecoration(
          hintText: 'Search',
          // border: InputBorder.none,
          filled: true,
          fillColor: AppColors.grey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 30,
          ),
          suffixIcon: GestureDetector(
            onTap: Get.back,
            child: Icon(
              Icons.cancel,
              size: 30,
            ),
          ),
        ),
        bottomSheetHeight: 550,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      onSelect: (Country country) {
        selected(true);
        displayNameNoCountryCode.value = country.displayNameNoCountryCode;
        flagEmoji.value = country.flagEmoji;
        currentLocales.value = country.countryCode;
        contryCTRl.text =
            '${country.flagEmoji}  ${country.displayNameNoCountryCode}';
      },
    );
  }

  Future<String> imagePicker({required bool isProfile}) async {
    File res = await PickImages.pickImages();
    if (res.path.isNotEmpty) {
      image.value = res.path;
      isProfile
          ? pickedPath(res.path)
          : imgList1.add(
              u.CoverPhoto(
                coverPhoto: res.path,
              ),
            );
    }
    return res.path;
  }

  Future<String> pickedImage({required bool isProfile}) async {
    File res = await PickImages.pickImages();
    if (res.path.isNotEmpty) {
      image1.value = res.path;
      isProfile
          ? pickedPath(res.path)
          : imgList2.add(
              b.CoverPhoto(
                coverPhoto: res.path,
              ),
            );
    }
    return res.path;
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          child: AlertDialog(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 30,
            ),
            actionsPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.all(20),
            iconPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppAssets.asImage(AppAssets.deletaccount, height: 60),
                Text(
                  'Are you sure want to delete your account? You can not retrieve your profile.',
                  style: AppThemes.lightTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 20,
                    letterSpacing: 2,
                    color: const Color(0xFF4F4F4F),
                  ),
                ).paddingSymmetric(vertical: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.redcolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onPressed: () {
                        deleteUser(id: app.user.id);
                      },
                      child: const Text(
                        'Yes, I’m sure',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'No, cancel',
                        style: AppThemes.lightTheme.textTheme.titleMedium
                            ?.copyWith(
                          color: AppColors.appBlackColor,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          onWillPop: () => Future(() => true),
        );
      },
    );
  }

  Future<void> showMyDialogBusiness() async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          child: AlertDialog(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 30,
            ),
            actionsPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.all(20),
            iconPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppAssets.asImage(AppAssets.deletaccount, height: 60),
                Text(
                  'Are you sure want to delete your account? You can not retrieve your Business Account.',
                  style: AppThemes.lightTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    letterSpacing: 1,
                    color: const Color(0xFF4F4F4F),
                  ),
                ).paddingSymmetric(vertical: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppElevatedButton(
                      height: 40,
                      width: 100,
                      color: AppColors.appWhiteColor,
                      borderRadius: BorderRadius.circular(11),
                      callback: () {
                        Get.back();
                      },
                      title: 'No, cancel',
                      style: AppThemes.lightTheme.textTheme.headlineMedium
                          ?.copyWith(color: AppColors.appBlackColor),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AppElevatedButton(
                      height: 40,
                      width: 100,
                      color: AppColors.redcolor,
                      borderRadius: BorderRadius.circular(11),
                      callback: () async {
                        await DeleteBussiness(id: app.bussiness.id);
                      },
                      title: 'Delete',
                    ),

                    const SizedBox(
                      width: 10,
                    ),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: AppColors.appWhiteColor,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(11),
                    //     ),
                    //   ),
                    //   onPressed: () {
                    //     Get.back();
                    //   },
                    //   child: Text(
                    //     'No, cancel',
                    //     style:
                    //   ),
                    // )
                  ],
                )
              ],
            ),
          ),
          onWillPop: () => Future(() => true),
        );
      },
    );
  }

  ///profileSetup api, Business setUp
  Future<void> profileSetups() async {
    try {
      List<u.CoverPhoto> images = imgList1
          .where((u.CoverPhoto p0) => p0.coverPhoto.isNotEmpty)
          .toList();
      logger.w(selectedSkillLevel);
      if (selectedSkillLevel == null && selectedSkillLevel != null) {
        throw 'Please select skill level';
      }
      if (birthdateCTRl.text.trim().isEmpty) {
        throw 'Please Enter DOB';
      }
      if (pickedPath.value.isEmpty) {
        throw 'Please Select profile image';
      }
      List<String> dob = birthdateCTRl.text.trim().split('/');
      String val = '';
      val += '${dob[2]}-';
      val += '${dob[1]}-';
      val += dob[0];
      logger.w(val);
      DateTime date = DateTime.parse(val);
      if (date == DateTime(0, 0, 0)) {
        throw 'Please enter valid date';
      }
      if (DateTime.now().subtract(Duration(days: (16 * 365))).isBefore(date)) {
        throw 'Age must be greater than 16';
      }
      if (DateTime.now().subtract(Duration(days: (80 * 365))).isAfter(date)) {
        throw 'Age must be less than 80';
      }
      if (images.isEmpty) {
        throw 'Please Select cover image';
      }
      onUpdate(status: Status.LOADING);

      Map<String, dynamic> body = {
        'profile_img': await MultipartFile.fromFile(pickedPath.value),
        'uid': app.user.id,
        'country': displayNameNoCountryCode.value,
        'skill_id': selectedSkillLevel?.id,
        'bio': bioController.text,
        'dob': DateFormat('yyyy-MM-dd').format(date),
        for (int i = 0; i < images.length; i++)
          'cover_photo[$i]': await MultipartFile.fromFile(images[i].coverPhoto)
      };
      logger.wtf(images.toString());
      logger.i(body);
      ResponseModel response = await net.post(UrlConst.profileSetup, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        UserModel tempUser = UserModel.fromJson(response.data ?? {});
        tempUser.bussiness = app.bussiness;
        logger.w('tempuser=>> ${tempUser.toJson()}');
        app.user = tempUser;
        Get.put(PrefService());
        prefs.setValue(key: 'user', value: tempUser.toJson());

        if (app.isBusiness) {
          await addBussiness();
        } else {
          Get.offAllNamed(Routes.HomeScreen);
        }
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw response.message;
      }
    } on FormatException catch (e) {
      onError(
        'Please enter valid date',
        () {},
      );
    } catch (e) {
      onError(
        e.toString(),
        () {},
      );
    }
  }

  Future<void> profileSetupsbio() async {
    try {
      onUpdate(status: Status.LOADING);

      Map<String, dynamic> body = {
        'uid': app.user.id,
        'bio': bioController.text,
      };
      logger.i('body=>${body}');
      ResponseModel response = await net.post(UrlConst.profileSetup, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        UserModel tempUser = UserModel.fromJson(response.data ?? {});
        logger.w('tempuser=>> ${tempUser.toJson()}');
        tempUser.bussiness = app.bussiness;
        app.user = tempUser;
        Get.put(PrefService());
        prefs.setValue(key: 'user', value: tempUser.toJson());
        // if (app.isBusiness) {
        //   await addBussiness();
        // } else {
        //
        //   // Get.offAllNamed(Routes.HomeScreen);
        // }
        Get.back();
        onUpdate(status: Status.SCUSSESS);
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

  Future<void> updatecategory() async {
    try {
      logger.w(selectedSkillLevel);

      if (birthdateCTRl.text.trim().isEmpty) {
        throw 'Please Enter DOB';
      }

      List<String> dob = birthdateCTRl.text.trim().split('/');
      String val = '';
      val += '${dob[2]}-';
      val += '${dob[1]}-';
      val += dob[0];
      logger.w(val);
      DateTime date = DateTime.parse(val);
      logger.w('$date');
      if (int.parse(dob[0]) > 31) {
        throw 'Date must not be greater that 31';
      }
      if (int.parse(dob[1]) > 12) {
        throw 'Month must not be greater that 12';
      }
      if (DateTime.now().subtract(Duration(days: (16 * 365))).isBefore(date)) {
        throw 'Age must be greater than 16';
      }
      if (DateTime.now().subtract(Duration(days: (80 * 365))).isAfter(date)) {
        throw 'Age must be less than 80';
      }

      onUpdate(status: Status.LOADING);

      Map<String, dynamic> body = {
        'uid': app.user.id,
        'country': displayNameNoCountryCode.value,
        'skill_id': selectedSkillLevel?.id,
        'dob': DateFormat('yyyy-MM-dd').format(date),
      };

      logger.i('body=>${body}');
      ResponseModel response = await net.post(UrlConst.profileSetup, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        UserModel tempUser = UserModel.fromJson(response.data ?? {});
        logger.w(' temper=>> ${tempUser.toJson()}');
        tempUser.bussiness = app.bussiness;
        app.user = tempUser;
        Get.put(PrefService());
        prefs.setValue(
          key: 'user',
          value: tempUser.toJson(),
        );
        update();

        Get.back();
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw response.message;
      }
    } on FormatException catch (e) {
      onError(
        'Please enter valid date',
        () {},
      );
    } catch (e) {
      onError(
        e.toString(),
        updatecategory,
      );
    }
  }

  /// this will pick profile photo and set new profile photo
  Future<void> profilephoto([bool isFromProfile = false]) async {
    try {
      if (pickedPath.value.isEmpty) {
        throw 'Please Select profile image';
      }

      onUpdate(status: isFromProfile ? Status.SEARCHING : Status.LOADING);

      Map<String, dynamic> body = {
        'uid': app.user.id,
        'profile_img': await MultipartFile.fromFile(pickedPath.value),
      };

      logger.i(body);
      ResponseModel response = await net.post(UrlConst.profileSetup, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        UserModel tempUser = UserModel.fromJson(response.data ?? {});
        tempUser.bussiness = app.bussiness;
        app.user = tempUser;
        update();
        app.update();

        Get.put(PrefService());
        prefs.setValue(key: 'user', value: tempUser.toJson());
        Get.back();
        onUpdate(status: Status.SCUSSESS);
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

  Future<void> updateCoverPhoto() async {
    try {
      imgList1.removeWhere(
        (u.CoverPhoto p0) {
          return p0.coverPhoto.isEmpty ||
              !p0.coverPhoto.toLowerCase().contains('data');
        },
      );
      logger.w(selectedSkillLevel);

      // if (images.isEmpty) {
      //   throw 'Please Select cover image';
      // }
      onUpdate(status: Status.LOADING);

      Map<String, dynamic> body = {
        'is_active': 1,
        if (removedImages.isNotEmpty) 'remove_photos': removedImages.join(','),
        'uid': app.user.id,
        for (int i = 0; i < imgList1.length; i++)
          'cover_photo[${i + app.user.coverPhotos.length}]':
              await MultipartFile.fromFile(imgList1[i].coverPhoto)
      };
      logger.i(body);
      ResponseModel response = await net.post(UrlConst.profileSetup, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        UserModel tempUser = UserModel.fromJson(response.data ?? {});
        logger.w('temper=>> ${tempUser.toJson()}');
        tempUser.bussiness = app.user.bussiness;
        app.user = tempUser;
        Get.put(PrefService());
        prefs.setValue(key: 'user', value: tempUser.toJson());
        coverPhotos.clear();
        Get.back();
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(
        e.toString(),
        () {
          updateCoverPhoto();
        },
      );
    }
  }

  Future<void> updateCoverPhotoBusiness() async {
    try {
      List<b.CoverPhoto> images = imgList2
          .where(
            (b.CoverPhoto p0) => p0.coverPhoto.isNotEmpty,
          )
          .toList();

      onUpdate(status: Status.LOADING);
      Map<String, dynamic> body = {
        if (businessRemovedImages.isNotEmpty)
          'remove_photos': businessRemovedImages.join(','),
        'id': app.bussiness.id,
        'business_name': app.bussiness.businessName,
        for (int i = 0; i < images.length; i++)
          'cover_photo[${i}]':
              await MultipartFile.fromFile(images[i].coverPhoto)
      };
      logger.i(body);
      ResponseModel response = await net.post(UrlConst.updatebussiness, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        bussiness.value = BussinessModel.fromJson(response.data ?? {});
        app.bussiness = bussiness.value;
        logger.i('bussiness=> ${app.bussiness.toJson()}');
        Get.put(PrefService());
        prefs.setValue(key: 'Bussiness', value: bussiness.toJson());
        Get.back();
        businessCoverPhotos.clear();
        Get.back();
        imgList2.clear();
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(
        e.toString(),
        () {
          updateCoverPhotoBusiness();
        },
      );
    }
  }

  ///get Category list api
  Future<void> getCategoryApi() async {
    try {
      onUpdate(status: Status.LOADING);
      ResponseModel res = await net.get(UrlConst.getAllCategory, {});
      logger.d(res.data);
      if (res.isSuccess) {
        List<CategoryModel> foo = List<CategoryModel>.from(
          (res.data ?? []).map(
            (e) => CategoryModel.fromJson(e),
          ),
        );
        categoryList.addAll(foo);

        Get.put(PrefService());
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), getCategoryApi);
    }
  }

  ///Get subCategory list api
  Future<void> getSubCategory() async {
    if (selectedCategoryModelID != null) {
      try {
        onUpdate(status: Status.LOADING);
        Map<String, dynamic> params = {
          'cat_id': selectedCategoryModelID,
        };
        ResponseModel res = await net.get(UrlConst.subCategory, params);
        logger.d(res.toJson());
        if (res.isSuccess) {
          // final category = res.list((x) => CategoryModel.fromJson(x));
          subCategory.clear();
          List<SubCategory> foo = List<SubCategory>.from(
            (res.data ?? []).map(
              (e) => SubCategory.fromJson(e),
            ),
          );
          subCategory.addAll(foo);

          onUpdate(status: Status.SCUSSESS);
        } else {
          throw res.message;
        }
      } catch (e) {
        onError(e.toString(), getSubCategory);
      }
    }
  }

  Future<void> addBussiness([bool isFromAuth = true]) async {
    try {
      onUpdate(status: Status.LOADING);
      List<b.CoverPhoto> images = imgList2
          .where((b.CoverPhoto p0) => p0.coverPhoto.isNotEmpty)
          .toList();

      Map<String, dynamic> body = {
        'cat_id': selectedCategoryModelID?.id,
        'location': locationCTRl.text,
        'business_name': businessNameCtrl.text,
        'address': businessAddress.text,
        'description': descriptionCtrl.text,
        'sub_cat_id': selectedSubCat.join(','),
        'lat': pickedLocation.latitude,
        'lang': pickedLocation.longitude,
        for (int i = 0; i < images.length; i++)
          'cover_photo[$i]': await MultipartFile.fromFile(images[i].coverPhoto)
      };
      logger.i('body =>${body}');
      logger.wtf(images.toString());
      ResponseModel response = await net.post(UrlConst.bussinessAdd, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        bussiness.value = BussinessModel.fromJson(response.data);
        app.bussiness = bussiness.value;
        app.user.bussiness = bussiness.value;
        Get.put(PrefService());
        prefs.setValue(key: 'user', value: app.user.toJson());
        logger.i('bussiness=> ${app.bussiness.toJson()}');
        prefs.setValue(key: 'Bussiness', value: bussiness.toJson());
        selectedCategoryModelID = null;
        locationCTRl.clear();
        businessNameCtrl.clear();
        descriptionCtrl.clear();
        pickedLocation = LatLng(0.0, 0.0);
        imgList2.clear();
        onUpdate(status: Status.SCUSSESS);
        if (isFromAuth) {
          Get.offAllNamed(Routes.HomeScreen);
        }
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(e.toString(), addBussiness);
    }
  }

  Future<void> updateBussiness() async {
    try {
      onUpdate(status: Status.LOADING);
      List<b.CoverPhoto> images = imgList2
          .where((b.CoverPhoto p0) => p0.coverPhoto.isNotEmpty)
          .toList();

      Map<String, dynamic> body = {
        'id': app.bussiness.id,
        'cat_id': selectedCategoryModelID?.id,
        'location': locationCTRl.text,
        'business_name': businessNameCtrl.text,
        'description': descriptionCtrl.text,
        'sub_cat_id': selectedSubCat.join(','),
        'lat': pickedLocation.latitude,
        'lang': pickedLocation.longitude,
        for (int i = 0; i < images.length; i++)
          'cover_photo[$i]': await MultipartFile.fromFile(images[i].coverPhoto)
      };
      logger.i('body =>${body}');
      logger.wtf(images.toString());
      ResponseModel response = await net.post(UrlConst.updatebussiness, body);
      logger.w(response.data);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        bussiness.value = BussinessModel.fromJson(response.data ?? {});
        app.bussiness = bussiness.value;
        logger.i('bussiness=> ${app.bussiness.toJson()}');
        Get.put(PrefService());
        prefs.setValue(key: 'Bussiness', value: bussiness.toJson());
        Get.back();
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(e.toString(), updateBussiness);
    }
  }

  Future<void> updateBussinessDetails() async {
    try {
      onUpdate(status: Status.LOADING);

      Map<String, dynamic> body = {
        'id': app.bussiness.id,
        'cat_id': selectedCategoryModelID?.id,
        'location': locationCTRl.text,
        if (pickedLocationForBusiness != null) ...{
          'lat': pickedLocationForBusiness!.latitude,
          'lang': pickedLocationForBusiness!.longitude,
        },
        'business_name': businessNameCtrl.text.trim().isEmpty
            ? app.bussiness.businessName
            : businessNameCtrl.text.trim(),
        'address': businessAddress.text.trim().isEmpty
            ? ''
            : businessAddress.text.trim(),
        if (selectedSubCat.isNotEmpty) ...{
          'sub_cat_id': selectedSubCat.join(','),
        } else ...{
          if (app.bussiness.subCategory.isNotEmpty) ...{
            'remove_sub_cat_id': app.bussiness.subCategory
                .map(
                  (e) => e.id,
                )
                .toList()
                .join(','),
          }
        },
      };

      logger.i('body =>${body}');

      ResponseModel response = await net.post(UrlConst.updatebussiness, body);
      logger.w(response.data);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        bussiness.value = BussinessModel.fromJson(response.data);
        app.bussiness = bussiness.value;
        logger.i('bussiness=> ${app.bussiness.toJson()}');
        Get.put(PrefService());
        prefs.setValue(key: 'Bussiness', value: bussiness.toJson());
        update();
        app.update();
        onUpdate(status: Status.SCUSSESS);
        Get.back();
        pickedLocationForBusiness = null;
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(e.toString(), updateBussinessDetails);
    }
  }

  Future<void> forceUpdateBusiness() async {
    try {
      imgList2.clear();
      businessCoverPhotos.clear();
      logger.w(imgList2.length);
      final imageList = await Get.toNamed(
        Routes.BusinessAddPhotos,
        arguments: [
          true,
          app.bussiness.id,
          true,
        ],
      );
      if (imageList is bool) {
        return;
      }
      final description = await Get.toNamed(
        Routes.DetailScreen,
        arguments: true,
      );
      if (description is bool) {
        return;
      }
      onUpdate(status: Status.LOADING);
      logger.i((imageList as List<b.CoverPhoto>).map((e) => e.photos));
      Map<String, dynamic> body = {
        'id': app.bussiness.id,
        'cat_id': selectedCategoryModelID?.id,
        'location': locationCTRl.text,
        if (pickedLocationForBusiness != null) ...{
          'lat': pickedLocationForBusiness!.latitude,
          'lang': pickedLocationForBusiness!.longitude,
        },
        'business_name': businessNameCtrl.text.trim().isEmpty
            ? app.bussiness.businessName
            : businessNameCtrl.text.trim(),
        if (selectedSubCat.isNotEmpty) ...{
          'sub_cat_id': selectedSubCat.join(','),
        } else ...{
          if (app.bussiness.subCategory.isNotEmpty) ...{
            'remove_sub_cat_id': app.bussiness.subCategory
                .map(
                  (e) => e.id,
                )
                .toList()
                .join(','),
          }
        },
        'description': '$description',
        if (app.bussiness.coverPhoto.isNotEmpty) ...{
          'remove_photos': app.bussiness.coverPhoto
              .map(
                (e) => e.id,
              )
              .toList()
              .join(',')
        },
        for (int i = 0; i < imageList.length; i++)
          'cover_photo[$i]':
              await MultipartFile.fromFile(imageList[i].coverPhoto)
      };

      logger.i('body =>${body}');

      ResponseModel response = await net.post(UrlConst.updatebussiness, body);
      logger.w(response.data);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        bussiness.value = BussinessModel.fromJson(response.data);
        app.bussiness = bussiness.value;
        logger.i('bussiness=> ${app.bussiness.toJson()}');
        Get.put(PrefService());
        prefs.setValue(key: 'Bussiness', value: bussiness.toJson());
        update();
        app.update();
        onUpdate(status: Status.SCUSSESS);
        Get.back();
        pickedLocationForBusiness = null;
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(e.toString(), updateBussinessDetails);
    }
  }

  ///get allUser DropIn
  Future<void> getAllUserDropIn() async {
    try {
      onUpdate(status: Status.LOADING);
      Map<String, dynamic> params = {'user_id': app.user.id};
      ResponseModel res = await net.get(UrlConst.getAllUserDropIn, params);
      logger.wtf(res.data);
      if (res.isSuccess) {
        final List<NewsFeedModel> foo = List<NewsFeedModel>.from(
          (res.data ?? []).map(
            (e) => NewsFeedModel.fromJson(e),
          ),
        );
        newsFeedList.addAll(foo);
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), getAllUserDropIn);
    }
  }

  Future<void> getBussinessByID() async {
    try {
      onUpdate(status: Status.LOADING);
      Map<String, dynamic> params = {'id': app.user.bussiness!.id};
      ResponseModel res = await net.get(UrlConst.getbyIdBussiness, params);
      logger.w(res.data);
      if (res.isSuccess) {
        logger.w(res.toJson());
        if (app.bussiness.id != 0) {
          bussiness.value = BussinessModel.fromJson(res.data ?? {});
          app.bussiness = bussiness.value;
          onUpdate(status: Status.SCUSSESS);
        }
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), getBussinessByID);
    }
  }

  ///report DropIn

  Future<void> deleteDropIn({required int id}) async {
    try {
      onUpdate(status: Status.LOADING_MORE);

      Map<String, dynamic> body = {'id': id};
      ResponseModel response = await net.post(UrlConst.deleteDropIn, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        newsFeedList.removeWhere((NewsFeedModel element) => element.id == id);
        onUpdate(status: Status.SCUSSESS);
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

  Future<void> deleteUser({required int id}) async {
    try {
      onUpdate(status: Status.LOADING_MORE);

      Map<String, dynamic> body = {'id': app.user.id};
      ResponseModel response = await net.post(UrlConst.deleteUser, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        user.removeWhere((UserModel element) => element.id == id);
        app.user = UserModel();
        await prefs.removeValue('user');
        onUpdate(status: Status.SCUSSESS);
        signOut();
        Get.offAllNamed(Routes.LoginScreen);
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
      Map<String, dynamic> body = {'id': app.bussiness.id};
      ResponseModel response = await net.post(UrlConst.deleteBussiness, body);
      if (response.isSuccess) {
        logger.wtf(response.toJson());
        app.user.bussiness = BussinessModel();
        await prefs.setValue(key: 'user', value: app.user.toJson());
        app.bussiness = BussinessModel();
        await Get.find<MapsController>().getMap();
        Get.find<MapsController>().update();
        onUpdate(status: Status.SCUSSESS);
        Get.back();
        Get.back();
        Get.back();
        Get.rawSnackbar(message: 'Business Deleted Successfully');
      } else {
        throw response.message;
      }
    } catch (e, t) {
      logger.e('ERROR TRACE:::$e $t');
      onError(
        e.toString(),
        () {},
      );
    }
  }

  Future<void> rateBussiness() async {
    try {
      onUpdate(status: Status.LOADING);
      ResponseModel res = await net
          .get(UrlConst.rateBussiness, {'business_id': app.bussiness.id});
      logger.d(res.data);
      if (res.isSuccess) {
        // List<CategoryModel> foo = List<CategoryModel>.from(
        //   (res.data ?? []).map(
        //     (e) => CategoryModel.fromJson(e),
        //   ),
        // );
        // categoryList.addAll(foo);

        Get.put(PrefService());
        prefs.getValue(key: 'Bussiness');
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), rateBussiness);
    }
  }

  Future<bool> createProfile() async {
    if (contryCTRl.text.isNotEmpty ||
        locationCTRl.text.isNotEmpty ||
        selectedSkillLevel == null) {
      return true;
    } else {
      return false;
    }
  }
}
