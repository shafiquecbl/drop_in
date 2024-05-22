import '../../../src_exports.dart';
import 'general_screen_controler.dart';

class GeneralScreen extends StatelessWidget {
  GeneralScreen({super.key});

  final GeneralController c = Get.put(GeneralController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(
      builder: (GeneralController controller) {
        if (controller.isLoading) {
          return LoaderView();
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'General',
                      style: AppThemes.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.appBlackColor, fontSize: 32),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(80, 60),
                        backgroundColor: AppColors.selectdeaweclr,
                        foregroundColor: AppColors.selectdeaweclr,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {},
                      label: Text(
                        'ADD WIDGET',
                        style: AppThemes.lightTheme.textTheme.headlineSmall
                            ?.copyWith(color: AppColors.appWhiteColor),
                      ),
                      icon: Icon(
                        Icons.add,
                        color: AppColors.appWhiteColor,
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 30, vertical: 20),
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            c.generalModel.value.onlineUsers.toString(),
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(fontSize: 40),
                          ),
                          Text(
                            'Online Users',
                            style:
                                AppThemes.lightTheme.textTheme.headlineMedium,
                          )
                        ],
                      ).paddingSymmetric(horizontal: 100),
                      VerticalDivider(
                        color: Colors.black,
                        thickness: 2,
                        indent: 2,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            c.generalModel.value.activeAccountToday.toString(),
                            style: AppThemes.lightTheme.textTheme.headlineMedium
                                ?.copyWith(fontSize: 40),
                          ),
                          Text(
                            'Active Accounts Today',
                            style:
                                AppThemes.lightTheme.textTheme.headlineMedium,
                          )
                        ],
                      ).paddingSymmetric(horizontal: 50),
                      VerticalDivider(
                        color: Colors.black,
                        thickness: 2,
                        indent: 2,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
