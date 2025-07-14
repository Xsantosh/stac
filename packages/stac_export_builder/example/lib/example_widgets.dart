import 'package:flutter/material.dart';
import 'package:stac_export_builder/stac_export_builder.dart';

part 'example_widgets.g.dart';

@StacExportable()
Widget homeContainer() {
  return Container(
    color: Colors.red,
    child: ElevatedButton(
      onPressed: () {},
      child: Text(DateTime.now().toString()),
    ),
  );
}
