import 'package:flutter/material.dart';
import '../../../shared/constants/admin_colors.dart';

class AdminChatScreen extends StatefulWidget {
  final String? selectedMemberId;
  const AdminChatScreen({super.key, this.selectedMemberId});

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  String? _activeMemberId;
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  // TODO: Replace with Firestore
  final List<Map<String, dynamic>> _chatList = [
    {
      'memberId': '001',
      'name': 'محمد العمري',
      'lastMessage': 'أود الاستفسار عن الفرص المتاحة',
      'time': '10:35',
      'unread': 2,
    },
    {
      'memberId': '002',
      'name': 'أحمد الشهري',
      'lastMessage': 'شكراً جزيلاً',
      'time': '09:20',
      'unread': 0,
    },
    {
      'memberId': '003',
      'name': 'سارة القحطاني',
      'lastMessage': 'متى موعد الملتقى القادم؟',
      'time': 'أمس',
      'unread': 1,
    },
  ];

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'admin',
      'text': 'أهلاً بك في نادي المستثمرين! كيف يمكنني مساعدتك؟',
      'time': '10:30',
    },
    {
      'sender': 'member',
      'text': 'أود الاستفسار عن الفرص الاستثمارية المتاحة في قطاع التقنية',
      'time': '10:32',
    },
    {
      'sender': 'admin',
      'text':
          'بالتأكيد! لدينا حالياً عدة فرص في قطاع التقنية. يمكنك الاطلاع على قسم العروض.',
      'time': '10:35',
    },
  ];

  @override
  void initState() {
    super.initState();
    _activeMemberId = widget.selectedMemberId ?? _chatList.first['memberId'];
  }

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
      _messages.add({
        'sender': 'admin',
        'text': text,
        'time': TimeOfDay.now().format(context),
      });
    });
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: AdminColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AdminColors.cardBorder),
        ),
        child: Row(
          children: [
            // ── Chat list (left) ──────────────────────
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: AdminColors.cardBorder)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.chat, color: AdminColors.primaryGold, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'المحادثات',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _chatList.length,
                      itemBuilder: (context, index) {
                        final chat = _chatList[index];
                        final isActive =
                            chat['memberId'] == _activeMemberId;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _activeMemberId = chat['memberId'];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AdminColors.primaryGold.withOpacity(0.08)
                                  : null,
                              border: const Border(
                                bottom: BorderSide(
                                    color: AdminColors.cardBorder, width: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AdminColors.primaryGold
                                      .withOpacity(0.15),
                                  child: Text(
                                    chat['name'][0],
                                    style: const TextStyle(
                                      fontFamily: 'IBMPlexSansArabic',
                                      fontWeight: FontWeight.w700,
                                      color: AdminColors.primaryGold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chat['name'],
                                        style: const TextStyle(
                                          fontFamily: 'IBMPlexSansArabic',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        chat['lastMessage'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'IBMPlexSansArabic',
                                          fontSize: 12,
                                          color: AdminColors.textHint,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      chat['time'],
                                      style: const TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 11,
                                        color: AdminColors.textHint,
                                      ),
                                    ),
                                    if (chat['unread'] > 0) ...[
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AdminColors.primaryGold,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '${chat['unread']}',
                                          style: const TextStyle(
                                            fontFamily: 'IBMPlexSansArabic',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AdminColors.primaryDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(width: 1, color: AdminColors.cardBorder),

            // ── Chat area (right) ─────────────────────
            Expanded(
              child: Column(
                children: [
                  // Chat header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AdminColors.cardBorder)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              AdminColors.primaryGold.withOpacity(0.15),
                          child: const Text('م',
                              style: TextStyle(
                                color: AdminColors.primaryGold,
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _chatList.firstWhere((c) =>
                              c['memberId'] == _activeMemberId)['name'],
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Messages
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isAdmin = msg['sender'] == 'admin';
                        return Align(
                          alignment: isAdmin
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.4,
                            ),
                            decoration: BoxDecoration(
                              color: isAdmin
                                  ? AdminColors.primaryGold.withOpacity(0.1)
                                  : AdminColors.pageBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg['text'],
                                  style: const TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontSize: 13,
                                    color: AdminColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  msg['time'],
                                  style: const TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontSize: 10,
                                    color: AdminColors.textHint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Input
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: AdminColors.cardBorder)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            onSubmitted: (_) => _sendMessage(),
                            decoration: InputDecoration(
                              hintText: 'اكتب ردك...',
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FloatingActionButton.small(
                          onPressed: _sendMessage,
                          backgroundColor: AdminColors.primaryGold,
                          child: const Icon(Icons.send,
                              size: 18, color: AdminColors.primaryDark),
                        ),
                      ],
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
