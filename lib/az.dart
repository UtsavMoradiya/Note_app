// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:googlenote/fire_base_screen.dart';
// import 'package:googlenote/search_screen.dart';
// import 'add_note_screen.dart';
// import 'drawer_screen.dart';
// import 'model/note_model.dart';
//
// class HomeScreenn extends StatefulWidget {
//   const HomeScreenn({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreenn> createState() => _HomeScreennState();
// }
//
// class _HomeScreennState extends State<HomeScreenn> {
//   IconData currentIcon = Icons.horizontal_split_outlined;
//   Set<int> selectedNoteIndices = {};
//   List<AddNote> pinnedNotes = [];
//   List<AddNote> allNotes = [];
//
//   final FirebaseService _firebaseService = FirebaseService();
//   bool isGridView = false; // State variable to track the view mode
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 40, 10, 0),
//             child: selectedNoteIndices.isEmpty ? _buildTopWidget() : _buildAppBar(AddNote(imagePaths: [])),
//           ),
//           _buildNoteList(),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//       floatingActionButton: _flotingbuttonwidget(),
//       bottomNavigationBar: _bottomappbarwidget(),
//       drawer: const DrawerScreen(),
//     );
//   }
//
//   Widget _buildTopWidget() {
//     return Builder(
//       builder: (context) {
//         return Container(
//           margin: const EdgeInsets.symmetric(vertical: 10),
//           width: double.infinity,
//           height: 55,
//           decoration: BoxDecoration(
//             color: const Color(0xFFD0E5EEFF),
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: Row(
//             children: [
//               IconButton(
//                 onPressed: () {
//                   Scaffold.of(context).openDrawer();
//                 },
//                 icon: const Icon(
//                   Icons.menu,
//                   color: Colors.black,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const SearchScreen(),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   "Search Your Notes",
//                   style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 16),
//                 ),
//               ),
//               const SizedBox(
//                 width: 80,
//               ),
//               TextButton(
//                 style: ButtonStyle(
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(40.0),
//                     ),
//                   ),
//                 ),
//                 onPressed: () {
//                   // Toggle between list and grid view modes
//                   setState(() {
//                     isGridView = !isGridView;
//                   });
//                 },
//                 child: const Icon(
//                   Icons.grid_view,
//                   color: Colors.black,
//                 ),
//               ),
//               const CircleAvatar(
//                 radius: 16,
//                 backgroundColor: Colors.grey,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _bottomappbarwidget() {
//     return BottomAppBar(
//       notchMargin: 10,
//       elevation: 2,
//       shape: const CircularNotchedRectangle(),
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () {
//               // Navigate or perform some action
//             },
//             icon: const Icon(Icons.done_outlined),
//           ),
//           IconButton(
//             onPressed: () {
//               // Navigate or perform some action
//             },
//             icon: const Icon(Icons.brush_outlined),
//           ),
//           IconButton(
//             onPressed: () {
//               // Navigate or perform some action
//             },
//             icon: const Icon(Icons.keyboard_voice_outlined),
//           ),
//           IconButton(
//             onPressed: () {
//               // Navigate or perform some action
//             },
//             icon: const Icon(Icons.photo_outlined),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _flotingbuttonwidget() {
//     return FloatingActionButton(
//       backgroundColor: Colors.grey.shade100,
//       onPressed: () async {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const AddNoteScreen(),
//           ),
//         );
//       },
//       child: const Icon(Icons.add),
//     );
//   }
//
//   // Widget _buildNoteList() {
//   //   return Expanded(
//   //     child: StreamBuilder<List<AddNote>>(
//   //       stream: _firebaseService.getNotesFromFirestore(),
//   //       builder: (context, snapshot) {
//   //         if (snapshot.connectionState == ConnectionState.waiting) {
//   //           return const Center(child: CircularProgressIndicator());
//   //         } else if (snapshot.hasError) {
//   //           return Text("Error: ${snapshot.error}");
//   //         } else if (snapshot.hasData) {
//   //           final notes = snapshot.data!;
//   //           allNotes.clear();
//   //           allNotes.addAll(pinnedNotes);
//   //           allNotes.addAll(notes.where((note) => !pinnedNotes.contains(note)));
//   //
//   //           return isGridView ? _buildGridView(allNotes) : _buildListView(allNotes);
//   //         }
//   //         // If there's no data, display a message
//   //         return _buildEmptyNotesMessage();
//   //       },
//   //     ),
//   //   );
//   // }
//
//   Widget _buildEmptyNotesMessage() {
//     return const Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           Icons.lightbulb_outline,
//           color: Colors.orangeAccent,
//           size: 130,
//         ),
//         SizedBox(height: 16),
//         Text("Notes you add appear here"),
//       ],
//     );
//   }
//
//   Widget _buildListView() {
//     return ListView.builder(
//       itemCount: pinnedNotes.length + allNotes.length,
//       itemBuilder: (context, index) {
//         if (index < pinnedNotes.length) {
//           final note = pinnedNotes[index];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (pinnedNotes.isNotEmpty && index == 0 && pinnedNotes.isNotEmpty) _buildSectionHeader("Pinned"),
//               if (pinnedNotes.contains(note)) _buildNoteCard(note, index),
//               if (!pinnedNotes.contains(note) && pinnedNotes.isNotEmpty && index == pinnedNotes.length)
//                 _buildSectionHeader("Other"),
//               if (!pinnedNotes.contains(note) && index > pinnedNotes.length) _buildNoteCard(note, index),
//             ],
//           );
//         } else {
//           final note = allNotes[index - pinnedNotes.length];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (pinnedNotes.isNotEmpty && index == pinnedNotes.length) _buildSectionHeader("Other"),
//               if (!pinnedNotes.contains(note) && index > pinnedNotes.length) _buildNoteCard(note, index),
//             ],
//           );
//         }
//       },
//     );
//   }
//
//   Widget _buildGridView() {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisSpacing: 8.0,
//         crossAxisSpacing: 8.0,
//       ),
//       itemCount: pinnedNotes.length + allNotes.length,
//       itemBuilder: (context, index) {
//         if (index < pinnedNotes.length) {
//           final note = pinnedNotes[index];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (pinnedNotes.isNotEmpty && index == 0 && pinnedNotes.isNotEmpty) _buildSectionHeader("Pinned"),
//               if (pinnedNotes.contains(note)) _buildNoteCard(note, index),
//               if (!pinnedNotes.contains(note) && pinnedNotes.isNotEmpty && index == pinnedNotes.length)
//                 _buildSectionHeader("Other"),
//               if (!pinnedNotes.contains(note) && index > pinnedNotes.length) _buildNoteCard(note, index),
//             ],
//           );
//         } else {
//           final note = allNotes[index - pinnedNotes.length];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (pinnedNotes.isNotEmpty && index == pinnedNotes.length) _buildSectionHeader("Other"),
//               if (!pinnedNotes.contains(note) && index > pinnedNotes.length) _buildNoteCard(note, index),
//             ],
//           );
//         }
//       },
//     );
//   }
//
//   Widget _buildNoteList() {
//     return Expanded(
//       child: StreamBuilder<List<AddNote>>(
//         stream: _firebaseService.getNotesFromFirestore(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Text("Error: ${snapshot.error}");
//           } else if (snapshot.hasData) {
//             final notes = snapshot.data!;
//
//             // Clear existing lists
//             pinnedNotes.clear();
//             allNotes.clear();
//
//             // Separate pinned and other notes
//             for (AddNote note in notes) {
//               if (noteIsPinned(note)) {
//                 pinnedNotes.add(note);
//               } else {
//                 allNotes.add(note);
//               }
//             }
//
//             return isGridView ? _buildGridView() : _buildListView();
//           }
//           // If there's no data, display a message
//           return _buildEmptyNotesMessage();
//         },
//       ),
//     );
//   }
//
//   bool noteIsPinned(AddNote note) {
//     return pinnedNotes.any((pinnedNote) => pinnedNote.id == note.id);
//   }
//
//
//   Widget _buildNoteCard(AddNote note, int index) {
//     bool isSelected = selectedNoteIndices.contains(index);
//
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: isSelected ? Colors.blue : Colors.grey, // Apply border only if selected
//           ),
//         ),
//         child: ListTile(
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (note.title!.isNotEmpty)
//                 Text(
//                   note.title!,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               if (note.title!.isNotEmpty && note.note!.isNotEmpty)
//                 const SizedBox(height: 4), // Add space between title and note
//               if (note.note!.isNotEmpty)
//                 Text(
//                   note.note!,
//                   style: const TextStyle(fontSize: 14),
//                 ),
//             ],
//           ),
//           onTap: () async {
//             await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => AddNoteScreen(editingNote: note),
//               ),
//             );
//             // Refresh the note list when returning from AddNoteScreen
//             setState(() {});
//           },
//           onLongPress: () {
//             setState(() {
//               if (isSelected) {
//                 selectedNoteIndices.remove(index);
//               } else {
//                 selectedNoteIndices.add(index);
//               }
//             });
//           },
//           trailing: GestureDetector(
//             onTap: () {
//               setState(() {
//                 if (pinnedNotes.contains(note)) {
//                   pinnedNotes.remove(note);
//                 } else {
//                   pinnedNotes.insert(pinnedNotes.length, note);
//                 }
//               });
//             },
//             child: Icon(
//               pinnedNotes.contains(note) ? Icons.push_pin : Icons.push_pin_outlined,
//               color: pinnedNotes.contains(note) ? Colors.blue : null,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAppBar(AddNote note) {
//     int selectedCount = selectedNoteIndices.length;
//
//     return Row(children: [
//       GestureDetector(
//         onTap: () {
//           setState(() {
//             selectedNoteIndices.clear();
//           });
//         },
//         child: const Icon(Icons.cancel_outlined),
//       ),
//       const SizedBox(
//         width: 15,
//       ),
//       Text(
//         "$selectedCount",
//         style: const TextStyle(fontSize: 22),
//       ),
//       const SizedBox(
//         width: 120,
//       ),
//       GestureDetector(
//         onTap: () {
//           _deleteSelectedNotes();
//         },
//         child: const Icon(CupertinoIcons.pin),
//       ),
//       const SizedBox(
//         width: 15,
//       ),
//       const Icon(Icons.notification_add_outlined),
//       const SizedBox(
//         width: 15,
//       ),
//       const Icon(Icons.palette_outlined),
//       const SizedBox(
//         width: 15,
//       ),
//       const Icon(Icons.navigate_next),
//       const SizedBox(
//         width: 15,
//       ),
//       GestureDetector(
//         onTap: () {
//           showMenu(
//             color: Colors.white,
//             context: context,
//             position: const RelativeRect.fromLTRB(10, 0, 0, 0),
//             // Adjust the position as needed
//             items: [
//               const PopupMenuItem(
//                 child: Text('Archive'),
//               ),
//               PopupMenuItem(
//                 child: InkWell(
//                   onTap: () {
//                     // _deleteNote(note);
//                   },
//                   child: const Text('Delete'),
//                 ),
//               ),
//               const PopupMenuItem(
//                 child: Text('Make a copy'),
//               ),
//               const PopupMenuItem(
//                 child: Text('Send'),
//               ),
//               const PopupMenuItem(
//                 child: Text('Copy to Google Docs'),
//               ),
//             ],
//             elevation: 8.0,
//           );
//         },
//         child: const Icon(Icons.menu),
//       )
//     ]);
//   }
//
//   void _deleteSelectedNotes() async {
//     if (selectedNoteIndices.isNotEmpty) {
//       List<AddNote> notesToDelete = [];
//
//       // Retrieve selected notes
//       for (int index in selectedNoteIndices) {
//         if (index < pinnedNotes.length) {
//           notesToDelete.add(pinnedNotes[index]);
//         } else {
//           notesToDelete.add(allNotes[index - pinnedNotes.length]);
//         }
//       }
//
//       // Delete selected notes from Firebase
//
//
//       // Clear selection
//       setState(() {
//         selectedNoteIndices.clear();
//       });
//     }
//   }
//
//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 18,
//           color: Colors.grey,
//         ),
//       ),
//     );
//   }
// }
