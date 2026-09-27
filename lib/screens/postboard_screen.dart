import 'package:flutter/material.dart';
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

  final List<Map<String, dynamic>> courses = [
    {'name': 'Applications Development and Emerging Technologies', 'code': 'IT-301', 'color': AppColors.notePink, 'headerColor': AppColors.headerPink, 'prof': 'Tjakoen Stolk', 'desc': 'Hello, class! The deadline for the final project will be moved next week, until October 16.'},
    {'name': 'Introduction to Modeling and Simulation', 'code': 'IT-302', 'color': AppColors.noteGreen, 'headerColor': AppColors.headerGreen, 'prof': 'Sylvanas Windrunner', 'desc': 'Good evening, there will be no classes tomorrow. Use this time to catch up on your activities.'},
    {'name': 'Implementation of Software Engineering', 'code': 'IT-303', 'color': AppColors.noteYellow, 'headerColor': AppColors.headerYellow, 'prof': 'Pilipins Uy', 'desc': 'Hello po, sino po meron additional notes and references for Module 7? Thank you po huhu.'},
    {'name': 'Technical Reading and Writing for IT', 'code': 'IT-304', 'color': AppColors.noteCyan, 'headerColor': AppColors.headerCyan, 'prof': 'Arthas Menethil', 'desc': 'ASYNCHRONOUS CLASS ON THURSDAY. ACCOMPLISH THE ACTIVITIES POSTED ON NETACAD.'},
    {'name': 'Automata Theory and Formal Languages', 'code': 'IT-305', 'color': AppColors.noteWhite, 'headerColor': AppColors.headerGray, 'prof': 'Varian Wrynn', 'desc': 'We will be having a quiz next week. Coverage of the quiz will include Subsets, Myhill-Nerode, Maily-Moore, and Arden\'s Theorem.'},
    {'name': 'Information Assurance and Security', 'code': 'IT-306', 'color': AppColors.notePurple, 'headerColor': AppColors.headerPurple, 'prof': 'Alleria Windrunner', 'desc': 'Bakit ganun kaya subject natin? May assurance sa title pero walang assurance pumasa huhu. Sir baka naman! #napakasakit #kuya #eddie'},
    {'name': 'Project Management', 'code': 'IT-307', 'color': AppColors.notePink, 'headerColor': AppColors.headerPink, 'prof': '', 'desc': 'No posts have been made.'},
    {'name': 'Data Structures and Algorithms', 'code': 'IT-308', 'color': AppColors.noteGreen, 'headerColor': AppColors.headerGreen, 'prof': '', 'desc': 'No posts have been made.'},
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Widget currentBody;

    String titleText = 'Postboard';
    Color headerBlockColor = AppColors.noteYellow;

    if (_currentIndex == 0) {
      titleText = 'Postboard';
      headerBlockColor = AppColors.noteYellow;
      
      currentBody = GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenEdgePadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          crossAxisSpacing: AppSpacing.md, 
          mainAxisSpacing: AppSpacing.md, 
          childAspectRatio: 0.72,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final note = courses[index];
          
          // --- Added Tapping Interactivity Handler ---
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassboardScreen(
                    className: note['name'],
                    colorAccent: note['headerColor'],
                    professorName: note['prof'],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: note['color'],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.textAndOutlines, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: note['headerColor'],
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                      border: const Border(bottom: BorderSide(color: AppColors.textAndOutlines, width: 1)),
                    ),
                    child: Text(
                      note['name'], 
                      maxLines: 2, 
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Text(
                        note['desc'], 
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
      );
    } else if (_currentIndex == 1) {
      titleText = 'Classes';
      headerBlockColor = AppColors.noteYellow;
      
      currentBody = ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenEdgePadding),
        itemCount: courses.length,
        itemBuilder: (context, index) => ClassCard(
          className: courses[index]['name'],
          code: courses[index]['code'],
          latestPost: '', 
          backgroundColor: courses[index]['color'],
          headerColor: courses[index]['headerColor'],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassboardScreen(
                className: courses[index]['name'],
                colorAccent: courses[index]['headerColor'],
                professorName: courses[index]['prof'],
              ),
            ),
          ),
        ),
      );
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
                  bottom: BorderSide(color: AppColors.textAndOutlines, width: 1),
                ),
              ),
              child: Text(
                titleText,
                style: textTheme.headlineSmall?.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: currentBody),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex > 1 ? 2 : _currentIndex,
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
                      onTap: () { Navigator.pop(context); showModalBottomSheet(context: context, builder: (_) => const JoinClassModal()); },
                    ),
                    ListTile(
                      leading: const Icon(Icons.add_box),
                      title: const Text('Create a Class'),
                      onTap: () { Navigator.pop(context); showModalBottomSheet(context: context, builder: (_) => const CreateClassModal()); },
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
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Classes'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Actions'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }
}
