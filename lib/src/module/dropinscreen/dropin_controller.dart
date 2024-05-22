import 'package:dropin/src/utils/const/common_functions.dart';
import 'package:dropin/src_exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/autocomplete_address_model.dart';
import '../../models/bussiness_model.dart';
import '../../models/drop_in_category.dart';
import '../../models/news_feed_model.dart';
import '../../service/network_service.dart';
import '../homescreen/home_screen_controller.dart';
import '../profilescreen/profile_screen_controller.dart';

class DropinController extends BaseController {
  GoogleMapController? gMapsController;
  RxInt descCount = 0.obs;
  RxList<NewsFeedModel> newsFeedList = <NewsFeedModel>[].obs;
  Rx<AutoCompleteAddress> addressResults = AutoCompleteAddress().obs;

  DropCategoryModel? selectedCategoryModelID;
  RxList<DropCategoryModel> dropInList = <DropCategoryModel>[].obs;
  RxList<DropinImages> dropInImage = <DropinImages>[].obs;

  Set<Marker> markers = <Marker>{};
  Set<Marker> mapMarkers = <Marker>{};

  RxBool isValidate = false.obs;

  /// this var will check that is update dropin or not
  RxBool edit = false.obs;

  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController titlectrl = TextEditingController();
  TextEditingController locationctrl = TextEditingController();

  Rx<FocusNode> selectedCategoryModelidFocus = FocusNode().obs;
  Rx<FocusNode> locationfocus = FocusNode().obs;
  Rx<FocusNode> titlefocus = FocusNode().obs;
  Rx<FocusNode> descriptionfocus = FocusNode().obs;
  Rx<FocusNode> imagefocus = FocusNode().obs;
  Rx<FocusNode> submit = FocusNode().obs;

  Rx<BussinessModel> bussiness = BussinessModel().obs;

  // RxList<DropInModel> dropinModel = <DropInModel>[].obs;
  List<int> selectedSubCat = [];
  RxInt id = 0.obs;
  RxBool verify = false.obs;
  LatLng? currentLocation;

  // RxInt descCount = 0.obs;

  @override
  void onInit() async {
    getDropInList();
    super.onInit();
    selectedCategoryModelidFocus.value.addListener(() {});
    locationfocus.value.addListener(() {});
    titlefocus.value.addListener(() {});
    descriptionfocus.value.addListener(() {});
  }

  RxString pickeimage = ''.obs;
  String imagepath = "";
  late File imagefile;

  Future<String> imagePicker({required bool isProfile}) async {
    File res = await PickImages.pickImages();
    if (res.path.isNotEmpty) {
      imagepath = res.path;
      isProfile == true
          ? imagefile = File(imagepath)
          : dropInImage.add(
              DropinImages(
                images: res.path,
              ),
            );
    }
    return res.path;
  }

  RxBool isVerifyed() {
    if (selectedCategoryModelID != null ||
        locationctrl.text.isNotEmpty ||
        titlectrl.text.isNotEmpty ||
        descriptionCtrl.text.isNotEmpty ||
        dropInImage.isNotEmpty) {
      return true.obs;
    } else {
      return false.obs;
    }
  }

