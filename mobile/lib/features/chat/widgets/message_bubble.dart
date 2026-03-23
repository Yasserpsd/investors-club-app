import 'package:flutter/material.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final String langCode;

  const MessageBubble({
    super.key,
    required this.message,
    required this.langCode,
  });

  @override
  Widget build(BuildContext context) {
    final isMember = message.isFromMember;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMember ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Admin avatar (left side)
          if (!isMember) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryGold.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.support_agent,
                size: 16,
                color: AppColors.primaryGold,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isMember
                    ? AppColors.chatMemberBubble
                    : AppColors.chatAdminBubble,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMember ? 16 : 4),
                  bottomRight: Radius.circular(isMember ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sender label
                  if (!isMember)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        langCode == 'ar' ? 'إدارة النادي' : 'Club Admin',
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGold.withValues(alpha: 0.8),
                        ),
                      ),
                    ),

                  // Message text
                  Text(
                    message.text,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 14,
                      color: isMember
                          ? AppColors.chatMemberText
                          : AppColors.chatAdminText,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Time + read status
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 10,
                          color: isMember
                              ? AppColors.chatMemberText.withValues(alpha: 0.6)
                              : AppColors.chatAdminText.withValues(alpha: 0.5),
                        ),
                      ),
                      if (isMember) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 14,
                          color: message.isRead
                              ? const Color(0xFF4FC3F7)
                              : AppColors.chatMemberText.withValues(alpha: 0.5),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Member avatar (right side)
          if (isMember) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryGold,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
