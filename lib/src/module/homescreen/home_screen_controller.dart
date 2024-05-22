import '../../../src_exports.dart';

class HomeScreenController extends BaseController {
  RxInt selectedIndex = 0.obs;
  RxBool isShow = false.obs;
  final Rx<Key> key = UniqueKey().obs;

  final List<Widget> screens = [
    NewsScreen(),
    MapScreen(),
    DropInScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  void onItemTapped(int index, BuildContext c) {
    selectedIndex.value = index;
    FocusScope.of(c).unfocus();
    key.value = UniqueKey();
  }
}
