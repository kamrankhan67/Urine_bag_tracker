import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
   AddButton({super.key, required this.fn});
  final VoidCallback? fn;
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fn,
      child: Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(84, 119, 146, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child:  Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// class AddButton extends StatelessWidget {
//   AddButton({super.key, required this.fn, this.isLoading});
//   final VoidCallback? fn;
//   final bool? isLoading=false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isLoading! ? null : fn, // Disable tap when loading
//       child: Container(
//         width: double.infinity,
//         height: 50,
//         margin: const EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//           color: const Color.fromRGBO(84, 119, 146, 1),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Center(
//           child: isLoading!
//               ? SizedBox(
//                   height: 24,
//                   width: 24,
//                   child: CircularProgressIndicator(
//                     color: Colors.white, // Color of the progress indicator
//                     strokeWidth: 3,
//                   ),
//                 )
//               : Text(
//                   "Add",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }

