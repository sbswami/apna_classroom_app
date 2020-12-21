import 'package:apna_classroom_app/internationalization/lang/en_IN.dart';
import 'package:apna_classroom_app/internationalization/lang/en_US.dart';
import 'package:apna_classroom_app/internationalization/lang/hi_IN.dart';
import 'package:get/get.dart';

class MyTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {'en_US': EN_US, 'en_IN': EN_IN, 'hi_IN': HI_IN};
}
