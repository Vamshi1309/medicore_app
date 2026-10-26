import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/primary_button.dart';

class PharmacistProfileScreen extends StatelessWidget {
  const PharmacistProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blueDark = const Color(0xFF0B5ED7);
    final blueMid = const Color(0xFF2A6DEB);
    final bg = const Color(0xFFEAF2F6);
    final cardBg = const Color(0xFFF6F8FB);
    final divider = const Color(0xFFE2E8F0);
    final text = const Color(0xFF1D2A3A);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [blueMid, blueDark],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 34,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.22,
                              ),
                              child: const Text(
                                'PS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Priya Shah',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'priya@citycare.in',
                              style: TextStyle(
                                color: Color(0xFFE9F1FF),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Pharmacist',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Professional details',
                                    style: TextStyle(
                                      color: text,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: blueDark,
                                    size: 22,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: divider),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAF2FF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.description_outlined,
                                      color: Color(0xFF2A6DEB),
                                      size: 23,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'License number',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF6D7B9A),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'MH-PC-2018-04821',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Color(0xFF1E2B3A),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: const [
                            _InfoRow(
                              icon: Icons.mail_outline,
                              iconColor: Color(0xFF2A6DEB),
                              label: 'Work email',
                              value: 'priya@citycare.in',
                            ),
                            Divider(height: 1, color: Color(0xFFE2E8F0)),
                            _InfoRow(
                              icon: Icons.access_time,
                              iconColor: Color(0xFF2A6DEB),
                              label: 'Shift',
                              value: '08:00 AM - 05:00 PM',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: PrimaryButton.outlinedFilled(
                        text: 'Log out',
                        onPressed: () {},
                        color: const Color(0xFFDD5C5C),
                        foregroundColor: const Color(0xFFDD5C5C),
                        prefixIcon: Icons.logout_rounded,
                        isTextBold: false,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'PharmaCare v2.4.0',
                      style: TextStyle(fontSize: 14, color: Color(0xFF8EA0B7)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF6D7B9A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF2D3849),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
