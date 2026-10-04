import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class ClassboardScreen extends StatefulWidget {
  final String className;
  final Color colorAccent;
  final String? classId;

  // Kept temporarily for compatibility with older navigation code.
  final String professorName;

  const ClassboardScreen({
    super.key,
    required this.className,
    required this.colorAccent,
    this.classId,
    this.professorName = '',
  });

  @override
  State<ClassboardScreen> createState() =>
      _ClassboardScreenState();
}

class _ClassboardScreenState
    extends State<ClassboardScreen> {
  final TextEditingController _postController =
      TextEditingController();

  List<Map<String, dynamic>> _posts = [];

  bool _isLoading = true;
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    if (widget.classId == null) {
      setState(() {
        _posts = [];
        _isLoading = false;
      });

      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('posts')
          .select('''
            id,
            class_id,
            author_id,
            content,
            created_at,
            updated_at,
            author:profiles!posts_author_id_fkey(
              first_name,
              last_name
            ),
            replies(
              id,
              author_id,
              content,
              created_at,
              updated_at,
              author:profiles!replies_author_id_fkey(
                first_name,
                last_name
              )
            )
          ''')
          .eq('class_id', widget.classId!)
          .order('created_at', ascending: false);

      if (!mounted) return;

      final loadedPosts =
          List<Map<String, dynamic>>.from(response);

      // Sort replies from oldest to newest.
      for (final post in loadedPosts) {
        final replies = post['replies'];

        if (replies is List) {
          replies.sort((a, b) {
            final aDate =
                DateTime.parse(a['created_at']);
            final bDate =
                DateTime.parse(b['created_at']);

            return aDate.compareTo(bDate);
          });
        }
      }

      setState(() {
        _posts = loadedPosts;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        'Could not load posts: $error',
      );
    }
  }

  Future<void> _createPost() async {
    final content = _postController.text.trim();

    if (content.isEmpty) {
      _showMessage('Please write something first.');
      return;
    }

    if (widget.classId == null) {
      _showMessage(
        'This class is not connected to the database yet.',
      );
      return;
    }

    final user =
        Supabase.instance.client.auth.currentUser;

    if (user == null) {
      _showMessage('You must be logged in.');
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      await Supabase.instance.client
          .from('posts')
          .insert({
        'class_id': widget.classId,
        'author_id': user.id,
        'content': content,
      });

      _postController.clear();

      await _loadPosts();
    } on PostgrestException catch (error) {
      _showMessage(error.message);
    } catch (error) {
      _showMessage(
        'Could not create post. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  Future<void> _showReplyDialog(
    String postId,
  ) async {
    final replyController =
        TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reply'),
          content: TextField(
            controller: replyController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Write a reply...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final content =
                    replyController.text.trim();

                if (content.isEmpty) {
                  return;
                }

                final user = Supabase
                    .instance.client.auth.currentUser;

                if (user == null) {
                  return;
                }

                try {
                  await Supabase.instance.client
                      .from('replies')
                      .insert({
                    'post_id': postId,
                    'author_id': user.id,
                    'content': content,
                  });

                  if (!dialogContext.mounted) {
                    return;
                  }

                  Navigator.pop(dialogContext);

                  await _loadPosts();
                } on PostgrestException catch (error) {
                  if (!mounted) return;

                  _showMessage(error.message);
                }
              },
              child: const Text('Reply'),
            ),
          ],
        );
      },
    );

    replyController.dispose();
  }

  // Checks whether content has been edited.
  bool _wasEdited(
    dynamic createdAt,
    dynamic updatedAt,
  ) {
    if (createdAt == null || updatedAt == null) {
      return false;
    }

    final created =
        DateTime.tryParse(createdAt.toString());

    final updated =
        DateTime.tryParse(updatedAt.toString());

    if (created == null || updated == null) {
      return false;
    }

    return updated.isAfter(created);
  }

  Future<void> _showEditPostDialog(
    Map<String, dynamic> post,
  ) async {
    final controller = TextEditingController(
      text: post['content'] ?? '',
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit post'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Edit your post...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final content =
                    controller.text.trim();

                if (content.isEmpty) {
                  return;
                }

                final user = Supabase
                    .instance.client.auth.currentUser;

                if (user == null) {
                  return;
                }

                try {
                  await Supabase.instance.client
                      .from('posts')
                      .update({
                        'content': content,
                      })
                      .eq('id', post['id'])
                      .eq('author_id', user.id);

                  if (!dialogContext.mounted) {
                    return;
                  }

                  Navigator.pop(dialogContext);

                  await _loadPosts();
                } on PostgrestException catch (error) {
                  if (!mounted) return;

                  _showMessage(error.message);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  Future<void> _showEditReplyDialog(
    Map<String, dynamic> reply,
  ) async {
    final controller = TextEditingController(
      text: reply['content'] ?? '',
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit reply'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Edit your reply...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final content =
                    controller.text.trim();

                if (content.isEmpty) {
                  return;
                }

                final user = Supabase
                    .instance.client.auth.currentUser;

                if (user == null) {
                  return;
                }

                try {
                  await Supabase.instance.client
                      .from('replies')
                      .update({
                        'content': content,
                      })
                      .eq('id', reply['id'])
                      .eq('author_id', user.id);

                  if (!dialogContext.mounted) {
                    return;
                  }

                  Navigator.pop(dialogContext);

                  await _loadPosts();
                } on PostgrestException catch (error) {
                  if (!mounted) return;

                  _showMessage(error.message);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _getAuthorName(dynamic author) {
    if (author is! Map) {
      return 'Unknown User';
    }

    final firstName =
        author['first_name'] ?? '';
    final lastName =
        author['last_name'] ?? '';

    final fullName =
        '$firstName $lastName'.trim();

    return fullName.isEmpty
        ? 'Unknown User'
        : fullName;
  }

  String _formatTimestamp(dynamic value) {
    if (value == null) {
      return '';
    }

    final date =
        DateTime.tryParse(value.toString());

    if (date == null) {
      return '';
    }

    final local = date.toLocal();

    final hour =
        local.hour.toString().padLeft(2, '0');

    final minute =
        local.minute.toString().padLeft(2, '0');

    return '${local.month}/${local.day}/${local.year} '
        '$hour:$minute';
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme;

    final currentUserId =
        Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                horizontal:
                    AppSpacing.screenEdgePadding,
                vertical: AppSpacing.md,
              ),
              decoration:
                  const BoxDecoration(
                color: AppColors.noteYellow,
                border: Border(
                  bottom: BorderSide(
                    color:
                        AppColors.textAndOutlines,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color:
                          AppColors.textAndOutlines,
                    ),
                    onPressed: () =>
                        Navigator.pop(context),
                  ),
                  const SizedBox(
                    width: AppSpacing.sm,
                  ),
                  Text(
                    'Classboard',
                    style: textTheme.headlineSmall
                        ?.copyWith(
                      fontSize: 32,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Class name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(
                AppSpacing.screenEdgePadding,
              ),
              decoration: BoxDecoration(
                color: widget.colorAccent,
                border: const Border(
                  bottom: BorderSide(
                    color:
                        AppColors.textAndOutlines,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                widget.className,
                style:
                    textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            // Posts
            Expanded(
              child: _isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(),
                    )
                  : _posts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              const Icon(
                                Icons
                                    .bedtime_outlined,
                                size: 80,
                                color: AppColors
                                    .textAndOutlines,
                              ),
                              const SizedBox(
                                height:
                                    AppSpacing.md,
                              ),
                              Text(
                                'No posts yet...',
                                style: textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  color: AppColors
                                      .placeholderText,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadPosts,
                          child:
                              ListView.builder(
                            padding:
                                const EdgeInsets
                                    .all(
                              AppSpacing
                                  .screenEdgePadding,
                            ),
                            itemCount:
                                _posts.length,
                            itemBuilder:
                                (context, index) {
                              final post =
                                  _posts[index];

                              final replies =
                                  List<Map<
                                      String,
                                      dynamic>>.from(
                                post['replies'] ??
                                    [],
                              );

                              return Container(
                                margin:
                                    const EdgeInsets
                                        .only(
                                  bottom:
                                      AppSpacing.md,
                                ),
                                padding:
                                    const EdgeInsets
                                        .all(
                                  AppSpacing.md,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: AppColors
                                      .authContainer,
                                  borderRadius:
                                      BorderRadius
                                          .circular(12),
                                  border:
                                      Border.all(
                                    color: AppColors
                                        .textAndOutlines,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      _getAuthorName(
                                        post['author'],
                                      ),
                                      style: textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    const SizedBox(
                                      height:
                                          AppSpacing.xs,
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          _formatTimestamp(
                                            post[
                                                'created_at'],
                                          ),
                                          style:
                                              textTheme
                                                  .labelSmall,
                                        ),
                                        if (_wasEdited(
                                          post[
                                              'created_at'],
                                          post[
                                              'updated_at'],
                                        ))
                                          Text(
                                            ' • edited',
                                            style:
                                                textTheme
                                                    .labelSmall,
                                          ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height:
                                          AppSpacing.sm,
                                    ),

                                    Text(
                                      post['content'] ??
                                          '',
                                      style: textTheme
                                          .bodyMedium,
                                    ),

                                    const SizedBox(
                                      height:
                                          AppSpacing.sm,
                                    ),

                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _showReplyDialog(
                                              post['id'],
                                            );
                                          },
                                          child:
                                              const Text(
                                            'Reply',
                                          ),
                                        ),

                                        if (post[
                                                'author_id'] ==
                                            currentUserId)
                                          TextButton(
                                            onPressed:
                                                () {
                                              _showEditPostDialog(
                                                post,
                                              );
                                            },
                                            child:
                                                const Text(
                                              'Edit',
                                            ),
                                          ),
                                      ],
                                    ),

                                    if (replies
                                        .isNotEmpty)
                                      const Divider(),

                                    for (final reply
                                        in replies)
                                      Padding(
                                        padding:
                                            const EdgeInsets
                                                .only(
                                          left:
                                              AppSpacing.md,
                                          top:
                                              AppSpacing.sm,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              _getAuthorName(
                                                reply[
                                                    'author'],
                                              ),
                                              style: textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                              ),
                                            ),

                                            Text(
                                              reply[
                                                      'content'] ??
                                                  '',
                                              style: textTheme
                                                  .bodyMedium,
                                            ),

                                            Row(
                                              children: [
                                                Text(
                                                  _formatTimestamp(
                                                    reply[
                                                        'created_at'],
                                                  ),
                                                  style: textTheme
                                                      .labelSmall,
                                                ),

                                                if (_wasEdited(
                                                  reply[
                                                      'created_at'],
                                                  reply[
                                                      'updated_at'],
                                                ))
                                                  Text(
                                                    ' • edited',
                                                    style:
                                                        textTheme
                                                            .labelSmall,
                                                  ),

                                                if (reply[
                                                        'author_id'] ==
                                                    currentUserId)
                                                  TextButton(
                                                    onPressed:
                                                        () {
                                                      _showEditReplyDialog(
                                                        reply,
                                                      );
                                                    },
                                                    child:
                                                        const Text(
                                                      'Edit',
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
            ),

            // New post composer
            if (widget.classId != null)
              Container(
                padding: const EdgeInsets.all(
                  AppSpacing.md,
                ),
                decoration:
                    const BoxDecoration(
                  color: AppColors.noteYellow,
                  border: Border(
                    top: BorderSide(
                      color:
                          AppColors.textAndOutlines,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller:
                            _postController,
                        maxLines: null,
                        decoration:
                            const InputDecoration(
                          hintText:
                              'Write a post...',
                          filled: true,
                          fillColor: Colors.white,
                          border:
                              OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: AppSpacing.sm,
                    ),
                    IconButton(
                      onPressed: _isPosting
                          ? null
                          : _createPost,
                      icon: _isPosting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.send,
                            ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}