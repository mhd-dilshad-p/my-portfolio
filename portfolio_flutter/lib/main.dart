import 'dart:math' show sin, cos, pi;
import 'dart:math' as math show Random;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const PortfolioApp());
}

// Color constants - Premium dark theme
class AppColors {
  static const Color bgPrimary = Color(0xFF0a0a0f);
  static const Color bgSecondary = Color(0xFF12121a);
  static const Color bgTertiary = Color(0xFF1a1a25);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFa0a0b0);
  static const Color textMuted = Color(0xFF6a6a7a);
  static const Color accentPrimary = Color(0xFF6366f1);
  static const Color accentSecondary = Color(0xFF8b5cf6);
  static const Color accentTertiary = Color(0xFFa855f7);
  static const Color glassBg = Color(0x08ffffff);
  static const Color glassBorder = Color(0x14ffffff);
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohammed Dilshad P | Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgPrimary,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.spaceGrotesk(
            fontSize: 80,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          displayMedium: GoogleFonts.spaceGrotesk(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          displaySmall: GoogleFonts.spaceGrotesk(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          headlineMedium: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 18,
            color: AppColors.textSecondary,
            height: 1.8,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 50 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 50 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  void _scrollToSection(String sectionId) {
    final key = _sectionKeys[sectionId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  final Map<String, GlobalKey> _sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'experience': GlobalKey(),
    'projects': GlobalKey(),
    'skills': GlobalKey(),
    'education': GlobalKey(),
    'contact': GlobalKey(),
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                key: _sectionKeys['home'],
                child: const HeroSection(),
              ),
              SliverToBoxAdapter(
                key: _sectionKeys['about'],
                child: const AboutSection(),
              ),
              SliverToBoxAdapter(
                key: _sectionKeys['experience'],
                child: const ExperienceSection(),
              ),
              SliverToBoxAdapter(
                key: _sectionKeys['projects'],
                child: const ProjectsSection(),
              ),
              SliverToBoxAdapter(
                key: _sectionKeys['skills'],
                child: const SkillsSection(),
              ),
              SliverToBoxAdapter(
                key: _sectionKeys['education'],
                child: const EducationSection(),
              ),
              SliverToBoxAdapter(
                key: _sectionKeys['contact'],
                child: const ContactSection(),
              ),
              const SliverToBoxAdapter(child: Footer()),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavigationBar(
              isScrolled: _isScrolled,
              onNavTap: _scrollToSection,
            ),
          ),
        ],
      ),
    );
  }
}

// Navigation Bar
class NavigationBar extends StatelessWidget {
  final bool isScrolled;
  final Function(String) onNavTap;

