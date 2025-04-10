import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:book_ease/modals/logout_modal.dart';

class Sidebar extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _hoverIndex = -1;
  bool _isArrowHovered = false;
  bool _canShowText = false;

  @override
  void initState() {
    super.initState();
    _canShowText = widget.isExpanded;
  }

  @override
  void didUpdateWidget(covariant Sidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded && !_canShowText) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted && widget.isExpanded) {
          setState(() => _canShowText = true);
        }
      });
    } else if (!widget.isExpanded) {
      setState(() => _canShowText = false);
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => LogoutModal(
        onCancel: () {
          Navigator.pop(context); // Close the dialog
        },
        onLogout: () {
          Navigator.pop(context); // Close the dialog
          // TODO: Add your logout logic here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logged out successfully.")),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    bool isHovered = _hoverIndex == index;
    bool isSelected = index != 99 && widget.selectedIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoverIndex = index),
      onExit: (_) => setState(() => _hoverIndex = -1),
      child: GestureDetector(
        onTap: () {
          if (index == 99) {
            _handleLogout(context);
          } else {
            widget.onItemSelected(index);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: GlowContainer(
            glowColor:
                isSelected ? const Color(0xFF77B254) : Colors.transparent,
            blurRadius: isSelected ? 10 : 0,
            borderRadius: BorderRadius.circular(8.0),
            color: isSelected ? const Color(0xFF77B254) : Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.only(left: 12, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: isHovered || isSelected
                    ? const Color(0xFF77B254)
                    : Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: Colors.white,
                  ),
                  if (widget.isExpanded && _canShowText) ...[
                    const SizedBox(width: 10),
                    AnimatedOpacity(
                      opacity: _canShowText ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 150),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: widget.isExpanded ? 220 : 70,
          color: const Color(0xFF2A3335),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  children: [
                    // Use Image.asset to display the logo
                    Image.asset(
                      'assets/images/admin_logo.png',
                      width: 40,
                      height: 40,
                    ),
                    if (widget.isExpanded && _canShowText) ...[
                      const SizedBox(width: 8),
                      const Text(
                        'Admin Panel',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildMenuItem(Icons.dashboard, 'Dashboard', 0),
                    _buildMenuItem(Icons.menu_book, 'Manage Books', 1),
                    _buildMenuItem(Icons.people, 'User Management', 2),
                    _buildMenuItem(Icons.event, 'Reservations', 3),
                    _buildMenuItem(Icons.calendar_today, 'Calendar', 4),
                    _buildMenuItem(Icons.bookmark, 'Borrowed Books', 5),
                  ],
                ),
              ),
              const Divider(color: Colors.white54),
              _buildMenuItem(Icons.logout, 'Logout', 99),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 20,
          right: -8,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isArrowHovered = true),
            onExit: (_) => setState(() => _isArrowHovered = false),
            child: GestureDetector(
              onTap: widget.onToggle,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isArrowHovered ? 1.0 : 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[700],
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    widget.isExpanded ? Icons.arrow_back : Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}