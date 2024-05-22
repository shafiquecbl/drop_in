// ignore_for_file: always_specify_types

import 'package:dropin/src/module/airline_info_screen/airline_info_screen.dart';
import 'package:dropin/src/module/mapscreen/map_screen_controller.dart';
import 'package:dropin/src/module/travel_tips_screen/travel_tips_screen.dart';
import 'package:dropin/src/utils/widgets/custom_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import '../../../src_exports.dart';
import '../../utils/widgets/maps_view.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  MapsController controller = Get.put(MapsController());

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    apiCall();
    super.initState();
  }

  Future<void> apiCall() async {
    await controller.getMap();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        logger.w('app killing');
        if (controller.animationController != null) {
          controller.stopLiveLocation();
        }
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      // case AppLifecycleState.hidden:
      //   break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MapsController>(
        builder: (MapsController controller) {
          if (controller.isLoading) {
            return LoaderView();
          } else {
            return Stack(
              children: <Widget>[
                MapsView(onMapTap: showAirlineInfoSheet),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextField(
                        onTap: () {
                          Get.toNamed(Routes.SearchScreen);
                        },
                        readOnly: true,
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
                      ).paddingOnly(bottom: 10),
                      InkWell(
                        onTap: () {
                          controller.filterOpen = !controller.filterOpen;
                          controller.update();
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 50,
                          width: controller.filterOpen ? Get.width * 0.8 : 50,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.listviewcolor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: controller.filterOpen
                              ? filterView()
                              : Icon(
                                  Icons.filter_list_outlined,
                                  color: AppColors.navyBlue,
                                ),
                        ),
                      ).paddingOnly(bottom: 10),
                      Visibility(
                        visible: controller.businessFilters.isNotEmpty ||
                            controller.userFilters.isNotEmpty,
                        child: InkWell(
                          onTap: () async {
                            controller.businessFilters.clear();
                            controller.userFilters.clear();
                            final DateTime startTime = DateTime.now();
                            await controller.getMap();
                            final DateTime endTime = DateTime.now();
                            logger.wtf(
                              endTime.difference(startTime).inMilliseconds,
                            );
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.listviewcolor,
                            child: Icon(
                              Icons.filter_list_off,
                              color: AppColors.navyBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 15, vertical: 10),
                ),
                Positioned(
                  bottom:
                      Platform.isIOS ? Get.height * 0.17 : Get.height * 0.15,
                  right: 10,
                  child: Column(
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: controller.animateToCurrentLoc,
                        elevation: 0,
                        backgroundColor: AppColors.locationcolor,
                        heroTag: 'my_location',
                        child: const Icon(
                          Icons.my_location,
                          color: AppColors.appWhiteColor,
                          size: 35,
                        ),
                      ).paddingOnly(bottom: 8),
                      FloatingActionButton(
                        heroTag: 'north',
                        onPressed: () {
                          controller.showNorth();
                        },
                        elevation: 0,
                        backgroundColor: AppColors.locationcolor,
                        child: AppAssets.asIcon(
                          AppAssets.north,
                          color: AppColors.appWhiteColor,
                          size: 35,
                        ),
                      ).paddingOnly(bottom: 20),
                      InkWell(
                        onTap: () async {
                          logger.w('message');
                          final LocationPermission permission =
                              await Geolocator.requestPermission();
                          logger.w(
                            '$permission == LocationPermission.denied || $permission == LocationPermission.deniedForever',
                          );
                          if (permission == LocationPermission.denied ||
                              permission == LocationPermission.deniedForever) {
                            Get.back();
                            showDialog(
                              context: Get.context!,
                              barrierDismissible: true,
                              builder: (BuildContext context) => AlertDialog(
                                shadowColor: AppColors.black,
                                backgroundColor: AppColors.transparent,
                                elevation: 0,
                                title: InkWell(
                                  onTap: () {
                                    Get.back();
                                    Geolocator.openLocationSettings();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.buttonColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    // height: 20,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Enable Location Permission',
                                      style: AppThemes
                                          .lightTheme.textTheme.headlineMedium
                                          ?.copyWith(
                                        color: AppColors.appWhiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            if (controller.animation == null) {
                              Get.back();
                              showDialog(
                                context: Get.context!,
                                barrierDismissible: true,
                                builder: (BuildContext context) => AlertDialog(
                                  shadowColor: AppColors.black,
                                  backgroundColor: AppColors.transparent,
                                  elevation: 0,
                                  title: InkWell(
                                    onTap: () {
                                      Get.back();
                                      Get.dialog(liveLocationPermission());
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: AppColors.buttonColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      // height: 20,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'Enable Location Sharing',
                                        style: AppThemes
                                            .lightTheme.textTheme.headlineMedium
                                            ?.copyWith(
                                          color: AppColors.appWhiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              showDialog(
                                context: Get.context!,
                                barrierDismissible: true,
                                builder: (BuildContext context) => AlertDialog(
                                  shadowColor: AppColors.black,
                                  backgroundColor: AppColors.transparent,
                                  elevation: 0,
                                  title: InkWell(
                                    onTap: () {
                                      controller.stopLiveLocation();
                                      Get.back();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: AppColors.buttonColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      // height: 20,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'Stop Live Location?',
                                        style: AppThemes
                                            .lightTheme.textTheme.headlineMedium
                                            ?.copyWith(
                                          color: AppColors.appWhiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        // : controller.stopLiveLocation,
                        child: Obx(
                          () => Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.navyBlue,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppColors.listviewcolor,
                                  blurRadius: 0,
                                  spreadRadius:
                                      controller.liveLocationRadius.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget liveLocationPermission() {
    return DialogContainer(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.buttonColor,
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Sharing Live Location',
              style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                fontSize: 15,
                color: AppColors.appWhiteColor,
              ),
            ).paddingOnly(bottom: 5),
            Row(
              children: <Widget>[
                Expanded(
                  child: AppTextField(
                    height: 80,
                    maxLines: 5,
                    textController: controller.descriptionController,
                    title: 'Tell People What You’re Up To...',
                    labelStyle:
                        AppThemes.lightTheme.textTheme.headlineLarge?.copyWith(
                      fontSize: 8,
                    ),
                    hint: "'Write a description for others to see here'",
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(
                        60,
                      ),
                    ],
                    onChanged: (
                      String value,
                    ) {
                      controller.descCount.value = value.length;
                    },
                    hintStyle:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontSize: 14,
                      color: AppColors.appBlackColor,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    try {
                      if (controller.descriptionController.text
                          .trim()
                          .isEmpty) {
                        throw 'Please enter description';
                      }
                      controller.startLiveLocation();
                      Fluttertoast.showToast(
                        msg:
                            "Location sharing will automatically stop after an hour if you don't turn if off  ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColors.primary,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );

                      Get.back();
                    } catch (e) {
                      controller.onError(
                        e,
                        () {},
                      );
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColors.listviewcolor,
                    radius: 28,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.navyBlue,
                      child: Text(
                        'GO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingOnly(bottom: 5),
            SizedBox(
              width: Get.width * 0.35,
              height: 10,
              child: Obx(
                () {
                  return Text(
                    '${controller.descCount.value}/60',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(
                        0.8,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
          ],
        ).paddingSymmetric(
          horizontal: 8,
          vertical: 10,
        ),
      ),
      maxHei: 138,
      minHei: 138,
      maxWid: 300,
      minWid: 300,
    );
  }

  Widget filterView() {
    return SizedBox(
      height: 45,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: BusinessCategoryType.values.length,
              itemBuilder: (BuildContext context, int index) {
                BusinessCategoryType map = BusinessCategoryType.values[index];
                return InkWell(
                  onTap: () async {
                    if (controller.businessFilters.contains(map.id)) {
                      controller.businessFilters.remove(map.id);
                    } else {
                      controller.businessFilters.add(map.id);
                    }
                    logger.w(controller.businessFilters);
                    final DateTime startTime = DateTime.now();
                    await controller.getMap();
                    final DateTime endTime = DateTime.now();
                    logger.wtf(endTime.difference(startTime).inMilliseconds);
                  },
                  child: SizedBox(
                    width: 30,
                    child: Column(
                      children: <Widget>[
                        AppAssets.asImage(
                          map.icon,
                          height: 30,
                          width: 30,
                        )
                            .paddingOnly(bottom: 5)
                            .paddingSymmetric(horizontal: 5),
                        Visibility(
                          visible: controller.businessFilters.contains(map.id),
                          child: CircleAvatar(
                            radius: 2,
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
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
                final DropInCategory map = DropInCategory.values[index];
                return InkWell(
                  onTap: () async {
                    if (controller.userFilters.contains(map.id)) {
                      controller.userFilters.remove(map.id);
                    } else {
                      controller.userFilters.add(map.id);
                    }
                    await controller.getMap();
                  },
                  child: SizedBox(
                    width: 20,
                    child: Column(
                      children: <Widget>[
                        AppAssets.asImage(
                          map.iconPath,
                          height: 30,
                          width: 30,
                        ).paddingOnly(bottom: 5),
                        Visibility(
                          visible: controller.userFilters.contains(map.id),
                          child: CircleAvatar(
                            radius: 2,
                            backgroundColor: AppColors.appButtonColor,
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
      ).paddingOnly(right: 10, left: 15),
    );
  }

  Future showAirlineInfoSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => AirlineInfoSheet(),
    );
  }
}

class AirlineInfoSheet extends StatelessWidget {
  const AirlineInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    return Container(
      padding: EdgeInsets.all(15).copyWith(top: 5),
      width: width,
      height: height * 0.65,
      decoration: BoxDecoration(
        color: Color(0xFF5A81E6),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView(
        children: <Widget>[
          Center(
            child: Container(
              height: 5,
              width: width * 0.3,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Image.asset(
                  AppAssets.plane,
                ),
              ),
              Text(
                'Airline Info',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: width * 0.1),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Divider(),
          ),
          Text(
            'Location',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Airline Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              visualDensity: VisualDensity(horizontal: -4, vertical: -2),
              shape: RoundedRectangleBorder(),
              title: Text(
                'More Info Here. (DO NOT ADD TO THE APP PLEASE)',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              childrenPadding: EdgeInsets.all(15).copyWith(top: 0),
              children: <Widget>[
                SizedBox(width: width),
                Text(
                  '//\n//\n//\n//\n//',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                Image.asset(
                  AppAssets.profile,
                  width: 20,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'Accepts checked-in surfboard bags',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                Image.asset(
                  AppAssets.surfWhite,
                  width: 20,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'Additional for multiple boards',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                Image.asset(
                  AppAssets.check,
                  width: 20,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'Accepts longboards (max. 300cm)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                Image.asset(
                  AppAssets.dolor,
                  color: Colors.white,
                  width: 20,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'Additional fees for longboards ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              Spacer(),
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Was this useful?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 5),
                        Wrap(
                          children: <Widget>[
                            Image.asset(
                              AppAssets.like,
                              color: Colors.white,
                              width: 20,
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              AppAssets.dislike,
                              color: Colors.white,
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  AppElevatedButton(
                    height: 27,
                    width: 147,
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(30),
                    callback: () async {
                      showDialog(
                        context: Get.context!,
                        barrierDismissible: true,
                        builder: (BuildContext context) => AlertDialog(
                          shadowColor: AppColors.black,
                          backgroundColor: AppColors.transparent,
                          elevation: 0,
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (_) => TravelTipsScreen(),
                                        ),
                                      )
                                      .then(
                                        (value) => showDialog(
                                          context: Get.context!,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            shadowColor: AppColors.black,
                                            backgroundColor:
                                                AppColors.transparent,
                                            elevation: 0,
                                            title: InkWell(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Container(
                                                width: 280,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 15,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      AppColors.buttonColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                // height: 20,
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  'Thank you for your contribution',
                                                  style: AppThemes.lightTheme
                                                      .textTheme.headlineMedium
                                                      ?.copyWith(
                                                    color:
                                                        AppColors.appWhiteColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                },
                                child: Container(
                                  width: 280,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.buttonColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  // height: 20,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'Share travel tips?',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (_) => AirlineInfoScreen(),
                                    ),
                                  )
                                      .then((value) {
                                    showDialog(
                                      context: Get.context!,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        shadowColor: AppColors.black,
                                        backgroundColor: AppColors.transparent,
                                        elevation: 0,
                                        title: InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Container(
                                            width: 280,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 15,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: AppColors.buttonColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            // height: 20,
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              'Thank you for your contribution',
                                              style: AppThemes.lightTheme
                                                  .textTheme.headlineMedium
                                                  ?.copyWith(
                                                color: AppColors.appWhiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                },
                                child: Container(
                                  width: 280,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.buttonColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  // height: 20,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'Share airline information?',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    title: 'Contribute',
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: AppColors.appWhiteColor,
                    ),
                  ).paddingAll(10),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
