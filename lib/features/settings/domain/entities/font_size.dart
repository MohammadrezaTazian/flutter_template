import 'package:equatable/equatable.dart';

class FontSize extends Equatable {
  final String name;
  final double scale;

  const FontSize({
    required this.name,
    required this.scale,
  });

  @override
  List<Object?> get props => [name, scale];

  static List<FontSize> getFontSizes() {
    return const [
      FontSize(name: 'کوچک', scale: 0.8),
      FontSize(name: 'معمولی', scale: 1.0),
      FontSize(name: 'بزرگ', scale: 1.2),
      FontSize(name: 'خیلی بزرگ', scale: 1.4),
    ];
  }
}