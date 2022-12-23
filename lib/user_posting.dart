// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:vailwallet/going_life.dart';
//
// class UserPosting extends StatefulWidget {
//   const UserPosting({Key? key}) : super(key: key);
//
//   @override
//   State<UserPosting> createState() => _UserPostingState();
// }
//
// class _UserPostingState extends State<UserPosting> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Expanded(
//         child: GoingLive(index: 1,),
//       ),
//       bottomSheet:  Padding(
//         padding: const EdgeInsets.only(bottom: 20.0),
//         child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Visibility(
//                 // visible: !_isRecording,
//                   child: MomentMicBtn(
//                     svgUrl: 'assets/svgs/mic-solid.svg',
//                     onClick: () async {
//                       // join();
//                     },
//                   )
//               ),
//               SizedBox(width: 30),
//               InkWell(
//                 onTap: () async {
//                   setState(() {
//                   });
//                 },
//                 child: Container(
//                   height: 80,
//                   width: 80,
//                   padding: const EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(70),
//                     color: Colors.red,
//                   ),
//                   child: Container(
//                     height: 70,
//                     width: 70,
//                     padding: const EdgeInsets.all(22),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(70),
//                     ),
//                     child: SvgPicture.asset(
//                         'assets/svgs/fluent_live-24-regular.svg',
//                         fit: BoxFit.contain,
//                         color: Colors.black
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 30),
//               Visibility(
//                 // visible: _isRecording,
//                 child: MomentCameraBtn(
//                   svgUrl: 'assets/svgs/flip-camera.svg',
//                   onClick: () async {
//
//                   },
//                 ),
//               ),
//             ]),
//       ),
//     );
//   }
//
// }
