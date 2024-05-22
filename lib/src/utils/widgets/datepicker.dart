import '../../../src_exports.dart';

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    int date;
    int month;
    int year;

// Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;

    // cText = cText.replaceAll("//", "/");

// Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    /// ENTERING THE DATE
    if (cLen == 1) {
      ///  User enters the first digit of the  date. The first digit
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 1) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      int mm = int.parse(cText.substring(0, 2));
      if (mm == 0) {
        cText = cText.substring(0, 1);
      } else if (mm > 12) {
        cText = cText.substring(0, 1);
      } else {
        /// User has entered a valid date (between 1 and 31). So now,
        // Add a / char
        cText += '/';
      }

      /// ENTERING THE MONTH
    } else if (cLen == 4) {
      /// after entering a valid date and programmatic insertion of '/', now User has entered
      /// the first digit of the Month. But, it
      // Can only be 0 or 1
      /// (and, not  '/' either)
      if (int.parse(cText.substring(3, 4)) > 3 ||
          cText.substring(3, 4) == "/") {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      int dd = int.parse(cText.substring(3, 5));
      int mm = int.parse(cText.substring(0, 2));

      /// User has entered the second digit of the Month, but the
      // Month cannot be greater than 12
      /// Also, that entry cannot be '/'
      // if ((dd == 0 || dd > 12|| cText.substring(3, 5) == "/") ||
      //     /// If the date is 31, the month cannot be Apr, Jun, Sept or Nov
      //     (mm == 31 && (dd == 02 || dd == 04 || dd == 06 || dd == 09 || dd == 11)) ||
      //     /// If the date is greater than 29, the month cannot be Feb
      //     /// (Leap years will be dealt with, when user enters the Year)
      //     (mm > 29 && (dd == 02))) {
      //   // Remove char
      //   cText = cText.substring(0, 4);
      // }
      // else if (cText.length == 5) {
      //   /// the Month entered is valid; so,
      //   // Add a / char
      //   cText += '/';
      // }

      if (mm == 2) {
        if (dd > 29) {
          cText = cText.substring(0, 4);
        } else {
          cText += '/';
        }
      } else if ((mm == 1 ||
              mm == 3 ||
              mm == 5 ||
              mm == 7 ||
              mm == 8 ||
              mm == 10 ||
              mm == 12) &&
          dd > 31) {
        cText = cText.substring(0, 4);
      } else if ((mm == 4 || mm == 6 || mm == 9 || mm == 11) && dd > 30) {
        cText = cText.substring(0, 4);
      } else {
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = '${cText.substring(0, 2)}/';
      } else {
        // Insert / char
        cText =
            '${cText.substring(0, pLen)}/${cText.substring(pLen, pLen + 1)}';
      }

      /// ENTERING THE YEAR
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        /// i.e, add '/' after the 5th position
        cText = '${cText.substring(0, 5)}/';
      } else {
        // Insert / char
        cText = '${cText.substring(0, 5)}/${cText.substring(5, 6)}';
      }
    } else if (cLen == 7) {
      /// the first digit of year
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      /// Also, there cannot be / typed by the user
      String y2 = cText.substring(6, 8);
      if (y2 != "19" && y2 != "20") {
        // Remove char
        cText = cText.substring(0, 7);
      }
    } else if (cLen == 9) {
      /// There cannot be / typed by the user
      if (cText.substring(8, 9) == "/") {
        // Remove char
        cText = cText.substring(0, 8);
      }
    } else if (cLen == 10) {
      /// There cannot be / typed by the user
      if (cText.substring(9, 10) == "/") {
        // Remove char
        cText = cText.substring(0, 9);
      }

      /// If the year entered is not a leap year but the date entered is February 29,
      /// it will be advanced to the next valid date
      date = int.parse(cText.substring(3, 5));
      month = int.parse(cText.substring(0, 2));
      year = int.parse(cText.substring(6, 10));
      bool isNotLeapYear =
          !((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0));
      if (isNotLeapYear && month == 02 && date == 29) {
        cText = "0$month/${date - 1}/$year";
        // cText = "01/03/$year";
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
} // END OF class _DateFormatter
