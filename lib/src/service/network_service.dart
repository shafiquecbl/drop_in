import 'dart:convert';

import 'package:dropin/src_exports.dart';

import '../utils/error_mixin.dart';

final Network net = Network();

class Network with ErrorHandling {
  final Map<String, dynamic> _parameters = {};
  static final Network _instance = Network.internal();
  static final Dio _dio = Dio();

  Network.internal();

  factory Network() => _instance;

  Future<void> init(UserModel user) async{
    if (user.token.isNotEmpty) {
      _dio.options.headers.addAll({
        'apikey': user.apikey,
        'token': user.token,
      });
      _parameters.addAll({
        'apikey': user.apikey,
        'token': user.token,
      });
    }
  }

  Future<ResponseModel> get(String url, Map<String, dynamic> params) async {
    if (kIsWeb) {
      _dio.options.headers.removeWhere((key, value) => key == 'apikey');
      _dio.options.headers.removeWhere((key, value) => key == 'token');
      params.addAll(_parameters);
    }
    logger.d('URL: $url\nPARAMS: $params\nHEADERS: ${_dio.options.headers}');
    logger.d('GET');
    return _dio
        .get(url, queryParameters: params)
        .then(_success)
        .catchError(_failed);
  }

  Future<ResponseModel> post(
    String url,
    dynamic body, {
    bool isRaw = false,
    dynamic params,
  }) async {
    if (kIsWeb) {
      _dio.options.headers.removeWhere((key, value) => key == 'apikey');
      _dio.options.headers.removeWhere((key, value) => key == 'token');
      body.addAll(_parameters);
    }
    logger.d(
        'URL: $url\nBODY : $body\nPARAMS: $params\nHEADERS: ${_dio.options.headers}');
    dynamic data;
    if (isRaw) {
      data = json.encode(body);
    } else {
      data = FormData.fromMap(body);
    }
    logger.d('CALLING POST NET');
    return _dio
        .post(url, data: data, queryParameters: params)
        .then(_success)
        .catchError(_failed);
  }

  ResponseModel _success(Response response) {
    final dynamic url = response.requestOptions.uri;
    final dynamic data = response.data;
    int? code = response.statusCode;
    logger.i('URL : $url\nRESPONSE ${response.statusCode} : $data');
    ResponseModel model = ResponseModel();
    if (code != null && code == 401) {
      // app.logout();
      model = ResponseModel();
    } else {
      model = ResponseModel.fromJson(data);
    }
    return model;
  }

  Future<ResponseModel> _failed(error) async {
    logger.e('onFailed', error: error, stackTrace: StackTrace.current);
    String message = '';
    try {
      if (!(await isConnected())) {
      } else if (error is DioError) {
        logger.e(error.response);
        DioError dError = error;
        switch (dError.type) {
          case DioErrorType.cancel:
            message = 'Request Cancelled';
            break;
          case DioErrorType.connectionTimeout:
            message = 'Connection Timeout';
            break;
          case DioErrorType.unknown:
            message = 'Something went wrong';
            break;
          case DioErrorType.receiveTimeout:
            message = 'Receive Timeout';
            break;
          case DioErrorType.badResponse:
            int code = dError.response?.statusCode ?? 0;
            if (code == 404) {
              message = 'Resource not found';
            } else if (code == 500) {
              message = 'Internal server error';
            } else if (code == 503) {
              message = 'Service Unavailable';
            } else if (code == 401) {
              message = 'Un Authorised';
            } else if (code == 429) {
              message = 'Too many Requests';
            } else if (code == 400) {
              message = 'Bad Request';
            } else {
              message = error.toString();
            }
            break;
          case DioErrorType.sendTimeout:
            message = 'Send Timeout';
            break;
          case DioExceptionType.badCertificate:
            // TODO: Handle this case.
          case DioExceptionType.connectionError:
            // TODO: Handle this case.
        }
      }
    } catch (e) {
      message = e.toString();
    }
    return ResponseModel(message: message, status: false);
  }

  Future<bool> isConnected() async {
    try {
      List<InternetAddress> list = await InternetAddress.lookup('google.com');
      return list.isNotEmpty && list[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
