import 'package:dropin/src/utils/widgets/app_images.dart';

import '../../../../src_exports.dart';
import '../../authprofile/profilescreen_controller.dart';

class ProfileEditScreen extends StatefulWidget {
  ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final ProfileController c = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    logger.wtf('APP VERSION ${app.packageVersion}');
    return DecoratedBox(
      decoration: BoxDecoration(gradient: AppColors.background),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: Column(
          children: [
            CustomAppBar.getWithLeading(
              'Edit Profile',
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
                          'Profile Picture',
                          style: AppThemes.lightTheme.textTheme.headlineMedium
                              ?.copyWith(fontSize: 18),
                        ).paddingSymmetric(horizontal: 10),
                        TextButton(
                          onPressed: () async {
                            logger.wtf(app.user.imageUrl);
                            await Get.toNamed(
                              Routes.EditProfileScreen,
                              arguments: true,
                            );
                            c.update();
                            setState(() {});

                            // Get.toNamed(Routes.EditPhotoScreen);
                          },
                          child: Text(
                            'Edit',
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              fontSize: 11,
                              color: AppColors.appWhiteColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: AppColors.appWhiteColor,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: AppImages.asProvider(
                          app.user.imageUrl,
                        ),
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
                          'Photos',
                          style: AppThemes.lightTheme.textTheme.headlineMedium
                              ?.copyWith(fontSize: 18),
                        ).paddingSymmetric(horizontal: 10),
                        TextButton(
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.AddPhotos,
                              arguments: true,
                            );
                            setState(() {});
                            // Get.toNamed(Routes.EditPhotoCoverScreen);
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
                      height: 220,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 12,
                          );
                        },
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        scrollDirection: Axis.horizontal,
                        itemCount: app.user.coverPhotos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: context.width * 0.9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: AppImages.asImage(
                                app.user.coverPhotos[index].url,
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
                          'Bio',
                          style: AppThemes.lightTheme.textTheme.headlineMedium
                              ?.copyWith(fontSize: 18),
                        ).paddingSymmetric(horizontal: 10),
                        TextButton(
                          onPressed: () async {
                            await Get.toNamed(Routes.EditBio);
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
                    Container(
                      height: 110,
                      width: context.width,
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xffebeb26).withOpacity(0.05),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          textAlign: TextAlign.start,
                          app.user.bio,
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
                              Routes.CreateProfileScreen,
                              arguments: true,
                            );
                            setState(() {});
                            // Get.toNamed(Routes.EditDetailsScreen);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            app.user.userName,
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                                    fontSize: 15,
                                    color: AppColors.appWhiteColor),
                          ).paddingSymmetric(horizontal: 10),
                        ),
                        Container(
                          // width: context.width * 0.30,
                          // height: 50,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: AppColors.containercolor),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: AppAssets.asProvider(
                                  '${AppAssets.countryIcon}${app.user.country.split(' ').last.replaceAll('(', '').replaceAll(')', '').toLowerCase()}.png',
                                ),
                                radius: 16.5,
                              ).paddingOnly(right: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    app.user.country,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontSize: 11,
                                      color: AppColors.appWhiteColor,
                                    ),
                                  ),
                                  Text(
                                    app.user.skillLevel,
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                            fontSize: 9,
                                            color: AppColors.appWhiteColor
                                                .withOpacity(0.6)),
                                  ),
                                  Text(
                                    'Age ${app.user.age}',
                                    style: AppThemes
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontSize: 9,
                                      color: AppColors.appWhiteColor
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ).paddingSymmetric(horizontal: 10),
                      ],
                    ),
                    const Divider(
                      color: AppColors.appWhiteColor,
                      indent: 5,
                      endIndent: 5,
                      height: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 210,
                      height: 27,
                      child: AppElevatedButton(
                        callback: () {
                          c.showMyDialog();
                        },
                        title: 'Delete Account',
                        color: Colors.black,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ).paddingOnly(bottom: 10),
                    SizedBox(
                      width: 210,
                      height: 27,
                      child: AppElevatedButton(
                        title: 'Edit Password',
                        callback: () {
                          Get.toNamed(Routes.EditPasswordScreen);
                        },
                        color: Colors.black,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        c.LogOUtDialog();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Logout',
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(color: AppColors.appWhiteColor),
                          ).paddingOnly(left: 20),
                          const SizedBox(
                            width: 10,
                          ),
                          AppAssets.asIcon(
                            AppAssets.signOut,
                            color: AppColors.appWhiteColor,
                            size: 40,
                          ),
                        ],
                      ),
                    ).paddingOnly(bottom: 10),
                    Text(
                      'App version: ${app.packageVersion}',
                      style: TextStyle(
                        color: AppColors.appWhiteColor,
                      ),
                    ).paddingOnly(bottom: 15),
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
