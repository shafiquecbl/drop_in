import 'package:dropin/src/models/live_location_model.dart';
import 'package:dropin/src/module/mapscreen/map_screen_controller.dart';
import 'package:dropin/src/utils/widgets/app_images.dart';
import 'package:dropin/src_exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatelessWidget {
  MapsView({this.onMapTap, super.key});
  final Function()? onMapTap;

  final MapsController controller = Get.find<MapsController>();

  @override
  Widget build(BuildContext context) {
    return GetX<MapsController>(
      builder: (MapsController c) {
        return GoogleMap(
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          trafficEnabled: false,
          compassEnabled: false,
          myLocationEnabled: false,
          rotateGesturesEnabled: true,

          initialCameraPosition: const CameraPosition(
            target: LatLng(19, 23),
            zoom: 14,
          ),
          onMapCreated: (GoogleMapController mapsController) async {
            controller.gMapsController = mapsController;
            await controller.onMapCreate();
          },
          onCameraMove: (CameraPosition position) {
            controller.movementLatLong = position.target;
            controller.zoomLevel = position.zoom;
          },
          onTap: (_) {
            controller.filterOpen = false;
            controller.update();
            onMapTap?.call();
          },
          onCameraIdle: () {
            if (controller.zoomLevel != null) {
              logger.i(controller.zoomLevel! > 12);
              if (controller.zoomLevel! > 12) {
                logger.wtf('message');
                if (!controller.lodingMore) {
                  controller.getMap();
                }
              } else {
                controller.tempMarkers.addAll(controller.markers);
                logger.w('markers clear');
                controller.markers.removeWhere(
                  (Marker element) => element.mapsId.value != 'currentLocation',
                );
                controller.onUpdate();
              }
            }
          },

          markers: <Marker>{
            ...controller.markers(),
            ...controller.liveMarkers(),
          }.obs(),
          // markers: controller.markers(),
        );
      },
    );
  }
}

class LiveLocationBottomSheet extends StatelessWidget {
  LiveLocationBottomSheet({required this.user, Key? key}) : super(key: key);
  final LiveLocationModel user;

  final MapsController c = Get.find<MapsController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 5,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
        ).paddingOnly(bottom: 15),
        SizedBox(
          width: Get.width,
          height: 130,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: Get.width * 0.25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      user.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                        fontFamily: 'Montserrat',
                      ),
                    ).paddingSymmetric(horizontal: 10),
                    Text(
                      'Live Location',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        fontFamily: 'Montserrat',
                      ),
                    ).paddingOnly(left: 20, bottom: 10),
                    Container(
                      width: 250,
                      height: 65,
                      padding: EdgeInsets.only(
                        left: 20,
                        top: 10,
                        bottom: 10,
                        right: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.67),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          user.description,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 55,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: AppImages.asProvider(
                    user.image,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (app.user.id != user.userId) ...<Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppElevatedButton(
                height: 35,
                width: 120,
                callback: () {
                  Get.toNamed(
                    Routes.ViewProfile,
                    arguments: user.userId,
                  );
                },
                title: 'View Profile',
                color: AppColors.appBlackColor,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              AppElevatedButton(
                height: 35,
                width: 120,
                callback: () {
                  c.createChat(user.userName, userId: user.userId);
                },
                title: 'Message',
                color: AppColors.appBlackColor,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ).paddingOnly(left: 10),
            ],
          ),
        ],
      ],
    ).paddingSymmetric(
      vertical: 10,
      horizontal: 25,
    );
  }
}
