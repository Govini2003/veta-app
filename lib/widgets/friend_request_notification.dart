import 'dart:io';
import 'package:flutter/material.dart';
import '../models/pet_owner.dart';
import '../services/pet_owner_service.dart';

class FriendRequestNotification extends StatelessWidget {
  final PetOwner requester;
  final Function() onDismissed;

  const FriendRequestNotification({
    Key? key,
    required this.requester,
    required this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: requester.imagePath != null
              ? FileImage(File(requester.imagePath!))
              : AssetImage('assets/images/default_avatar.png') as ImageProvider,
        ),
        title: Text('Friend Request from ${requester.name}'),
        subtitle: Text(requester.bio ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: () async {
                final currentOwner = await PetOwnerService().getCurrentOwner();
                if (currentOwner != null) {
                  await PetOwnerService().acceptFriendRequest(
                    currentOwner.email,
                    requester.email,
                  );
                  onDismissed();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Friend request accepted')),
                  );
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () async {
                final currentOwner = await PetOwnerService().getCurrentOwner();
                if (currentOwner != null) {
                  await PetOwnerService().rejectFriendRequest(
                    currentOwner.email,
                    requester.email,
                  );
                  onDismissed();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Friend request rejected')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
