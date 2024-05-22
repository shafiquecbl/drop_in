import 'package:dropin/src/utils/widgets/common_functions.dart';

import '../../../../src_exports.dart';
import '../../authprofile/profilescreen_controller.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final c = Get.find<ProfileController>();
  bool isForceUpdate = false;

  @override
  void initState() {
    if (Get.arguments is bool) {
      isForceUpdate = Get.arguments;
    }
    if (!isForceUpdate) {
      c.descriptionCtrl.text = app.bussiness.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    c.descriptionCtrl.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (ProfileController controller) {
        return Scaffold(
          backgroundColor: AppColors.transparent,
          body: Container(
            height: context.height,
            decoration: BoxDecoration(gradient: AppColors.background),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  const CustomAppBar(
                    title: 'Description',
                    showBackButton: false,
                    titleColor: AppColors.appBlackColor,
                  ),
                  AppTextField(
                    height: 150,
                    maxLines: 7,
                    title: 'DESCRIPTION',
                    hint: 'Write a description for others to see here',
                    textController: c.descriptionCtrl,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(250),
                    ],
                    onChanged: (String value) {
                      c.descCount.value = value.length;
                      // app.bussiness.description = c.descriptionCtrl.text;
                    },
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Obx(
                    () {
                      return SizedBox(
                        width: Get.width,
                        child: Text(
                          '${controller.descCount.value}/250',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ).paddingOnly(right: 5);
                    },
                  ),
                  controller.isLoading
                      ? LoaderView().paddingOnly(
                          bottom: 10,
                          top: context.height * 0.3,
                        )
                      : AppElevatedButton(
                          callback: () {
                            if (!isForceUpdate) {
                              controller.updateBusinessDescription();
                            } else {
                              if (controller.descriptionCtrl.text
                                  .trim()
                                  .isNotEmpty) {
                                Get.back(
                                  result:
                                      controller.descriptionCtrl.text.trim(),
                                );
                              } else {
                                showSnackBar(
                                  'Please enter business description',
                                );
                              }
                            }
                          },
                          title: isForceUpdate ? 'Next' : 'Update',
                        ).paddingOnly(
                          bottom: 10,
                          top: context.height * 0.3,
                        ),
                  AppElevatedButton(
                    callback: () {
                      // here in result whatever you pass ot dose not matter it must be bool
                      Get.back(result: true);
                    },
                    title: 'Back',
                  ).paddingOnly(bottom: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
