// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NoteStore on _NoteStore, Store {
  late final _$selectedColorAtom =
      Atom(name: '_NoteStore.selectedColor', context: context);

  @override
  int get selectedColor {
    _$selectedColorAtom.reportRead();
    return super.selectedColor;
  }

  @override
  set selectedColor(int value) {
    _$selectedColorAtom.reportWrite(value, super.selectedColor, () {
      super.selectedColor = value;
    });
  }

  late final _$_isGridViewAtom =
      Atom(name: '_NoteStore._isGridView', context: context);

  @override
  bool get _isGridView {
    _$_isGridViewAtom.reportRead();
    return super._isGridView;
  }

  @override
  set _isGridView(bool value) {
    _$_isGridViewAtom.reportWrite(value, super._isGridView, () {
      super._isGridView = value;
    });
  }

  late final _$selectedBackgroundImageAtom =
      Atom(name: '_NoteStore.selectedBackgroundImage', context: context);

  @override
  String get selectedBackgroundImage {
    _$selectedBackgroundImageAtom.reportRead();
    return super.selectedBackgroundImage;
  }

  @override
  set selectedBackgroundImage(String value) {
    _$selectedBackgroundImageAtom
        .reportWrite(value, super.selectedBackgroundImage, () {
      super.selectedBackgroundImage = value;
    });
  }

  late final _$selectedNotesAtom =
      Atom(name: '_NoteStore.selectedNotes', context: context);

  @override
  ObservableList<dynamic> get selectedNotes {
    _$selectedNotesAtom.reportRead();
    return super.selectedNotes;
  }

  @override
  set selectedNotes(ObservableList<dynamic> value) {
    _$selectedNotesAtom.reportWrite(value, super.selectedNotes, () {
      super.selectedNotes = value;
    });
  }

  @override
  String toString() {
    return '''
selectedColor: ${selectedColor},
selectedBackgroundImage: ${selectedBackgroundImage},
selectedNotes: ${selectedNotes}
    ''';
  }
}
