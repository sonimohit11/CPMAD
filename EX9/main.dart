
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:share_plus/share_plus.dart';

// import 'quote.dart';
// import 'quote_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const QuoteApp());
// }

// class QuoteApp extends StatelessWidget {
//   const QuoteApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Daily Quote',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple,
//         ),
//         useMaterial3: true,
//       ),
//       home: const QuoteHomePage(),
//     );
//   }
// }

// class QuoteHomePage extends StatefulWidget {
//   const QuoteHomePage({super.key});

//   @override
//   State<QuoteHomePage> createState() => _QuoteHomePageState();
// }

// class _QuoteHomePageState extends State<QuoteHomePage> {
//   final QuoteService service = QuoteService();

//   late Future<Quote?> quoteFuture;

//   List<Quote> favorites = [];

//   String selectedCategory = 'all';

//   @override
//   void initState() {
//     super.initState();

//     quoteFuture = service.fetchRandomQuote(
//       category: selectedCategory,
//     );

//     loadFavorites();
//   }

//   void fetchAnotherQuote() {
//     setState(() {
//       quoteFuture = service.fetchRandomQuote(
//         category: selectedCategory,
//       );
//     });
//   }

//   Future<void> loadFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     final saved = prefs.getStringList('favoriteQuotes') ?? [];

//     final loaded = <Quote>[];

//     for (final item in saved) {
//       try {
//         final decoded = jsonDecode(item);

//         if (decoded is Map<String, dynamic>) {
//           final quote = Quote.fromJson(decoded);

//           if (quote.content.isNotEmpty) {
//             loaded.add(quote);
//           }
//         }
//       } catch (_) {
//         // Ignore invalid saved data.
//       }
//     }

//     if (!mounted) return;

//     setState(() {
//       favorites = loaded;
//     });
//   }

//   Future<void> saveFavorites() async {
//     final prefs = await SharedPreferences.getInstance();

//     await prefs.setStringList(
//       'favoriteQuotes',
//       favorites
//           .map((quote) => jsonEncode(quote.toJson()))
//           .toList(),
//     );
//   }

//   bool isFavorite(Quote quote) {
//     return favorites.any(
//       (item) =>
//           item.content == quote.content &&
//           item.author == quote.author,
//     );
//   }

//   Future<void> toggleFavorite(Quote quote) async {
//     final alreadyFavorite = isFavorite(quote);

//     setState(() {
//       if (alreadyFavorite) {
//         favorites.removeWhere(
//           (item) =>
//               item.content == quote.content &&
//               item.author == quote.author,
//         );
//       } else {
//         favorites.add(quote);
//       }
//     });

//     await saveFavorites();

//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           alreadyFavorite
//               ? 'Removed from favorites'
//               : 'Added to favorites',
//         ),
//       ),
//     );
//   }

//   Future<void> shareQuote(Quote quote) async {
//     await SharePlus.instance.share(
//       ShareParams(text: quote.shareText),
//     );
//   }

//   Future<void> openFavorites() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => FavoriteQuotesScreen(
//           favorites: List<Quote>.of(favorites),
//           onRemove: toggleFavorite,
//         ),
//       ),
//     );

