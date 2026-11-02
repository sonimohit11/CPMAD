
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'quote.dart';

// class QuoteService {
//   static const String apiUrl =
//       'https://quoteslate.vercel.app/api/quotes/random';

//   Future<Quote?> fetchRandomQuote() async {
//     final response = await http
//         .get(Uri.parse(apiUrl))
//         .timeout(const Duration(seconds: 15));

//     if (response.statusCode != 200) {
//       throw Exception('Server error: ${response.statusCode}');
//     }

//     final dynamic data = jsonDecode(response.body);

//     // API may return a single quote object or a list.
//     dynamic item = data;

//     if (data is List) {
//       if (data.isEmpty) return null;
//       item = data.first;
//     }

//     if (item is! Map) {
//       throw const FormatException('Invalid quote response');
//     }

//     // QuoteSlate uses "quote"; other APIs may use "content".
//     final text = (item['quote'] ?? item['content'] ?? '').toString();
//     final author = (item['author'] ?? 'Unknown').toString();

//     if (text.trim().isEmpty) return null;

//     return Quote(
//       content: text.trim(),
//       author: author.trim().isEmpty ? 'Unknown' : author.trim(),
//     );
//   }
// }


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'quote.dart';

// class QuoteService {
//   static const String baseUrl =
//       'https://quoteslate.vercel.app/api/quotes/random';

//   Future<Quote?> fetchRandomQuote({String category = 'all'}) async {
//     final uri = Uri.parse(baseUrl).replace(
//       queryParameters: category == 'all'
//           ? null
//           : {'tags': category},
//     );

//     final response = await http
//         .get(uri)
//         .timeout(const Duration(seconds: 15));

//     if (response.statusCode != 200) {
//       throw Exception('Server error: ${response.statusCode}');
//     }

//     final dynamic data = jsonDecode(response.body);

//     dynamic item = data;
//     if (data is List) {
//       if (data.isEmpty) return null;
//       item = data.first;
//     }

//     if (item is! Map) {
//       throw const FormatException('Invalid quote data.');
//     }

//     final content =
//         (item['quote'] ?? item['content'] ?? '').toString().trim();
//     final author = (item['author'] ?? 'Unknown').toString().trim();

//     if (content.isEmpty) return null;

//     return Quote(
//       content: content,
//       author: author.isEmpty ? 'Unknown' : author,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'quote.dart';
import 'quote_service.dart';

class ShareQuoteScreen extends StatefulWidget {
  const ShareQuoteScreen({super.key});

  @override
  State<ShareQuoteScreen> createState() =>
      _ShareQuoteScreenState();
}

class _ShareQuoteScreenState extends State<ShareQuoteScreen> {
  final QuoteService service = QuoteService();

  late Future<Quote?> quoteFuture;

  @override
  void initState() {
    super.initState();
    quoteFuture = service.fetchRandomQuote();
  }

  void fetchQuote() {
    setState(() {
      quoteFuture = service.fetchRandomQuote();
    });
  }

  Future<void> shareQuote(Quote quote) async {
    final text =
        '"${quote.content}"\n— ${quote.author.isEmpty ? 'Unknown Author' : quote.author}';

    await SharePlus.instance.share(
      ShareParams(text: text),
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
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading quote...'),
                  ],
                );
              }

              if (snapshot.hasError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text('Unable to load quote.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: fetchQuote,
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
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: fetchQuote,
                      child: const Text('Try Again'),
                    ),
                  ],
                );
              }

              return SingleChildScrollView(
                child: Column(
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
                        onPressed: fetchQuote,
                        icon: const Icon(Icons.refresh),
                        label: const Text('New Quote'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
