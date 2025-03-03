import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import '../models/chat_message.dart';
import '../widgets/voice_recorder.dart';
import '../widgets/audio_player.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  void sendMessage(String text, {
    String? attachmentPath,
    String? attachmentName,
    String? attachmentType,
    int? attachmentSize,
    String? voiceMessagePath,
    Duration? voiceMessageDuration,
  }) {
    if (text.trim().isEmpty && attachmentPath == null && voiceMessagePath == null) return;
    
    _messages.add(ChatMessage(
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
      attachmentPath: attachmentPath,
      attachmentName: attachmentName,
      attachmentType: attachmentType,
      attachmentSize: attachmentSize,
      voiceMessagePath: voiceMessagePath,
      voiceMessageDuration: voiceMessageDuration,
    ));
    notifyListeners();
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Veta Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Color(0xFF357376),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE9EFEC),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE9EFEC),
              Color(0xFFE9EFEC).withOpacity(0.95),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.white.withOpacity(0.7),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF357376), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Messages are end-to-end encrypted',
                      style: TextStyle(
                        color: Color(0xFF1D4D4F),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _ChatMessages(),
            ),
            _MessageInput(),
          ],
        ),
      ),
    );
  }
}

class _ChatMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          itemCount: chatProvider.messages.length,
          itemBuilder: (context, index) {
            final message = chatProvider.messages[chatProvider.messages.length - 1 - index];
            return _MessageBubble(
              message: message,
              isLastMessage: index == 0,
            );
          },
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isLastMessage;

  const _MessageBubble({
    required this.message,
    required this.isLastMessage,
  });

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget _buildAttachment() {
    if (!message.hasAttachment) return SizedBox.shrink();

    IconData iconData;
    if (message.attachmentType?.startsWith('image/') ?? false) {
      iconData = Icons.image;
    } else if (message.attachmentType?.startsWith('video/') ?? false) {
      iconData = Icons.video_file;
    } else if (message.attachmentType?.startsWith('audio/') ?? false) {
      iconData = Icons.audio_file;
    } else {
      iconData = Icons.insert_drive_file;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, color: Colors.white70, size: 24),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.attachmentName ?? 'File',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (message.attachmentSize != null)
                  Text(
                    _formatFileSize(message.attachmentSize!),
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceMessage() {
    if (!message.hasVoiceMessage) return SizedBox.shrink();
    return AudioMessagePlayer(
      audioPath: message.voiceMessagePath!,
      duration: message.voiceMessageDuration!,
      isMe: message.isMe,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4.0,
          bottom: isLastMessage ? 8.0 : 4.0,
          left: message.isMe ? 64.0 : 0.0,
          right: message.isMe ? 0.0 : 64.0,
        ),
        child: Column(
          crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: message.isMe ? Color(0xFF357376) : Color(0xFFdec092),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(message.isMe ? 20 : 5),
                  bottomRight: Radius.circular(message.isMe ? 5 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.hasAttachment) _buildAttachment(),
                  if (message.hasVoiceMessage) _buildVoiceMessage(),
                  if (message.text.isNotEmpty)
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isMe ? Colors.white : Color(0xFF1D4D4F),
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
              child: Text(
                DateFormat('HH:mm').format(message.timestamp),
                style: TextStyle(
                  color: Color(0xFF1D4D4F).withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  final _controller = TextEditingController();
  bool _isComposing = false;
  PlatformFile? _selectedFile;
  bool _isRecording = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: true,
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _isComposing = true;
        });
      }
    } catch (e) {
      print('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting file')),
      );
    }
  }

  void _clearAttachment() {
    setState(() {
      _selectedFile = null;
      _isComposing = _controller.text.trim().isNotEmpty;
    });
  }

  void _handleVoiceMessage(String path, Duration duration) {
    Provider.of<ChatProvider>(context, listen: false).sendMessage(
      '',
      voiceMessagePath: path,
      voiceMessageDuration: duration,
    );
  }

  void _sendMessage() {
    final text = _controller.text;
    if (text.trim().isEmpty && _selectedFile == null) return;

    Provider.of<ChatProvider>(context, listen: false).sendMessage(
      text,
      attachmentPath: _selectedFile?.name,
      attachmentName: _selectedFile?.name,
      attachmentType: _selectedFile != null ? lookupMimeType(_selectedFile!.name) : null,
      attachmentSize: _selectedFile?.size,
    );

    _controller.clear();
    _clearAttachment();
  }

  Widget _buildAttachmentPreview() {
    if (_selectedFile == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Icon(Icons.attach_file, color: Color(0xFF357376)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _selectedFile!.name,
              style: TextStyle(color: Color(0xFF1D4D4F)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 20),
            color: Color(0xFF357376),
            onPressed: _clearAttachment,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAttachmentPreview(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  color: Color(0xFF6BA8A9),
                  onPressed: _pickFile,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (text) {
                      setState(() {
                        _isComposing = text.trim().isNotEmpty || _selectedFile != null;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Color(0xFF6BA8A9).withOpacity(0.7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFE9EFEC).withOpacity(0.5),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _isComposing ? _sendMessage() : null,
                  ),
                ),
                SizedBox(width: 8),
                VoiceRecorder(onStop: _handleVoiceMessage),
                SizedBox(width: 8),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: FloatingActionButton(
                    onPressed: _isComposing ? _sendMessage : null,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                    backgroundColor: _isComposing ? Color(0xFF357376) : Color(0xFF6BA8A9).withOpacity(0.7),
                    elevation: _isComposing ? 2 : 0,
                    mini: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
