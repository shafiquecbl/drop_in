import 'package:dropin/src/module/dropinscreen/dropin_controller.dart';
import 'package:dropin/src/module/homescreen/home_screen_controller.dart';
import 'package:dropin/src_exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/autocomplete_address_model.dart';

class DropInMap extends StatefulWidget {
  DropInMap({Key? key}) : super(key: key);

  @override
  State<DropInMap> createState() => _DropInMapState();
}

class _DropInMapState extends State<DropInMap> {
  DropinController controller = Get.find<DropinController>();

  HomeScreenController c = Get.find<HomeScreenController>();

  final uuid = Uuid().v4();

  Set<Marker> markers = {};

  @override
  void dispose() {
    controller.searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DropinController>(
      builder: (DropinController controller) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              GoogleMap(
                markers: controller.markers,
                zoomControlsEnabled: false,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 10,
                ),
                myLocationButtonEnabled: false,
                compassEnabled: false,
                onMapCreated: (GoogleMapController mapController) async {
                  controller.gMapsController = mapController;
                  await controller.onMapCreate();
                },
                // onCameraMove: (CameraPosition position) async {
                //   controller.currentLocation = position.target;
                // },
                onTap: (LatLng argument) async {
                  controller.currentLocation = argument;
                  controller.addMarker(argument);
                  await controller.getAddressFromLatLng(
                    long: controller.currentLocation!.longitude,
                    lat: controller.currentLocation!.latitude,
                  );
                },
              ),
              SafeArea(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: controller.searchController,
                      onChanged: (String value) async {
                        controller.onUpdate(status: Status.LOADING_MORE);
                        controller.addressResults.value =
                            await app.getLocationFromMap(value, uuid);
                        controller.onUpdate(status: Status.SCUSSESS);
                        app.update();
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
                      visible: controller
                          .addressResults.value.predictions.isNotEmpty,
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
                                .addressResults.value.predictions.length,
                            itemBuilder: (context, index) {
                              final result = controller
                                  .addressResults.value.predictions[index];
                              return InkWell(
                                onTap: () async {
                                  final foo = await app
                                      .getLocationFromPlaceID(result.placeId);
                                  controller.addressResults.value =
                                      AutoCompleteAddress();
                                  controller.gMapsController!.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                      LatLng(
                                        foo.result!.geometry!.location!.lat,
                                        foo.result!.geometry!.location!.lng,
                                      ),
                                      16,
                                    ),
                                  );
                                  final latLang = LatLng(
                                    foo.result!.geometry!.location!.lat,
                                    foo.result!.geometry!.location!.lng,
                                  );
                                  controller.markers.clear();
                                  controller.currentLocation = latLang;
                                  controller.addMarker(latLang);
                                  await controller.getAddressFromLatLng(
                                    long: controller.currentLocation!.longitude,
                                    lat: controller.currentLocation!.latitude,
                                    address: result.description,
                                  );
                                },
                                child: Text(result.description),
                              );
                            },
                            separatorBuilder: (_, __) => Divider(),
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
                            controller.locationctrl.text =
                                controller.currentAddress.value;

                            if (c.selectedIndex.value == 2) {
                              controller.addressResults.value =
                                  AutoCompleteAddress();
                              Get.back();
                            } else {
                              Get.toNamed(Routes.AddYourBusiness);
                              Get.back();
                            }

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
              // Center(
              //   child: AppAssets.asImage(
              //     AppAssets.dropinPin,
              //     height: 50,
              //   ).paddingOnly(bottom: 25),
              // ),
            ],
          ),
        );
      },
    );
  }
}
