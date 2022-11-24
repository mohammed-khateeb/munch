// import 'package:flutter/material.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:photo_view/photo_view.dart';

// class SimplePhotoViewPage extends StatelessWidget {
//   final String imagePath;

//   // ignore: use_key_in_widget_constructors
//   const SimplePhotoViewPage(this.imagePath);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(''),
//         backgroundColor: Colors.black,
//       ),
//       body: PhotoView(
//         imageProvider: NetworkImage(
//           imagePath,
//         ),
//         // Contained = the smallest possible size to fit one dimension of the screen
//         minScale: PhotoViewComputedScale.contained * 0.8,
//         // Covered = the smallest possible size to fit the whole screen
//         maxScale: PhotoViewComputedScale.covered * 2,
//         enableRotation: true,
//         // Set the background color to the "classic white"
//         // backgroundDecoration: BoxDecoration(
//         //   color: Theme.of(context).canvasColor,
//         // ),
//         loadingChild: Center(
//           child: Image.asset(
//             "lib/assets/images/MunchLoadingTransparent.gif",
//             height: 100.0,
//             width: 100.0,
//           ),
//         ),
//       ),
//     );
//   }
// }
