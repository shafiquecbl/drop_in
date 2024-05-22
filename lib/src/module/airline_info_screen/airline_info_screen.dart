// ignore_for_file: always_specify_types
import 'package:dropin/src_exports.dart';

class AirlineInfoScreen extends StatefulWidget {
  @override
  _AirlineInfoScreenState createState() => _AirlineInfoScreenState();
}

class _AirlineInfoScreenState extends State<AirlineInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.background,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Image.asset(
                      AppAssets.arrowBack,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  Wrap(
                    children: <Widget>[
                      Text(
                        'Airline Info',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    Text(
                      'Airline Info',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Provide some information about airlines and surf equipment check-ins. ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    TravelDetailInput(
                      title: 'Location (required*)',
                      hint: 'Type in Country or Region...',
                    ),
                    TravelDetailInput(
                      title: 'Airlines (required*)',
                      hint: 'Type in airline...',
                      padding: 0,
                    ),
                    TravelRadioTile(
                      title: 'Accepts checked-in surfboard bags?',
                      value: false,
                      onChanged: (bool? val) {},
                    ).paddingSymmetric(vertical: 10),
                    SizedBox(
                      height: 170,
                      child: TravelDetailInput(
                        title: 'DESCRIPTION (required*)',
                        hint:
                            'Write Information about the Country or Region here...',
                      ),
                    ),
                    Divider(),
                    Text(
                      'More Details',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ).paddingSymmetric(vertical: 5),
                    TravelRadioTile(
                      title: 'Additional fees for multiple boards?',
                      value: false,
                      onChanged: (bool? val) {},
                    ),
                    TravelRadioTile(
                      title: 'Accepts longboards (max. 300cm)? ',
                      value: false,
                      onChanged: (bool? val) {},
                    ),
                    TravelRadioTile(
                      title: 'Additional fees for longboards? ',
                      value: false,
                      onChanged: (bool? val) {},
                      subcategory: true,
                      note: true,
                    ),
                    TravelRadioTile(
                      title:
                          'Are advance reservations required for surfboard equipment?',
                      value: false,
                      onChanged: (bool? val) {},
                    ),
                    Divider(),
                    Text(
                      'DropIn will notify you about the status of the updates',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ).paddingSymmetric(vertical: 10),
                    SizedBox(height: 50),
                    AppElevatedButton(
                      color: AppColors.appButtonColor.withOpacity(0.8),
                      width: context.width,
                      height: 50,
                      elevation: 0,
                      callback: () async {},
                      title: 'Submit'.tr,
                    ).paddingSymmetric(horizontal: 20),
                    SizedBox(height: 10),
                    AppElevatedButton(
                      color: AppColors.appButtonColor,
                      width: context.width,
                      height: 50,
                      elevation: 0,
                      callback: () async {},
                      title: 'Cancel'.tr,
                    ).paddingSymmetric(horizontal: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TravelDetailInput extends StatelessWidget {
  const TravelDetailInput({
    required this.title,
    required this.hint,
    this.padding = 20,
    Key? key,
  }) : super(key: key);
  final double padding;
  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: AppTextField(
        title: title,
        hint: hint,
        maxLines: 3,
      ),
    );
  }
}

// Define the TravelChecklistTile widget here
class TravelRadioTile extends StatelessWidget {
  const TravelRadioTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.note = false,
    this.subcategory = false,
    Key? key,
  }) : super(key: key);
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool note;
  final bool subcategory;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? AppColors.appButtonColor : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: AppColors.appButtonColor,
              ),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
          contentPadding: EdgeInsets.zero,
        ),
        if (note)
          // Add padding and more info text if necessary
          Padding(
            padding: EdgeInsets.only(left: width * 0.12, bottom: 8.0),
            child: AppTextField(
              title: 'How much?',
              hint: 'Type in amount...',
              maxLines: 3,
            ),
          ),
      ],
    ).paddingOnly(left: subcategory ? width * 0.1 : 0);
  }
}

// Define the TravelOptionCheckbox widget here
class TravelOptionCheckbox extends StatelessWidget {
  const TravelOptionCheckbox({
    required this.title,
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
