import '../core/stac_widget.dart';
import 'stac_style.dart';

/// A STAC Text widget.
///
/// This widget represents a text element in the STAC framework.
class StacText extends StacWidget {
  /// The text data to display.
  final String data;

  /// The style for the text.
  final StacTextStyle? style;

  /// Creates a new [StacText] widget.
  ///
  /// The [data] parameter is required and represents the text to display.
  /// The [style] parameter is optional and can be used to style the text.
  StacText({required this.data, this.style});

  @override
  String get type => 'text';

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {'type': type, 'data': data};

    if (style != null) {
      json['style'] = style!.toJson();
    }

    return json;
  }
}

////
///
///

class StacTextFormField extends StacWidget {
  StacTextFormField({required this.id});

  final String id;

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  String get type => 'textFormField';
}
