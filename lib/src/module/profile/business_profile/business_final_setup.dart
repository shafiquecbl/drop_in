import 'package:dropin/src_exports.dart';

import '../../authprofile/profilescreen_controller.dart';

class BusinessFinalSetup extends StatelessWidget {
  BusinessFinalSetup({Key? key}) : super(key: key);
  final ProfileController c = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Spacer(
              flex: 9,
            ),
            Text(
              'Congratulations!\nYour Business is Added!',
              textAlign: TextAlign.center,
              style: Get.theme.textTheme.displayLarge!.copyWith(
                fontSize: 18,
                color: AppColors.appWhiteColor,
                fontWeight: FontWeight.w600,
              ),
            ).paddingOnly(bottom: 20),
            AppElevatedButton(
              callback: () async {
                Get.toNamed(Routes.CreateProfileScreen, arguments: false);
              },
              title: 'Create User Profile',
            ),
            const Spacer(
              flex: 8,
            ),
          ],
        ),
      ),
    );
  }
}
