import '../../../src_exports.dart';
import 'dropin_controller.dart';

class AddDropinPhotos extends StatelessWidget {
  AddDropinPhotos({super.key});

  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      gradient: AppColors.background,
      appBar: CustomAppBar.getAppBar(
        'Photos',
        titleColor: AppColors.appBlackColor,
      ),
      body: GetBuilder<DropinController>(
        builder: (DropinController c) {
          return Column(
            children: [
              Obx(
                () => Stack(
                  children: [
                    c.dropInImage.isEmpty
                        ? Container(
                            clipBehavior: Clip.hardEdge,
                            height: 200,
                            width: Get.width,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xffE6e6e6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          )
                        : SizedBox(
                            height: 200,
                            child: PageView.builder(
                              reverse: false,
                              clipBehavior: Clip.hardEdge,

                              onPageChanged: (int value) {
                                currentindex = value;
                              },
                              scrollDirection: Axis.horizontal,
                              // scrollDirection: Axis.,
                              itemCount: c.dropInImage.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  clipBehavior: Clip.hardEdge,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.file(
                                          File(
                                            c.dropInImage[index].images,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 10,
                                        child: IconButton(
                                          onPressed: () {
                                            c.dropInImage
                                                .removeAt(currentindex);
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: 30,
                                            color: AppColors.appWhiteColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ).paddingSymmetric(horizontal: 10);
                              },
                            ),
                          ).paddingOnly(bottom: 20),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        hoverColor: AppColors.transparent,
                        splashColor: AppColors.transparent,
                        focusColor: AppColors.transparent,
                        onTap: () async {
                          if (c.dropInImage.length < 5) {
                            await c.imagePicker(isProfile: false);
                          } else {
                            c.onError(
                              'You can select only 5 images',
                              () {},
                            );
                          }
                        },
                        child: AppAssets.asImage(
                          AppAssets.gallary,
                          height: 60,
                          width: 70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: context.height * 0.2,
              ),
              GetBuilder<DropinController>(
                builder: (c) {
                  return c.isLoading
                      ? LoaderView()
                      : AppElevatedButton(
                          width: context.width * 0.90,
                          height: 50,
                          callback: () async {
                            if (c.dropInImage.isEmpty) {
                              c.onError('Please Select Cover Photo', () {});
                            } else {
                              Get.back();
                            }
                          },
                          title: 'Continue',
                        ).paddingSymmetric(horizontal: 20, vertical: 5);
                },
              ),
              AppElevatedButton(
                width: context.width * 0.90,
                height: 50,
                callback: () {
                  Get.back();
                },
                title: 'Back',
              ).paddingSymmetric(horizontal: 20, vertical: 5),
            ],
          );
        },
      ),
    );
  }
}
