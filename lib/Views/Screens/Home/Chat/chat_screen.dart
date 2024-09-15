import 'package:flutter/material.dart';
import '../../../../Controllers/api_servie_login.dart';
import '../../../../Utils/constants.dart';
class Chat extends StatefulWidget {
  final int? receiverId; // ID of the user you want to chat with
  final int? eventId; // Event ID for event-based chat (optional)
  const Chat({Key? key, this.receiverId, this.eventId}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}
class _ChatState extends State<Chat> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> directChats = [];
  List<Map<String, dynamic>> eventChats = [];
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.receiverId != null) {
      _loadDirectChats();
    }
    if (widget.eventId != null) {
      _loadEventChats();
    }
  }
  Future<void> _loadDirectChats() async {
    if (widget.receiverId == null) return; 
    setState(() {
      _isLoading = true;
    });
    try {
      final chats = await _authService.fetchDirectChats(
        receiverId: widget.receiverId!,
        page: 1,
      );
      setState(() {
        directChats = chats;
      });
    } catch (e) {
      _showError('Failed to load direct chats: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _sendDirectMessage(String message) async {
    if (widget.receiverId == null) {
      _showError('Receiver ID is missing.');
      return;
    }
    try {
      final newMessage = await _authService.sendDirectMessage(
        receiverId: widget.receiverId!,
        content: message,
      );
      setState(() {
        directChats.add(newMessage);
      });
      _messageController.clear();
    } catch (e) {
      _showError('Failed to send message: $e');
    }
  }
  Future<void> _loadEventChats() async {
    if (widget.eventId == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final chats = await _authService.fetchEventChat(widget.eventId!);
      setState(() {
        eventChats = chats;
      });
    } catch (e) {
      _showError('Failed to load event chats: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _sendEventMessage(String message) async {
    if (widget.eventId == null) {
      _showError('Event ID is missing.');
      return;
    }
    try {
      final newMessage = await _authService.sendEventMessage(
        eventId: widget.eventId!,
        content: message,
      );
      setState(() {
        eventChats.add(newMessage);
      });
      _messageController.clear();
    } catch (e) {
      _showError('Failed to send event message: $e');
    }
  }
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Chat',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: ColorConstants.mainColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          widget.receiverId == null
              ? Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: ColorConstants.mainColor,
              tabs: const [
                Tab(text: 'Direct'),
                Tab(text: 'Event'),
              ],
            ),
          )
              : Container(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : widget.receiverId != null
                ? _buildDirectMessages()
                : TabBarView(
              controller: _tabController,
              children: [
                _buildDirectMessages(),
                _buildEventMessages(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDirectMessages() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: directChats.length,
            itemBuilder: (context, index) {
              final message = directChats[index];
              return _buildMessageTile(
                message['sender']['fullname'] ?? '',
                message['content'] ?? '',
                message['sender']['image'] ??
                    'assets/sidra.png',
              );
            },
          ),
        ),
        _buildMessageInputField(_sendDirectMessage),
      ],
    );
  }
  Widget _buildEventMessages() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: eventChats.length,
            itemBuilder: (context, index) {
              final message = eventChats[index];
              return _buildMessageTile(
                message['sender']['fullname'] ?? '',
                message['content'] ?? '',
                message['sender']['image'] ??
                    'assets/sidra.png',
              );
            },
          ),
        ),
        _buildMessageInputField(_sendEventMessage),
      ],
    );
  }
  Widget _buildMessageTile(String title, String subtitle, String imagePath) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imagePath),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
  Widget _buildMessageInputField(Function(String) onSendMessage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: ColorConstants.mainColor,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_messageController.text.isNotEmpty) {
                  onSendMessage(_messageController.text);
                } else {
                  _showError('Message cannot be empty.');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
