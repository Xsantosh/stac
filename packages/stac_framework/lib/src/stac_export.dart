import 'package:flutter/widgets.dart';

abstract class StacExport<T extends Widget> {
  const StacExport();

  String get type;

  Type get widget;

  Map<String, dynamic> toStacJson(T widget);
}
