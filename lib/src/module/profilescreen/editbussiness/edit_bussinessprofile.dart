import 'package:dropin/src/models/sub_category_model.dart';
import 'package:dropin/src_exports.dart';

import '../../../utils/widgets/app_images.dart';
import '../../authprofile/profilescreen_controller.dart';

class EditBussinessProfile extends StatefulWidget {
  EditBussinessProfile({Key? key}) : super(key: key);

  @override
  State<EditBussinessProfile> createState() => _EditBussinessProfileState();
}

class _EditBussinessProfileState extends State<EditBussinessProfile> {
  final c = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    logger.w('BUSINESS DETAILS :: ${app.bussiness.toJson()}');
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Container(
        height: Get.height,
        decoration: BoxDecoration(gradient: AppColors.background),
        child: Column(
          children: [
            CustomAppBar.getWithLeading(
              'Edit Business',
              Style: AppThemes.lightTheme.textTheme.headlineMedium
                  ?.copyWith(fontSize: 18),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Photos',
                          style: AppThemes.lightTheme.textTheme.headlineMedium
                              ?.copyWith(fontSize: 18),
                        ).paddingSymmetric(horizontal: 10),
                        TextButton(
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.BusinessAddPhotos,
                              arguments: [
                                true,
                                app.bussiness.id,
                                false,
                              ],
                            );
                            setState(() {});
                            // Get.toNamed(Routes.EditPhotoCoverScreen);
                          },
                          child: Text(
                            'Edit',
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                                    fontSize: 11,
                                    color: AppColors.appWhiteColor),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 12,
                          );
                        },
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        scrollDirection: Axis.horizontal,
                        itemCount: app.bussiness.coverPhoto.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: context.width * 0.9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: AppImages.asImage(
                                app.bussiness.coverPhoto[index].photos,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(
                      color: AppColors.appWhiteColor,
                      indent: 5,
                      endIndent: 5,
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Description',
                          style: AppThemes.lightTheme.textTheme.headlineMedium
                              ?.copyWith(fontSize: 18),
                        ).paddingSymmetric(horizontal: 10),
                        TextButton(
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.DetailScreen,
                            );
                            setState(() {});
                          },
                          child: Text(
                            'Edit',
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                                    fontSize: 11,
                                    color: AppColors.appWhiteColor),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 110,
                      width: Get.width,
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xffebeb26).withOpacity(0.05),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          textAlign: TextAlign.start,
                          app.bussiness.description,
                          style: AppThemes.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.appWhiteColor,
                          ),
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 20),
                    const Divider(
                      color: AppColors.appWhiteColor,
                      indent: 5,
                      endIndent: 5,
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Details',
                          style: AppThemes.lightTheme.textTheme.headlineMedium
                              ?.copyWith(fontSize: 18),
                        ).paddingSymmetric(horizontal: 10),
                        TextButton(
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.AddYourBusiness,
                              arguments: true,
                            );
                            setState(() {});
                          },
                          child: Text(
                            'Edit',
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              fontSize: 11,
                              color: AppColors.appWhiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: app.bussiness.subCategory.length,
                        itemBuilder: (BuildContext context, int index) {
                          final SubCategory cat =
                              app.bussiness.subCategory[index];
                          return InkWell(
                            onTap: () {
                              logger.wtf(app.bussiness.subCategory[index].name);
                            },
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: UrlConst.iconPath + cat.icon,
                                      height: 20,
                                      width: 20,
                                    ).paddingOnly(right: 8),
                                    Text(
                                      cat.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.appWhiteColor,
                                      ),
                                    ),
                                  ],
                                ).paddingOnly(bottom: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 210,
                      child: AppElevatedButton(
                        width: Get.width / 1.5,
                        height: 27,
                        callback: () {
                          c.showMyDialogBusiness();
                          // c.DeleteBussiness(id: app.bussiness.id);
                        },
                        title: 'Delete Business Account',
                        color: Colors.black,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ).paddingOnly(bottom: 50),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
