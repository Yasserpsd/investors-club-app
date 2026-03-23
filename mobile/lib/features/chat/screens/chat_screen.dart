import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../app/providers.dart';
import '../services/chat_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  String? get _currentUid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    // Mark messages as read when entering chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markAsRead();
    });
  }

  void _markAsRead() {
    final uid = _currentUid;
    if (uid == null) return;
    ref.read(chatServiceProvider).markAsRead(
          memberId: uid,
          readerRole: 'member',
        );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final uid = _currentUid;
    if (uid == null) return;

    _messageController.clear();

    try {
      await ref.read(chatServiceProvider).sendMessage(
            memberId: uid,
            senderId: uid,
            senderRole: 'member',
            text: text,
          );

      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 200), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'فشل إرسال الرسالة. حاول مرة أخرى',
              style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(languageProvider).languageCode;
    final uid = _currentUid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('يرجى تسجيل الدخول')),
      );
    }

    final messagesAsync = ref.watch(memberMessagesProvider(uid));

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGold.withOpacity(0.15),
              ),
              child: const Icon(
                Icons.support_agent,
                color: AppColors.primaryGold,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  langCode == 'ar' ? 'إدارة النادي' : 'Club Admin',
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  langCode == 'ar' ? 'متصل الآن' : 'Online',
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 11,
                    color: Colors.greenAccent.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: Colors.white.withOpacity(0.15),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          langCode == 'ar'
                              ? 'ابدأ محادثة مع الإدارة'
                              : 'Start a conversation',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Auto scroll to bottom when new messages arrive
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: messages[index],
                      langCode: langCode,
                    );
                  },
                );
              },
              loading: () =>
                  const LoadingWidget(message: 'جاري تحميل المحادثة...'),
              error: (error, _) => Center(
                child: Text(
                  'حدث خطأ في تحميل المحادثة',
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              border: Border(
                top: BorderSide(
                  color: AppColors.primaryGold.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.primaryGold.withOpacity(0.1),
                      ),
                    ),
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (_) => _sendMessage(),
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: langCode == 'ar'
                            ? 'اكتب رسالتك...'
                            : 'Type a message...',
                        hintStyle: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGold.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send,
                      color: AppColors.primaryDark,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
