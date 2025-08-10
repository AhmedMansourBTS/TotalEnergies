import 'package:flutter/material.dart';
import 'package:total_energies/models/news_model.dart';
import 'package:total_energies/screens/Dashboard/news_detail_page.dart';

class NewsSection extends StatelessWidget {
  final Future<List<NewsModel>> newsFuture;
  final double newsHeight;

  const NewsSection({
    super.key,
    required this.newsFuture,
    this.newsHeight = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest News',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: newsHeight,
            child: FutureBuilder<List<NewsModel>>(
              future: newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load news.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No news available.'));
                }

                final newsList = snapshot.data!;

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: newsList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final newsItem = newsList[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NewsDetailPage(news: newsItem),
                          ),
                        );
                      },
                      child: Container(
                        width: 250,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            newsItem.newsTitle,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}