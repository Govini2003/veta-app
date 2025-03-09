// veta-app/lib/settings_page.dart

import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'friends_page.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback? onSettingsChanged;

  const SettingsPage({
    Key? key,
    this.onSettingsChanged,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'සිංහල', 'தமிழ்'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setString('language', _selectedLanguage);
  }

  void _onSettingChanged() {
    if (widget.onSettingsChanged != null) {
      widget.onSettingsChanged!();
    }
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required Widget trailing,
    required IconData icon,
    Function? onTap,
  }) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryColor),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          trailing: trailing,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSettingItem(
              title: 'Friends',
              subtitle: 'Connect with other pet owners',
              icon: Icons.people,
              trailing: Icon(Icons.arrow_forward_ios, size: 20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FriendsPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildSettingItem(
              title: 'Notifications',
              subtitle: 'Manage your alerts',
              icon: Icons.notifications_outlined,
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  _saveSettings();
                  _onSettingChanged();
                },
                activeColor: AppTheme.primaryColor,
              ),
            ),
            _buildSettingItem(
              title: 'Language',
              subtitle: 'Change app language',
              icon: Icons.language,
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                underline: SizedBox(),
                items: _languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                    _saveSettings();
                    _onSettingChanged();
                  }
                },
              ),
            ),
            _buildSettingItem(
              title: 'Dark Mode',
              subtitle: 'Toggle theme',
              icon: Icons.dark_mode_outlined,
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                  _saveSettings();
                  _onSettingChanged();
                },
                activeColor: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
