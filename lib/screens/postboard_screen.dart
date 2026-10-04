import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'classboard_screen.dart';
import 'profile_screen.dart';
import 'join_class_modal.dart';
import 'create_class_modal.dart';
import '../widgets/class_card.dart';

class PostboardScreen extends StatefulWidget {
  const PostboardScreen({super.key});

  @override
  State<PostboardScreen> createState() => _PostboardScreenState();
}

class _PostboardScreenState extends State<PostboardScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _joinedClasses = [];
  bool _isLoadingClasses = true;
  List<Map<String, dynamic>> _postboardItems = [];
  bool _isLoadingPostboard = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    await _loadClasses();
    await _loadPostboard();
  }

  Future<void> _loadClasses() async {
    try {
      final response = await Supabase.instance.client
          .from('classes')
          .select()
          .order('created_at');

      if (!mounted) return;

      setState(() {
        _joinedClasses = List<Map<String, dynamic>>.from(response);

        _isLoadingClasses = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoadingClasses = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not load classes: $error')));
    }
  }

  Future<void> _loadPostboard() async {
    try {
      // Because of RLS, this only returns classes
      // the logged-in user has joined.
      final classesResponse = await Supabase.instance.client
          .from('classes')
          .select()
          .order('created_at');

      final joinedClasses = List<Map<String, dynamic>>.from(classesResponse);

      if (joinedClasses.isEmpty) {
        if (!mounted) return;

        setState(() {
          _postboardItems = [];
          _isLoadingPostboard = false;
        });

        return;
      }

      final classIds = joinedClasses
          .map((classData) => classData['id'])
          .toList();

      // Get all posts belonging to the user's classes,
      // newest post first.
      final postsResponse = await Supabase.instance.client
          .from('posts')
          .select('id, class_id, content, created_at, author_id')
          .inFilter('class_id', classIds)
          .order('created_at', ascending: false);

      final posts = List<Map<String, dynamic>>.from(postsResponse);

      // Since posts are newest first, the first post found
      // for each class is that class's latest post.
      final Map<String, Map<String, dynamic>> latestPosts = {};

      for (final post in posts) {
        final classId = post['class_id'].toString();

        if (!latestPosts.containsKey(classId)) {
          latestPosts[classId] = post;
        }
      }

      final List<Map<String, dynamic>> postboardItems = [];

      for (final classData in joinedClasses) {
        final classId = classData['id'].toString();
        final latestPost = latestPosts[classId];

        // Classes with no posts should NOT appear
        // on the Postboard.
        if (latestPost != null) {
          postboardItems.add({'class': classData, 'latest_post': latestPost});
        }
      }

      if (!mounted) return;

      setState(() {
        _postboardItems = postboardItems;
        _isLoadingPostboard = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoadingPostboard = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load Postboard: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Widget currentBody;

    String titleText = 'Postboard';
    Color headerBlockColor = AppColors.noteYellow;

    if (_currentIndex == 0) {
      titleText = 'Postboard';
      headerBlockColor = AppColors.noteYellow;

      if (_isLoadingPostboard) {
        currentBody = const Center(child: CircularProgressIndicator());
      } else if (_postboardItems.isEmpty) {
        currentBody = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.sticky_note_2_outlined,
                size: 80,
                color: AppColors.textAndOutlines,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No posts from your classes yet.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.placeholderText,
                ),
              ),
            ],
          ),
        );
      } else {
        currentBody = RefreshIndicator(
          onRefresh: _refreshData,
          child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.screenEdgePadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.72,
            ),
            itemCount: _postboardItems.length,
            itemBuilder: (context, index) {
              final item = _postboardItems[index];

              final classData = item['class'] as Map<String, dynamic>;

              final latestPost = item['latest_post'] as Map<String, dynamic>;

              final backgroundColors = [
                AppColors.notePink,
                AppColors.noteGreen,
                AppColors.noteYellow,
                AppColors.noteCyan,
                AppColors.noteWhite,
                AppColors.notePurple,
              ];

              final headerColors = [
                AppColors.headerPink,
                AppColors.headerGreen,
                AppColors.headerYellow,
                AppColors.headerCyan,
                AppColors.headerGray,
                AppColors.headerPurple,
              ];

              final colorIndex = index % backgroundColors.length;

              return GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassboardScreen(
                        classId: classData['id'],
                        className: classData['class_name'],
                        colorAccent: headerColors[colorIndex],
                        professorName: '',
                      ),
                    ),
                  );

                  // Reload when returning from Classboard,
                  // because a newer post may have been added.
                  _refreshData();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColors[colorIndex],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.textAndOutlines,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: headerColors[colorIndex],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(11),
                          ),
                          border: const Border(
                            bottom: BorderSide(
                              color: AppColors.textAndOutlines,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          classData['class_name'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Text(
                            latestPost['content'] ?? '',
                            style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    } else if (_currentIndex == 1) {
      titleText = 'Classes';
      headerBlockColor = AppColors.noteYellow;

      if (_isLoadingClasses) {
        currentBody = const Center(child: CircularProgressIndicator());
      } else if (_joinedClasses.isEmpty) {
        currentBody = Center(
          child: Text(
            'You have not joined any classes yet.',
            style: textTheme.bodyMedium,
          ),
        );
      } else {
        currentBody = RefreshIndicator(
          onRefresh: _loadClasses,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.screenEdgePadding),
            itemCount: _joinedClasses.length,
            itemBuilder: (context, index) {
              final classData = _joinedClasses[index];

              final backgroundColors = [
                AppColors.notePink,
                AppColors.noteGreen,
                AppColors.noteYellow,
                AppColors.noteCyan,
                AppColors.noteWhite,
                AppColors.notePurple,
              ];

              final headerColors = [
                AppColors.headerPink,
                AppColors.headerGreen,
                AppColors.headerYellow,
                AppColors.headerCyan,
                AppColors.headerGray,
                AppColors.headerPurple,
              ];

              final colorIndex = index % backgroundColors.length;

              return ClassCard(
                className: classData['class_name'],
                code: classData['class_code'],
                latestPost: '',
                backgroundColor: backgroundColors[colorIndex],
                headerColor: headerColors[colorIndex],
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassboardScreen(
                        classId: classData['id'],
                        className: classData['class_name'],
                        colorAccent: headerColors[colorIndex],
                        professorName: '',
                      ),
                    ),
                  );

                  _refreshData();
                },
              );
            },
          ),
        );
      }
    } else {
      titleText = 'Profile';
      headerBlockColor = AppColors.noteYellow;
      currentBody = const ProfileScreen();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenEdgePadding,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: headerBlockColor,
                border: const Border(
                  bottom: BorderSide(
                    color: AppColors.textAndOutlines,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                titleText,
                style: textTheme.headlineSmall?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: currentBody),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            showModalBottomSheet(
              context: context,
              backgroundColor: AppColors.background,
              builder: (context) => Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.group_add),
                      title: const Text('Join a Class'),
                      onTap: () async {
                        Navigator.pop(context);

                        await showModalBottomSheet(
                          context: context,
                          builder: (_) => const JoinClassModal(),
                        );

                        _refreshData();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.add_box),
                      title: const Text('Create a Class'),
                      onTap: () async {
                        Navigator.pop(context);

                        await showModalBottomSheet(
                          context: context,
                          builder: (_) => const CreateClassModal(),
                        );

                        _refreshData();
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            setState(() => _currentIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Postboard'),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Classes',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Actions'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
