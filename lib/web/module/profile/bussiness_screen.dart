import 'package:dropin/src/models/bussiness_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../src/models/sub_category_model.dart';
import '../../../src/module/mapscreen/map_screen_controller.dart';
import '../../../src/utils/widgets/app_images.dart';
import '../../../src/utils/widgets/custom_dialog.dart';
import '../../../src/utils/widgets/popup_widget.dart';
import '../../../src/utils/widgets/web_button.dart';
import '../../../src/utils/widgets/web_textfield.dart';
import '../../../src_exports.dart';
import 'comon_controller.dart';

class BussinessScreen extends GetResponsiveView {
  final ProfileCtrl c = Get.put(ProfileCtrl());
  final MapsController controler = Get.put(MapsController());

  @override
  Widget desktop() {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Business',
            style: AppThemes.lightTheme.textTheme.headlineMedium
                ?.copyWith(color: AppColors.appBlackColor, fontSize: 32),
          ).paddingOnly(left: 10, bottom: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 700,
                    child: WebTextField(
                      width: 600,
                      color: AppColors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      hint: 'Search',
                      suffixIcon: IconButton(
                        highlightColor: AppColors.transparent,
                        splashColor: AppColors.transparent,
                        hoverColor: AppColors.transparent,
                        focusColor: AppColors.transparent,
                        onPressed: () {
                          c.onUpdate();
                          controller.onUpdate();
                          c.searchControllerBusiness.clear();
                          c.searchBusinessList.value.clear();
                        },
                        icon: const Icon(
                          CupertinoIcons.clear,
                          color: AppColors.grey,
                        ),
                      ),
                      textController: c.searchControllerBusiness,
                      contentPadding: EdgeInsets.only(bottom: 5),
                      prefixIcon: IconButton(
                        highlightColor: AppColors.transparent,
                        splashColor: AppColors.transparent,
                        hoverColor: AppColors.transparent,
                        focusColor: AppColors.transparent,
                        icon: Icon(
                          CupertinoIcons.search,
                          color: AppColors.grey,
                        ),
                        onPressed: () {},
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(
                          RegExp(r'\s'),
                        ),
                      ],
                      onChanged: (String p0) async {
                        c.searchApi(
                          isUser: false,
                        );
                      },
                    ).paddingSymmetric(horizontal: 30),
                  ),
                ],
              ),
              WebElevatedButton(
                callback: () {
                  c.createCSV(
                    userList: <UserModel>[],
                    isUSER: false,
                    businessList: c.businessList(),
                  );
                },
                title: 'Export',
                width: 100,
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              ).paddingOnly(right: 50),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey.shade100,
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Sort',
                      style: AppThemes.lightTheme.textTheme.titleSmall
                          ?.copyWith(color: AppColors.appBlackColor),
                    ),
                    IconButton(
                      highlightColor: AppColors.transparent,
                      splashColor: AppColors.transparent,
                      hoverColor: AppColors.transparent,
                      focusColor: AppColors.transparent,
                      onPressed: () {
                        final RenderBox renderBox =
                            Get.context!.findRenderObject() as RenderBox;
                        final Offset offset =
                            renderBox.localToGlobal(Offset.zero);
                        showMenu(
                          elevation: 0,
                          color: Colors.transparent,
                          constraints: const BoxConstraints(
                            maxWidth: double.infinity,
                          ),
                          context: Get.context!,
                          position: RelativeRect.fromLTRB(200, 200, 200, 200),
                          items: <PopupMenuWidget>[
                            PopupMenuWidget(
                              height: 100,
                              width: 200,
                              child: listView(),
                            ),
                          ],
                        );
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: AppColors.appBlackColor,
                      ),
                    ),
                  ],
                ),
              ).paddingOnly(right: 50, left: 20),
              SizedBox(
                width: 100,
              ),
              Container(
                width: 230,
                height: 40,
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                margin: EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.shade400,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(2, 4),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: AppColors.appBlackColor, width: 1.5),
                ),
                child: Obx(
                  () => Text(
                    c.selectedBusiness.value,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.appBlackColor,
                      height: 19 / 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: 100,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: <int, TableColumnWidth>{
              0: FixedColumnWidth(50),
              1: FlexColumnWidth(2.5),
              2: FlexColumnWidth(4),
              3: FlexColumnWidth(3),
              4: FlexColumnWidth(3),
              5: FlexColumnWidth(3),
              6: FlexColumnWidth(3),
              7: FlexColumnWidth(3),
              8: FlexColumnWidth(1.5),
              9: FlexColumnWidth(1.5),
            },
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  Obx(
                    () => Checkbox(
                      value: c.showvalue.value,
                      checkColor: AppColors.appWhiteColor,
                      activeColor: AppColors.appButtonColor,
                      side: BorderSide(
                        color: AppColors.black,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      fillColor: MaterialStateProperty.resolveWith(c.getColor),
                      onChanged: (bool? value) {
                        c.showvalue.value = value!;
                      },
                    ),
                  ),
                  Text(
                    'Business Name',
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Owner First and Last Name',
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Email Address',
                    textAlign: TextAlign.center,
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Location',
                    textAlign: TextAlign.center,
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Category',
                    textAlign: TextAlign.center,
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Visits Today',
                    textAlign: TextAlign.center,
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Total Visits',
                    textAlign: TextAlign.center,
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Rating',
                    style:
                        AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.admingreycolor,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ],
          ),
          Divider(height: 20),
          Expanded(
            child: GetBuilder<ProfileCtrl>(
              builder: (ProfileCtrl c) {
                if (c.isLoading || c.lodingMore) {
                  return SizedBox(
                    height: Get.height * 0.61,
                    child: LoaderView(),
                  );
                } else if (c.searchBusinessList.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    // padding: const EdgeInsets.only(bottom: 20),
                    itemCount: c.searchBusinessList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final BussinessModel bussiess =
                          c.searchBusinessList[index];
                      return Obx(
                        () => DecoratedBox(
                          decoration: BoxDecoration(
                            color: bussiess.isSelected.value
                                ? Color(0xFFF0F0F5)
                                : AppColors.appWhiteColor,
                            borderRadius: bussiess.isSelected.value
                                ? BorderRadius.circular(10)
                                : BorderRadius.zero,
                          ),
                          child: Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            columnWidths: <int, TableColumnWidth>{
                              0: FixedColumnWidth(50),
                              1: FlexColumnWidth(2.5),
                              2: FlexColumnWidth(4),
                              3: FlexColumnWidth(3),
                              4: FlexColumnWidth(3),
                              5: FlexColumnWidth(3),
                              6: FlexColumnWidth(3),
                              7: FlexColumnWidth(3),
                              8: FlexColumnWidth(1.5),
                              9: FlexColumnWidth(1.5),
                            },
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  Obx(() {
                                    return Checkbox(
                                      checkColor: AppColors.appWhiteColor,
                                      activeColor: AppColors.appButtonColor,
                                      side: BorderSide(
                                        color: AppColors.black,
                                        width: 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                        c.getColor,
                                      ),
                                      value: bussiess.isSelected.value ||
                                          c.showvalue.value,
                                      onChanged: (bool? value) {
                                        FocusScope.of(Get.context!).unfocus();
                                        bussiess.isSelected.value = value!;
                                      },
                                    );
                                  }),
                                  Text(
                                    bussiess.businessName,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.appBlackColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${bussiess.first_name} ${bussiess.last_name}',
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.appBlackColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    bussiess.email,
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    bussiess.location,
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    BusinessCategoryType.businessCategoryType(bussiess.catId).title,
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    bussiess.visitToday.toString(),
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    bussiess.totalVisit.toString(),
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${bussiess.businessRating.toStringAsFixed(1)} /5 ${(bussiess.ratedByCount.toString())}',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  IconButton(
                                    highlightColor: AppColors.transparent,
                                    splashColor: AppColors.transparent,
                                    hoverColor: AppColors.transparent,
                                    focusColor: AppColors.transparent,
                                    onPressed: () {
                                      final RenderBox renderBox = Get.context!
                                          .findRenderObject() as RenderBox;
                                      final Offset offset =
                                          renderBox.localToGlobal(Offset.zero);
                                      showMenu(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        constraints: const BoxConstraints(
                                          maxWidth: double.infinity,
                                        ),
                                        context: Get.context!,
                                        position: RelativeRect.fromLTRB(
                                          500,
                                          320,
                                          60,
                                          320,
                                        ),
                                        // position: RelativeRect.fromLTRB(left, top, right, bottom),
                                        items: <PopupMenuWidget>[
                                          PopupMenuWidget(
                                            height: 100,
                                            width: 200,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                WebElevatedButton(
                                                  callback: () {
                                                    c.isShow(true);
                                                    showDialog(
                                                      context: Get.context!,
                                                      builder: (
                                                        BuildContext context,
                                                      ) =>
                                                          DialogContainer(
                                                        body: DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .appWhiteColor,
                                                          ),
                                                          child: Obx(
                                                            () => Column(
                                                              children: <Widget>[
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      Get.back();
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .close,
                                                                    ),
                                                                  ),
                                                                ),
                                                                AppAssets
                                                                    .asImage(
                                                                  AppAssets
                                                                      .deletaccount,
                                                                  height: 60,
                                                                ),
                                                                Text(
                                                                  'Are you sure want to delete this business?',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'Montserrat',
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color:
                                                                        Color(
                                                                      0xff4f4f4f,
                                                                    ),
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ).paddingOnly(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: <Widget>[
                                                                    c.isLoading
                                                                        ? LoaderView()
                                                                        : AppElevatedButton(
                                                                            color:
                                                                                AppColors.redcolor,
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                70,
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                              8,
                                                                            ),
                                                                            callback:
                                                                                () {
                                                                              c.DeleteBussiness(id: bussiess.id);
                                                                            },
                                                                            title:
                                                                                'Yes, I’m sure',
                                                                          ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    AppElevatedButton(
                                                                      color: AppColors
                                                                          .greyColor,
                                                                      height:
                                                                          50,
                                                                      width: 70,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      callback:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      title:
                                                                          'No, cancel',
                                                                      style: AppThemes
                                                                          .lightTheme
                                                                          .textTheme
                                                                          .headlineMedium
                                                                          ?.copyWith(
                                                                        color: AppColors
                                                                            .appBlackColor,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ).paddingSymmetric(
                                                                  horizontal:
                                                                      10,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        maxHei: 250,
                                                        minHei: 250,
                                                        maxWid: 330,
                                                        minWid: 330,
                                                      ),
                                                    );
                                                    // c.isShow(false);
                                                  },
                                                  width: 100,
                                                  height: 40,
                                                  title: 'Delete',
                                                ),
                                                WebElevatedButton(
                                                  callback: () {
                                                    controler.getBussinessByID(
                                                      bussiess.id,
                                                    );
                                                    Dialog();
                                                  },
                                                  width: 100,
                                                  height: 40,
                                                  title: 'View Profile',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    icon: Icon(
                                      Icons.more_vert_outlined,
                                      color: AppColors.admingreycolor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).paddingOnly(bottom: 5, left: 5, right: 5),
                      );
                    },
                  );
                } else if (c.searchControllerBusiness.text.isNotEmpty &&
                    c.selectedBusiness.isEmpty) {
                  return Center(child: Text('No matches found'));
                }
                //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    // padding: const EdgeInsets.only(bottom: 20),
                    itemCount: c.businessList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final BussinessModel bussiess = c.businessList[index];
                      return Obx(
                        () => DecoratedBox(
                          decoration: BoxDecoration(
                            color: bussiess.isSelected.value
                                ? Color(0xFFF0F0F5)
                                : AppColors.appWhiteColor,
                            borderRadius: bussiess.isSelected.value
                                ? BorderRadius.circular(10)
                                : BorderRadius.zero,
                          ),
                          child: Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            columnWidths: <int, TableColumnWidth>{
                              0: FixedColumnWidth(50),
                              1: FlexColumnWidth(2.5),
                              2: FlexColumnWidth(4),
                              3: FlexColumnWidth(3),
                              4: FlexColumnWidth(3),
                              5: FlexColumnWidth(3),
                              6: FlexColumnWidth(3),
                              7: FlexColumnWidth(3),
                              8: FlexColumnWidth(1.5),
                              9: FlexColumnWidth(1.5),
                            },
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  Obx(() {
                                    return Checkbox(
                                      checkColor: AppColors.appWhiteColor,
                                      activeColor: AppColors.appButtonColor,
                                      side: BorderSide(
                                        color: AppColors.black,
                                        width: 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                        c.getColor,
                                      ),
                                      value: bussiess.isSelected.value ||
                                          c.showvalue.value,
                                      onChanged: (bool? value) {
                                        FocusScope.of(Get.context!).unfocus();
                                        bussiess.isSelected.value = value!;
                                      },
                                    );
                                  }),
                                  Text(
                                    bussiess.businessName,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.appBlackColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${bussiess.first_name}${bussiess.last_name}',
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.appBlackColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    bussiess.email,
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    bussiess.location,
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    BusinessCategoryType.businessCategoryType(
                                            bussiess.catId)
                                        .title,
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    bussiess.visitToday.toString(),
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    bussiess.visitToday.toString(),
                                    textAlign: TextAlign.center,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${bussiess.businessRating.toStringAsFixed(1)}/5 ${(bussiess.ratedByCount.toString())}',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.admingreycolor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  IconButton(
                                    highlightColor: AppColors.transparent,
                                    splashColor: AppColors.transparent,
                                    hoverColor: AppColors.transparent,
                                    focusColor: AppColors.transparent,
                                    onPressed: () {
                                      final RenderBox renderBox = Get.context!
                                          .findRenderObject() as RenderBox;
                                      final Offset offset =
                                          renderBox.localToGlobal(Offset.zero);
                                      showMenu(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        constraints: const BoxConstraints(
                                          maxWidth: double.infinity,
                                        ),
                                        context: Get.context!,
                                        position: RelativeRect.fromLTRB(
                                          500,
                                          320,
                                          60,
                                          320,
                                        ),
                                        // position: RelativeRect.fromLTRB(left, top, right, bottom),
                                        items: <PopupMenuWidget>[
                                          PopupMenuWidget(
                                            height: 100,
                                            width: 200,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                WebElevatedButton(
                                                  callback: () {
                                                    c.isShow(true);

                                                    showDialog(
                                                      context: Get.context!,
                                                      builder: (
                                                        BuildContext context,
                                                      ) =>
                                                          DialogContainer(
                                                        body: DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .appWhiteColor,
                                                          ),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.close,
                                                                  ),
                                                                ),
                                                              ),
                                                              AppAssets.asImage(
                                                                AppAssets
                                                                    .deletaccount,
                                                                height: 60,
                                                              ),
                                                              Text(
                                                                'Are you sure want to delete this user?',
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                    0xff4f4f4f,
                                                                  ),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ).paddingOnly(
                                                                top: 10,
                                                                bottom: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <Widget>[
                                                                  c.isLoading
                                                                      ? LoaderView()
                                                                      : AppElevatedButton(
                                                                          color:
                                                                              AppColors.redcolor,
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              70,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                          callback:
                                                                              () {
                                                                            c.DeleteBussiness(id: bussiess.id);
                                                                          },
                                                                          title:
                                                                              'Yes, I’m sure',
                                                                        ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  AppElevatedButton(
                                                                    color: AppColors
                                                                        .greyColor,
                                                                    height: 50,
                                                                    width: 70,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    callback:
                                                                        () {
                                                                      Get.back();
                                                                    },
                                                                    title:
                                                                        'No, cancel',
                                                                    style: AppThemes
                                                                        .lightTheme
                                                                        .textTheme
                                                                        .headlineMedium
                                                                        ?.copyWith(
                                                                      color: AppColors
                                                                          .appBlackColor,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ).paddingSymmetric(
                                                                horizontal: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        maxHei: 250,
                                                        minHei: 250,
                                                        maxWid: 330,
                                                        minWid: 330,
                                                      ),
                                                    );
                                                    // c.isShow(false);
                                                  },
                                                  width: 100,
                                                  height: 40,
                                                  title: 'Delete',
                                                ),
                                                WebElevatedButton(
                                                  callback: () {
                                                    controler.getBussinessByID(
                                                      bussiess.id,
                                                    );
                                                    Dialog();
                                                  },
                                                  width: 100,
                                                  height: 40,
                                                  title: 'View Profile',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    icon: Icon(
                                      Icons.more_vert_outlined,
                                      color: AppColors.admingreycolor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).paddingOnly(bottom: 5, left: 5, right: 5),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              c.numberOfPageForBusiness.round(),
              (int index) => Center(
                child: Obx(
                  () => InkWell(
                    onTap: () {
                      c.getAllUsers(paginationCount: index * 10, isUser: false);

                      c.isBusinessIndex.value = index;
                      logger.w(c.isBusinessIndex.value);
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c.isBusinessIndex.value == index
                            ? AppColors.selectdeaweclr
                            : AppColors.appWhiteColor,
                        border: Border.all(
                          color: AppColors.appBlackColor,
                        ),
                      ),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: c.isBusinessIndex.value == index
                              ? AppColors.appWhiteColor
                              : AppColors.appBlackColor,
                        ),
                        textAlign: TextAlign.center,
                      ).paddingSymmetric(vertical: 0),
                    ),
                  ),
                ),
              ),
            ),
          ).paddingOnly(bottom: 10),
        ],
      ),
    );
  }

  Widget listView() {
    return SizedBox(
      height: 350,
      width: 230,
      child: ListView.builder(
        itemCount: c.tileModelBussiness.length,
        padding: EdgeInsets.only(top: 40, left: 30),
        itemBuilder: (BuildContext context, int index) {
          final TileModel title = c.tileModelBussiness[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: title.callback,
                child: Container(
                  width: 230,
                  height: 40,
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(2, 4),
                      ),
                    ],
                    border:
                        Border.all(color: AppColors.appBlackColor, width: 1.5),
                  ),
                  child: Text(
                    title.title,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.appBlackColor,
                      height: 19 / 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> Dialog() {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) => DialogContainer(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.background,
          ),
          child: GetBuilder<MapsController>(
            builder: (MapsController c) {
              if (c.isLoading) {
                return LoaderView();
              } else
                return Scaffold(
                  backgroundColor: AppColors.transparent,
                  body: SafeArea(
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              reverse: false,
                              clipBehavior: Clip.hardEdge,
                              scrollDirection: Axis.horizontal,
                              // padding: EdgeInsets.symmetric(horizontal: 5),
                              itemCount: c.bussiness.value.coverPhoto.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: AppImages.asImage(
                                    c.bussiness.value.coverPhoto[index].photos,
                                    fit: BoxFit.cover,
                                    width: 320,
                                    height: 200,
                                  ),
                                ).paddingOnly(right: 8);
                              },
                            ),
                          ).paddingOnly(bottom: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      c.bussiness.value.businessName,
                                      style: AppThemes
                                          .lightTheme.textTheme.headlineMedium
                                          ?.copyWith(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 15,
                                      ),
                                    ).paddingSymmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    Text(
                                      c.bussiness.value.location,
                                      style: AppThemes
                                          .lightTheme.textTheme.headlineMedium
                                          ?.copyWith(
                                        color: AppColors.greyColor,
                                        fontSize: 9.5,
                                      ),
                                    ).paddingSymmetric(horizontal: 10),
                                    Text(
                                      BusinessCategoryType.businessCategoryType(c.bussiness.value.catId).title,
                                      style: AppThemes
                                          .lightTheme.textTheme.headlineMedium
                                          ?.copyWith(
                                        color: AppColors.greyColor,
                                        fontSize: 9.5,
                                      ),
                                    ).paddingSymmetric(horizontal: 10),
                                  ],
                                ),
                              ),
                              AppElevatedButton(
                                height: 35,
                                width: 120,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                color: AppColors.appBlackColor,
                                title: 'Message',
                                callback: () {
                                  Get.toNamed(Routes.ViewBussinessScreen);
                                },
                              ),
                            ],
                          ).paddingOnly(bottom: 20),
                          Container(
                            height: 200,
                            width: Get.width,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xffebeb26).withOpacity(0.05),
                            ),
                            child: Text(
                              app.bussiness.description,
                              style: AppThemes.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.appWhiteColor,
                              ),
                            ),
                          ).paddingSymmetric(horizontal: 5),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(
                                  height: 90,
                                  child: ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    shrinkWrap: true,
                                    itemCount:
                                        c.bussiness.value.subCategory.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final SubCategory cat =
                                          c.bussiness.value.subCategory[index];
                                      return InkWell(
                                        onTap: () {
                                          logger.wtf(
                                            c.bussiness.value.subCategory[index]
                                                .name,
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              cat.name,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.appWhiteColor,
                                              ),
                                            ).paddingOnly(bottom: 10),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 190,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: AppColors.greyColor),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      child: RatingBar.builder(
                                        initialRating: 5,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        ignoreGestures: true,
                                        itemSize: 30,
                                        itemPadding: EdgeInsets.symmetric(
                                          horizontal: 2.0,
                                          vertical: 5,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, _) =>
                                                AppAssets.asIcon(
                                          AppAssets.star,
                                          color: AppColors.appWhiteColor,
                                        ),
                                        onRatingUpdate: (double rating) {
                                          print(rating);
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          '${c.bussiness.value.businessRating.toStringAsFixed(1)} /5',
                                          style: AppThemes.lightTheme.textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                            color: AppColors.appWhiteColor,
                                            fontSize: 11.35,
                                          ),
                                        ),
                                        SizedBox(
                                          width: Get.width * 0.05,
                                        ),
                                        Text(
                                          c.bussiness.value.ratedByCount
                                              .toString(),
                                          style: AppThemes.lightTheme.textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                            color: AppColors.appWhiteColor,
                                            fontSize: 11.35,
                                          ),
                                        ),
                                        AppAssets.asImage(
                                          AppAssets.profile,
                                          height: 10,
                                          width: 20,
                                        ),
                                      ],
                                    ).paddingSymmetric(
                                      horizontal: 20,
                                      vertical: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
            },
          ),
        ),
        maxHei: 600,
        minHei: 600,
        maxWid: 350,
        minWid: 350,
      ),
    );
  }
}
