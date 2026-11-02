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
//       title: 'News Dashboard',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const NewsDashboard(),
//     );
//   }
// }

// class NewsDashboard extends StatefulWidget {
//   const NewsDashboard({super.key});

//   @override
//   State<NewsDashboard> createState() => _NewsDashboardState();
// }

// class _NewsDashboardState extends State<NewsDashboard> {
//   List<String> news = [
//     'New Technology Trends in 2026',
//     'India Announces New Space Mission',
//     'AI is Changing the Future',
//     'Latest Updates in Science',
//     'New Smartphones Released',
//     'Global Business News',
//   ];

//   List<String> categories = [
//     'Technology',
//     'Sports',
//     'Business',
//     'Science',
//     'Entertainment',
//     'Politics',
//   ];

//   Future<void> refreshNews() async {
//     await Future.delayed(const Duration(seconds: 2));

//     setState(() {
//       news.shuffle();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RefreshIndicator(
//         onRefresh: refreshNews,
//         child: CustomScrollView(
//           slivers: [

//             // -------------------------------
//             // COLLAPSING HEADER
//             // -------------------------------
//             SliverAppBar(
//               expandedHeight: 180,
//               pinned: true,
//               backgroundColor: Colors.blue,
//               flexibleSpace: FlexibleSpaceBar(
//                 title: const Text('News Dashboard'),
//                 background: Container(
//                   color: Colors.blue,
//                   child: const Center(
//                     child: Icon(
//                       Icons.newspaper,
//                       size: 80,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // -------------------------------
//             // FEATURED ARTICLE
//             // -------------------------------
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Stack(
//                   children: [

//                     Container(
//                       height: 200,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         image: const DecorationImage(
//                           image: NetworkImage(
//                             'https://picsum.photos/600/300',
//                           ),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),

//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         padding: const EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                           color: Colors.black54,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: const Text(
//                           'Featured News: Latest Technology Updates',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // -------------------------------
//             // CATEGORY TITLE
//             // -------------------------------
//             const SliverToBoxAdapter(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Text(
//                   'Categories',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),

//             // -------------------------------
//             // CATEGORY GRID
//             // -------------------------------
//             SliverGrid(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   return Card(
//                     margin: const EdgeInsets.all(8),
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.category,
//                             size: 35,
//                             color: Colors.blue,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             categories[index],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 childCount: categories.length,
//               ),
//               gridDelegate:
//                   const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 1.5,
//               ),
//             ),

//             // -------------------------------
//             // NEWS TITLE
//             // -------------------------------
//             const SliverToBoxAdapter(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Text(
//                   'Latest News',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),

//             // -------------------------------
//             // NEWS LIST
//             // -------------------------------
//             SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   return Card(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 5,
//                     ),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.blue,
//                         child: Text(
//                           '${index + 1}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       title: Text(
//                         news[index],
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       subtitle: const Text(
//                         'Read the latest news and updates',
//                       ),
//                       trailing: const Icon(
//                         Icons.arrow_forward_ios,
//                         size: 18,
//                       ),
//                     ),
//                   );
//                 },
//                 childCount: news.length,
//               ),
//             ),

//             // Bottom space
//             const SliverToBoxAdapter(
//               child: SizedBox(height: 30),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
//       home: const VideoPage(),
//     );
//   }
// }

// class VideoPage extends StatelessWidget {
//   const VideoPage({super.key});

//   final List<String> categories = const [
//     'All',
//     'Music',
//     'Sports',
//     'News',
//     'Gaming',
//   ];

//   final List<String> videos = const [
//     'Amazing Travel Video',
//     'Latest Technology News',
//     'Top Football Highlights',
//     'New Gaming Video',
//     'Music Concert 2026',
//     'Interesting Science Video',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Feed'),
//       ),

//       body: Column(
//         children: [

//           // Categories
//           SizedBox(
//             height: 60,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   margin: const EdgeInsets.all(8),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 15,
//                       vertical: 10,
//                     ),
//                     child: Center(
//                       child: Text(
//                         categories[index],
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Featured Video
//           Container(
//             margin: const EdgeInsets.all(10),
//             height: 180,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.play_circle,
//                     size: 70,
//                     color: Colors.white,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Featured Video',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Video List
//           Expanded(
//             child: ListView.builder(
//               itemCount: videos.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 5,
//                   ),
//                   child: ListTile(
//                     leading: Container(
//                       width: 80,
//                       height: 50,
//                       color: Colors.grey,
//                       child: const Icon(
//                         Icons.play_arrow,
//                         color: Colors.white,
//                       ),
//                     ),
//                     title: Text(
//                       videos[index],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: const Text('10K views'),
//                     trailing: const Icon(Icons.more_vert),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
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
      home: const RecipePage(),
    );
  }
}

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  final List<String> categories = const [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
  ];

  final List<String> recipes = const [
    'Pizza',
    'Pasta',
    'Burger',
    'Biryani',
    'Pancakes',
    'Chocolate Cake',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe App'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Categories
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Featured Recipe
          Container(
            margin: const EdgeInsets.all(12),
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant,
                    size: 60,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Featured Recipe: Special Pizza',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Recipe List
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Recipes',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.restaurant),
                    ),
                    title: Text(
                      recipes[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Easy and delicious recipe',
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