  Future<void> onMapCreate() async {
    if (gMapsController != null) {
      final String style =
          await rootBundle.loadString(AppAssets.gMapsDefaultStyle);
      await gMapsController!.setMapStyle(style);
      gMapsController!.moveCamera(
        CameraUpdate.newLatLngZoom(
          currentLocation ??
              LatLng(
                app.currentPosition.latitude,
                app.currentPosition.longitude,
              ),
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
        draggable: true,
        position: latLang,
      ),
    );
    update();
  }

  RxString currentAddress = ''.obs;

  Future<void> getAddressFromLatLng({
    required double lat,
    required double long,
    String address = '',
  }) async {
    String foo = '';
    if (address.isEmpty) {
      foo = await app.getAddress(lat: lat, long: long);
    } else {
      foo = address;
    }
    currentAddress.value = foo;
    searchController.text = foo;
    logger.wtf(currentAddress.value);
  }

  Future<void> getDropInList() async {
    try {
      onUpdate(status: Status.LOADING);
      ResponseModel res = await net.get(UrlConst.getDropIn, {});
      if (res.isSuccess) {
        List<DropCategoryModel> foo = List<DropCategoryModel>.from(
          (res.data ?? []).map(
            (e) => DropCategoryModel.fromJson(e),
          ),
        );
        dropInList.addAll(foo);

        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
      onUpdate(status: Status.SCUSSESS);
    } catch (e) {
      // onError(e.toString(), getCategoryApi);
    }
  }

  Future<void> addDropIn() async {
    try {
      if (selectedCategoryModelID?.id == null) {
        throw 'Please select Category ';
      }
      if (dropInImage.isEmpty) {
        throw 'Please Select images';
      }
      onUpdate(status: Status.LOADING);

      Map<String, dynamic> body = {
        'cat_id': selectedCategoryModelID?.id,
        'location': locationctrl.text,
        'title': titlectrl.text,
        'description': descriptionCtrl.text,
        'lat': currentLocation!.latitude,
        'lang': currentLocation!.longitude,
        'user_id': app.user.id,
        for (int i = 0; i < dropInImage.length; i++) ...{
          'images[$i]': await MultipartFile.fromFile(
            dropInImage.value[i].images,
            filename: 'image[$i].png',
          )
        }
      };

      ResponseModel response = await net.post(UrlConst.addDropIn, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        currentLocation = null;
        logger.w(response.data);
        newsFeedList.insert(0, NewsFeedModel.fromJson(response.data));
        onUpdate(status: Status.SCUSSESS);
        NewsFeedModel news = NewsFeedModel.fromJson(response.data ?? {});
        ProfileScreenController profileController =
            Get.put(ProfileScreenController());
        profileController.newsFeedList.add(news);
        profileController.onUpdate();
        dropInImage.clear();
        Get.find<HomeScreenController>().selectedIndex.value = 1;
        createDropInDialog();
        await 2.delay();
        Get.back();
        titlectrl.clear();
        locationctrl.clear();
        descriptionCtrl.clear();
        selectedCategoryModelID = null;
      } else {
        if (response.message == 'limit exiced') {
          throw 'You can only upload 3 three DropIns';
        }
        throw response.message;
      }
    } catch (e) {
      onError(e.toString(), addDropIn);
    }
  }

  Future<void> updateDropIn({required NewsFeedModel dropin}) async {
    try {
      if (selectedCategoryModelID?.id == null) {
        throw 'Please select Category';
      }
      final image = [];
      image.addAll(dropInImage);
      image.removeWhere((element) => element.id != 0);
      onUpdate(status: Status.LOADING);

      Map<String, dynamic> body = {
        'cat_id': selectedCategoryModelID?.id,
        'location': locationctrl.text,
        'title': titlectrl.text,
        'description': descriptionCtrl.text,
        'lat': currentLocation?.latitude ?? dropin.lat,
        'lang': currentLocation?.longitude ?? dropin.lang,
        'id': dropin.id,
        if (image.isNotEmpty) ...{
          for (int i = 0; i < image.length; i++) ...{
            'images[$i]': await MultipartFile.fromFile(
              image[i].images,
              filename: 'image[$i].png',
            )
          }
        }
      };

      ResponseModel response = await net.post(UrlConst.updateDropIn, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        currentLocation = null;
        logger.w(response.data);
        onUpdate(status: Status.SCUSSESS);
        locationctrl.clear();
        titlectrl.clear();
        descriptionCtrl.clear();
        edit.value = false;
        selectedCategoryModelID = null;
        dropInImage.clear();
        Get.back(result: NewsFeedModel.fromJson(response.data));
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(
        e.toString(),
        () {
          updateDropIn(dropin: dropin);
        },
      );
    }
  }

  @override
  void onReady() {
    if (Get.arguments != null) {
      descriptionCtrl.text = Get.arguments[0];
      titlectrl.text = Get.arguments[1];
      locationctrl.text = Get.arguments[2];
      pickeimage.value = Get.arguments[3];
      id.value = Get.arguments[4];
    }
    super.onReady();
  }

  Future<void> createDropInDialog() async {
    return showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
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
            'DROPIN Created!',
            style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppColors.appWhiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
