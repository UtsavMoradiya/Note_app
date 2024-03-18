import 'package:mobx/mobx.dart';

part 'note_store.g.dart';

class NoteStore = _NoteStore with _$NoteStore;

abstract class _NoteStore with Store {
  @observable
  int selectedColor = 4294967295;
  @observable
  bool _isGridView = false;

  @observable
  String selectedBackgroundImage = "";

  @observable
  ObservableList selectedNotes = ObservableList();
}
