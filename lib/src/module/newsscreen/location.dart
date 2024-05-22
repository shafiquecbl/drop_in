import 'package:dropin/src/models/place_api_model.dart';
import 'package:dropin/src/module/newsscreen/news_screen_controller.dart';
import 'package:dropin/src_exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/autocomplete_address_model.dart';

class LocationMap extends StatefulWidget {
  LocationMap({Key? key}) : super(key: key);

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  final String uuid = Uuid().v4();
  final c = Get.find<NewsScreenController>();

  @override
  void dispose() {
    // c.searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsScreenController>(
      builder: (NewsScreenController controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.markers.clear();

            return await true;
          },
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(19, 23),
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController mapController) async {
                    controller.gMapsController = mapController;
                    await controller.onMapCreate();
                  },
                  onTap: (LatLng latLang) async {
                    await controller.addMarker(latLang);
                    controller.currentLocation = latLang;
                    logger.wtf(latLang);
                    controller.searchController.text = await app.getAddress(
                      lat: latLang.latitude,
                      long: latLang.longitude,
                    );

                    // Get.back();
                  },
                  markers: controller.markers,
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
                          hintStyle:
                              const TextStyle(color: AppColors.hintColor),
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
                              itemBuilder: (BuildContext context, int index) {
                                final Prediction result = controller
                                    .addressResults.value.predictions[index];
                                return InkWell(
                                  onTap: () async {
                                    final PlaceApiModel foo = await app
                                        .getLocationFromPlaceID(result.placeId);
                                    controller.addressResults.value =
                                        AutoCompleteAddress();
                                    await controller.gMapsController!
                                        .animateCamera(
                                      CameraUpdate.newLatLngZoom(
                                        LatLng(
                                          foo.result!.geometry!.location!.lat,
                                          foo.result!.geometry!.location!.lng,
                                        ),
                                        16,
                                      ),
                                    );
                                    controller.searchController.text =
                                        result.description;
                                    controller.controller.text =
                                        result.description;
                                    controller.update();
                                    logger.w(
                                        'SELECTED LOCATION::${result.description}');
                                    await controller.addMarker(
                                      LatLng(
                                        foo.result!.geometry!.location!.lat,
                                        foo.result!.geometry!.location!.lng,
                                      ),
                                    );
                                    /* controller.currentLocation = LatLng(
                                      foo.result!.geometry!.location!.lat,
                                      foo.result!.geometry!.location!.lng,
                                    );*/
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
                              // controller.markers.clear();
                              controller.searchController.clear();
                              controller.addressResults.value.predictions = [];
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
                            callback: () async {
                              if (app.currentAddress.isEmpty) {
                                controller.controller.text = controller
                                    .searchController
                                    .text = await app.getAddress(
                                  lat: controller.currentLocation.latitude,
                                  long: controller.currentLocation.longitude,
                                );
                                await controller.addMarker(
                                  LatLng(
                                    controller.currentLocation.latitude,
                                    controller.currentLocation.longitude,
                                  ),
                                );
                                controller.addressResults.value.predictions =
                                    [];
                                Get.back();
                              } else if (controller.controller.text !=
                                  app.currentAddress) {
                                logger.w('Else if');
                                if (app.currentAddress.isEmpty) {
                                  controller.controller.text =
                                      app.currentAddress;
                                } else {
                                  controller.controller.text =
                                      controller.searchController.text;
                                }
                                controller.addressResults.value.predictions =
                                    [];
                                Get.back();
                              } else {
                                // controller.controller.text
                                logger.w('Else');
                                Get.back();
                                controller.addressResults.value.predictions =
                                [];
                                controller.searchController.text =
                                    controller.controller.text;
                              }
                              // controller.markers.clear();
                              /*if (controller.controller.text.isNotEmpty) {
                                Get.back();
                              }*/
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
          ),
        );
      },
    );
  }
}
