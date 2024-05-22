import 'package:dropin/src_exports.dart';

final PrefService prefs = PrefService.instance;

class PrefService extends GetxService {
  static final PrefService instance = PrefService();
  GetStorage storage = GetStorage();

  @override
  Future<void> onInit() async {
    logger.w('Prefs Init');
    await GetStorage.init();
    super.onInit();
  }

  dynamic getValue({required String key}) {
    final foo = storage.read(key);
    loggerNoStack.i('store value >>->$foo');
    return foo;
  }

  Future<void> setValue({required String key, dynamic value}) async {
    try {
      await storage.write(key, value);
    } catch (e) {
      logger.e(e.runtimeType);
      logger.e(e);
    }
    logger.i('store value : ${value}');
  }

  Future<void> removeValue(String key) async {
    await storage.remove(key);
  }
}
