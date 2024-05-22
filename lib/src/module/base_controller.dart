import 'package:dropin/src_exports.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class BaseController extends GetxController {
  Status _status = Status.IDEL;
  bool get isLoading => _status == Status.LOADING;
  bool get lodingMore => _status == Status.LOADING_MORE;
  bool get searching => _status == Status.SEARCHING;
  bool get isSuccess => _status == Status.SCUSSESS || _status == Status.IDEL;
  Widget view = const SizedBox();

  void onUpdate({
    Status status = Status.IDEL,
    VoidCallback? callback,
    String message = '',
    String description = '',
  }) {
    switch (status) {
      case Status.LOADING:
        break;
      case Status.LOADING_MORE:
        break;
      case Status.FAILED:
        break;
      case Status.IDEL:
        break;
      case Status.SCUSSESS:
        break;
      case Status.SEARCHING:
        break;
    }
    if (status == Status.LOADING) {
      view = LoaderView();
    } else if (status == Status.FAILED) {
      view = ErrorView(
        callback: callback,
        message: message,
        description: description,
      );
    } else {
      view = const SizedBox();
    }
    _status = status;
    update();
  }

  void onError(
    dynamic error,
    VoidCallback? callback, {
    bool showSnackbar = true,
  }) {
    logger.e(error);
    if (showSnackbar) {
      dynamic message = error;
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.connectionTimeout:
            message = 'Connection time out';
            break;
          case DioErrorType.sendTimeout:
            message = 'Send time out';
            break;
          case DioErrorType.receiveTimeout:
            message = 'Connection time out';
            break;
          case DioErrorType.badResponse:
            message = 'Internal server error';
            break;
          case DioErrorType.cancel:
            message = 'Connection Canceled';
            break;
          case DioErrorType.unknown:
            break;
          case DioExceptionType.badCertificate:
            // TODO: Handle this case.
          case DioExceptionType.connectionError:
            message = 'Check your internet connection';
        }
      }
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'Something went wrong..!!',
          error,
          margin: EdgeInsets.zero,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 0,
        );
      }
    }
    onUpdate(
      status: Status.FAILED,
      callback: callback,
      message: 'Something wrong',
    );
    onSendError(error, StackTrace.current);
    logger.e('onError', error: error, stackTrace: StackTrace.current);
  }

  void onSendError(dynamic error, StackTrace trace) {
    if (!kDebugMode && !kIsWeb) {
      FirebaseCrashlytics.instance.recordError(
        error,
        trace,
        fatal: true,
      );
    }
  }
}
