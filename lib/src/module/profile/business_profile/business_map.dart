import 'package:dropin/src/models/place_api_model.dart';
import 'package:dropin/src/module/authprofile/profilescreen_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../src_exports.dart';
import '../../../models/autocomplete_address_model.dart';

class BusinessMaps extends StatefulWidget {
  BusinessMaps({super.key});

  @override
  State<BusinessMaps> createState() => _BusinessMapsState();
}

class _BusinessMapsState extends State<BusinessMaps> {
  final String uuid = Uuid().v4();
  ProfileController controller = Get.find<ProfileController>();

  @override
  void dispose() {
    controller.searchContoller.clear();
    super.dispose();
  }

  LatLng? foo;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (ProfileController controller) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(19, 23),
                  zoom: 14,
                ),
                compassEnabled: false,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                onMapCreated: (GoogleMapController mapController) async {
                  controller.gMapsController = mapController;
                  await controller.onMapCreate();
                },
                onTap: (LatLng latLang) async {
                  foo = latLang;
                  controller.pickedLocation = latLang;
                  logger.i(controller.pickedLocation);
                  await controller.addMarker(latLang);
                  controller.getAddress(
                    lat: latLang.latitude,
                    long: latLang.longitude,
                  );
                  // customBottomSheet(child: AddressBottomSheet());
                },
                markers: controller.markers,
              ),
              SafeArea(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: controller.searchContoller,
                      textInputAction: TextInputAction.search,
                      onChanged: (String value) async {
                        controller.onUpdate(status: Status.LOADING_MORE);
                        controller.addressModel.value =
                            await app.getLocationFromMap(value, uuid);
                        controller.onUpdate(status: Status.SCUSSESS);
                      },
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        hintStyle: const TextStyle(color: AppColors.hintColor),
                        hintText: 'Search for the location...',
                        fillColor: Colors.white,
                      ),
                    ).paddingOnly(top: 10, right: 15, left: 15),
                    Visibility(
                      visible:
                          controller.addressModel.value.predictions.isNotEmpty,
                      child: SizedBox(
                        height: 120,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            itemCount: controller
                                .addressModel.value.predictions.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Prediction result = controller
                                  .addressModel.value.predictions[index];
                              return InkWell(
                                onTap: () async {
                                  final PlaceApiModel address = await app
                                      .getLocationFromPlaceID(result.placeId);
                                  controller.addressModel.value =
                                      AutoCompleteAddress();
                                  final latLang = LatLng(
                                    address.result!.geometry!.location!.lat,
                                    address.result!.geometry!.location!.lng,
                                  );
                                  controller.pickedLocation = latLang;
                                  logger.i(controller.pickedLocation);
                                  await controller.addMarker(latLang);
                                  controller.getAddress(
                                    lat: latLang.latitude,
                                    long: latLang.longitude,
                                    address: result.description,
                                  );
                                  foo = LatLng(
                                    address.result!.geometry!.location!.lat,
                                    address.result!.geometry!.location!.lng,
                                  );
                                  controller.gMapsController!.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                      LatLng(
                                        address.result!.geometry!.location!.lat,
                                        address.result!.geometry!.location!.lng,
                                      ),
                                      16,
                                    ),
                                  );
                                },
                                child: Text(result.description),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(),
                          ).paddingSymmetric(vertical: 10),
                        ),
                      ).paddingOnly(top: 10, left: 20, right: 20),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AppButton(
                          title: 'Back',
                          callback: () {
                            Get.back();
                          },
                          width: 100,
                          height: 45,
                          padding: EdgeInsets.zero,
                          radius: const BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          color: AppColors.appButtonColor,
                        ),
                        AppButton(
                          color: AppColors.appButtonColor,
                          padding: EdgeInsets.zero,
                          title: 'Next',
                          callback: () {
                            controller.pickedLocationForBusiness = foo;
                            logger.w(controller.pickedLocationForBusiness);
                            controller.locationCTRl.text =
                                controller.currentAddress.value;
                            controller.addressModel.value =
                                AutoCompleteAddress();
                            controller.searchContoller.clear();
                            Get.back();
                          },
                          width: 100,
                          height: 45,
                          radius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                        ),
                      ],
                    ).paddingOnly(top: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AddressBottomSheet extends StatelessWidget {
  AddressBottomSheet({super.key});

  final TextEditingController storeController = TextEditingController();
  final TextEditingController blockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (ProfileController controller) => WillPopScope(
        onWillPop: () {
          controller.selectedAddressIndex.value = -1;
          return Future.value(true);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'selectAddress'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (controller.isLoading) ...<Widget>[
                SizedBox(
                  height: Get.height * 0.3,
                  child: Center(
                    child: LoaderView(),
                  ),
                ),
              ],
              if (!controller.isLoading) ...<Widget>[
                Row(
                  children: <Widget>[
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.back();
                        controller.selectedAddressIndex.value = -1;
                        FocusScope.of(context).unfocus();
                      },
                      child: Text(
                        'selectAgain'.tr,
                        style: const TextStyle(
                          color: AppColors.appButtonColor,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ).paddingOnly(bottom: 10),
                ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.addressList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        controller.selectedAddressIndex.value = index;
                        controller.update();
                        // FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        // margin: EdgeInsets.all(10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: controller.selectedAddressIndex.value == index
                              ? AppColors.appButtonColor
                              : Colors.transparent,
                        ),
                        child: Text(
                          controller.addressList[index].trim(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color:
                                controller.selectedAddressIndex.value == index
                                    ? Colors.white
                                    : Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
              AppButton(
                title: 'select'.tr,
                callback: () {
                  if (controller.selectedAddressIndex() == -1) {
                    app.onError('Please select Address', () {});
                  } else {
                    FocusScope.of(context).unfocus();
                    controller.address = controller
                        .addressList[controller.selectedAddressIndex.value];
                    logger.w(controller.address);
                    controller.selectedAddressIndex.value = -1;
                    controller.locationCTRl.text = controller.address;
                    Get.back();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
