library app;

///Dart
export 'dart:io' hide HeaderValue;


///Flutter
export 'package:flutter/material.dart';
export 'package:flutter/foundation.dart';
export 'package:flutter/services.dart';

///Theme & Styling
export './src/mics/app_style/app_colors.dart';
export './src/mics/app_style/theme.dart';

///Controller
export './src/module/auth/auth_controller.dart';
export './src/module/base_controller.dart';

///Service
export './src/service/app_service.dart';
export './src/service/pref_sevice.dart';

///Models
export './src/models/response_model.dart';
export './src/models/user_model.dart';
export './src/models/emuns.dart';

///Screen & View

export './src/module/auth/forget_password.dart';
export './src/utils/widgets/loding_view.dart';
export './src/utils/widgets/error_view.dart';
export 'package:dropin/src/utils/widgets/custom_appbar.dart';

///Plugins
export 'package:get/get.dart' hide FormData, MultipartFile, Response;
export 'package:get_storage/get_storage.dart';

export 'package:package_info_plus/package_info_plus.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:device_info_plus/device_info_plus.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:flutter_spinkit/flutter_spinkit.dart';
export 'package:country_picker/country_picker.dart';
export 'package:cloud_functions/cloud_functions.dart';

export 'package:dio/dio.dart' hide VoidCallback;

export 'package:file_picker/file_picker.dart';
export 'package:flutter_slidable/flutter_slidable.dart'
    hide ConfirmDismissCallback;
// export 'package:photo_view/photo_view.dart';

///Utils & Const
export './src/utils/const/key_const.dart';
export './src/utils/const/asset_const.dart';
export './src/utils/const/url_const.dart';
export './src/utils/logger.dart';
export './src/mics/localization/localization.dart';
export './src/utils/widgets/custom_textfield.dart';
export './src/utils/widgets/custom_navagationbaar.dart';
export './src/utils/widgets/custom_Scaffold.dart';
export './src/utils/widgets/custom_appbutton.dart';
export './src/utils/const/app_validation.dart';
export './src/utils/widgets/custom_filepicker.dart';

///Navigation
export './src/navigation/pages.dart';
export './src/navigation/routes.dart';
export './src/navigation/bindings.dart';
export './src/navigation/middelware.dart';

/// screens
export 'package:dropin/main.dart';
export 'package:dropin/src/module/auth/login_screen.dart.dart';
export 'package:dropin/src/module/auth/signup_screen.dart.dart';
export 'package:dropin/src/module/auth/choose_account.dart';
export 'package:dropin/src/module/profile/createprofile_sscreen.dart';
export 'package:dropin/src/module/profile/business_profile/add_your_business.dart';
export 'package:dropin/src/module/profile/business_profile/business_add_pphotos.dart';
export 'package:dropin/src/module/profile/business_profile/business_final_setup.dart';
export 'package:dropin/src/module/authprofile/profilephoto_screen.dart';
export 'package:dropin/src/module/authprofile/addphotos_screen.dart';
export 'package:dropin/src/module/homescreen/home_screen.dart';
export 'package:dropin/src/module/profilescreen/editbussiness/edit_bussinessprofile.dart';

export 'package:dropin/src/module/newsscreen/news_screen.dart';
export 'package:dropin/src/module/chatscreen/chat_screen.dart';
export 'package:dropin/src/module/mapscreen/map_screen.dart';
export 'package:dropin/src/module/profilescreen/profile_screen.dart';
export 'package:dropin/src/module/profilescreen/editprofile/editprofile_screen.dart';
export 'package:dropin/src/module/profilescreen/editprofile/editbio_screen.dart';

export 'package:dropin/src/module/mapscreen/search_screen.dart';

export 'package:dropin/src/module/splashscreen/splash_screen.dart';

export 'package:dropin/src/module/dropinscreen/dropin_screen.dart';
export 'package:dropin/src/module/inobxscreen/inbox_Screen.dart';
export 'package:dropin/src/module/profilescreen/editprofile/edit_passwoed_screen.dart';

//web
// export './web/homescreen/navagation.dart';

export './web/module/auth/web_loginscreen.dart';
export './web/module/homescreen/navagation.dart';
