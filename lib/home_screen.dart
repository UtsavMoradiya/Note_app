import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:googlenote/add_note_screen.dart';
import 'package:googlenote/drawer_screen.dart';
import 'package:googlenote/fire_base_screen.dart';
import 'package:googlenote/google_login.dart';
import 'package:googlenote/model/note_model.dart';
import 'package:googlenote/search_screen.dart';
import 'package:googlenote/store/note_store.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isGridView = false;
  final NoteStore _note = NoteStore();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 16, 0),
                child: _note.selectedNotes.isEmpty ? _buildTopWidget() : _buildAppBar(),
              ),
              _buildNoteGride(),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: _floatingButtonWidget(),
          bottomNavigationBar: _bottomAppBarWidget(),
          drawer: const DrawerScreen(),
        );
      },
    );
  }

  Widget _buildTopWidget() {
    // final firstLetter = user?.email?.isNotEmpty == true ? user!.email![0].toUpperCase() : '';

    return Builder(
      builder: (context) {
        return Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                child: Text(
                  "Search Your Notes",
                  style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 16),
                ),
              ),
              const SizedBox(
                width: 100,
              ),
              GestureDetector(
                onTap: () {
                  setState(
                    () {
                      _isGridView = !_isGridView;
                    },
                  );
                },
                child: _isGridView
                    ? const Icon(
                        Icons.view_list_sharp,
                        color: Colors.black,
                      )
                    : const Icon(
                        Icons.grid_view,
                        color: Colors.black,
                      ),
              ),
              const SizedBox(width: 15),
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.pink,
                // child: Text(firstLetter),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomAppBarWidget() {
    return BottomAppBar(
      notchMargin: 11,
      elevation: 2,
      shape: const CircularNotchedRectangle(),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.done_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.brush_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.keyboard_voice_outlined),
          ),
          IconButton(
            onPressed: () {
              _showPhotoDialog();
            },
            icon: const Icon(Icons.photo_outlined),
          ),
        ],
      ),
    );
  }

  Widget _floatingButtonWidget() {
    return FloatingActionButton(
      backgroundColor: Colors.grey.shade100,
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const AddNoteScreen();
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildNoteGride() {
    return _isGridView
        ? Expanded(
            child: StreamBuilder<List<AddNote>>(
              stream: _firebaseService.getNotesFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final notes = snapshot.data!;
                  if (notes.isNotEmpty) {
                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: MasonryGridView.count(
                        crossAxisCount: 2,
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return _buildNoteCard(note);
                        },
                      ),
                    );
                  } else {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.orangeAccent,
                          size: 130,
                        ),
                        SizedBox(height: 16),
                        Text("Notes you add appear here"),
                      ],
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          )
        : _buildNoteList();
  }

  Widget _buildNoteList() {
    return Expanded(
      child: StreamBuilder<List<AddNote>>(
        stream: _firebaseService.getNotesFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notes = snapshot.data!;
            if (notes.isNotEmpty) {
              return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return _buildNoteCard(note);
                  },
                ),
              );
            } else {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.orangeAccent,
                    size: 130,
                  ),
                  SizedBox(height: 16),
                  Text("Notes you add appear here"),
                ],
              );
            }
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildNoteCard(AddNote note) {
    final isSelected = _note.selectedNotes.contains(note.id);

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          // Deselect the note if it's already selected
          _note.selectedNotes.remove(note.id);
        } else if (_note.selectedNotes.isEmpty) {
          // Navigate to note details only if no notes are selected
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteScreen(editingNote: note),
            ),
          );
        }
      },
      onLongPress: () {
        // Toggle selection on long-press
        if (_note.selectedNotes.contains(note.id)) {
          _note.selectedNotes.remove(note.id);
        } else {
          _note.selectedNotes.add(note.id);
        }
      },
      child: Dismissible(
        key: Key(note.id!), // Assuming id is non-null
        onDismissed: (direction) {
          if (direction == DismissDirection.horizontal) {
            _deleteNoteAndRefresh(note.id!);
          }
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSelected ? Colors.blue.withOpacity(0.2) : (note.color != null ? Color(note.color!) : Colors.white),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey,
                width: 1,
              ),
              image: note.backImage != null && note.backImage!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(note.backImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    if (note.imagePaths.isNotEmpty) _buildImageRow(note.imagePaths),
                  ],
                ),
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (note.title!.isNotEmpty)
                        Text(
                          note.title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      if (note.title!.isNotEmpty && note.note!.isNotEmpty) const SizedBox(height: 4),
                      if (note.note!.isNotEmpty)
                        Text(
                          note.note!,
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteNoteAndRefresh(String noteId) {
    print("Deleting note with ID: $noteId");
    _firebaseService.deleteNoteById(noteId).then((result) {
      print("Note deleted successfully");
    }).catchError((error) {
      print("Error deleting note: $error");
    });
  }

  Widget _buildImageRow(List<String> imagePaths) {
    int crossAxisCount = 1;

    if (imagePaths.length >= 2) {
      crossAxisCount = 2;
    }

    if (imagePaths.length >= 3) {
      crossAxisCount = 3;
    }

    return Expanded(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: imagePaths.map((imagePath) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAppBar() {
    int selectedCount = _note.selectedNotes.length;

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _note.selectedNotes.clear();
          },
          child: const Icon(Icons.cancel_outlined),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          "$selectedCount",
          style: const TextStyle(fontSize: 22),
        ),
        const SizedBox(
          width: 130,
        ),
        GestureDetector(
          child: const Icon(CupertinoIcons.pin),
        ),
        const SizedBox(
          width: 19,
        ),
        const Icon(Icons.notification_add_outlined),
        const SizedBox(
          width: 19,
        ),
        GestureDetector(onTap: () {}, child: const Icon(Icons.palette_outlined)),
        const SizedBox(
          width: 19,
        ),
        const Icon(Icons.label_outline),
        const SizedBox(
          width: 8,
        ),
        PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 'Delete':
                _deleteSelectedNotes();
                break;
              case 'Send':
                _shareSelectedNotes(_note.selectedNotes);
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                value: 'Archive',
                child: Text('Archive'),
              ),
              const PopupMenuItem(
                value: 'Delete',
                child: Text('Delete'),
              ),
              const PopupMenuItem(
                value: 'Make a copy',
                child: Text('Make a copy'),
              ),
              const PopupMenuItem(
                value: 'Send',
                child: Text('Send'),
              ),
              const PopupMenuItem(
                value: 'Copy to Google Docs',
                child: Text('Copy to Google Docs'),
              ),
            ];
          },
          child: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  void _shareSelectedNotes(ObservableList<dynamic> selectedNotes) {
    // List<String> noteContents = [];
    //
    // for (dynamic note in selectedNotes) {
    //   if (note is AddNote) {
    //     String noteContent = "Title: ${note.title}, Note: ${note.note}";
    //     noteContents.add(noteContent);
    //   }
    // }

    String shareText = "Shared Notes:\n\n${selectedNotes.join('\n\n')}";

    Share.share(shareText);
  }

  void _deleteSelectedNotes() {
    for (String noteId in _note.selectedNotes) {
      _deleteNoteAndRefresh(noteId);
    }
    _note.selectedNotes.clear();
  }

  _showPhotoDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  _takePhoto();
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(Icons.camera_alt_outlined),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Take photo',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  _chooseImage();
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(Icons.image_outlined),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Choose image',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _takePhoto() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      print('Image path from camera: ${pickedFile.path}');
    }
  }

  Future<void> _chooseImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('Image path from gallery: ${pickedFile.path}');
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GoogleLogin()), // Navigate back to sign-in screen
    );
  }
}
