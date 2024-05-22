import 'package:dropin/src_exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/bussiness_model.dart';
import '../../models/news_feed_model.dart';
import '../../service/network_service.dart';
import '../../utils/const/common_functions.dart';
import '../chatscreen/chat_screen_controller.dart';

class ProfileScreenController extends ChatScreenController {
  TextEditingController emailCTRL = TextEditingController();
  TextEditingController firstNameCTRL = TextEditingController();
  TextEditingController lastNameCTRL = TextEditingController();
  TextEditingController passwordCTRL = TextEditingController();
  TextEditingController userNameCTRL = TextEditingController();
  TextEditingController conformpasswordCTRL = TextEditingController();
  TextEditingController contryCTRl = TextEditingController();
  TextEditingController birthdateCTRl = TextEditingController();

  RxString selectedDropdownValue = 'Beginner'.obs;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxList<NewsFeedModel> newsFeedList = <NewsFeedModel>[].obs;
  RxList<UserModel> user = <UserModel>[].obs;

  // RxBool isProfile = false.obs;

  RxBool selected = false.obs;

  //country picker
  RxString countryCode = ''.obs;
  RxString displayNameNoCountryCode = ''.obs;
  RxString countrycode = '91'.obs;
  RxString flagEmoji = ''.obs;
  RxString currentLocales = ''.obs;
  String locales = '';

  RxBool isEdit = false.obs;
  RxInt currentIndex = 0.obs;

  LatLng currentLocation = LatLng(0.0, 0.0);

  @override
  void onInit() {
    currentLocation =
        LatLng(app.currentPosition.latitude, app.currentPosition.longitude);
    getAllUserDropIn();

    super.onInit();
  }

  GoogleMapController? gMapsController;

  Future<void> onMapCreate() async {
    if (gMapsController != null) {
      final style = await rootBundle.loadString(AppAssets.gMapsDefaultStyle);
      await gMapsController!.setMapStyle(style);
      gMapsController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(app.currentPosition.latitude, app.currentPosition.longitude),
          14,
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

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
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
                    onPressed: () {},
                    child: const Text(
                      'Yes, I’m sure',
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
                      style:
                          AppThemes.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppColors.appBlackColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  ///get allUser DropIn
  Future<void> getAllUserDropIn() async {
    try {
      onUpdate(status: Status.LOADING);
      Map<String, dynamic> params = {'user_id': app.user.id};
      ResponseModel res = await net.get(UrlConst.getAllUserDropIn, params);
      logger.wtf(res.data);
      if (res.isSuccess) {
        final foo = List<NewsFeedModel>.from(
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

  Future<void> deleteDropIn({required int id}) async {
    try {
      onUpdate(status: Status.LOADING_MORE);

      ResponseModel response =
          await net.post(UrlConst.deleteDropIn, {'id': id});
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        newsFeedList.removeWhere((NewsFeedModel element) {
          logger.w('${element.id} == $id');
          return element.id == id;
        });
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

  RxString images = ''.obs;

  RxnString image = RxnString();

  Future<String> imagePicker() async {
    var res = await PickImages.pickImages();
    if (res.path.isNotEmpty) {
      image.value = res.path;
      images(res.path);
    }
    return res.path;
  }

  Rx<BussinessModel> bussiness = BussinessModel().obs;
}
