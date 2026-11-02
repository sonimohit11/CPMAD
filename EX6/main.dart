// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Animated Product App',
// //       home: const ProductPage(),
// //     );
// //   }
// // }

// // class Product {
// //   String name;
// //   String price;
// //   String image;

// //   Product({
// //     required this.name,
// //     required this.price,
// //     required this.image,
// //   });
// // }

// // class ProductPage extends StatefulWidget {
// //   const ProductPage({super.key});

// //   @override
// //   State<ProductPage> createState() => _ProductPageState();
// // }

// // class _ProductPageState extends State<ProductPage> {

// //   List<Product> products = [
// //     Product(
// //       name: 'Shoes',
// //       price: '1500',
// //       image: 'https://picsum.photos/200?1',
// //     ),
// //     Product(
// //       name: 'Watch',
// //       price: '2500',
// //       image: 'https://picsum.photos/200?2',
// //     ),
// //     Product(
// //       name: 'Bag',
// //       price: '1200',
// //       image: 'https://picsum.photos/200?3',
// //     ),
// //     Product(
// //       name: 'Headphones',
// //       price: '2000',
// //       image: 'https://picsum.photos/200?4',
// //     ),
// //   ];

// //   int selectedIndex = -1;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Product Catalogue'),
// //       ),

// //       body: ListView.builder(
// //         itemCount: products.length,

// //         itemBuilder: (context, index) {

// //           Product product = products[index];

// //           return GestureDetector(
// //             onTap: () {

// //               Navigator.push(
// //                 context,
// //                 PageRouteBuilder(
// //                   pageBuilder:
// //                       (context, animation, secondaryAnimation) {
// //                     return ProductDetails(product: product);
// //                   },

// //                   transitionsBuilder:
// //                       (context, animation, secondaryAnimation, child) {

// //                     return FadeTransition(
// //                       opacity: animation,
// //                       child: child,
// //                     );
// //                   },
// //                 ),
// //               );
// //             },

// //             child: AnimatedContainer(
// //               duration: const Duration(milliseconds: 500),
// //               curve: Curves.easeInOut,

// //               margin: const EdgeInsets.all(10),

// //               padding: const EdgeInsets.all(10),

// //               decoration: BoxDecoration(
// //                 color: selectedIndex == index
// //                     ? Colors.blue.shade100
// //                     : Colors.white,

// //                 borderRadius: BorderRadius.circular(
// //                   selectedIndex == index ? 30 : 10,
// //                 ),

// //                 boxShadow: const [
// //                   BoxShadow(
// //                     blurRadius: 5,
// //                     color: Colors.grey,
// //                   ),
// //                 ],
// //               ),

// //               child: Row(
// //                 children: [

// //                   // Hero Animation
// //                   Hero(
// //                     tag: product.name,

// //                     child: Image.network(
// //                       product.image,
// //                       width: 100,
// //                       height: 100,
// //                     ),
// //                   ),

// //                   const SizedBox(width: 15),

// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment:
// //                           CrossAxisAlignment.start,

// //                       children: [

// //                         Text(
// //                           product.name,
// //                           style: const TextStyle(
// //                             fontSize: 20,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),

// //                         const SizedBox(height: 5),

// //                         Text(
// //                           '₹${product.price}',
// //                           style: const TextStyle(
// //                             fontSize: 18,
// //                           ),
// //                         ),

// //                         const SizedBox(height: 5),

// //                         ElevatedButton(
// //                           onPressed: () {

// //                             setState(() {
// //                               selectedIndex = index;
// //                             });

// //                           },
// //                           child: const Text('Select'),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }


// // // --------------------------------------------------
// // // PRODUCT DETAILS PAGE
// // // --------------------------------------------------

// // class ProductDetails extends StatefulWidget {

// //   final Product product;

// //   const ProductDetails({
// //     super.key,
// //     required this.product,
// //   });

// //   @override
// //   State<ProductDetails> createState() =>
// //       _ProductDetailsState();
// // }

// // class _ProductDetailsState
// //     extends State<ProductDetails>
// //     with SingleTickerProviderStateMixin {

