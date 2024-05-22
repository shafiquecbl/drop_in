class UrlConst {
  static String privacyPolicy = 'https://dropinsurf.app/privacy-policy';
  static String termsAndConditions =
      'https://dropinsurf.app/end-user-license-agreement';
  static String _googleMapsKey = 'AIzaSyDVgUvft6ju2y-1uhvQQcuRs5vzHn6zw_A';
  static String _baseUrl = 'https://api.app.appdropin.com/api/';
  static String otherMediaBase = 'https://api.app.appdropin.com/uploads/icon/';
  static String coverImg = 'https://api.app.appdropin.com/uploads/cover_photo/';
  static String mediaBase = 'https://api.app.appdropin.com/uploads/image/';
  static String dropinBaseUrl = 'https://api.app.appdropin.com/uploads/images/';
  static String profileBase =
      'https://api.app.appdropin.com/uploads/profile_images/';
  static String noImage =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png';

  static String login = '${_baseUrl}auth/login';
  static String signUp = '${_baseUrl}auth/signup';
  static String profileSetup = '${_baseUrl}user/update';

  // static String getCategoryList = "${baseUrl}Category/get";
  static String list = '${_baseUrl}user/get-all';
  static String forgetPassword = '${_baseUrl}auth/forgot-password';
  static String checkUser = '${_baseUrl}auth/check';

  // static String getAllDropIn = "${baseUrl}Dropin/get-all";

  static String getAllCategory = '${_baseUrl}bussiness_cat/get';
  static String addCategory = '${_baseUrl}bussiness_cat/add';
  static String addressGetFromText =
      'https://maps.googleapis.com/maps/api/geocode/json?key=$_googleMapsKey&address=';
  static String addressGetFromLatLong =
      'https://maps.googleapis.com/maps/api/geocode/json?key=$_googleMapsKey&latlng=';
  static String autoComplete =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$_googleMapsKey&types=geocode&input=';
  static String placeId =
      'https://maps.googleapis.com/maps/api/place/details/json?key=$_googleMapsKey&place_id=';
  static String subCategory = '${_baseUrl}Sub_cat/get';
  static String newsFeed = '${_baseUrl}Dropin/get-all';
  static String bussinessAdd = '${_baseUrl}Business/add';
  static String updatebussiness = '${_baseUrl}Business/update';

  static String reportDropin = '${_baseUrl}Dropin/report';
  static String addDropIn = '${_baseUrl}Dropin/add';
  static String dropinid = '${_baseUrl}Dropin/get_by_id';

  // static String bussinessid = '${_baseUrl}Business/get_by_id';

  static String getDropIn = '${_baseUrl}Category_user/get';
  static String deleteUser = '${_baseUrl}user/delete';
  static String deleteDropIn = '${_baseUrl}Dropin/delete';
  static String updateDropIn = '${_baseUrl}Dropin/update';
  static String getMap = '${_baseUrl}map/get_map';
  static String searchLocation = '${_baseUrl}map/search_map';
  static String getAllUserDropIn = '${_baseUrl}Dropin/get_all_user_dropin';
  static String createChat = '${_baseUrl}chat/create';
  static String getChat = '${_baseUrl}chat/list';
  static String getSearchApi = '${_baseUrl}map/search_map?search';
  static String reportuser = '${_baseUrl}chat/report';
  static String blockUser = '${_baseUrl}block/block_user';
  static String userGetById = '${_baseUrl}user/get-by-id';
  static String deleteBussiness = '${_baseUrl}Business/delete';
  static String getbyIdBussiness = '${_baseUrl}Business/get_by_id';
  static String chatLike = '${_baseUrl}chat/chat_like';
  static String rateBussiness = '${_baseUrl}Business_rating/get';
  static String addBussinessRate = '${_baseUrl}Business_rating/add';
  static String userLike = '${_baseUrl}user/user_like_dislike';
  static String bussinessRate = '${_baseUrl}Business_rating/get?business_id';
  static String postFCM = '${_baseUrl}fcm-token/add';
  static String getFCM = '${_baseUrl}fcm-token/get';
  static String getNearByPins = '${_baseUrl}map/user_get_map';
  static String iconPath = 'https://api.app.appdropin.com/uploads/sub_category/icons/';

  ///admin

  static String adminLogin = '${_baseUrl}auth/admin_login';
  static String bussinessGet = '${_baseUrl}Admin/get';
  static String bussinessGetCategories = '${_baseUrl}bussiness_cat/get';
  static String bussinessUpdateCategories = '${_baseUrl}Admin/update';
  static String getAllUsers = '${_baseUrl}Admin/get_all';
  static String getReportUser = '${_baseUrl}Admin/report_users';
  static String statistic = '${_baseUrl}Admin/analytics';
  static String changePassword = '${_baseUrl}Admin/admin_change_password';
  static String generalApi = '${_baseUrl}Admin/analytics_general';
  static String exportApi = '${_baseUrl}Admin/get_all';
  static String searchApi = '${_baseUrl}Admin/search?search';
}
