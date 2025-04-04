import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

class Sidebar extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const Sidebar({Key? key, required this.isExpanded, required this.onToggle})
      : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _hoverIndex = -1;
  bool _isArrowHovered = false;
  bool _canShowText = false; // Controls when text is visible

  @override
  void initState() {
    super.initState();
    // Ensure text is visible initially if sidebar starts expanded
    _canShowText = widget.isExpanded;
  }

  @override
  void didUpdateWidget(covariant Sidebar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isExpanded && !_canShowText) {
      // Delay text only when expanding from collapsed state
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted && widget.isExpanded) {
          setState(() {
            _canShowText = true;
          });
        }
      });
    } else if (!widget.isExpanded) {
      setState(() {
        _canShowText = false;
      });
    }
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
                padding: const EdgeInsets.only(
                    left: 8.0, top: 16.0, bottom: 16.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/admin_logo.png',
                      height: 50,
                    ),
                    if (widget.isExpanded && _canShowText) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: AnimatedOpacity(
                          opacity: _canShowText ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 150),
                          child: Text(
                            'Admin Panel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 15),
                    _buildMenuItem(Icons.dashboard, 'Dashboard', 0),
                    const SizedBox(height: 10),
                    _buildMenuItem(Icons.menu_book, 'Manage Books', 1),
                    const SizedBox(height: 10),
                    _buildMenuItem(Icons.people, 'User Management', 2),
                    const SizedBox(height: 10),
                    _buildMenuItem(Icons.event, 'Reservations', 3),
                    const SizedBox(height: 10),
                    _buildMenuItem(Icons.calendar_today, 'Calendar', 4),
                    const SizedBox(height: 10),
                    _buildMenuItem(Icons.settings, 'Settings', 5),
                  ],
                ),
              ),
              const Divider(color: Colors.white54),
              _buildMenuItem(Icons.logout, 'Log out', 6),
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
                duration: Duration(milliseconds: 200),
                opacity: _isArrowHovered ? 1.0 : 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[700],
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
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

  Widget _buildMenuItem(IconData icon, String title, int index) {
    bool isHovered = _hoverIndex == index;
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverIndex = index),
      onExit: (_) => setState(() => _hoverIndex = -1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GlowContainer(
          glowColor: isHovered ? const Color(0xFF77B254) : Colors.transparent,
          blurRadius: isHovered ? 10 : 0,
          borderRadius: BorderRadius.circular(8.0),
          color: isHovered ? const Color(0xFF77B254) : Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.only(left: 12, top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: isHovered ? const Color(0xFF77B254) : Colors.transparent,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isHovered ? Colors.white : Colors.grey[400],
                ),
                if (widget.isExpanded && _canShowText) ...[
                  SizedBox(width: 10),
                  AnimatedOpacity(
                    opacity: _canShowText ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 150),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: isHovered ? Colors.white : Colors.grey[300],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
