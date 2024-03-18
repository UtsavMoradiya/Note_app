import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class AddNote {
  final String? title;
  final String? note;
  final String? id;
  final int? color;
  final String? backImage;
  final List<String> imagePaths;
  bool isPinned;

  AddNote({
    this.title,
    this.note,
    this.id,
    this.color,
    this.backImage,
    required this.imagePaths,
    this.isPinned=false,
  });

  factory AddNote.fromJson(Map<String, dynamic> json) => _$AddNoteFromJson(json);

  Map<String, dynamic> toJson() => _$AddNoteToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}
