import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:googlenote/fire_base_screen.dart';
import 'package:googlenote/store/note_store.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'model/note_model.dart';

class AddNoteScreen extends StatefulWidget {
  final AddNote? editingNote;

  const AddNoteScreen({Key? key, this.editingNote}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final NoteStore _note = NoteStore();
  List<String> _pickedImagePaths = [];

  @override
  void initState() {
    super.initState();
    if (widget.editingNote != null) {
      titleController.text = widget.editingNote!.title!;
      noteController.text = widget.editingNote!.note!;
      _pickedImagePaths = List.from(widget.editingNote!.imagePaths);
      _note.selectedColor = widget.editingNote!.color!;
      _note.selectedBackgroundImage = widget.editingNote!.backImage!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (titleController.text.isNotEmpty || noteController.text.isNotEmpty || _pickedImagePaths.isNotEmpty) {
          AddNote updatedNoteObject = AddNote(
            id: widget.editingNote?.id,
            title: titleController.text,
            note: noteController.text,
            color: _note.selectedColor,
            imagePaths: List.from(_pickedImagePaths),
            backImage: _note.selectedBackgroundImage,
          );

          if (widget.editingNote != null) {
            await _firebaseService.updateNoteInFirestore(updatedNoteObject);
          } else {
            await _firebaseService.addNoteToFirestore(updatedNoteObject);
          }

          Navigator.pop(context);
          return true;
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Empty note discarded'),
            ),
          );
          return false;
        }
      },
      child: Observer(
        builder: (context) {
          return Scaffold(

            backgroundColor: Color(_note.selectedColor),
            appBar: _buildAppbar(),
            body: Stack(
              children: [
                _note.selectedBackgroundImage.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_note.selectedBackgroundImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: _textFildWidget(),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _bottomAppBarWidget(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildAppbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      actions: [
        const Icon(CupertinoIcons.pin, color: Colors.black),
        const SizedBox(width: 13),
        GestureDetector(
          onTap: () {
            _showBottomSheetWithMessagecenter();
          },
          child: const Icon(Icons.notification_add_outlined, color: Colors.black),
        ),
        const SizedBox(width: 13),
        const Icon(Icons.archive_outlined, color: Colors.black),
        const SizedBox(width: 13),
      ],
    );
  }

  Widget _textFildWidget() {
    return Column(
      children: [
        if (_pickedImagePaths.isNotEmpty)
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _pickedImagePaths.length,
              itemBuilder: (context, index) {
                final imagePath = _pickedImagePaths[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(imagePath)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        TextField(
          cursorColor: Colors.black,
          controller: titleController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: const TextStyle(fontSize: 22),
          decoration: const InputDecoration(
            hintText: 'Title',
            border: InputBorder.none,
          ),
        ),
        TextField(
          autofocus: true,
          cursorColor: Colors.black,
          controller: noteController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: const TextStyle(fontSize: 18),
          decoration: const InputDecoration(
            hintText: 'Note',
            border: InputBorder.none,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(_note.selectedColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomAppBarWidget() {
    return BottomAppBar(
      height: 55,
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _showBottomSheetWithMessageleft();
            },
            icon: const Icon(Icons.add_box_outlined),
          ),
          IconButton(
            onPressed: () {
              _showColorPicker();
            },
            icon: const Icon(Icons.palette_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.text_format),
          ),
          Text(
            _formatTimestamp(DateTime.now()),
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            width: 74,
          ),
          IconButton(
            onPressed: () {
              _showBottomSheetWithMessage();
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  void _showBottomSheetWithMessage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 300,
          width: double.infinity,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 7),
                  Icon(CupertinoIcons.delete),
                  SizedBox(width: 7),
                  Text('Delete'),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 7),
                  Icon(Icons.copy),
                  SizedBox(width: 7),
                  Text('Make a copy'),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 7),
                  Icon(Icons.share),
                  SizedBox(width: 7),
                  Text('Send'),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 7),
                  Icon(Icons.add_reaction),
                  SizedBox(width: 7),
                  Text('Collaborator'),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 7),
                  Icon(Icons.label_outline),
                  SizedBox(width: 7),
                  Text('Labels'),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 7),
                  Icon(Icons.help_outline),
                  SizedBox(width: 7),
                  Text('Help & feedback'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBottomSheetWithMessagecenter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 375,
          width: double.infinity,
          child: const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 7),
                    Icon(CupertinoIcons.clock),
                    SizedBox(width: 7),
                    Text('Later today'),
                    Spacer(),
                    Text("6:00 pm")
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 7),
                    Icon(CupertinoIcons.clock),
                    SizedBox(width: 7),
                    Text('Tomorrow morning'),
                    Spacer(),
                    Text("8:00 am")
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 7),
                    Icon(CupertinoIcons.clock),
                    SizedBox(width: 7),
                    Text('Friday morning'),
                    Spacer(),
                    Text("Fri,8:00 am")
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 7),
                    Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Home',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 7),
                    Icon(
                      Icons.work,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Work',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 7),
                    Icon(CupertinoIcons.clock),
                    SizedBox(width: 7),
                    Text('Shoose a date & time'),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 7),
                    Icon(CupertinoIcons.location_solid),
                    SizedBox(width: 7),
                    Text('Choose a place'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheetWithMessageleft() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 250,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  final imagePicker = ImagePicker();
                  final pickedFile = await imagePicker.getImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _pickedImagePaths.add(pickedFile.path);
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Row(
                  children: [
                    SizedBox(width: 7),
                    Icon(CupertinoIcons.photo_camera),
                    SizedBox(width: 7),
                    Text('Take photo'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final imagePicker = ImagePicker();
                  final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _pickedImagePaths.add(pickedFile.path);
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Row(
                  children: [
                    SizedBox(width: 7),
                    Icon(Icons.photo_outlined),
                    SizedBox(width: 7),
                    Text('Add image'),
                  ],
                ),
              ),
              const Row(
                children: [
                  SizedBox(width: 7),
                  Icon(Icons.draw),
                  SizedBox(width: 7),
                  Text('Drawing'),
                ],
              ),
              const Row(
                children: [
                  SizedBox(width: 7),
                  Icon(Icons.keyboard_voice_outlined),
                  SizedBox(width: 7),
                  Text('Recording'),
                ],
              ),
              const Row(
                children: [
                  SizedBox(width: 7),
                  Icon(Icons.done),
                  SizedBox(width: 7),
                  Text('Tick boxes'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      shape: const Border(),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: Column(
            children: [
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colorOptions.length,
                  itemBuilder: (context, index) {
                    final color = _colorOptions[index];
                    final isSelected = _note.selectedColor == color.value;

                    return GestureDetector(
                      onTap: () {
                        _note.selectedColor = color.value;
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.blueAccent : Colors.transparent,
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                          color: color,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.blueAccent,
                                size: 30,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              _showBackgroundImagePicker(),
            ],
          ),
        );
      },
    );
  }

  _showBackgroundImagePicker() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _backgroundImageOptions.length,
        itemBuilder: (context, index) {
          final backgroundImage = _backgroundImageOptions[index];
          final isSelected = _note.selectedBackgroundImage == backgroundImage;

          return GestureDetector(
            onTap: () {
              _note.selectedBackgroundImage = backgroundImage;
            },
            child: FutureBuilder(
              future: precacheImage(NetworkImage(backgroundImage), context),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blueAccent : Colors.transparent,
                        width: 3,
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(backgroundImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.blueAccent,
                            size: 30,
                          )
                        : null,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return 'Edited: ${DateFormat('h:mm a').format(timestamp)}';
  }

  final List<Color> _colorOptions = [
    const Color(0xffFF9E9E),
    const Color(0xffFD99FF),
    const Color(0xfffedc56),
    const Color(0xfffca3b7),
    const Color(0xff91F48F),
    const Color(0xffB69CFF),
    const Color(0xff229810),
    const Color(0x7ec4e4f1),
    const Color(0xffa5ceef),
  ];
  final List<String> _backgroundImageOptions = [
    'https://www.pixelstalk.net/wp-content/uploads/2016/06/Free-Images-Wallpaper-HD-Background.jpg',
    'https://wallpapercave.com/wp/wp2555019.jpg',
    'https://wonderfulengineering.com/wp-content/uploads/2016/02/wallpaper-background-2.jpg',
    'https://wallpapercave.com/wp/mlZFB5z.jpg',
    'https://wallpapercave.com/wp/wp7213366.jpg',
    'https://www.pixelstalk.net/wp-content/uploads/2016/06/Solid-light-blue-wide-wallpaper.jpg',
    'https://wallpapercave.com/wp/wp7213408.jpg',
    'https://getwallpapers.com/wallpaper/full/7/7/4/135893.jpg',
    'https://wallpaperaccess.com/full/1567957.jpg'
  ];
}
