import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Language extends Equatable {
  final String code;
  final String name;
  final Locale locale;

  const Language({
    required this.code,
    required this.name,
    required this.locale,
  });

  @override
  List<Object?> get props => [code, name, locale];
}