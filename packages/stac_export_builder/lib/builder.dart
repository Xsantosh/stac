import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/widget_export_generator.dart';
import 'src/json_builder.dart';

/// Builder factory function for the widget export generator.
Builder stacWidgetExportBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [WidgetExportGenerator()], 
    'stac_widget_export'
  );
}

/// Creates a builder that generates JSON files directly.
Builder stacJsonBuilder(BuilderOptions options) {
  return StacJsonBuilder(options);
}
