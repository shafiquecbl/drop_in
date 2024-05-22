import 'package:dropin/src/module/base_controller.dart';
import 'package:dropin/src_exports.dart';

import '../../../src/models/general_model.dart';
import '../../../src/service/network_service.dart';

class GeneralController extends BaseController {
  Rx<GeneralModel> generalModel = GeneralModel().obs;

  @override
  void onInit() {
    getGeneralApi();
    super.onInit();
  }

  Future<void> getGeneralApi() async {
    try {
      onUpdate(status: Status.LOADING);
      ResponseModel res = await net.get(UrlConst.generalApi, {});
      logger.d(res.data);
      if (res.isSuccess) {
        generalModel.value = GeneralModel.fromJson(res.data);
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), getGeneralApi);
    }
  }
}
