import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../src/utils/widgets/custom_container.dart';
import '../../../src/utils/widgets/popup_widget.dart';
import '../../../src_exports.dart';
import 'comon_controller.dart';

class StatisticScreen extends GetResponsiveView {
  final ProfileCtrl c = Get.put(ProfileCtrl());

  @override
  Widget desktop() {
    return Scaffold(
      backgroundColor: AppColors.appBlackColor,
      body: GetBuilder<ProfileCtrl>(
        builder: (ProfileCtrl c) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Users Statistics',
                  style:
                      AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    color: AppColors.appWhiteColor,
                  ),
                ).paddingSymmetric(horizontal: 20, vertical: 10),
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.totalUsers.toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Total Users',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.activeUsers.toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Active Logged-In Users',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.activateLocation
                                  .toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'New Users Last 24 Hours',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.lastChatSevendays
                                  .toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'New Users Last 7 Days',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Active Users VS DropIn Clicks',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color: AppColors.appWhiteColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ).paddingSymmetric(horizontal: 80),
                            TextButton(
                              onPressed: () {
                                c.isShow.value = !c.isShow();
                              },
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Last 30 Days',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineSmall
                                        ?.copyWith(
                                      color: AppColors.appWhiteColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: AppColors.appWhiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => c.isShow.value
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CustomContainer(
                                      title: 'Last 24 Hours',
                                      onTap: () {},
                                    ),
                                    CustomContainer(
                                      title: 'Last 7 Days',
                                      onTap: () {},
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ).paddingOnly(left: Get.width * 0.22),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              height: 300,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 220,
                                    child: SfCircularChart(
                                      series: <CircularSeries<ChartData,
                                          String>>[
                                        // Renders radial bar chart
                                        RadialBarSeries<ChartData, String>(
                                          dataSource: c.chartData,
                                          xValueMapper: (ChartData data, _) =>
                                              data.x,
                                          yValueMapper: (ChartData data, _) =>
                                              double.parse(
                                            c.statisticsModel.value.totalUsers
                                                .toString(),
                                          ),
                                          radius: '70%',
                                          maximumValue: double.parse(
                                            c.statisticsModel.value.totalUsers
                                                .toString(),
                                          ),
                                          innerRadius: '95%',
                                          strokeWidth: 5,
                                          strokeColor: AppColors.barcolor1,
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          animationDuration: 1000,
                                          cornerStyle: CornerStyle.bothCurve,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 280,
                                    child: SfCircularChart(
                                      series: <CircularSeries>[
                                        // Renders radial bar chart
                                        RadialBarSeries<ChartData, String>(
                                          dataSource: c.chartData,
                                          xValueMapper: (ChartData data, _) =>
                                              'Active user',
                                          yValueMapper: (ChartData data, _) =>
                                              double.parse(
                                            c.statisticsModel.value.totalVisits
                                                .toString(),
                                          ),
                                          radius: '70%',
                                          strokeWidth: 20,
                                          maximumValue: double.parse(
                                            c.statisticsModel.value.totalVisits,
                                          ),
                                          innerRadius: '95%',
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          cornerStyle: CornerStyle.bothCurve,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: AppColors.barcolor1,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Active Users',
                                      style: AppThemes
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  c.statisticsModel.value.activeUsers
                                      .toString(),
                                  style: AppThemes
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 16,
                                  ),
                                ).paddingSymmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: AppColors.barcolor,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Dropin MAP Clicks',
                                      style: AppThemes
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${c.statisticsModel.value.totalDropins}',
                                  style: AppThemes
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 16,
                                  ),
                                ).paddingSymmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ).paddingOnly(left: 50),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Active Users VS New Dropins',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color: AppColors.appWhiteColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ).paddingSymmetric(horizontal: 80),
                            TextButton(
                              onPressed: () {
                                c.showvalue.value = !c.showvalue();
                              },
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Last 7 Days',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineSmall
                                        ?.copyWith(
                                      color: AppColors.appWhiteColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: AppColors.appWhiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => c.showvalue.value
                              ? Column(
                                  // mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CustomContainer(
                                      title: 'Last 24 Hours',
                                      onTap: () {},
                                    ),
                                    CustomContainer(
                                      title: 'Last 7 Days',
                                      onTap: () {},
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ).paddingOnly(left: Get.width * 0.22),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              height: 300,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 220,
                                    child: SfCircularChart(
                                      series: <CircularSeries<ChartData,
                                          String>>[
                                        // Renders radial bar chart
                                        RadialBarSeries<ChartData, String>(
                                          dataSource: c.chartData,
                                          xValueMapper: (ChartData data, _) =>
                                              data.x,
                                          yValueMapper: (ChartData data, _) =>
                                              data.y,
                                          radius: '70%',
                                          maximumValue: double.parse(
                                            c.statisticsModel.value.totalUsers
                                                .toString(),
                                          ),
                                          innerRadius: '95%',
                                          strokeWidth: 5,
                                          strokeColor: AppColors.barcolor1,
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          animationDuration: 1000,
                                          cornerStyle: CornerStyle.bothCurve,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 280,
                                    child: SfCircularChart(
                                      series: <CircularSeries>[
                                        // Renders radial bar chart
                                        RadialBarSeries<ChartData, String>(
                                          dataSource: c.chartData,
                                          xValueMapper: (ChartData data, _) =>
                                              'Active user',
                                          yValueMapper: (ChartData data, _) =>
                                              double.parse(
                                            c.statisticsModel.value.totalDropins
                                                .toString(),
                                          ),
                                          radius: '70%',
                                          strokeWidth: 20,
                                          maximumValue: double.parse(
                                            c.statisticsModel.value.totalDropins
                                                .toString(),
                                          ),
                                          innerRadius: '95%',
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          cornerStyle: CornerStyle.bothCurve,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: AppColors.barcolor1,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Active Users',
                                      style: AppThemes
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${c.statisticsModel.value.activeUsers}',
                                  style: AppThemes
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 16,
                                  ),
                                ).paddingSymmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: AppColors.barcolor,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Dropin MAP Clicks',
                                      style: AppThemes
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${c.statisticsModel.value.totalDropins}',
                                  style: AppThemes
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 16,
                                  ),
                                ).paddingSymmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ).paddingOnly(right: 50),
                  ],
                ),
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.totalDropins.toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Total Dropins',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.goingSurfing.toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Going Surfing',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.meetOthers.toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Meet Others',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.wantingPhotographer
                                  .toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Wanting Photographer',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.surfTripRideshare
                                  .toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Surf Trip RideShare',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.buyAndSell.toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Buy and Sell',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Business Statistics',
                  style: AppThemes.lightTheme.textTheme.headlineLarge
                      ?.copyWith(color: AppColors.appWhiteColor, fontSize: 32),
                ).paddingSymmetric(horizontal: 20),
                SizedBox(
                  height: 10,
                ),
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.totalBusiness.toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Total Businesses',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${c.statisticsModel.value.totalVisits}',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Total Visits',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.totalBusinessRated
                                  .toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Total Businesses Rated',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${c.statisticsModel.value.totalAverageRatingBusiness.toStringAsFixed(1)} /5',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Average Rating of All Businesses ',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Total Businesses VS Visits',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color: AppColors.appWhiteColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ).paddingSymmetric(horizontal: 80),
                            TextButton(
                              onPressed: () {},
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Last 7 Days',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineSmall
                                        ?.copyWith(
                                      color: AppColors.appWhiteColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: AppColors.appWhiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              height: 300,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 220,
                                    child: SfCircularChart(
                                      series: <CircularSeries<ChartData,
                                          String>>[
                                        // Renders radial bar chart
                                        RadialBarSeries<ChartData, String>(
                                          dataSource: c.chartData,
                                          xValueMapper: (ChartData data, _) =>
                                              data.x,
                                          yValueMapper: (ChartData data, _) =>
                                              data.y,
                                          radius: '70%',
                                          maximumValue: double.parse(
                                            c.statisticsModel.value.totalUsers
                                                .toString(),
                                          ),
                                          innerRadius: '95%',
                                          strokeWidth: 5,
                                          strokeColor: AppColors.barcolor1,
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          animationDuration: 1000,
                                          cornerStyle: CornerStyle.bothCurve,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 280,
                                    child: SfCircularChart(
                                      series: <CircularSeries>[
                                        // Renders radial bar chart
                                        RadialBarSeries<ChartData, String>(
                                          dataSource: c.chartData,
                                          xValueMapper: (ChartData data, _) =>
                                              'Active user',
                                          yValueMapper: (ChartData data, _) =>
                                              double.parse(
                                            c.statisticsModel.value.totalDropins
                                                .toString(),
                                          ),
                                          radius: '70%',
                                          strokeWidth: 20,
                                          maximumValue: double.parse(
                                            c.statisticsModel.value.totalDropins
                                                .toString(),
                                          ),
                                          innerRadius: '95%',
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          cornerStyle: CornerStyle.bothCurve,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: AppColors.barcolor1,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Total Businesses',
                                      style: AppThemes
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${c.statisticsModel.value.totalBusiness}',
                                  style: AppThemes
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 16,
                                  ),
                                ).paddingSymmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: AppColors.barcolor,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Visits',
                                      style: AppThemes
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${c.statisticsModel.value.totalVisits}',
                                  style: AppThemes
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 16,
                                  ),
                                ).paddingSymmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ).paddingOnly(left: 50),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Active User VS Visits',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color: AppColors.appWhiteColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ).paddingSymmetric(horizontal: 80),
                            TextButton(
                              onPressed: () {
                                showMenu(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  constraints: const BoxConstraints(
                                    maxWidth: double.infinity,
                                  ),
                                  context: Get.context!,
                                  position:
                                      RelativeRect.fromLTRB(100, 280, 200, 260),
                                  items: <PopupMenuWidget>[
                                    PopupMenuWidget(
                                      height: 100,
                                      width: 200,
                                      child: Column(
                                        children: <Widget>[
                                          CustomContainer(
                                            title: 'Last 24 Hours',
                                            onTap: () {},
                                          ),
                                          CustomContainer(
                                            title: 'Last 7 Days',
                                            onTap: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Last 24 Hours',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineSmall
                                        ?.copyWith(
                                      color: AppColors.appWhiteColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: AppColors.appWhiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              height: 300,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 220,
                                    child: SfCircularChart(
                                      series: <CircularSeries<ChartData,
                                          String>>[
                                        // Renders radial bar chart
                                        RadialBarSeries<ChartData, String>(
                                          dataSource: c.chartData,
                                          xValueMapper: (ChartData data, _) =>
                                              data.x,
                                          yValueMapper: (ChartData data, _) =>
                                              double.parse(
                                            c.statisticsModel.value
                                                .totalBusiness
                                                .toString(),
                                          ),
                                          radius: '70%',
                                          maximumValue: double.parse(
                                            c.statisticsModel.value
                                                .totalBusiness
                                                .toString(),
                                          ),
                                          innerRadius: '95%',
                                          strokeWidth: 5,
                                          strokeColor: AppColors.barcolor1,
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          animationDuration: 1000,
                                          cornerStyle: CornerStyle.bothCurve,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 280,
                                    child: SfCircularChart(
                                      series: <CircularSeries>[
                                        // Renders radial bar chart
                                        RadialBarSeries<ChartData, String>(
                                          dataSource: c.chartData,
                                          xValueMapper: (ChartData data, _) =>
                                              'Active user',
                                          yValueMapper: (ChartData data, _) =>
                                              double.parse(
                                            c.statisticsModel.value.totalVisits
                                                .toString(),
                                          ),
                                          radius: '70%',
                                          strokeWidth: 20,
                                          maximumValue: double.parse(
                                            c.statisticsModel.value.totalVisits
                                                .toString(),
                                          ),
                                          innerRadius: '95%',
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          cornerStyle: CornerStyle.bothCurve,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: AppColors.barcolor1,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Active Users',
                                      style: AppThemes
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${c.statisticsModel.value.activeUsers}',
                                  style: AppThemes
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 16,
                                  ),
                                ).paddingSymmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: AppColors.barcolor,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Visits',
                                      style: AppThemes
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${c.statisticsModel.value.totalVisits}',
                                  style: AppThemes
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 16,
                                  ),
                                ).paddingSymmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ).paddingOnly(right: 50),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.photographer.toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Photographer',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.surfShop.toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Surf Shop',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.surfAccomodation
                                  .toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Surf Accommodations',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.surfCamp.toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Surf Camp',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.surfSchool.toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Surf School',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'General Statistics',
                  style: AppThemes.lightTheme.textTheme.headlineLarge
                      ?.copyWith(color: AppColors.appWhiteColor, fontSize: 32),
                ).paddingSymmetric(horizontal: 20, vertical: 15),
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.totalChats.toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Total Chats ',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.lastChatSevendays
                                  .toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'New Chats Last 7 Days',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              c.statisticsModel.value.activateLocation
                                  .toString(),
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              'Total Activated Live Locations',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              '510',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              '.....',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              '510',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontSize: 40,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                            Text(
                              '.....',
                              style: AppThemes
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.appWhiteColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingOnly(bottom: 100),
          );
        },
      ),
    );
  }
}
