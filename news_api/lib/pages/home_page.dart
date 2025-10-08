import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'stories_page.dart';
import '../providers/providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  final List<StoryType> _storyTypes = [
    StoryType.top,
    StoryType.newStories,
    StoryType.best,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_storyTypes[_currentIndex].displayName),
        backgroundColor: Colors.teal[300],
        foregroundColor: Colors.grey[900],
      ),
      body: StoriesPage(storyType: _storyTypes[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Top News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: 'New News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Best News',
          ),
        ],
      ),
    );
  }
}