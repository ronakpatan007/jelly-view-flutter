import 'dart:ui';

import 'package:jellyview/model/border_point.dart';

class JellyBody {
  List<BorderPoint> borderPoints;
  Path jellyPath;

  JellyBody(this.borderPoints, this.jellyPath);
}
