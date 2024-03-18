// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddNote _$AddNoteFromJson(Map<String, dynamic> json) => AddNote(
      title: json['title'] as String?,
      note: json['note'] as String?,
      id: json['id'] as String?,
      color: json['color'] as int?,
      backImage: json['backImage'] as String?,
      imagePaths: (json['imagePaths'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AddNoteToJson(AddNote instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('note', instance.note);
  writeNotNull('id', instance.id);
  writeNotNull('color', instance.color);
  writeNotNull('backImage', instance.backImage);
  val['imagePaths'] = instance.imagePaths;
  return val;
}
