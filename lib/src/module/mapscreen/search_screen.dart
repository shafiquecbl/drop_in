import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../src_exports.dart';
import '../../models/address_model.dart';
import '../../models/autocomplete_address_model.dart';
import '../../models/map_model.dart';
import 'map_screen_controller.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MapsController controller = Get.find<MapsController>();

  @override
  void dispose() {
    controller.address.value = AutoCompleteAddress();
    controller.searchController.clear();
    super.dispose();
  }

  final uuid = Uuid().v4();
  Debouncer debouncer = Debouncer(delay: Duration(milliseconds: 300));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.searchBgColor,
      body: SafeArea(
        child: GetBuilder<MapsController>(
          builder: (MapsController controller) {
            return Column(
              children: <Widget>[
                TextField(
                  textInputAction: TextInputAction.search,
                  controller: controller.searchController,
                  onChanged: (String value) async {
                    debouncer.call(() async {
                      logger.w('on chan');
                      if (value.isNotEmpty) {
                        controller.onUpdate(status: Status.LOADING_MORE);
                        controller.address.value =
                            await app.getLocationFromMap(value, uuid);
                        controller.onUpdate(status: Status.SCUSSESS);
                        // await controller.searchLocation();
                      } else {
                        controller.searchMapModel.value = MapModel();
                        controller.onUpdate();
                      }
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        controller.searchController.clear();
                        Get.back();
                      },
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.searchController.clear();
                        controller.searchMapModel.value = MapModel();
                        controller.onUpdate();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
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
                /* Divider(
                  thickness: 2,
                  color: AppColors.darkWhite.withOpacity(0.6),
                ),
                SizedBox(
                  height: 90,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: BusinessCategoryType.values.length,
                          itemBuilder: (BuildContext context, int index) {
                            BusinessCategoryType map =
                                BusinessCategoryType.values[index];
                            return InkWell(
                              onTap: () {
                                controller.isBusinessSearch = true;
                                controller.catId = map.id;
                                controller.searchLocation();
                              },
                              child: SizedBox(
                                width: 60,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    AppAssets.asImage(
                                      map.icon,
                                      height: 50,
                                      width: 50,
                                    ).paddingOnly(bottom: 5),
                                    Text(
                                      map.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.greyLight,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ).paddingSymmetric(horizontal: 5),
                              ),
                            );
                          },
                        ),
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: DropInCategory.values.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final DropInCategory map =
                                DropInCategory.values[index];
                            return InkWell(
                              onTap: () {
                                controller.isBusinessSearch = false;
                                controller.catId = map.id;
                                controller.searchLocation();
                              },
                              child: SizedBox(
                                width: 60,
                                child: Column(
                                  children: [
                                    AppAssets.asImage(
                                      map.iconPath,
                                      height: 50,
                                      width: 50,
                                    ).paddingOnly(bottom: 5),
                                    Text(
                                      map.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.greyLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ).paddingSymmetric(horizontal: 5),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: AppColors.darkWhite.withOpacity(0.6),
                ),*/
                controller.lodingMore
                    ? Text('Searching')
                    : Expanded(
                        child: ListView.separated(
                          /*shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),*/
                          padding: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          itemCount:
                              controller.address.value.predictions.length,
                          itemBuilder: (_, int index) {
                            final result =
                                controller.address.value.predictions[index];
                            return InkWell(
                              onTap: () async {
                                final foo = await app
                                    .getLocationFromPlaceID(result.placeId);
                                controller.addressModel = AddressResults();

                                Get.back();
                                controller.gMapsController!.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                    LatLng(
                                      foo.result!.geometry!.location!.lat,
                                      foo.result!.geometry!.location!.lng,
                                    ),
                                    14,
                                  ),
                                );
                                controller.addressModel = AddressResults();
                              },
                              child: SizedBox(
                                width: Get.width,
                                child: Text(
                                  result.description,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => Divider(
                            thickness: 2,
                            color: AppColors.darkWhite.withOpacity(0.6),
                          ),
                        ),
                      ),
                /* : Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Visibility(
                                visible: controller.isBusinessSearch ?? true,
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: controller.searchMapModel.value
                                      .businessDetails.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final BusinessDetail map = controller
                                        .searchMapModel
                                        .value
                                        .businessDetails[index];
                                    return InkWell(
                                      onTap: () {
                                        controller.animateToCurrentLoc(
                                          map.toLatLong(),
                                        );
                                        Get.back();
                                      },
                                      child: Row(
                                        children: [
                                          AppAssets.asImage(
                                            map.iconPath,
                                            height: 40,
                                          ).paddingOnly(right: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                map.businessName,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.8,
                                                child: Text(
                                                  map.loc,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 9.57,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ).paddingOnly(bottom: 10),
                                    );
                                  },
                                ),
                              ),
                              Visibility(
                                visible:
                                    !(controller.isBusinessSearch ?? false),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: controller
                                      .searchMapModel.value.userDropin.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final BusinessDetail map = controller
                                        .searchMapModel.value.userDropin[index];
                                    return InkWell(
                                      focusColor: AppColors.transparent,
                                      highlightColor: AppColors.transparent,
                                      hoverColor: AppColors.transparent,
                                      splashColor: AppColors.transparent,
                                      onTap: () {
                                        controller.animateToCurrentLoc(
                                          map.toLatLong(),
                                        );
                                        Get.back();
                                      },
                                      child: Row(
                                        children: [
                                          AppAssets.asImage(map.iconPath,
                                                  height: 40)
                                              .paddingOnly(right: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                map.title,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.8,
                                                child: Text(
                                                  map.loc,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 9.57,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ).paddingOnly(bottom: 10),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )*/
              ],
            );
          },
        ),
      ),
    );
  }
}
