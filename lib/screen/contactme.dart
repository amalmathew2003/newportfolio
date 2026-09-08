import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/data/social_links.dart';
import 'package:my_portfolio/widgets/inspector_box.dart';
import 'package:my_portfolio/widgets/gradient_button.dart';

class ContactMe extends StatefulWidget {
  const ContactMe({super.key});

  @override
  State<ContactMe> createState() => _ContactMeState();
}

class _ContactMeState extends State<ContactMe> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  void _sendEmail() {
    if (_formKey.currentState!.validate()) {
      final subject = Uri.encodeComponent('Portfolio Contact from ${_nameController.text}');
      final body = Uri.encodeComponent('${_messageController.text}\n\nFrom: ${_emailController.text}');
      final mailtoUri = 'mailto:${SocialLinks.email}?subject=$subject&body=$body';
      _launchUrl(mailtoUri);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      color: AppColors.background(context),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 48,
        vertical: isMobile ? 32 : 64,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: InspectorBox(
            widgetTag: 'Contact',
            dimensionTag: 'form: active',
            signalAccent: SignalAccent.cyan,
            padding: EdgeInsets.all(isMobile ? 20 : 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Header line in IBM Plex Mono
                Text(
                  'Future<void> connect(Developer dev) async {',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: isMobile ? 13 : 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cyan,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Get in Touch & Collaborate',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 24 : 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText(context),
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Have an opportunity, app idea, or architectural question? Send a message or connect directly.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 14 : 16,
                    color: AppColors.dim,
                  ),
                ),

                const SizedBox(height: 36),

                isMobile
                    ? Column(
                        children: [
                          _buildForm(context),
                          const SizedBox(height: 36),
                          _buildDirectLinks(context),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Expanded(flex: 6, child: _buildForm(context)),
                          const SizedBox(width: 48),
                          Expanded(flex: 5, child: _buildDirectLinks(context)),
                        ],
                      ),

                const SizedBox(height: 36),

                Text(
                  '} // end connect',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 14,
                    color: AppColors.cyan,
                  ),
                ),

                const SizedBox(height: 48),

                // Footer Bar
                Container(
                  padding: const EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.line(context))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '© 2026 Amal Mathew. Built with Flutter Web.',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 11,
                          color: AppColors.dim,
                        ),
                      ),
                      Text(
                        'DevTools Inspector Mode',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 11,
                          color: AppColors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          _buildInputField(
            context,
            controller: _nameController,
            label: 'String name',
            hint: 'Your Name',
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            context,
            controller: _emailController,
            label: 'String email',
            hint: 'your.email@example.com',
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            context,
            controller: _messageController,
            label: 'String message',
            hint: 'Describe your project or query...',
            maxLines: 4,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 24),
          DevToolsButton(
            text: 'SEND MESSAGE',
            onPressed: _sendEmail,
            icon: Icons.send_outlined,
          ),
        ],
      ),
    );
  }


  Widget _buildInputField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.cyan,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            color: AppColors.primaryText(context),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              color: AppColors.dim.withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: AppColors.surfaceCard(context),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: BorderSide(color: AppColors.line(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: BorderSide(color: AppColors.line(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(color: AppColors.cyan, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDirectLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          '// Direct Connections',
          style: GoogleFonts.ibmPlexMono(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.pink,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactLinkTile(
          context,
          icon: Icons.email_outlined,
          label: 'Email',
          value: SocialLinks.email,
          onTap: () => _launchUrl('mailto:${SocialLinks.email}'),
        ),
        const SizedBox(height: 12),
        _buildContactLinkTile(
          context,
          icon: Icons.link_outlined,
          label: 'LinkedIn',
          value: 'linkedin.com/in/amal-mathew-1-',
          onTap: () => _launchUrl(SocialLinks.linkedInUrl),
        ),
        const SizedBox(height: 12),
        _buildContactLinkTile(
          context,
          icon: Icons.code_outlined,
          label: 'GitHub',
          value: 'github.com/amalmathew2003',
          onTap: () => _launchUrl(SocialLinks.githubUrl),
        ),
      ],
    );
  }

  Widget _buildContactLinkTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard(context),
          border: Border.all(color: AppColors.line(context)),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.cyan),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 10,
                      color: AppColors.dim,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
