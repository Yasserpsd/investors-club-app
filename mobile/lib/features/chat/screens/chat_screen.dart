import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/models/message_model.dart';
import '../widgets/message_bubble.dart';
import '../../../app/providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  // TODO: Replace with Firestore stream
  final List<MessageModel> _messages = [
    MessageModel(
      messageId: '1',
      senderId: 'admin_001',
      senderRole: 'admin',
      text: 'أهلاً بك في نادي المستثمرين! كيف يمكنني مساعدتك؟',
      timestamp: DateTime(2026, 3, 22, 10, 30),
      isRead: true,
    ),
    MessageModel(
      messageId: '2',
      senderId: 'member_001',
      senderRole: 'member',
      text: 'شكراً لكم، أود الاستفسار عن الفرص الاستثمارية المتاحة في قطاع التقنية',
      timestamp: DateTime(2026, 3, 22, 10, 32),
      isRead: true,
    ),
    MessageModel(
      messageId: '3',
      senderId: 'admin_001',
      senderRole: 'admin',
      text: 'بالتأكيد! لدينا حالياً عدة فرص في قطاع التقنية. يمكنك الاطلاع على قسم العروض في الصفحة الرئيسية، أو أخبرني بالتحديد عن نوع الاستثمار الذي يهمك وسأساعدك.',
      timestamp: DateTime(2026, 3, 22, 10, 35),
      isRead: true,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        MessageModel(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'member_001', // TODO: Use actual member UID
          senderRole: 'member',
          text: text,
          timestamp: DateTime.now(),
          isRead: false,
        ),
      );
    });

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(languageProvider);
    final langCode = locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: Row(
          children: [
            // Admin avatar
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryGold.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.primaryDark,
                    child: const Icon(
                      Icons.support_agent,
                      color: AppColors.primaryGold,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    langCode == 'ar' ? 'إدارة النادي' : 'Club Admin',
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    langCode == 'ar' ? 'متصل الآن' : 'Online',
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 11,
                      color: Colors.greenAccent.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: AppColors.textHint.withOpacity(0.3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          langCode == 'ar'
                              ? 'لا توجد رسائل بعد\nابدأ محادثة مع الإدارة'
                              : 'No messages yet\nStart a conversation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 14,
                            color: AppColors.textHint.withOpacity(0.6),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(
                        message: _messages[index],
                        langCode: langCode,
                      );
                    },
                  ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: langCode == 'ar'
                              ? 'اكتب رسالتك...'
                              : 'Type a message...',
                          hintStyle: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 14,
                            color: AppColors.textHint.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send button
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGold,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(
                        Icons.send_rounded,
                        color: AppColors.primaryDark,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
