import 'package:equatable/equatable.dart';

class AppTheme extends Equatable {
  final String name;
  final bool isDark;

  const AppTheme({
    required this.name,
    required this.isDark,
  });

  @override
  List<Object?> get props => [name, isDark];
}