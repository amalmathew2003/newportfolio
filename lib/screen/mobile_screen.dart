// import 'package:flutter/material.dart';

// class MobileScreen extends StatelessWidget {
//   const MobileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               height: size.height * 0.5,
//               decoration: BoxDecoration(
//                 color: Colors.amber,
//                 image: DecorationImage(
//                   image: AssetImage("assests/images/landingpage.jpg"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Stack(),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//               child: Column(
//                 children: [
//                   Text(
//                     'Amal Mathew',
//                     style: const TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Flutter Developer | UI/UX Enthusiast | Tech Blogger',
//                     style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 30,
//                         vertical: 15,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: const Text(
//                       'View My Work',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
