import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<int> noteColors = [];
  SearchController _searchController = SearchController();
  int? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search Your Notes",
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                selectedColor = null;
              });
            },
          ),
        ],
      ),
      body: _buildNoteColorsList(),
    );
  }

  Widget _buildNoteColorsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final notes = snapshot.data!.docs;
        noteColors = (notes
                .where((note) => (note.data() as Map<String, dynamic>)['color'] != null)
                .map<int>((note) => (note.data() as Map<String, dynamic>)['color'] as int)
                .toList())
            .toSet()
            .toList();
        noteColors = noteColors.toList();
        return Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Colours",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: noteColors.length,
                  itemBuilder: (context, index) {
                    final color = noteColors[index];
                    return GestureDetector(
                      onTap: () {
                        setState((){
                          selectedColor = color;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == color ? Colors.blue : Colors.grey,
                              width: selectedColor == color ? 3.0 : 1.0,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(color),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (selectedColor != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final noteColor = (notes[index].data() as Map<String, dynamic>)['color'] as int?;
                      if (noteColor == selectedColor) {
                        final noteTitle = (notes[index].data() as Map<String, dynamic>)['title'] as String?;
                        final note = (notes[index].data() as Map<String, dynamic>)['note'] as String?;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12, top: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(noteColor!),
                            ),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (noteTitle != null && noteTitle.isNotEmpty)
                                    Column(
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          noteTitle,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (noteTitle != null &&
                                      noteTitle.isNotEmpty &&
                                      note != null &&
                                      note.isNotEmpty)
                                    const SizedBox(height: 4),
                                  if (note != null && note.isNotEmpty)
                                    Text(
                                      note,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}