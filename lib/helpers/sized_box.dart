import 'package:app/res/res.dart';

extension SizedBoxExtension on num {
  SizedBox get sH => SizedBox(height: toDouble().h);
  SizedBox get sW => SizedBox(width: toDouble().w);
}
