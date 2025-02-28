import 'package:flutter/material.dart';
import 'petO_home_page.dart';
import 'petO_activities_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Veta.lk',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFF357376),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF6BA8A9),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Text(
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
              const SizedBox(height: 24),

              // Quick Access Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const QuickAccessButton(
                    icon: Icons.help_outline,
                    label: 'Help',
                    onTap: () {},
                  ),
                  const QuickAccessButton(
                    icon: Icons.account_balance_wallet,
                    label: 'Wallet',
                    onTap: () {},
                  ),
                  const QuickAccessButton(
                    icon: Icons.message_outlined,
                    label: 'Messages',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Main Action Buttons
              const ActionButton(
                title: 'Become A Veta Member',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              const ActionButton(
                title: 'Add More Pets',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              const ActionButton(
                title: 'Your Pet\'s Profile',
                onTap: () {},
              ),
              const SizedBox(height: 24),

              // Menu Items
              const MenuListItem(
                icon: Icons.person,
                title: 'Manage your Vet Profile',
                onTap: () {},
              ),
              const MenuListItem(
                icon: Icons.pets,
                title: 'Manage your Pet Profile',
                onTap: () {},
              ),
              const MenuListItem(
                icon: Icons.medical_services,
                title: 'Register As a Veterinary Supplier',
                onTap: () {},
              ),
              const MenuListItem(
                icon: Icons.account_circle,
                title: 'Manage your Veta Profile',
                onTap: () {},
              ),
              const MenuListItem(
                icon: Icons.security,
                title: 'Privacy And Security',
                onTap: () {},
              ),
              const MenuListItem(
                icon: Icons.business,
                title: 'Manage Veta for business',
                onTap: () {},
              ),
              const MenuListItem(
                icon: Icons.info_outline,
                title: 'About Us',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF357376),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PetOHomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PetOHomePage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PetOActivitiesPage()),
            );
          }
        },
      ),
    );
  }
}

class QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickAccessButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE5DFDF),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
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
            Icon(icon, color: const Color(0xFF357376), size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
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

class ActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6BA8A9),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }
}

class MenuListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuListItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF357376)),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Questrial',
          color: Color(0xFF357376),
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
