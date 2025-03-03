//chat message 
class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String? attachmentPath;
  final String? attachmentName;
  final String? attachmentType;
  final int? attachmentSize;
  final String? voiceMessagePath;
  final Duration? voiceMessageDuration;

  bool get hasAttachment => attachmentPath != null;
  bool get hasVoiceMessage => voiceMessagePath != null;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.attachmentPath,
    this.attachmentName,
    this.attachmentType,
    this.attachmentSize,
    this.voiceMessagePath,
    this.voiceMessageDuration,
  });
}