// //   bool favorite = false;

// //   late AnimationController controller;

// //   late Animation<double> animation;

// //   @override
// //   void initState() {
// //     super.initState();

// //     // AnimationController
// //     controller = AnimationController(
// //       duration: const Duration(seconds: 1),
// //       vsync: this,
// //     );

// //     // Tween
// //     animation = Tween<double>(
// //       begin: 0,
// //       end: 1,
// //     ).animate(
// //       CurvedAnimation(
// //         parent: controller,
// //         curve: Curves.elasticOut,
// //       ),
// //     );

// //     controller.forward();
// //   }

// //   @override
// //   void dispose() {
// //     controller.dispose();
// //     super.dispose();
// //   }

// //   void favoriteButton() {

// //     setState(() {
// //       favorite = !favorite;
// //     });

// //     if (favorite) {
// //       controller.forward(from: 0);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {

// //     return Scaffold(

// //       appBar: AppBar(
// //         title: Text(widget.product.name),
// //       ),

// //       body: Center(

// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,

// //           children: [

// //             // Hero Animation
// //             Hero(
// //               tag: widget.product.name,

// //               child: Image.network(
// //                 widget.product.image,
// //                 width: 250,
// //                 height: 250,
// //               ),
// //             ),

// //             const SizedBox(height: 20),

// //             Text(
// //               widget.product.name,
// //               style: const TextStyle(
// //                 fontSize: 30,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),

// //             const SizedBox(height: 10),

// //             Text(
// //               '₹${widget.product.price}',
// //               style: const TextStyle(
// //                 fontSize: 25,
// //               ),
// //             ),

// //             const SizedBox(height: 30),

// //             // AnimationController + Tween
// //             ScaleTransition(
// //               scale: animation,

// //               child: IconButton(
// //                 onPressed: favoriteButton,

// //                 icon: Icon(
// //                   favorite
// //                       ? Icons.favorite
// //                       : Icons.favorite_border,

// //                   color: favorite
// //                       ? Colors.red
// //                       : Colors.grey,

// //                   size: 50,
// //                 ),
// //               ),
// //             ),

// //             const Text(
// //               'Favorite',
// //               style: TextStyle(fontSize: 18),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const CounterPage(),
//     );
//   }
// }

// class CounterPage extends StatefulWidget {
//   const CounterPage({super.key});

//   @override
//   State<CounterPage> createState() => _CounterPageState();
// }

// class _CounterPageState extends State<CounterPage>
//     with SingleTickerProviderStateMixin {

//   int count = 0;

//   late AnimationController controller;
//   late Animation<double> animation;

//   @override
//   void initState() {
//     super.initState();

//     controller = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );

//     animation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: Curves.bounceOut,
//       ),
//     );
//   }

//   void increaseCounter() {
//     setState(() {
//       count++;
//     });

//     controller.forward(from: 0);
//   }

//   void decreaseCounter() {
//     setState(() {
//       count--;
//     });

//     controller.forward(from: 0);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Animated Counter'),
//       ),

//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,

//           children: [

//             ScaleTransition(
//               scale: animation,

//               child: Text(
//                 '$count',
//                 style: const TextStyle(
//                   fontSize: 80,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,

//               children: [

//                 ElevatedButton(
//                   onPressed: decreaseCounter,
//                   child: const Text('-'),
//                 ),

//                 const SizedBox(width: 20),

//                 ElevatedButton(
//                   onPressed: increaseCounter,
//                   child: const Text('+'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoadingPage(),
    );
  }
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Tween
    animation = Tween<double>(
      begin: 0,
      end: 6.28,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );

    // Repeat animation
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Loading'),
      ),

      body: Center(

        child: AnimatedBuilder(
          animation: animation,

          builder: (context, child) {

            return Transform.rotate(
              angle: animation.value,

              child: Container(
                width: 60,
                height: 60,

                decoration: BoxDecoration(
                  border: Border.all(
                    width: 6,
                    color: Colors.blue,
                  ),

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.refresh,
                  size: 35,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}