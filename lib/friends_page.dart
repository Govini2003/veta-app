import 'package:flutter/material.dart';
import 'models/pet_owner.dart';
import 'services/pet_owner_service.dart';
import 'widgets/friend_request_notification.dart';
import 'theme/app_theme.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _petOwnerService = PetOwnerService();
  List<PetOwner> _friends = [];
  PetOwner? _currentOwner;
  List<PetOwner> _pendingRequests = [];
  final _searchController = TextEditingController();
  List<PetOwner> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
    _setupFriendRequestListener();
  }

  void _setupFriendRequestListener() {
    _petOwnerService.friendRequestStream.listen((requester) {
      setState(() {
        if (!_pendingRequests.any((r) => r.email == requester.email)) {
          _pendingRequests.add(requester);
        }
      });
    });
  }

  Future<void> _loadData() async {
    _currentOwner = await _petOwnerService.getCurrentOwner();
    if (_currentOwner != null) {
      final friends = await _petOwnerService.getFriends(_currentOwner!.email);
      final requests = await _petOwnerService.getPendingFriendRequests(_currentOwner!.email);
      setState(() {
        _friends = friends;
        _pendingRequests = requests;
      });
    }
  }

  Future<void> _searchFriends(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      _loadData();
      return;
    }

    final allOwners = await _petOwnerService.searchPetOwners(query);
    setState(() {
      _searchResults = allOwners.where((owner) => 
        owner.email != _currentOwner?.email &&
        !_currentOwner!.sentFriendRequests.contains(owner.email)
      ).toList();
      _isSearching = true;
    });
  }

  Future<void> _sendFriendRequest(String toEmail) async {
    final currentOwner = await _petOwnerService.getCurrentOwner();
    if (currentOwner == null) return;

    await _petOwnerService.sendFriendRequest(currentOwner.email, toEmail);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request sent!')),
    );
  }

  Future<void> _acceptFriendRequest(String fromEmail) async {
    final currentOwner = await _petOwnerService.getCurrentOwner();
    if (currentOwner == null) return;

    await _petOwnerService.acceptFriendRequest(fromEmail, currentOwner.email);
    _loadData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request accepted!')),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for friends...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: _searchFriends,
      ),
    );
  }

  Widget _buildSearchResults() {
    if (!_isSearching) return SizedBox();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final petOwner = _searchResults[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: petOwner.imagePath != null
                  ? NetworkImage(petOwner.imagePath!)
                  : null,
              child: petOwner.imagePath == null
                  ? Icon(Icons.person)
                  : null,
            ),
            title: Text(petOwner.name),
            subtitle: Text(petOwner.bio ?? ''),
            trailing: TextButton(
              onPressed: () => _sendFriendRequest(petOwner.email),
              child: Text('Add Friend'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFriendsList() {
    return ListView.builder(
      itemCount: _friends.length,
      itemBuilder: (context, index) {
        final friend = _friends[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: friend.imagePath != null
                ? NetworkImage(friend.imagePath!)
                : null,
            child: friend.imagePath == null
                ? Icon(Icons.person)
                : null,
          ),
          title: Text(friend.name),
          subtitle: Text(friend.bio ?? ''),
        );
      },
    );
  }

  Widget _buildPendingRequestsList() {
    return ListView.builder(
      itemCount: _pendingRequests.length,
      itemBuilder: (context, index) {
        final request = _pendingRequests[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: request.imagePath != null
                  ? NetworkImage(request.imagePath!)
                  : null,
              child: request.imagePath == null
                  ? Icon(Icons.person)
                  : null,
            ),
            title: Text(request.name),
            subtitle: Text(request.bio ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => _acceptFriendRequest(request.email),
                  child: Text('Accept'),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Implement reject friend request
                  },
                  child: Text('Reject'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        backgroundColor: Theme.of(context).primaryColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Friends'),
            Tab(text: 'Requests'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSearchResults(),
          if (_pendingRequests.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Friend Requests',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _pendingRequests.length,
              itemBuilder: (context, index) {
                return FriendRequestNotification(
                  requester: _pendingRequests[index],
                  onDismissed: () {
                    setState(() {
                      _pendingRequests.removeAt(index);
                    });
                  },
                );
              },
            ),
            Divider(height: 32),
          ],
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsList(),
                _buildPendingRequestsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