  const NavigationBar({
    super.key,
    required this.isScrolled,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: isScrolled ? 16 : 24,
      ),
      decoration: BoxDecoration(
        color: isScrolled
            ? AppColors.bgPrimary.withAlpha(204)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isScrolled ? AppColors.glassBorder : Colors.transparent,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: isScrolled
              ? const ColorFilter.matrix([
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  20,
                  -10,
                ])
              : const ColorFilter.matrix([
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.accentPrimary, AppColors.accentSecondary],
                ).createShader(bounds),
                child: Text(
                  'MD.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (MediaQuery.of(context).size.width > 768)
                Row(
                  children: [
                    _NavLink('About', () => onNavTap('about')),
                    _NavLink('Experience', () => onNavTap('experience')),
                    _NavLink('Projects', () => onNavTap('projects')),
                    _NavLink('Skills', () => onNavTap('skills')),
                    _NavLink('Contact', () => onNavTap('contact')),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _NavLink(this.text, this.onTap);

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _isHovered
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: _isHovered ? 40 : 0,
                height: 2,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentPrimary,
                      AppColors.accentSecondary,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Particle Animation Widget
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late List<Particle> particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    particles = List.generate(30, (index) => Particle.random());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ParticlePainter(
            particles: particles,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class Particle {
  double x, y, size, speedX, speedY, opacity;

  Particle.random()
    : x = _random.nextDouble(),
      y = _random.nextDouble(),
      size = _random.nextDouble() * 4 + 1,
      speedX = (_random.nextDouble() - 0.5) * 0.002,
      speedY = (_random.nextDouble() - 0.5) * 0.002,
      opacity = _random.nextDouble() * 0.5 + 0.2;

  static final _random = math.Random();
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter({required this.particles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentPrimary.withAlpha(77)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      final x =
          (particle.x + particle.speedX * animationValue * 1000) %
          1.0 *
          size.width;
      final y =
          (particle.y + particle.speedY * animationValue * 1000) %
          1.0 *
          size.height;

      paint.color = AppColors.accentPrimary.withAlpha(
        (particle.opacity * 77).toInt(),
      );
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Hero Section with Profile Photo
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(color: AppColors.bgPrimary),
      child: Stack(
        children: [
          // Particle background
          const ParticleBackground(),

          // Animated gradient orbs
          Positioned(
            top: -200,
            right: -100,
            child: _AnimatedOrb(
              size: 600,
              color: AppColors.accentPrimary,
              delay: 0,
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: _AnimatedOrb(
              size: 400,
              color: AppColors.accentSecondary,
              delay: 5,
            ),
          ),
          Positioned(
            top: size.height * 0.3,
            left: size.width * 0.3,
            child: _AnimatedOrb(
              size: 300,
              color: AppColors.accentTertiary,
              delay: 10,
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Photo with animated ring
                _ProfilePhotoWithRing(),

                const SizedBox(height: 32),

                // Subtitle
                Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.accentPrimary,
                            AppColors.accentSecondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'FLUTTER DEVELOPER',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 300.ms)
                    .slideY(begin: 0.3, end: 0)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                    ),

                const SizedBox(height: 24),

                // Title with character animation
                _AnimatedTitle(),

                const SizedBox(height: 24),

                // Role description
                RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          color: AppColors.textSecondary,
                        ),
                        children: const [
                          TextSpan(text: 'Building '),
                          TextSpan(
                            text: 'scalable, user-centric',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' mobile applications\nwith Flutter & Dart',
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 1200.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 40),

                // CTA Buttons
                Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _PrimaryButton(
                          text: 'View Projects',
                          icon: FontAwesomeIcons.rocket,
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _SecondaryButton(
                          text: 'Get in Touch',
                          icon: FontAwesomeIcons.envelope,
                          onTap: () {},
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 1400.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 48),

                // Social Links
                Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialButton(
                          icon: FontAwesomeIcons.github,
                          url: 'https://github.com/mhd-dilshad-p',
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          icon: FontAwesomeIcons.linkedinIn,
                          url: 'https://linkedin.com/in/mhd-dilshad-p',
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          icon: FontAwesomeIcons.envelope,
                          url: 'mailto:dilshadgb750@gmail.com',
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 1600.ms)
                    .slideY(begin: 0.3, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePhotoWithRing extends StatefulWidget {
  @override
  State<_ProfilePhotoWithRing> createState() => _ProfilePhotoWithRingState();
}

class _ProfilePhotoWithRingState extends State<_ProfilePhotoWithRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: const [
                    AppColors.accentPrimary,
                    AppColors.accentSecondary,
                    AppColors.accentTertiary,
                    AppColors.accentPrimary,
                  ],
                  transform: GradientRotation(_controller.value * 2 * pi),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPrimary.withAlpha(100),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bgPrimary, width: 4),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/profile_photo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        )
        .animate()
        .fadeIn(duration: 1000.ms)
        .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1))
        .rotate(begin: -0.1, end: 0);
  }
}

class _AnimatedOrb extends StatefulWidget {
  final double size;
  final Color color;
  final double delay;

  const _AnimatedOrb({
    required this.size,
    required this.color,
    required this.delay,
  });

  @override
  State<_AnimatedOrb> createState() => _AnimatedOrbState();
}

class _AnimatedOrbState extends State<_AnimatedOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    Future.delayed(Duration(seconds: widget.delay.toInt()), () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            30 * sin(_controller.value * 2 * pi),
            -30 * cos(_controller.value * 2 * pi),
          ),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withAlpha(102),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = 'Mohammed Dilshad P';

    return Wrap(
      alignment: WrapAlignment.center,
      children: name.split('').asMap().entries.map((entry) {
        final index = entry.key;
        final char = entry.value;
        return Text(
              char == ' ' ? '\u00A0' : char,
              style: GoogleFonts.spaceGrotesk(
                fontSize: MediaQuery.of(context).size.width > 768 ? 72 : 36,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: (500 + index * 50).ms)
            .slideY(begin: 0.5, end: 0, duration: 600.ms)
            .shimmer(duration: 1200.ms, delay: (2000 + index * 100).ms);
      }).toList(),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accentPrimary, AppColors.accentSecondary],
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentPrimary.withAlpha(
                  _isHovered ? 128 : 102,
                ),
                blurRadius: _isHovered ? 30 : 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          transform: _isHovered
              ? Matrix4.translationValues(0, -2, 0)
              : Matrix4.identity(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(widget.icon, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.glassBg,
            border: Border.all(
              color: _isHovered
                  ? AppColors.accentPrimary
                  : AppColors.glassBorder,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          transform: _isHovered
              ? Matrix4.translationValues(0, -2, 0)
              : Matrix4.identity(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(widget.icon, color: AppColors.textPrimary, size: 16),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String url;

  const _SocialButton({required this.icon, required this.url});

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _launchUrl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.accentPrimary : AppColors.glassBg,
            border: Border.all(
              color: _isHovered
                  ? AppColors.accentPrimary
                  : AppColors.glassBorder,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          transform: _isHovered
              ? Matrix4.translationValues(0, -3, 0)
              : Matrix4.identity(),
          child: Center(
            child: FaIcon(
              widget.icon,
              color: _isHovered ? Colors.white : AppColors.textSecondary,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

// Section Header Widget
class _SectionHeader extends StatelessWidget {
  final String tag;
  final String title;
  final String? subtitle;

  const _SectionHeader({required this.tag, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentPrimary.withAlpha(26),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accentPrimary.withAlpha(51)),
          ),
          child: Text(
            tag.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accentPrimary,
              letterSpacing: 3,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: MediaQuery.of(context).size.width > 768 ? 48 : 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 17,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    ).animate().fadeIn().slideY(begin: 0.3, end: 0);
  }
}

// About Section with Social Work Background
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSecondary,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          _SectionHeader(
            tag: 'About Me',
            title: 'Passionate Developer,\nUnique Perspective',
          ),
          const SizedBox(height: 64),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _AboutImage()),
                    const SizedBox(width: 64),
                    Expanded(child: _AboutContent()),
                  ],
                );
              }
              return Column(
                children: [
                  _AboutImage(),
                  const SizedBox(height: 48),
                  _AboutContent(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AboutImage extends StatefulWidget {
  @override
  State<_AboutImage> createState() => _AboutImageState();
}

class _AboutImageState extends State<_AboutImage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _isHovered
            ? Matrix4.translationValues(0, -5, 0)
            : Matrix4.identity(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect
            // AnimatedContainer(
            //   duration: const Duration(milliseconds: 300),
            //   width: 320,
            //   height: 320,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(30),
            //     gradient: const LinearGradient(
            //       colors: [AppColors.accentPrimary, AppColors.accentSecondary],
            //     ),
            //   ),
            //   transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
            // ),
            // Image container with social work theme
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.bgTertiary,
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Y29kaW5nfGVufDB8fDB8fHww',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crafting Digital Experiences',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Junior Flutter Developer with hands-on experience building scalable, user-centric mobile applications using Flutter and Dart. I transitioned into mobile development through focused technical training, bringing a unique perspective in user-centered design from my social science background.',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Strong command of Provider state management, Firebase integration (Authentication & Firestore), and REST API consumption. I translate complex UI/UX designs into responsive, high-performance interfaces with a passion for clean architecture and modular development.',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            _StatItem(number: '2+', label: 'Projects'),
            const SizedBox(width: 16),
            _StatItem(number: '1+', label: 'Years Experience'),
            const SizedBox(width: 16),
            _StatItem(number: '3', label: 'Languages'),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatefulWidget {
  final String number;
  final String label;

  const _StatItem({required this.number, required this.label});

  @override
  State<_StatItem> createState() => _StatItemState();
}

class _StatItemState extends State<_StatItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.glassBg,
          border: Border.all(
            color: _isHovered ? AppColors.accentPrimary : AppColors.glassBorder,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.accentPrimary.withAlpha(77),
                    blurRadius: 40,
                  ),
                ]
              : null,
        ),
        transform: _isHovered
            ? Matrix4.translationValues(0, -5, 0)
            : Matrix4.identity(),
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.accentPrimary, AppColors.accentSecondary],
              ).createShader(bounds),
              child: Text(
                widget.number,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Experience Section
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgPrimary,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          _SectionHeader(
            tag: 'Experience',
            title: 'Professional Journey',
            subtitle:
                'My career path and the valuable experience I\'ve gained along the way',
          ),
          const SizedBox(height: 64),
          const _ExperienceTimeline(),
        ],
      ),
    );
  }
}

class _ExperienceTimeline extends StatelessWidget {
  const _ExperienceTimeline();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Stack(
        children: [
          // Timeline line
          Positioned(
            left: 6,
            top: 0,
            bottom: 0,
            child: Container(
              width: 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accentPrimary, AppColors.accentSecondary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Experience items
          Column(
            children: [
              _ExperienceItem(
                title: 'Flutter Development Trainee',
                company: 'Zoople Technologies',
                date: '2025 – Present',
                responsibilities: const [
                  'Contributed to the end-to-end Flutter application development lifecycle, including UI implementation, state management, and feature integration',
                  'Developed reusable Flutter widgets following clean code and modular architecture principles',
                  'Implemented Provider-based state management to ensure predictable application behaviour and efficient UI updates',
                  'Integrated Firebase services and REST APIs to enable dynamic data handling',
                  'Translated complex UI/UX designs into responsive Flutter interfaces optimised for multiple screen sizes',
                  'Used Git and GitHub for version control, branching, and collaborative development in an agile environment',
                  'Assisted in debugging and performance optimisation, improving overall application stability',
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExperienceItem extends StatefulWidget {
  final String title;
  final String company;
  final String date;
  final List<String> responsibilities;

  const _ExperienceItem({
    required this.title,
    required this.company,
    required this.date,
    required this.responsibilities,
  });

  @override
  State<_ExperienceItem> createState() => _ExperienceItemState();
}

class _ExperienceItemState extends State<_ExperienceItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 48, bottom: 48),
      child: Stack(
        children: [
          // Timeline dot
          Positioned(
            left: -41,
            top: 4,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.accentPrimary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bgPrimary, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.accentPrimary,
                    blurRadius: 0,
                    spreadRadius: 3,
                  ),
                ],
              ),
            ),
          ),
          // Content card
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.glassBg,
                border: Border.all(
                  color: _isHovered
                      ? AppColors.accentPrimary
                      : AppColors.glassBorder,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.accentPrimary.withAlpha(77),
                          blurRadius: 40,
                        ),
                      ]
                    : null,
              ),
              transform: _isHovered
                  ? Matrix4.translationValues(10, 0, 0)
                  : Matrix4.identity(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.company,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.accentPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgTertiary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.date,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...widget.responsibilities.map(
                    (resp) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '→ ',
                            style: TextStyle(
                              color: AppColors.accentPrimary,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              resp,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }
}

// Projects Section with Logos
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSecondary,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          _SectionHeader(
            tag: 'Portfolio',
            title: 'Featured Projects',
            subtitle:
                'A selection of my recent work and technical achievements',
          ),
          const SizedBox(height: 64),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 32,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: [
                  _ProjectCard(
                    title: 'Alizo',
                    logoAsset: 'assets/images/alizo_logo.png',
                    technologies: const [
                      'Flutter',
                      'Dart',
                      'Firebase',
                      'Provider',
                      'REST API',
                    ],
                    description:
                        'A task-oriented Flutter mobile application focused on improving everyday workflow efficiency.',
                    features: const [
                      'Modular architecture for scalability',
                      'Provider state management with form validation',
                      'Firebase Authentication & Firestore integration',
                      'Responsive layouts tested across multiple Android screens',
                    ],
                    githubUrl: 'https://github.com/mhd-dilshad-p',
                  ),
                  _ProjectCard(
                    title: 'Adam Travels',
                    logoAsset: 'assets/images/adam_logo.png',
                    technologies: const ['Flutter', 'Dart', 'Web', 'Mobile'],
                    description:
                        'Cross-platform Flutter project with both web and mobile targets, demonstrating versatile development capability.',
                    features: const [
                      'Cross-platform development (Web & Mobile)',
                      'Clean code principles throughout',
                      'Git-based version control workflow',
                      'Production-ready architecture',
                    ],
                    githubUrl: 'https://github.com/mhd-dilshad-p',
                  ),
                  _ProjectCard(
                    title: 'Nadodi',
                    logoAsset: 'assets/images/nadodi_logo.jpg',
                    technologies: const ['Flutter', 'Dart', 'UI/UX'],
                    description:
                        'Travel and exploration app with beautiful UI design and smooth user experience.',
                    features: const [
                      'Beautiful UI/UX design',
                      'Smooth animations and transitions',
                      'Responsive design patterns',
                      'Modern Flutter architecture',
                    ],
                    githubUrl: 'https://github.com/mhd-dilshad-p',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final String title;
  final String logoAsset;
  final List<String> technologies;
  final String description;
  final List<String> features;
  final String githubUrl;

  const _ProjectCard({
    required this.title,
    required this.logoAsset,
    required this.technologies,
    required this.description,
    required this.features,
    required this.githubUrl,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  Future<void> _launchGithub() async {
    final uri = Uri.parse(widget.githubUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(maxWidth: 380),
        decoration: BoxDecoration(
          color: AppColors.glassBg,
          border: Border.all(
            color: _isHovered ? AppColors.accentPrimary : AppColors.glassBorder,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.accentPrimary.withAlpha(77),
                    blurRadius: 40,
                  ),
                ]
              : null,
        ),
        transform: _isHovered
            ? Matrix4.translationValues(0, -10, 0)
            : Matrix4.identity(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project logo area
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.bgTertiary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: _isHovered
                      ? Matrix4.diagonal3Values(1.1, 1.1, 1)
                      : Matrix4.identity(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      widget.logoAsset,
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const FaIcon(
                          FontAwesomeIcons.code,
                          size: 64,
                          color: AppColors.accentPrimary,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _launchGithub,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.bgTertiary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.arrowUpRightFromSquare,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tech tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.technologies
                        .map(
                          (tech) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.bgTertiary,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: Text(
                              tech,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...widget.features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              color: AppColors.accentPrimary,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              feature,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.3, end: 0);
  }
}

// Skills Section with Tech Logos
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgPrimary,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          _SectionHeader(
            tag: 'Expertise',
            title: 'Technical Skills',
            subtitle:
                'Technologies and tools I work with to bring ideas to life',
          ),
          const SizedBox(height: 48),
          // Tech logos row
          _TechLogosRow(),
          const SizedBox(height: 64),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 32,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: [
                  _SkillCategory(
                    icon: FontAwesomeIcons.code,
                    title: 'Languages & Framework',
                    skills: const ['Dart', 'Flutter SDK'],
                  ),
                  _SkillCategory(
                    icon: FontAwesomeIcons.layerGroup,
                    title: 'State Management',
                    skills: const [
                      'Provider',
                      'Bloc (Learning)',
                      'Riverpod (Learning)',
                    ],
                  ),
                  _SkillCategory(
                    icon: FontAwesomeIcons.server,
                    title: 'Backend & APIs',
                    skills: const [
                      'Firebase Auth',
                      'Cloud Firestore',
                      'REST API Integration',
                    ],
                  ),
                  _SkillCategory(
                    icon: FontAwesomeIcons.screwdriverWrench,
                    title: 'Dev Tools',
                    skills: const [
                      'Git',
                      'GitHub',
                      'Android Studio',
                      'VS Code',
                    ],
                  ),
                  _SkillCategory(
                    icon: FontAwesomeIcons.mobileScreen,
                    title: 'Mobile Concepts',
                    skills: const [
                      'Responsive UI Design',
                      'Widget Optimization',
                      'Navigation & Routing',
                      'Form Validation',
                      'Debugging & Performance',
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TechLogosRow extends StatefulWidget {
  @override
  State<_TechLogosRow> createState() => _TechLogosRowState();
}

class _TechLogosRowState extends State<_TechLogosRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> techLogos = [
    {
      'name': 'Flutter',
      'color': const Color(0xFF54C5F8),
      'icon': FontAwesomeIcons.code,
    },
    {
      'name': 'Dart',
      'color': const Color(0xFF0175C2),
      'icon': FontAwesomeIcons.circle,
    },
    {
      'name': 'Firebase',
      'color': const Color(0xFFFFCA28),
      'icon': FontAwesomeIcons.fire,
    },
    {
      'name': 'Git',
      'color': const Color(0xFFF05032),
      'icon': FontAwesomeIcons.gitAlt,
    },
    {'name': 'GitHub', 'color': Colors.white, 'icon': FontAwesomeIcons.github},
    {
      'name': 'Android',
      'color': const Color(0xFF3DDC84),
      'icon': FontAwesomeIcons.android,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: techLogos.asMap().entries.map((entry) {
            final index = entry.key;
            final tech = entry.value;
            final offset =
                sin((_controller.value * 2 * pi) + (index * 0.5)) * 5;

            return Transform.translate(
              offset: Offset(0, offset),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.glassBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      tech['icon'] as IconData,
                      color: tech['color'] as Color,
                      size: 32,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tech['name'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _SkillCategory extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<String> skills;

  const _SkillCategory({
    required this.icon,
    required this.title,
    required this.skills,
  });

  @override
  State<_SkillCategory> createState() => _SkillCategoryState();
}

class _SkillCategoryState extends State<_SkillCategory> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.glassBg,
          border: Border.all(
            color: _isHovered ? AppColors.accentPrimary : AppColors.glassBorder,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        transform: _isHovered
            ? Matrix4.translationValues(0, -5, 0)
            : Matrix4.identity(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.accentPrimary,
                        AppColors.accentSecondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: FaIcon(widget.icon, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: widget.skills
                  .map((skill) => _SkillItem(skill: skill))
                  .toList(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.3, end: 0);
  }
}

class _SkillItem extends StatefulWidget {
  final String skill;

  const _SkillItem({required this.skill});

  @override
  State<_SkillItem> createState() => _SkillItemState();
}

class _SkillItemState extends State<_SkillItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.accentPrimary : AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered ? AppColors.accentPrimary : AppColors.glassBorder,
          ),
        ),
        transform: _isHovered
            ? Matrix4.diagonal3Values(1.05, 1.05, 1)
            : Matrix4.identity(),
        child: Text(
          widget.skill,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: _isHovered ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// Education Section
class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSecondary,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          _SectionHeader(tag: 'Background', title: 'Education & Languages'),
          const SizedBox(height: 64),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 32,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: [
                  _EducationCard(
                    date: '2025',
                    degree: 'Flutter Development Program',
                    school: 'Zoople Technologies, Kerala',
                  ),
                  _EducationCard(
                    date: '2022 – 2025',
                    degree: 'Bachelor of Social Work (BSW)',
                    school: 'Calicut University',
                  ),
                  _EducationCard(
                    date: '2021 – 2022',
                    degree: 'Higher Secondary (Humanities)',
                    school: 'Kerala State Board',
                    languages: const ['English', 'Malayalam', 'Tamil'],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EducationCard extends StatefulWidget {
  final String date;
  final String degree;
  final String school;
  final List<String>? languages;

  const _EducationCard({
    required this.date,
    required this.degree,
    required this.school,
    this.languages,
  });

  @override
  State<_EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<_EducationCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.glassBg,
          border: Border.all(
            color: _isHovered ? AppColors.accentPrimary : AppColors.glassBorder,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        transform: _isHovered
            ? Matrix4.translationValues(0, -5, 0)
            : Matrix4.identity(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 3,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accentPrimary, AppColors.accentSecondary],
                ),
              ),
            ),
            Text(
              widget.date,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.accentPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              widget.degree,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Text(
              widget.school,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.languages != null) ...[
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: widget.languages!
                    .map(
                      (lang) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgTertiary,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Text(
                          lang,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Contact Section
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgPrimary,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          _SectionHeader(
            tag: 'Get in Touch',
            title: 'Let\'s Work Together',
            subtitle: 'Have a project in mind? I\'d love to hear from you.',
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _ContactItem(
                icon: FontAwesomeIcons.envelope,
                label: 'Email',
                value: 'dilshadgb750@gmail.com',
                url: 'mailto:dilshadgb750@gmail.com',
              ),
              _ContactItem(
                icon: FontAwesomeIcons.phone,
                label: 'Phone',
                value: '+91 97783 53618',
                url: 'tel:+919778353618',
              ),
              _ContactItem(
                icon: FontAwesomeIcons.linkedinIn,
                label: 'LinkedIn',
                value: 'mhd-dilshad-p',
                url: 'https://linkedin.com/in/mhd-dilshad-p',
              ),
              _ContactItem(
                icon: FontAwesomeIcons.github,
                label: 'GitHub',
                value: 'mhd-dilshad-p',
                url: 'https://github.com/mhd-dilshad-p',
              ),
            ],
          ),
          const SizedBox(height: 64),
          const _ContactForm(),
        ],
      ),
    );
  }
}

class _ContactItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String url;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
  });

  @override
  State<_ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<_ContactItem> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _launchUrl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minWidth: 160, maxWidth: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.glassBg,
            border: Border.all(
              color: _isHovered
                  ? AppColors.accentPrimary
                  : AppColors.glassBorder,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.accentPrimary.withAlpha(77),
                      blurRadius: 40,
                    ),
                  ]
                : null,
          ),
          transform: _isHovered
              ? Matrix4.translationValues(0, -5, 0)
              : Matrix4.identity(),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentPrimary,
                      AppColors.accentSecondary,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(widget.icon, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.value,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.3, end: 0);
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final subject = Uri.encodeComponent(_subjectController.text);
      final body = Uri.encodeComponent(
        'Name: ${_nameController.text}\n'
        'Email: ${_emailController.text}\n\n'
        '${_messageController.text}',
      );
      final url = 'mailto:dilshadgb750@gmail.com?subject=$subject&body=$body';

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }

      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.glassBg,
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 500) {
                  return Row(
                    children: [
                      Expanded(
                        child: _FormField(
                          label: 'Your Name',
                          hint: 'John Doe',
                          controller: _nameController,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _FormField(
                          label: 'Your Email',
                          hint: 'john@example.com',
                          controller: _emailController,
                          isEmail: true,
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    _FormField(
                      label: 'Your Name',
                      hint: 'John Doe',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 24),
                    _FormField(
                      label: 'Your Email',
                      hint: 'john@example.com',
                      controller: _emailController,
                      isEmail: true,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            _FormField(
              label: 'Subject',
              hint: 'Project Inquiry',
              controller: _subjectController,
            ),
            const SizedBox(height: 24),
            _FormField(
              label: 'Message',
              hint: 'Tell me about your project...',
              controller: _messageController,
              isMessage: true,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: _PrimaryButton(
                text: 'Send Message',
                icon: FontAwesomeIcons.paperPlane,
                onTap: _submitForm,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.3, end: 0);
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isEmail;
  final bool isMessage;

  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    this.isEmail = false,
    this.isMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: isMessage ? 5 : 1,
          style: GoogleFonts.inter(fontSize: 16, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.bgTertiary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.glassBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accentPrimary),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            if (isEmail && !value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }
}

// Footer
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSecondary,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 48),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.accentPrimary, AppColors.accentSecondary],
            ).createShader(bounds),
            child: Text(
              'MD.',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Flutter Developer crafting beautiful mobile experiences',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterSocialButton(
                icon: FontAwesomeIcons.github,
                url: 'https://github.com/mhd-dilshad-p',
              ),
              const SizedBox(width: 16),
              _FooterSocialButton(
                icon: FontAwesomeIcons.linkedinIn,
                url: 'https://linkedin.com/in/mhd-dilshad-p',
              ),
              const SizedBox(width: 16),
              _FooterSocialButton(
                icon: FontAwesomeIcons.envelope,
                url: 'mailto:dilshadgb750@gmail.com',
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            '© 2025 Mohammed Dilshad P. All rights reserved.',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _FooterSocialButton extends StatefulWidget {
  final IconData icon;
  final String url;

  const _FooterSocialButton({required this.icon, required this.url});

  @override
  State<_FooterSocialButton> createState() => _FooterSocialButtonState();
}

class _FooterSocialButtonState extends State<_FooterSocialButton> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _launchUrl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.accentPrimary : AppColors.glassBg,
            border: Border.all(
              color: _isHovered
                  ? AppColors.accentPrimary
                  : AppColors.glassBorder,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          transform: _isHovered
              ? Matrix4.translationValues(0, -3, 0)
              : Matrix4.identity(),
          child: Center(
            child: FaIcon(
              widget.icon,
              color: _isHovered ? Colors.white : AppColors.textSecondary,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
