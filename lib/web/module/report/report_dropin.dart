import 'package:dropin/src/models/report_model.dart';
import 'package:dropin/src_exports.dart';
import 'package:dropin/web/module/report/report_controller.dart';
import 'package:flutter/cupertino.dart';

import '../../../src/utils/widgets/app_images.dart';
import '../../../src/utils/widgets/custom_dialog.dart';
import '../../../src/utils/widgets/popup_widget.dart';
import '../../../src/utils/widgets/web_button.dart';
import '../../../src/utils/widgets/web_textfield.dart';

class ReportedDropIn extends GetResponsiveView {
  ReportedDropIn({super.key});

  final ReportController c = Get.put(ReportController());

  Widget desktop() {
    return Scaffold(
      body: GetBuilder<ReportController>(
        builder: (ReportController c) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Reports',
                style: AppThemes.lightTheme.textTheme.headlineMedium
                    ?.copyWith(color: AppColors.appBlackColor, fontSize: 32),
              ).paddingOnly(left: 10, bottom: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 900,
                        child: WebTextField(
                          width: 800,
                          color: AppColors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          hint: 'Search',
                          contentPadding: EdgeInsets.only(bottom: 5),
                          prefixIcon: IconButton(
                            highlightColor: AppColors.transparent,
                            splashColor: AppColors.transparent,
                            hoverColor: AppColors.transparent,
                            focusColor: AppColors.transparent,
                            icon: Icon(
                              Icons.search,
                              color: AppColors.grey,
                            ),
                            onPressed: () {},
                          ),
                          suffixIcon: IconButton(
                            highlightColor: AppColors.transparent,
                            splashColor: AppColors.transparent,
                            hoverColor: AppColors.transparent,
                            focusColor: AppColors.transparent,
                            onPressed: () {
                              c.onUpdate();
                              controller.onUpdate();
                              c.searchController.clear();
                            },
                            icon: const Icon(
                              CupertinoIcons.clear,
                              color: AppColors.grey,
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny(
                              RegExp(r'\s'),
                            )
                          ],
                          onChanged: (String p0) async {
                            c.searchApi();
                          },
                        ).paddingSymmetric(horizontal: 30),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.greyColor,
                      backgroundColor: AppColors.greyColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.appBlackColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
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
                              position:
                                  RelativeRect.fromLTRB(200, 200, 200, 200),
                              items: <PopupMenuWidget>[
                                PopupMenuWidget(
                                  height: 100,
                                  width: 150,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 100,
                                        width: 200,
                                      ),
                                      WebElevatedButton(
                                        callback: () {
                                          c.reportedUsers.clear();
                                          c.getReportedUserList(s_type: 1);
                                        },
                                        width: 100,
                                        height: 40,
                                        title: 'Newest',
                                      ),
                                      WebElevatedButton(
                                        callback: () {
                                          c.reportedUsers.clear();
                                          c.getReportedUserList(s_type: 2);
                                        },
                                        width: 100,
                                        height: 40,
                                        title: 'Oldest',
                                      ),
                                      WebElevatedButton(
                                        callback: () {
                                          c.reportedUsers.clear();
                                          c.getReportedUserList(s_type: 3);
                                        },
                                        width: 100,
                                        height: 40,
                                        title: 'Most Reported',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: AppColors.appBlackColor,
                          ),
                        )
                      ],
                    ),
                  ).paddingOnly(right: 50, left: 20),
                  SizedBox(
                    width: 150,
                  ),
                  WebElevatedButton(
                    callback: () {
                      c.createCSV(userList: <UserModel>[]);
                    },
                    title: 'Export',
                    width: 200,
                    height: 40,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  ).paddingOnly(right: 50),
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
                  2: FlexColumnWidth(2.5),
                  3: FlexColumnWidth(2.5),
                  4: FlexColumnWidth(2.5),
                  5: FlexColumnWidth(2.5),
                },
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Checkbox(
                        value: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: AppColors.selectdeaweclr),
                        ),
                        onChanged: (bool? value) {},
                      ),
                      Text(
                        'Owner First and Last Name ',
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.admingreycolor,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Email Address',
                        textAlign: TextAlign.center,
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.admingreycolor,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Reported Count',
                        textAlign: TextAlign.center,
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.admingreycolor,
                          fontSize: 14,
                        ),
                      ).paddingSymmetric(horizontal: 8),
                      Text(
                        'Title',
                        textAlign: TextAlign.center,
                        style: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.admingreycolor,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox()
                    ],
                  )
                ],
              ),
              Divider(height: 20),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: c.reportedDropins.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ReportModel userList = c.reportedDropins[index];
                    return Obx(
                      () => DecoratedBox(
                        decoration: BoxDecoration(
                          color: userList.isSelected.value
                              ? Color(0xFFF0F0F5)
                              : AppColors.appWhiteColor,
                          borderRadius: userList.isSelected.value
                              ? BorderRadius.circular(10)
                              : BorderRadius.zero,
                        ),
                        child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: <int, TableColumnWidth>{
                            0: FixedColumnWidth(50),
                            1: FlexColumnWidth(2.5),
                            2: FlexColumnWidth(2.5),
                            3: FlexColumnWidth(2.5),
                            4: FlexColumnWidth(2.5),
                            5: FlexColumnWidth(2.5),
                          },
                          children: <TableRow>[
                            TableRow(
                              children: <Widget>[
                                Obx(
                                  () {
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
                                      value: userList.isSelected.value,
                                      onChanged: (bool? value) {
                                        FocusScope.of(Get.context!).unfocus();
                                        userList.isSelected.value = value!;
                                      },
                                    );
                                  },
                                ),
                                Text(
                                  userList.fullName,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.admingreycolor,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  userList.email,
                                  textAlign: TextAlign.center,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.admingreycolor,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${userList.reportCount}',
                                  textAlign: TextAlign.center,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.admingreycolor,
                                    fontSize: 14,
                                  ),
                                ).paddingSymmetric(horizontal: 8),
                                Text(
                                  '${userList.name}',
                                  textAlign: TextAlign.center,
                                  style: AppThemes
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.admingreycolor,
                                    fontSize: 14,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    c.dropInGetId(id: userList.dropinId);
                                    reportDialog();
                                  },
                                  icon: Icon(Icons.remove_red_eye_outlined),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  c.numberOfPageForReport.round(),
                  (int index) => Center(
                    child: Obx(
                      () => InkWell(
                        highlightColor: AppColors.transparent,
                        splashColor: AppColors.transparent,
                        hoverColor: AppColors.transparent,
                        focusColor: AppColors.transparent,
                        onTap: () {
                          c.isReportIndex == index;
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c.isReportIndex.value == index
                                ? AppColors.selectdeaweclr
                                : AppColors.appWhiteColor,
                            border: Border.all(
                              color: AppColors.appBlackColor,
                            ),
                          ),
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: c.isReportIndex.value == index
                                  ? AppColors.appWhiteColor
                                  : AppColors.appBlackColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ).paddingOnly(bottom: 10),
            ],
          );
        },
      ),
    );
  }

  Future<void> reportDialog() {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) => DialogContainer(
        body: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.purpale,
          ),
          child: GetBuilder<ReportController>(
            builder: (ReportController c) {
              if (c.lodingMore) {
                return LoaderView();
              } else {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          reverse: false,
                          clipBehavior: Clip.hardEdge,
                          scrollDirection: Axis.horizontal,
                          itemCount: c.news.value.dropinImages.length,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (BuildContext context, int index) {
                            logger.w(c.news.value.dropinImages.length);
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: AppImages.asImage(
                                c.news.value.dropinImages[index].url,
                                fit: BoxFit.cover,
                                width: 330,
                                height: 200,
                              ),
                            ).paddingOnly(right: 8);
                          },
                        ),
                      ).paddingOnly(top: 10),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          c.news.value.title,
                          style: AppThemes.lightTheme.textTheme.headlineMedium
                              ?.copyWith(fontSize: 18),
                        ),
                      ).paddingOnly(left: 30, right: 25, top: 10, bottom: 5),
                      Container(
                        height: 120,
                        width: Get.width,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.appWhiteColor.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(c.news.value.description).paddingOnly(
                          top: 10,
                          right: 10,
                          left: 5,
                          bottom: 10,
                        ),
                      ).paddingSymmetric(horizontal: 8),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        maxHei: 400,
        minHei: 400,
        maxWid: 350,
        minWid: 350,
      ),
    );
  }
}
