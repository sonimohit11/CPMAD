
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

  void fetchNewQuote() {
    setState(() {
      quoteFuture = service.fetchRandomQuote();
    });
  }

  Future<void> shareQuote(Quote quote) async {
    final String author = quote.author.isEmpty
        ? 'Unknown Author'
        : quote.author;

    final String text = '"${quote.content}"\n\n— $author';

    try {
      await SharePlus.instance.share(
        ShareParams(text: text),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to share this quote.'),
        ),
      );
    }
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
        child: FutureBuilder<Quote?>(
          future: quoteFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading quote...'),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 55,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text('Unable to load quote.'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: fetchNewQuote,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final Quote? quote = snapshot.data;

            if (quote == null ||
                quote.content.trim().isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No quote available.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: fetchNewQuote,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.format_quote,
                      size: 75,
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: fetchNewQuote,
                        icon: const Icon(Icons.refresh),
                        label: const Text('New Quote'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
