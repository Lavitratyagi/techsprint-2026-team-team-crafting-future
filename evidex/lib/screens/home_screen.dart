import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double dragX = 0;
  bool isCardView = true;
  bool loading = true;

  String selectedCategory = "all";
  List<NewsModel> newsList = [];

  @override
  void initState() {
    super.initState();
    _loadNews(selectedCategory);
  }

  Future<void> _loadNews(String category) async {
    setState(() {
      loading = true;
      selectedCategory = category;
    });

    try {
      final data = await NewsApiService.fetchNews(category);
      setState(() {
        newsList = data;
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => loading = false);
  }

  void _onSwipeEnd() {
    if (dragX < -120 && newsList.length > 1) {
      setState(() {
        final removed = newsList.removeAt(0);
        newsList.add(removed);
      });
    }
    dragX = 0;
  }

  @override
  Widget build(BuildContext context) {
    final swipeProgress = (dragX.abs() / 220).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _searchBar(),
            _categoryTabs(),
            _viewToggle(),
            const SizedBox(height: 10),

            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : newsList.isEmpty
                      ? const Center(child: Text("No news available"))
                      : isCardView
                          ? _cardStackView(swipeProgress)
                          : _listView(),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CATEGORY TABS =================

  Widget _categoryTabs() {
    final categories = [
      "trending",
      "policies",
      "healthcare",
      "finance",
      "education",
      "all",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((cat) {
            final bool active = selectedCategory == cat;
            return GestureDetector(
              onTap: () => _loadNews(cat),
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontWeight:
                        active ? FontWeight.bold : FontWeight.normal,
                    color:
                        active ? const Color(0xFF1765BE) : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ================= VIEW TOGGLE =================

  Widget _viewToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 36,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _iconToggle(
                  selected: isCardView,
                  icon: Icons.view_agenda,
                  label: "Card",
                  onTap: () => setState(() => isCardView = true),
                ),
                _iconToggle(
                  selected: !isCardView,
                  icon: Icons.list,
                  label: "List",
                  onTap: () => setState(() => isCardView = false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconToggle({
    required bool selected,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding:
            EdgeInsets.symmetric(horizontal: selected ? 12 : 8),
        height: 28,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1765BE) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 16,
                color: selected ? Colors.white : Colors.black54),
            if (selected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================= CARD STACK VIEW =================

  Widget _cardStackView(double swipeProgress) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(min(3, newsList.length), (index) {
        final isTop = index == 0;

        final offsetX = index == 1
            ? lerpDouble(18.0, 0.0, swipeProgress)!
            : index == 2
                ? lerpDouble(36.0, 18.0, swipeProgress)!
                : 0.0;

        final scale = index == 1
            ? lerpDouble(0.95, 1.0, swipeProgress)!
            : index == 2
                ? lerpDouble(0.9, 0.95, swipeProgress)!
                : 1.0;

        return Positioned(
          child: isTop
              ? _draggableCard(newsList[index])
              : Transform.translate(
                  offset: Offset(offsetX, index * 6.0),
                  child: Transform.scale(
                    scale: scale,
                    child: _newsCard(newsList[index]),
                  ),
                ),
        );
      }).reversed.toList(),
    );
  }

  Widget _draggableCard(NewsModel news) {
    return GestureDetector(
      onPanUpdate: (d) => setState(() => dragX += d.delta.dx),
      onPanEnd: (_) => _onSwipeEnd(),
      child: Transform.translate(
        offset: Offset(dragX, 0),
        child: Transform.rotate(
          angle: dragX * pi / 2600,
          child: _newsCard(news),
        ),
      ),
    );
  }

  // ================= LIST VIEW =================

  Widget _listView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        final news = newsList[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              news.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        news.imageUrl,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(news.title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text("Published by ${news.author}",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= UI =================

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          Text(
            "Evidex",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1765BE),
            ),
          ),
          Spacer(),
          CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 8),
            Text("Search for any news",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _newsCard(NewsModel news) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.86,
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2DE8A),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(news.title,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(news.description),
        ],
      ),
    );
  }
}
