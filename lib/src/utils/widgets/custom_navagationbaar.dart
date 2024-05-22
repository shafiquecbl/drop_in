import '../../../src_exports.dart';

class CustomBottomNavigationBar extends BottomNavigationBar {
  CustomBottomNavigationBar({
    Key? key,
    required List<BottomNavigationBarItem> items,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) : super(
          key: key,
          items: items,
          currentIndex: currentIndex,
          onTap: onTap,
        );

  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.appButtonColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: BottomNavigationBar(
        key: key,
        items: items,
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: AppColors.appButtonColor,
        selectedItemColor: AppColors.appButtonColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
