/// Text style properties for STAC text widgets.
class StacTextStyle {
  /// The size of the font in logical pixels.
  final double? fontSize;
  
  /// The weight of the font.
  /// 
  /// In STAC, this is represented as an integer where:
  /// - 400 is normal
  /// - 700 is bold
  final int? fontWeight;
  
  /// The color of the text.
  /// 
  /// This should be a hex color string (e.g., "#FF0000" for red).
  final String? color;
  
  /// Creates a [StacTextStyle] with the given properties.
  StacTextStyle({
    this.fontSize,
    this.fontWeight,
    this.color,
  });
  
  /// Converts the style to a JSON representation.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    
    if (fontSize != null) {
      json['fontSize'] = fontSize;
    }
    
    if (fontWeight != null) {
      json['fontWeight'] = fontWeight;
    }
    
    if (color != null) {
      json['color'] = color;
    }
    
    return json;
  }
}
