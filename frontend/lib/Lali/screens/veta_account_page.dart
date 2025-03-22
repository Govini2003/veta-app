import 'package:flutter/material.dart';
import 'petO_home_page.dart';
import 'petO_activities_page.dart';

class VetaAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Veta.lk',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF357376),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF6BA8A9),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Hello,\nUser\'s Name',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF357376),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Quick Access Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  VetaQuickAccessButton(
                    icon: Icons.help_outline,
                    label: 'Help',
                    onTap: () {},
                  ),
                  VetaQuickAccessButton(
                    icon: Icons.account_balance_wallet,
                    label: 'Wallet',
                    onTap: () {},
                  ),
                  VetaQuickAccessButton(
                    icon: Icons.message_outlined,
                    label: 'Messages',
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Main Action Buttons
              VetaActionButton(
                title: 'Become A Veta Member',
                onTap: () {},
              ),
              SizedBox(height: 12),
              VetaActionButton(
                title: 'Add More Pets',
                onTap: () {},
              ),
              SizedBox(height: 12),
              VetaActionButton(
                title: 'Your Pet\'s Profile',
                onTap: () {},
              ),
              SizedBox(height: 24),

              // Menu Items
              VetaMenuListItem(
                icon: Icons.person,
                title: 'Manage your Vet Profile',
                onTap: () {},
              ),
              VetaMenuListItem(
                icon: Icons.pets,
                title: 'Manage your Pet Profile',
                onTap: () {},
              ),
              VetaMenuListItem(
                icon: Icons.medical_services,
                title: 'Register As a Veterinary Supplier',
                onTap: () {},
              ),
              VetaMenuListItem(
                icon: Icons.account_circle,
                title: 'Manage your Veta Profile',
                onTap: () {},
              ),
              VetaMenuListItem(
                icon: Icons.security,
                title: 'Privacy And Security',
                onTap: () {},
              ),
              VetaMenuListItem(
                icon: Icons.business,
                title: 'Manage Veta for business',
                onTap: () {},
              ),
              VetaMenuListItem(
                icon: Icons.info_outline,
                title: 'About Us',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VetaQuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  VetaQuickAccessButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFE5DFDF),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Color(0xFF357376), size: 24),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Questrial',
                color: Color(0xFF357376),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VetaActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  VetaActionButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF6BA8A9),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }
}

class VetaMenuListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  VetaMenuListItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF357376)),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Questrial',
          color: Color(0xFF357376),
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
} 