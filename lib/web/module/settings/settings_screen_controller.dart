import '../../../src/models/category_model.dart';
import '../../../src/models/drop_in_category.dart';
import '../../../src/service/network_service.dart';
import '../../../src_exports.dart';

class SettingsController extends BaseController {
  CategoryModel? selectedCategoryModelID;
  DropCategoryModel? selectedCategoryModelId;

  // Rx<CategoryModel> categort = CategoryModel().obs;

  Rx<DropCategoryModel> dropCategory = DropCategoryModel().obs;

  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxList<DropCategoryModel> dropInList = <DropCategoryModel>[].obs;
  String updateTextFieldValue1 = '';

  @override
  Future<void> onInit() async {
    await getCategoryApi();

    super.onInit();
    await getBussinessCategories();
  }

  Future<void> getCategoryApi() async {
    try {
      onUpdate(status: Status.LOADING);
      ResponseModel res = await net.get(
        UrlConst.bussinessGet,
        <String, dynamic>{'type': 1},
      );
      logger.d(res.data);
      if (res.isSuccess) {
        List<CategoryModel> foo = List<CategoryModel>.from(
          (res.data ?? <Map<String, dynamic>>[]).map(
            (Map<String, dynamic> e) => CategoryModel.fromJson(e),
          ),
        );
        categoryList.addAll(foo);

        Get.put(PrefService());
        prefs.getValue(key: 'user');
        // prefs.getValue(key: 'Bussiness');
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), getCategoryApi);
    }
  }

  Future<void> getBussinessCategories() async {
    try {
      onUpdate(status: Status.LOADING_MORE);
      ResponseModel res =
          await net.get(UrlConst.bussinessGetCategories, <String, dynamic>{});
      logger.d(res.data);
      if (res.isSuccess) {
        List<DropCategoryModel> foo = List<DropCategoryModel>.from(
          (res.data ?? <Map<String, dynamic>>[]).map(
            (Map<String, dynamic> e) => DropCategoryModel.fromJson(e),
          ),
        );
        dropInList.addAll(foo);

        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
      onUpdate(status: Status.SCUSSESS);
    } catch (e) {
      onError(e.toString(), getBussinessCategories);
    }
  }

  Future<void> updateBussinessCategoriessy<T>({required T cat}) async {
    try {
      onUpdate(status: Status.LOADING);
      if (updateTextFieldValue1.trim().isEmpty) {
        throw 'Please enter value to update.';
      }
      bool isDropin = cat is CategoryModel;
      Map<String, dynamic> body = <String, dynamic>{
        if (cat is CategoryModel) ...<String, dynamic>{
          'id': cat.id,
        } else if (cat is DropCategoryModel) ...<String, dynamic>{
          // for updating business cat
          'id': cat.id,
        },
        'name': updateTextFieldValue1,
        'type': isDropin ? 1 : 2,
      };
      ResponseModel res = await net.post(
        UrlConst.bussinessUpdateCategories,
        body,
      );
      logger.wtf(res.data);
      if (res.isSuccess) {
        if (!isDropin) {
          dropInList.forEach((DropCategoryModel element) {
            if (element.id == ((cat as DropCategoryModel).id)) {
              element.name = updateTextFieldValue1;
            }
          });
        } else {
          categoryList.forEach((CategoryModel element) {
            if (element.id == cat.id) {
              element.name = updateTextFieldValue1;
            }
          });
        }
        updateTextFieldValue1 = '';
        onUpdate(status: Status.SCUSSESS);
        Get.back();
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), () {
        updateBussinessCategoriessy(cat: cat);
      });
    }
  }
}