//     if (mounted) {
//       await loadFavorites();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Daily Quote'),
//         actions: [
//           IconButton(
//             tooltip: 'Favorite Quotes',
//             icon: const Icon(Icons.favorite),
//             onPressed: openFavorites,
//           ),
//         ],
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           children: [
//             // Category selector
//             DropdownButtonFormField<String>(
//               value: selectedCategory,
//               isExpanded: true,
//               decoration: const InputDecoration(
//                 labelText: 'Select Quote Category',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.category),
//               ),
//               items: const [
//                 DropdownMenuItem(
//                   value: 'all',
//                   child: Text('All Quotes'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'motivation',
//                   child: Text('Motivation'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'life',
//                   child: Text('Life'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'wisdom',
//                   child: Text('Wisdom'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'inspiration',
//                   child: Text('Inspiration'),
//                 ),
//               ],
//               onChanged: (value) {
//                 if (value == null) return;

//                 setState(() {
//                   selectedCategory = value;

//                   quoteFuture = service.fetchRandomQuote(
//                     category: selectedCategory,
//                   );
//                 });
//               },
//             ),

//             const SizedBox(height: 20),

//             // Quote display
//             Expanded(
//               child: FutureBuilder<Quote?>(
//                 future: quoteFuture,

//                 builder: (context, snapshot) {
//                   // Loading state
//                   if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return const Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           CircularProgressIndicator(),
//                           SizedBox(height: 16),
//                           Text('Loading quote...'),
//                         ],
//                       ),
//                     );
//                   }

//                   // Error state
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(
//                             Icons.wifi_off,
//                             size: 60,
//                             color: Colors.redAccent,
//                           ),
//                           const SizedBox(height: 12),
//                           const Text(
//                             'Unable to load quote.',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           const SizedBox(height: 8),
//                           const Text(
//                             'Check your connection and try again.',
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 16),
//                           ElevatedButton.icon(
//                             onPressed: fetchAnotherQuote,
//                             icon: const Icon(Icons.refresh),
//                             label: const Text('Retry'),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   final quote = snapshot.data;

//                   // Empty state
//                   if (quote == null ||
//                       quote.content.trim().isEmpty) {
//                     return Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(
//                             Icons.format_quote,
//                             size: 60,
//                           ),
//                           const SizedBox(height: 12),
//                           const Text('No quote available.'),
//                           const SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: fetchAnotherQuote,
//                             child: const Text('Try Again'),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   final favorite = isFavorite(quote);

//                   // Success state
//                   return SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 20),

//                         const Icon(
//                           Icons.format_quote,
//                           size: 70,
//                           color: Colors.deepPurple,
//                         ),

//                         const SizedBox(height: 20),

//                         Card(
//                           elevation: 4,
//                           child: Padding(
//                             padding: const EdgeInsets.all(24),
//                             child: Column(
//                               children: [
//                                 Text(
//                                   '"${quote.content}"',
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                     fontSize: 22,
//                                     fontStyle: FontStyle.italic,
//                                   ),
//                                 ),

//                                 const SizedBox(height: 20),

//                                 Text(
//                                   '— ${quote.author.isEmpty ? 'Unknown Author' : quote.author}',
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         Text(
//                           'Category: ${selectedCategory == 'all' ? 'All Quotes' : selectedCategory[0].toUpperCase() + selectedCategory.substring(1)}',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyMedium,
//                         ),

//                         const SizedBox(height: 16),

//                         Wrap(
//                           alignment: WrapAlignment.center,
//                           spacing: 12,
//                           children: [
//                             IconButton.filledTonal(
//                               tooltip: favorite
//                                   ? 'Remove Favorite'
//                                   : 'Add Favorite',
//                               onPressed: () =>
//                                   toggleFavorite(quote),
//                               icon: Icon(
//                                 favorite
//                                     ? Icons.favorite
//                                     : Icons.favorite_border,
//                                 color: favorite ? Colors.red : null,
//                               ),
//                             ),

//                             IconButton.filledTonal(
//                               tooltip: 'Share Quote',
//                               onPressed: () => shareQuote(quote),
//                               icon: const Icon(Icons.share),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 16),

//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             onPressed: fetchAnotherQuote,
//                             icon: const Icon(Icons.refresh),
//                             label: const Text('New Quote'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Favorite quotes screen
// class FavoriteQuotesScreen extends StatefulWidget {
//   final List<Quote> favorites;
//   final Future<void> Function(Quote) onRemove;

//   const FavoriteQuotesScreen({
//     super.key,
//     required this.favorites,
//     required this.onRemove,
//   });

//   @override
//   State<FavoriteQuotesScreen> createState() =>
//       _FavoriteQuotesScreenState();
// }

// class _FavoriteQuotesScreenState
//     extends State<FavoriteQuotesScreen> {
//   late List<Quote> localFavorites;

//   @override
//   void initState() {
//     super.initState();
//     localFavorites = List<Quote>.of(widget.favorites);
//   }

//   Future<void> removeFavorite(Quote quote) async {
//     await widget.onRemove(quote);

//     if (!mounted) return;

//     setState(() {
//       localFavorites.removeWhere(
//         (item) =>
//             item.content == quote.content &&
//             item.author == quote.author,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Favorite Quotes'),
//       ),

//       body: localFavorites.isEmpty
//           ? const Center(
//               child: Text(
//                 'No favorite quotes yet.',
//                 style: TextStyle(fontSize: 18),
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: localFavorites.length,

//               itemBuilder: (context, index) {
//                 final quote = localFavorites[index];

//                 return Card(
//                   child: ListTile(
//                     leading: const Icon(
//                       Icons.format_quote,
//                       color: Colors.deepPurple,
//                     ),

//                     title: Text(quote.content),

//                     subtitle: Text('— ${quote.author}'),

//                     trailing: IconButton(
//                       tooltip: 'Remove Favorite',
//                       icon: const Icon(
//                         Icons.delete_outline,
//                         color: Colors.red,
//                       ),
//                       onPressed: () => removeFavorite(quote),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'share_quote_screen.dart';
import 'quote.dart';
import 'quote_service.dart';
import 'share_quote_screen.dart';

class ShareQuoteScreen extends StatefulWidget {
  const ShareQuoteScreen({super.key});

  @override
  State<ShareQuoteScreen> createState() => _ShareQuoteScreenState();
}

class _ShareQuoteScreenState extends State<ShareQuoteScreen> {
  final QuoteService service = QuoteService();

  late Future<Quote?> quoteFuture;

  @override
  void initState() {
    super.initState();
    quoteFuture = service.fetchRandomQuote();
  }

  void getNewQuote() {
    setState(() {
      quoteFuture = service.fetchRandomQuote();
    });
  }

  Future<void> shareQuote(Quote quote) async {
    await SharePlus.instance.share(
      ShareParams(text: quote.shareText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share a Quote'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: FutureBuilder<Quote?>(
            future: quoteFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 50),
                    const SizedBox(height: 12),
                    const Text('Unable to load quote.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: getNewQuote,
                      child: const Text('Retry'),
                    ),
                  ],
                );
              }

              final quote = snapshot.data;

              if (quote == null || quote.content.isEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No quote available.'),
                    ElevatedButton(
                      onPressed: getNewQuote,
                      child: const Text('Try Again'),
                    ),
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.format_quote,
                    size: 70,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            '"${quote.content}"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '— ${quote.author.isEmpty ? 'Unknown Author' : quote.author}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => shareQuote(quote),
                      icon: const Icon(Icons.share),
                      label: const Text('Share Quote'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: getNewQuote,
                      icon: const Icon(Icons.refresh),
                      label: const Text('New Quote'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
