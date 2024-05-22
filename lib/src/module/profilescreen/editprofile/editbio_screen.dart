import '../../../../src_exports.dart';
import '../../authprofile/profilescreen_controller.dart';

class EditBio extends StatelessWidget {
  EditBio({Key? key}) : super(key: key);
  bool isEditProfile = (Get.arguments ?? false);
  ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    if (!isEditProfile && controller.bioController.text.trim().isEmpty) {
      controller.bioController.text = app.user.bio;
    }
    return GetBuilder<ProfileController>(
      builder: (ProfileController controller) {
        return Container(
          height: context.height,
          decoration: BoxDecoration(gradient: AppColors.background),
          child: Scaffold(
            backgroundColor: AppColors.transparent,
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  const CustomAppBar(
                    title: 'Bio',
                    showBackButton: false,
                    titleColor: AppColors.appBlackColor,
                  ),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldColor.withOpacity(0.8),
                      border:
                          Border.all(color: AppColors.appButtonColor, width: 2),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: TextFormField(
                      maxLines: 10,
                      controller: controller.bioController,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(160),
                      ],
                      onChanged: (String value) {
                        controller.descCount.value = value.length;
                      },
                      onTapOutside: (_) {
                        FocusScope.of(Get.context!).unfocus();
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        alignLabelWithHint: true,
                        labelText: 'BIO',
                        labelStyle: AppThemes.lightTheme.textTheme.headlineLarge
                            ?.copyWith(
                          fontSize: 14,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        hintText:
                            '“ Write a description for others to see here ” ',
                        hintStyle: AppThemes.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.appBlackColor,
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 10),
                  ),
                  Obx(
                    () {
                      return SizedBox(
                        width: Get.width,
                        child: Text(
                          '${controller.descCount.value}/160'
                              .replaceAll('161', '160'),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ).paddingOnly(right: 8, top: 2);
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  controller.isLoading
                      ? LoaderView()
                      : AppElevatedButton(
                          callback: () {
                            logger.w(isEditProfile);
                            if (!isEditProfile) {
                              controller.profileSetupsbio();
                            } else {
                              controller.updatecategory();
                            }
                            // Get.back();
                          },
                          title: isEditProfile ? 'Update' : 'Continue',
                        ).paddingOnly(
                          bottom: 10,
                          top: context.height * 0.3,
                        ),
                  AppElevatedButton(
                    callback: () {
                      Get.back();
                    },
                    title: 'Back',
                  ).paddingOnly(bottom: 50),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
