// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cewrrs/core/config/app_constants.dart';
// import 'package:cewrrs/presentation/themes/colors.dart';
// import 'package:cewrrs/presentation/controllers/register_controller.dart';
// class RegisterPage extends GetView<RegisterController> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(child: Image.asset('assets/images/logo.png', height: 80)),
//               const SizedBox(height: 32),
//               Text("Create Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               Text("Sign up with your phone", style: TextStyle(fontSize: 16, color: Colors.grey)),

//               const SizedBox(height: 32),

//               TextField(
//                 controller: controller.phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   hintText: "Phone Number",
//                   prefixIcon: const Icon(Icons.phone),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               TextField(
//                 controller: controller.usernameController,
//                 decoration: InputDecoration(
//                   hintText: "Username",
//                   prefixIcon: const Icon(Icons.person),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               TextField(
//                 controller: controller.passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   prefixIcon: const Icon(Icons.lock),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               TextField(
//                 controller: controller.confirmPasswordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: "Confirm Password",
//                   prefixIcon: const Icon(Icons.lock_outline),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               Obx(() => controller.isLoading.value
//                   ? const Center(child: CircularProgressIndicator())
//                   : SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: controller.register,
//                         child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
//                       ),
//                     )),
//               const SizedBox(height: 24),

//               Center(
//                 child: GestureDetector(
//                   onTap: () => Get.toNamed("/login"),
//                   child: RichText(
//                     text: TextSpan(
//                       text: "Already have an account? ",
//                       style: const TextStyle(color: Colors.grey),
//                       children: const [
//                         TextSpan(text: "Login", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
