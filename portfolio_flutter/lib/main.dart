import 'dart:math' show sin, cos, pi, sqrt;
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:lottie/lottie.dart';
import 'dart:html' as html;

void main() => runApp(const PortfolioApp());

// ══════════════════════════════════════════════
// COLOR SYSTEM — Cyberpunk Noir
// ══════════════════════════════════════════════
class AppColors {
  static const Color bg0 = Color(0xFF04040A);
  static const Color bg1 = Color(0xFF080810);
  static const Color bg2 = Color(0xFF0D0D1A);
  static const Color bg3 = Color(0xFF141428);
  static const Color text0 = Color(0xFFEEEEFF);
  static const Color text1 = Color(0xFF9090B0);
  static const Color text2 = Color(0xFF505070);
  static const Color cyan = Color(0xFF00F5FF);
  static const Color violet = Color(0xFF7C3AED);
  static const Color pink = Color(0xFFEC4899);
  static const Color green = Color(0xFF39FF14);
  static const Color glass = Color(0x0AFFFFFF);
  static const Color glassB = Color(0x18FFFFFF);
}

// ══════════════════════════════════════════════
// APP ROOT
// ══════════════════════════════════════════════
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohammed Dilshad P',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg0,
      ),
      home: const PortfolioHome(),
    );
  }
}

// ══════════════════════════════════════════════
// HOME — orchestrator
// ══════════════════════════════════════════════
class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});
  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final _scroll = ScrollController();
  bool _scrolled = false;
  Offset _cursor = Offset.zero;

  final _keys = <String, GlobalKey>{
    'hero': GlobalKey(),
    'about': GlobalKey(),
    'services': GlobalKey(),
    'experience': GlobalKey(),
    'projects': GlobalKey(),
    'testimonials': GlobalKey(),
    'skills': GlobalKey(),
    'education': GlobalKey(),
    'contact': GlobalKey(),
  };

  bool _showBanner = true;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final s = _scroll.offset > 60;
      if (s != _scrolled) setState(() => _scrolled = s);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _goto(String id) {
    final ctx = _keys[id]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOutQuart,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) => setState(() => _cursor = e.position),
      child: Scaffold(
        backgroundColor: AppColors.bg0,
        endDrawer: _MobileDrawer(onNav: _goto),
        body: Column(
          children: [
            if (_showBanner)
              _TopBanner(onDismiss: () => setState(() => _showBanner = false)),
            Expanded(
              child: Stack(
                children: [
                  const Positioned.fill(child: _AuroraBackground()),
                  // Cursor glow
                  Positioned(
                    left: _cursor.dx - 200,
                    top: _cursor.dy - 200,
                    child: IgnorePointer(
                      child: Container(
                        width: 400,
                        height: 400,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.violet.withOpacity(0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (MediaQuery.of(context).size.width > 768)
                    ...List.generate(5, (i) {
                      return AnimatedPositioned(
                        duration: Duration(milliseconds: 100 + (i * 80)),
                        curve: Curves.easeOut,
                        left: _cursor.dx - 2,
                        top: _cursor.dy - 2,
                        child: IgnorePointer(
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cyan.withOpacity(0.6 - (i * 0.1)),
                            ),
                          ),
                        ),
                      );
                    }),
                  // Main scroll
                  ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                    ),
                    child: CustomScrollView(
                      controller: _scroll,
                      slivers: [
                        SliverToBoxAdapter(
                          key: _keys['hero'],
                          child: HeroSection(onNav: _goto),
                        ),
                        const SliverToBoxAdapter(child: _SectionDivider()),
                        const SliverToBoxAdapter(
                          child: _Reveal(child: _AnimatedStatsBar()),
                        ),
                        const SliverToBoxAdapter(child: _SectionDivider()),
                        SliverToBoxAdapter(
                          key: _keys['about'],
                          child: const _Reveal(child: AboutSection()),
                        ),
                        const SliverToBoxAdapter(child: _SectionDivider()),
                        SliverToBoxAdapter(
                          key: _keys['services'],
                          child: const _Reveal(child: ServicesSection()),
                        ),
                        const SliverToBoxAdapter(child: _SectionDivider()),
                        SliverToBoxAdapter(
                          key: _keys['experience'],
                          child: const _Reveal(child: ExperienceSection()),
                        ),
                        const SliverToBoxAdapter(child: _SectionDivider()),
                        SliverToBoxAdapter(
                          key: _keys['projects'],
                          child: const _Reveal(child: ProjectsSection()),
                        ),
                        const SliverToBoxAdapter(child: _SectionDivider()),
                        SliverToBoxAdapter(
                          key: _keys['testimonials'],
                          child: const _Reveal(child: TestimonialsSection()),
                        ),
                        const SliverToBoxAdapter(child: _SectionDivider()),
                        SliverToBoxAdapter(
                          key: _keys['skills'],
                          child: const _Reveal(child: SkillsSection()),
                        ),
                        const SliverToBoxAdapter(child: _SectionDivider()),
                        SliverToBoxAdapter(
                          key: _keys['education'],
                          child: const _Reveal(child: EducationSection()),
                        ),
                        const SliverToBoxAdapter(child: _SectionDivider()),
                        SliverToBoxAdapter(
                          key: _keys['contact'],
                          child: const _Reveal(child: ContactSection()),
                        ),
                        const SliverToBoxAdapter(child: _Reveal(child: _Footer())),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _ProgressBar(scroll: _scroll),
                  ),
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: AnimatedBuilder(
                      animation: _scroll,
                      builder: (context, child) {
                        final bool show = _scroll.hasClients && _scroll.offset > 500;
                        return AnimatedOpacity(
                          opacity: show ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: show ? child : IgnorePointer(child: child),
                        );
                      },
                      child: _ScrollToTopButton(scroll: _scroll),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _NavBar(scrolled: _scrolled, onNav: _goto),
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

// ══════════════════════════════════════════════
// AURORA BACKGROUND
// ══════════════════════════════════════════════
class _AuroraBackground extends StatefulWidget {
  const _AuroraBackground();
  @override
  State<_AuroraBackground> createState() => _AuroraBgState();
}

class _AuroraBgState extends State<_AuroraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 18))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, __) =>
        CustomPaint(size: Size.infinite, painter: _AuroraPainter(_c.value)),
  );
}

class _AuroraPainter extends CustomPainter {
  final double t;
  _AuroraPainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..blendMode = BlendMode.screen;
    void blob(double cx, double cy, double r, Color color) {
      paint.shader =
          RadialGradient(
            colors: [color.withOpacity(0.14), Colors.transparent],
            stops: const [0, 1],
          ).createShader(
            Rect.fromCircle(
              center: Offset(cx * size.width, cy * size.height),
              radius: r,
            ),
          );
      canvas.drawCircle(Offset(cx * size.width, cy * size.height), r, paint);
    }

    blob(
      0.2 + sin(t * 2 * pi) * 0.12,
      0.1 + cos(t * 2 * pi) * 0.06,
      size.width * 0.45,
      AppColors.violet,
    );
    blob(
      0.8 + cos(t * 2 * pi + 1) * 0.08,
      0.15 + sin(t * 2 * pi) * 0.07,
      size.width * 0.4,
      AppColors.cyan,
    );
    blob(
      0.5 + sin(t * 2 * pi + 2) * 0.11,
      0.35 + cos(t * 2 * pi) * 0.09,
      size.width * 0.36,
      AppColors.pink,
    );
  }

  @override
  bool shouldRepaint(_AuroraPainter o) => o.t != t;
}

// ══════════════════════════════════════════════
// CONSTELLATION BG (hero)
// ══════════════════════════════════════════════
class _ConstellationBg extends StatefulWidget {
  const _ConstellationBg();
  @override
  State<_ConstellationBg> createState() => _ConstellationBgState();
}

class _ConstellationBgState extends State<_ConstellationBg>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late List<_Node> nodes;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 25))
      ..repeat();
    nodes = List.generate(40, (_) => _Node.rng());
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, __) => CustomPaint(
      size: Size.infinite,
      painter: _ConstellationPainter(nodes, _c.value),
    ),
  );
}

class _Node {
  double x, y, bx, by, r, sx, sy;
  _Node.rng()
    : x = math.Random().nextDouble(),
      y = math.Random().nextDouble(),
      bx = math.Random().nextDouble(),
      by = math.Random().nextDouble(),
      r = math.Random().nextDouble() * 1.4 + 0.6,
      sx = (math.Random().nextDouble() - 0.5) * 0.00018,
      sy = (math.Random().nextDouble() - 0.5) * 0.00018;
}

class _ConstellationPainter extends CustomPainter {
  final List<_Node> nodes;
  final double t;
  _ConstellationPainter(this.nodes, this.t);
  @override
  void paint(Canvas canvas, Size size) {
    for (var n in nodes) {
      n.x = (n.bx + n.sx * t * 10000) % 1.0;
      n.y = (n.by + n.sy * t * 10000) % 1.0;
    }
    final lp = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final np = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final dx = (nodes[i].x - nodes[j].x) * size.width;
        final dy = (nodes[i].y - nodes[j].y) * size.height;
        final d = sqrt(dx * dx + dy * dy);
        if (d < 130) {
          lp.color = AppColors.cyan.withOpacity((1 - d / 130) * 0.18);
          canvas.drawLine(
            Offset(nodes[i].x * size.width, nodes[i].y * size.height),
            Offset(nodes[j].x * size.width, nodes[j].y * size.height),
            lp,
          );
        }
      }
    }
    for (var n in nodes) {
      np.color = AppColors.cyan.withOpacity(0.2);
      canvas.drawCircle(
        Offset(n.x * size.width, n.y * size.height),
        n.r * 2.5,
        np,
      );
      np.color = AppColors.cyan.withOpacity(0.65);
      canvas.drawCircle(Offset(n.x * size.width, n.y * size.height), n.r, np);
    }
  }

  @override
  bool shouldRepaint(_ConstellationPainter o) => true;
}

// ══════════════════════════════════════════════
// PROGRESS BAR
// ══════════════════════════════════════════════
class _ProgressBar extends StatelessWidget {
  final ScrollController scroll;
  const _ProgressBar({required this.scroll});

  double _getProgress() {
    try {
      if (scroll.hasClients && scroll.position.maxScrollExtent > 0) {
        return (scroll.offset / scroll.position.maxScrollExtent).clamp(0.0, 1.0);
      }
    } catch (_) {
      // position not yet attached
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scroll,
      builder: (context, _) {
        final double p = _getProgress();
        return SizedBox(
          height: 3,
          width: double.infinity,
          child: Stack(
            children: [
              Container(color: AppColors.bg3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                width: MediaQuery.of(context).size.width * p,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.cyan, AppColors.violet, AppColors.pink],
                  ),
                ),
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyan.withOpacity(0.8),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════
// NAV BAR
// ══════════════════════════════════════════════
class _NavBar extends StatelessWidget {
  final bool scrolled;
  final Function(String) onNav;
  const _NavBar({required this.scrolled, required this.onNav});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: scrolled ? 14 : 22,
      ),
      decoration: BoxDecoration(
        color: scrolled ? AppColors.bg0.withOpacity(0.88) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: scrolled ? AppColors.glassB : Colors.transparent,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: scrolled
              ? ImageFilter.blur(sigmaX: 24, sigmaY: 24)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _GlitchLogo(),
              if (MediaQuery.of(context).size.width > 768)
                Row(
                  children: [
                    ...['About', 'Experience', 'Projects', 'Skills', 'Contact']
                        .map((l) => _NavLink(l, () => onNav(l.toLowerCase()))),
                    const SizedBox(width: 12),
                    const _DownloadCVNavButton(),
                  ],
                )
              else
                Row(
                  children: [
                    const _DownloadCVNavButton(),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.menu, color: AppColors.cyan),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// SCROLL TO TOP BUTTON
// ══════════════════════════════════════════════
class _ScrollToTopButton extends StatefulWidget {
  final ScrollController scroll;
  const _ScrollToTopButton({required this.scroll});

  @override
  State<_ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<_ScrollToTopButton> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (widget.scroll.hasClients) {
            widget.scroll.animateTo(
              0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutQuart,
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _hov
                ? const LinearGradient(
                    colors: [AppColors.cyan, AppColors.violet],
                  )
                : null,
            color: _hov ? null : AppColors.cyan.withOpacity(0.12),
            border: Border.all(
              color: _hov ? Colors.transparent : AppColors.cyan,
            ),
            boxShadow: _hov
                ? [
                    BoxShadow(
                      color: AppColors.cyan.withOpacity(0.6),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: AnimatedScale(
              scale: _hov ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: FaIcon(
                FontAwesomeIcons.chevronUp,
                color: _hov ? Colors.white : AppColors.cyan,
                size: 18,
              ),
            ),
          ),
        ).animate().scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOut),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// DOWNLOAD CV NAV BUTTON
// ══════════════════════════════════════════════
class _DownloadCVNavButton extends StatefulWidget {
  const _DownloadCVNavButton();

  @override
  State<_DownloadCVNavButton> createState() => _DownloadCVNavButtonState();
}

class _DownloadCVNavButtonState extends State<_DownloadCVNavButton> {
  bool _hov = false;

  void _downloadCV() {
    html.window.open('https://drive.google.com/file/d/1ed2qQwzo-gh5DdFYGTWfvf5F4B9WAqLB/view?usp=sharing', '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _downloadCV,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.cyan),
            gradient: _hov
                ? const LinearGradient(colors: [AppColors.cyan, AppColors.violet])
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.fileArrowDown,
                color: _hov ? Colors.white : AppColors.cyan,
                size: 12,
              ),
              const SizedBox(width: 6),
              Text(
                'Download CV',
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _hov ? Colors.white : AppColors.cyan,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// TOP BANNER
// ══════════════════════════════════════════════
class _TopBanner extends StatelessWidget {
  final VoidCallback onDismiss;
  const _TopBanner({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cyan.withOpacity(0.08),
        border: const Border(bottom: BorderSide(color: AppColors.cyan, width: 1)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "👋 Currently available for hire — Let's build something great!",
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.text0,
            ),
          ),
          Positioned(
            right: 12,
            child: IconButton(
              icon: const Icon(Icons.close, size: 16, color: AppColors.cyan),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// MOBILE DRAWER
// ══════════════════════════════════════════════
class _MobileDrawer extends StatelessWidget {
  final Function(String) onNav;
  const _MobileDrawer({required this.onNav});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bg0,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: AppColors.glassB)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.glassB)),
              ),
              child: Center(
                child: Text(
                  'MD',
                  style: GoogleFonts.spaceMono(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.cyan,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...['About', 'Experience', 'Projects', 'Skills', 'Contact']
                .map(
                  (l) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onNav(l.toLowerCase());
                      },
                      child: Center(
                        child: _NavLink(l, () {
                          Navigator.pop(context);
                          onNav(l.toLowerCase());
                        }),
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// GLITCH LOGO — Using Profile Image
// ══════════════════════════════════════════════
class _GlitchLogo extends StatefulWidget {
  @override
  State<_GlitchLogo> createState() => _GlitchLogoState();
}

class _GlitchLogoState extends State<_GlitchLogo> {
  bool _glitch = false;
  @override
  void initState() {
    super.initState();
    _scheduleGlitch();
  }

  void _scheduleGlitch() async {
    while (mounted) {
      await Future.delayed(
        Duration(milliseconds: 2500 + math.Random().nextInt(3000)),
      );
      if (!mounted) return;
      setState(() => _glitch = true);
      await Future.delayed(const Duration(milliseconds: 140));
      if (!mounted) return;
      setState(() => _glitch = false);
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;
      setState(() => _glitch = true);
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;
      setState(() => _glitch = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_glitch)
          Transform.translate(
            offset: const Offset(2, 1),
            child: _buildLogoContainer(AppColors.pink.withOpacity(0.6)),
          ),
        if (_glitch)
          Transform.translate(
            offset: const Offset(-2, -1),
            child: _buildLogoContainer(AppColors.cyan.withOpacity(0.6)),
          ),
        _buildLogoContainer(null),
      ],
    );
  }

  Widget _buildLogoContainer(Color? glitchColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Profile image
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: glitchColor ?? AppColors.cyan.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: glitchColor != null
                ? [
                    BoxShadow(
                      color: glitchColor.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.cyan.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile_logo.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to initials if image fails
                return Container(
                  color: AppColors.bg2,
                  child: Center(
                    child: Text(
                      'MD',
                      style: GoogleFonts.spaceMono(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: glitchColor ?? AppColors.cyan,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Name text
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mohammed',
              style: GoogleFonts.syne(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: glitchColor ?? AppColors.text0,
              ),
            ),
            Text(
              'Dilshad P',
              style: GoogleFonts.syne(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: glitchColor?.withOpacity(0.8) ?? AppColors.text1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════
// NAV LINK
// ══════════════════════════════════════════════
class _NavLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _NavLink(this.text, this.onTap);
  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: GoogleFonts.spaceMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _hov ? AppColors.cyan : AppColors.text1,
                  letterSpacing: 1,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                width: _hov ? 38 : 0,
                height: 1.5,
                margin: const EdgeInsets.only(top: 3),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.cyan, AppColors.violet],
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

// ══════════════════════════════════════════════
// SCROLL REVEAL
// ══════════════════════════════════════════════
class _Reveal extends StatefulWidget {
  final Widget child;
  final double fraction;
  const _Reveal({required this.child, this.fraction = 0.15});
  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal> {
  bool _vis = false;
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(widget.child.hashCode),
      onVisibilityChanged: (i) {
        if (i.visibleFraction > widget.fraction && !_vis)
          setState(() => _vis = true);
      },
      child: AnimatedOpacity(
        opacity: _vis ? 1 : 0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
        child: AnimatedSlide(
          offset: _vis ? Offset.zero : const Offset(0, 0.12),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// SECTION HEADER
// ══════════════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  final String tag;
  final String title;
  final String? sub;
  const _SectionHeader({required this.tag, required this.title, this.sub});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(30),
            color: AppColors.cyan.withOpacity(0.06),
          ),
          child: Text(
            tag.toUpperCase(),
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              color: AppColors.cyan,
              letterSpacing: 3,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppColors.text0, AppColors.text1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(b),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.syne(
              fontSize: w > 768 ? 48 : 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        if (sub != null) ...[
          const SizedBox(height: 14),
          Text(
            sub!,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.text1,
              height: 1.6,
            ),
          ),
        ],
      ],
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.2, end: 0);
  }
}

// ══════════════════════════════════════════════
// ORB
// ══════════════════════════════════════════════
class _Orb extends StatefulWidget {
  final double size;
  final Color color;
  final int delay;
  const _Orb({required this.size, required this.color, required this.delay});
  @override
  State<_Orb> createState() => _OrbState();
}

class _OrbState extends State<_Orb> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 18))
      ..repeat();
    if (widget.delay > 0) _c.value = widget.delay / 18;
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, __) => Transform.translate(
      offset: Offset(28 * sin(_c.value * 2 * pi), -22 * cos(_c.value * 2 * pi)),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withOpacity(0.07),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.15),
              blurRadius: 80,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    ),
  );
}

// ═══════ _FloatingCode, _FloatingLogo and _NeonBadge removed — no longer used ═══════

// ══════════════════════════════════════════════
// HERO GLITCH TITLE
// ══════════════════════════════════════════════
class _HeroGlitchTitle extends StatefulWidget {
  @override
  State<_HeroGlitchTitle> createState() => _HeroGlitchTitleState();
}

class _HeroGlitchTitleState extends State<_HeroGlitchTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmer;
  bool _glitch = false;
  static const _name = 'Mohammed Dilshad P';

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _scheduleGlitch();
  }

  void _scheduleGlitch() async {
    while (mounted) {
      await Future.delayed(
        Duration(milliseconds: 3500 + math.Random().nextInt(4000)),
      );
      if (!mounted) return;
      setState(() => _glitch = true);
      await Future.delayed(const Duration(milliseconds: 180));
      if (!mounted) return;
      setState(() => _glitch = false);
    }
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final fontSize = w > 768 ? 68.0 : 34.0;
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        children: [
          if (_glitch)
            Transform.translate(
              offset: const Offset(4, 2),
              child: Opacity(
                opacity: 0.7,
                child: ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [AppColors.pink, AppColors.pink],
                  ).createShader(b),
                  child: _buildTitle(fontSize, clipRight: true),
                ),
              ),
            ),
          if (_glitch)
            Transform.translate(
              offset: const Offset(-4, -2),
              child: Opacity(
                opacity: 0.7,
                child: ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [AppColors.cyan, AppColors.cyan],
                  ).createShader(b),
                  child: _buildTitle(fontSize, clipLeft: true),
                ),
              ),
            ),
          ShaderMask(
            shaderCallback: (b) => LinearGradient(
              colors: const [AppColors.text0, AppColors.cyan, AppColors.text0],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _shimmer.value * 3, 0),
              end: Alignment(0.0 + _shimmer.value * 3, 0),
            ).createShader(b),
            child: _buildTitle(fontSize),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(
    double fontSize, {
    bool clipRight = false,
    bool clipLeft = false,
  }) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: _name.split('').asMap().entries.map((e) {
        return Text(
              e.value == ' ' ? '\u00A0' : e.value,
              style: GoogleFonts.syne(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms, delay: (400 + e.key * 40).ms)
            .slideY(
              begin: 0.5,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOutBack,
            );
      }).toList(),
    );
  }
}

// ══════════════════════════════════════════════
// TYPEWRITER
// ══════════════════════════════════════════════
class _Typewriter extends StatefulWidget {
  final List<String> texts;
  const _Typewriter({required this.texts});
  @override
  State<_Typewriter> createState() => _TypewriterState();
}

class _TypewriterState extends State<_Typewriter>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursor;
  int _idx = 0;
  String _current = '';
  @override
  void initState() {
    super.initState();
    _cursor = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..repeat(reverse: true);
    _run();
  }

  @override
  void dispose() {
    _cursor.dispose();
    super.dispose();
  }

  void _run() async {
    while (mounted) {
      final target = widget.texts[_idx];
      for (int i = 0; i <= target.length; i++) {
        if (!mounted) return;
        setState(() => _current = target.substring(0, i));
        await Future.delayed(const Duration(milliseconds: 80));
      }
      await Future.delayed(const Duration(seconds: 2));
      for (int i = target.length; i >= 0; i--) {
        if (!mounted) return;
        setState(() => _current = target.substring(0, i));
        await Future.delayed(const Duration(milliseconds: 45));
      }
      _idx = (_idx + 1) % widget.texts.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _cursor,
      builder: (_, __) => Text(
        _current + (_cursor.value > 0.5 ? '|' : ' '),
        style: GoogleFonts.spaceMono(
          fontSize: 17,
          color: AppColors.cyan,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// AVATAR RING
// ══════════════════════════════════════════════
class _AvatarRing extends StatefulWidget {
  @override
  State<_AvatarRing> createState() => _AvatarRingState();
}

class _AvatarRingState extends State<_AvatarRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  double _rx = 0, _ry = 0;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) {
        final s = context.size ?? const Size(200, 200);
        setState(() {
          _ry = (e.localPosition.dx - s.width / 2) / 80;
          _rx = (s.height / 2 - e.localPosition.dy) / 80;
        });
      },
      onExit: (_) => setState(() {
        _rx = 0;
        _ry = 0;
      }),
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_rx)
            ..rotateY(_ry),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulse ring
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cyan.withOpacity(
                      0.15 + sin(_c.value * 2 * pi) * 0.12,
                    ),
                    width: 1,
                  ),
                ),
              ),
              // Spinning gradient ring
              Container(
                width: 196,
                height: 196,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: const [
                      AppColors.cyan,
                      AppColors.violet,
                      AppColors.pink,
                      AppColors.cyan,
                    ],
                    transform: GradientRotation(_c.value * 2 * pi),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withOpacity(0.4),
                      blurRadius: 28,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: AppColors.violet.withOpacity(0.3),
                      blurRadius: 50,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3.5),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bg0, width: 4),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/profile_logo.jpg'),
                      fit: BoxFit.cover,
                    ),
                    color: AppColors.bg2,
                  ),
                ),
              ),
              // Status dot
              Positioned(
                right: 18,
                bottom: 18,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bg0,
                    border: Border.all(color: AppColors.bg0, width: 3),
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.green,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green.withOpacity(0.6),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
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

// ══════════════════════════════════════════════
// CYBER BUTTON
// ══════════════════════════════════════════════
class _CyberButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;
  const _CyberButton({
    required this.text,
    required this.icon,
    required this.primary,
    required this.onTap,
  });
  @override
  State<_CyberButton> createState() => _CyberButtonState();
}

class _CyberButtonState extends State<_CyberButton>
    with SingleTickerProviderStateMixin {
  bool _hov = false;
  Offset _mag = Offset.zero;
  late AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  void _move(PointerEvent e) {
    final box = context.findRenderObject() as RenderBox;
    final local = box.globalToLocal(e.position);
    final s = box.size;
    setState(
      () => _mag = Offset(
        (local.dx - s.width / 2) * 0.12,
        (local.dy - s.height / 2) * 0.12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {
        setState(() => _hov = true);
        _move(e);
      },
      onExit: (_) => setState(() {
        _hov = false;
        _mag = Offset.zero;
      }),
      onHover: _move,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _shimmer,
          builder: (_, __) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(_mag.dx, _mag.dy, 0),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
            decoration: widget.primary
                ? BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.cyan, AppColors.violet],
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyan.withOpacity(_hov ? 0.55 : 0.28),
                        blurRadius: _hov ? 35 : 18,
                      ),
                      BoxShadow(
                        color: AppColors.violet.withOpacity(_hov ? 0.35 : 0.15),
                        blurRadius: _hov ? 50 : 25,
                      ),
                    ],
                  )
                : BoxDecoration(
                    color: AppColors.glass,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: _hov
                          ? AppColors.cyan.withOpacity(0.7)
                          : AppColors.glassB,
                    ),
                    boxShadow: _hov
                        ? [
                            BoxShadow(
                              color: AppColors.cyan.withOpacity(0.15),
                              blurRadius: 20,
                            ),
                          ]
                        : null,
                  ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  widget.icon,
                  color: widget.primary
                      ? Colors.white
                      : (_hov ? AppColors.cyan : AppColors.text1),
                  size: 15,
                ),
                const SizedBox(width: 9),
                Text(
                  widget.text,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: widget.primary
                        ? Colors.white
                        : (_hov ? AppColors.cyan : AppColors.text0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// SOCIAL BUTTON
// ══════════════════════════════════════════════
class _SocialBtn extends StatefulWidget {
  final IconData icon;
  final String url;
  const _SocialBtn({required this.icon, required this.url});
  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _hov = false;
  Future<void> _open() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      if (widget.url.startsWith('mailto:')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening your email client...', style: GoogleFonts.inter()),
            backgroundColor: AppColors.cyan.withOpacity(0.85),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open email client. Please email dilshadgb750@gmail.com directly',
              style: GoogleFonts.inter()),
          backgroundColor: Colors.redAccent.withOpacity(0.85),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          width: 44,
          height: 44,
          transform: _hov
              ? Matrix4.translationValues(0, -4, 0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hov ? AppColors.cyan.withOpacity(0.15) : AppColors.glass,
            border: Border.all(color: _hov ? AppColors.cyan : AppColors.glassB),
            boxShadow: _hov
                ? [
                    BoxShadow(
                      color: AppColors.cyan.withOpacity(0.3),
                      blurRadius: 16,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: FaIcon(
              widget.icon,
              size: 17,
              color: _hov ? AppColors.cyan : AppColors.text1,
            ),
          ),
        ),
      ),
    );
  }
}

// _TechBadge class removed — no longer used in codebase

// ══════════════════════════════════════════════
// BOUNCE ARROW
// ══════════════════════════════════════════════
class _BounceArrow extends StatefulWidget {
  @override
  State<_BounceArrow> createState() => _BounceArrowState();
}

class _BounceArrowState extends State<_BounceArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: const FaIcon(
          FontAwesomeIcons.chevronDown,
          size: 20,
          color: AppColors.text2,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// HERO SECTION — Split Cinematic Layout
// ══════════════════════════════════════════════
class HeroSection extends StatelessWidget {
  final Function(String) onNav;
  const HeroSection({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return Container(
      constraints: BoxConstraints(minHeight: size.height),
      color: AppColors.bg0,
      child: Stack(
        children: [
          const Positioned.fill(child: _ConstellationBg()),
          // Orbs (reduced opacity)
          Positioned(top: -160, right: -90,
            child: _Orb(size: 520, color: AppColors.violet, delay: 0)),
          Positioned(bottom: -90, left: -80,
            child: _Orb(size: 400, color: AppColors.cyan, delay: 6)),
          Positioned(top: size.height * 0.32, left: size.width * 0.3,
            child: _Orb(size: 300, color: AppColors.pink, delay: 12)),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? size.width * 0.07 : 24,
                vertical: isWide ? 80 : 40,
              ),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 55, child: _HeroLeftColumn(onNav: onNav)),
                        const SizedBox(width: 48),
                        Expanded(flex: 45, child: _HeroRightColumn()),
                      ],
                    )
                  : Column(
                      children: [
                        _HeroRightColumn(isMobile: true),
                        const SizedBox(height: 40),
                        _HeroLeftColumn(onNav: onNav, isMobile: true),
                      ],
                    ),
            ),
          ),

          // Bottom gradient divider
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.cyan.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Hero Left Column
// ──────────────────────────────────────────────
class _HeroLeftColumn extends StatelessWidget {
  final Function(String) onNav;
  final bool isMobile;
  const _HeroLeftColumn({required this.onNav, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final fontSize = isMobile ? 40.0 : 72.0;
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Availability pill
        _AvailabilityPill()
            .animate().fadeIn(delay: 200.ms, duration: 600.ms)
            .slideX(begin: -0.3, end: 0),
        const SizedBox(height: 28),

        // 2. Name with shimmer (no glitch — glitch is only on navbar)
        _HeroNameTitle(fontSize: fontSize, isMobile: isMobile)
            .animate().fadeIn(delay: 400.ms, duration: 800.ms),
        const SizedBox(height: 20),

        // 3. Role typewriter
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'I am a ',
              style: GoogleFonts.spaceMono(
                fontSize: 16,
                color: AppColors.text1,
              ),
            ),
            _Typewriter(
              texts: const [
                'Flutter Developer',
                'Mobile App Architect',
                'UI/UX Craftsman',
                'Clean Code Believer',
                'Problem Solver',
              ],
            ),
          ],
        ).animate().fadeIn(delay: 800.ms, duration: 700.ms),
        const SizedBox(height: 20),

        // 4. Bio snippet
        Text(
          'Flutter Developer crafting production-ready apps —\nAlizo, NaDodi & Adam Travels.',
          style: GoogleFonts.inter(fontSize: 15, color: AppColors.text1, height: 1.7),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ).animate().fadeIn(delay: 1000.ms, duration: 700.ms),
        const SizedBox(height: 36),

        // 5. CTA buttons
        _HeroCTARow(onNav: onNav, isMobile: isMobile)
            .animate().fadeIn(delay: 1200.ms, duration: 700.ms),
        const SizedBox(height: 28),

        // 6. Social links row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SocialBtn(icon: FontAwesomeIcons.github, url: 'https://github.com/mhd-dilshad-p'),
            const SizedBox(width: 12),
            _SocialBtn(icon: FontAwesomeIcons.linkedinIn, url: 'https://linkedin.com/in/mhd-dilshad-p'),
            const SizedBox(width: 12),
            _SocialBtn(icon: FontAwesomeIcons.envelope, url: 'mailto:dilshadgb750@gmail.com'),
          ],
        ).animate().fadeIn(delay: 1200.ms, duration: 700.ms),
        const SizedBox(height: 32),

        // 7. Tech stack strip
        _HeroTechStrip()
            .animate().fadeIn(delay: 1400.ms, duration: 700.ms),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Availability Pill
// ──────────────────────────────────────────────
class _AvailabilityPill extends StatefulWidget {
  @override
  State<_AvailabilityPill> createState() => _AvailabilityPillState();
}

class _AvailabilityPillState extends State<_AvailabilityPill>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.08),
        border: Border.all(color: AppColors.green.withOpacity(0.35)),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: AppColors.green.withOpacity(0.1), blurRadius: 14)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) => Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green,
                boxShadow: [BoxShadow(
                  color: AppColors.green.withOpacity(0.3 + 0.4 * _pulse.value),
                  blurRadius: 6 + 4 * _pulse.value,
                )],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '🟢 Available for hire',
            style: GoogleFonts.spaceMono(fontSize: 12, color: AppColors.green),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Hero Name Title (shimmer only, NO glitch)
// ──────────────────────────────────────────────
class _HeroNameTitle extends StatefulWidget {
  final double fontSize;
  final bool isMobile;
  const _HeroNameTitle({required this.fontSize, this.isMobile = false});
  @override
  State<_HeroNameTitle> createState() => _HeroNameTitleState();
}

class _HeroNameTitleState extends State<_HeroNameTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) => Column(
        crossAxisAlignment:
            widget.isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          _buildLine('Mohammed', 0),
          _buildLine('Dilshad P', 18),
        ],
      ),
    );
  }

  Widget _buildLine(String text, int baseDelay) {
    return Wrap(
      children: text.split('').asMap().entries.map((e) {
        return Text(
          e.value == ' ' ? ' ' : e.value,
          style: GoogleFonts.syne(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w700,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: const [AppColors.text0, AppColors.cyan, AppColors.text0],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment(-1.0 + _shimmer.value * 3, 0),
                end: Alignment(0.0 + _shimmer.value * 3, 0),
              ).createShader(const Rect.fromLTWH(0, 0, 400, 120)),
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: (400 + baseDelay + e.key * 40).ms)
            .slideY(begin: 0.5, end: 0, duration: 500.ms, curve: Curves.easeOutBack);
      }).toList(),
    );
  }
}

// ──────────────────────────────────────────────
// Hero CTA Row
// ──────────────────────────────────────────────
class _HeroCTARow extends StatelessWidget {
  final Function(String) onNav;
  final bool isMobile;
  const _HeroCTARow({required this.onNav, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _CyberButton(
        text: 'View Projects',
        icon: FontAwesomeIcons.rocket,
        primary: true,
        onTap: () => onNav('projects'),
      ),
      _CyberButton(
        text: 'Get in Touch',
        icon: FontAwesomeIcons.envelope,
        primary: false,
        onTap: () => onNav('contact'),
      ),
      const _HeroDownloadCVBtn(),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: buttons,
    );
  }
}

// ──────────────────────────────────────────────
// Hero Tech Strip
// ──────────────────────────────────────────────
class _HeroTechStrip extends StatelessWidget {
  const _HeroTechStrip();

  @override
  Widget build(BuildContext context) {
    final techs = [
      {'label': 'Flutter', 'assetPath': 'assets/icons/flutter.png', 'icon': FontAwesomeIcons.code, 'color': const Color(0xFF54C5F8)},
      {'label': 'Dart', 'assetPath': 'assets/icons/dart.png', 'icon': FontAwesomeIcons.d, 'color': const Color(0xFF00B4AB)},
      {'label': 'Firebase', 'assetPath': 'assets/icons/firebase.png', 'icon': FontAwesomeIcons.fire, 'color': const Color(0xFFFFCA28)},
      {'label': 'Supabase', 'assetPath': 'assets/icons/supabase.png', 'icon': FontAwesomeIcons.database, 'color': const Color(0xFF3ECF8E)},
      {'label': 'GitHub', 'assetPath': 'assets/icons/GitHub.png', 'icon': FontAwesomeIcons.github, 'color': Colors.white},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: techs.map((t) => _HeroTechBadge(
          label: t['label'] as String,
          assetPath: t['assetPath'] as String,
          icon: t['icon'] as IconData,
          color: t['color'] as Color,
        )).toList(),
      ),
    );
  }
}

class _HeroTechBadge extends StatefulWidget {
  final String label, assetPath;
  final IconData icon;
  final Color color;
  const _HeroTechBadge({
    required this.label,
    required this.assetPath,
    required this.icon,
    required this.color,
  });
  @override
  State<_HeroTechBadge> createState() => _HeroTechBadgeState();
}

class _HeroTechBadgeState extends State<_HeroTechBadge> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _hov ? widget.color.withOpacity(0.1) : AppColors.glass,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hov ? widget.color.withOpacity(0.8) : AppColors.glassB,
          ),
          boxShadow: _hov
              ? [BoxShadow(color: widget.color.withOpacity(0.25), blurRadius: 16)]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              widget.assetPath,
              width: 16,
              height: 16,
              errorBuilder: (_, __, ___) =>
                  FaIcon(widget.icon, size: 14, color: widget.color),
            ),
            const SizedBox(width: 7),
            Text(
              widget.label,
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                color: _hov ? widget.color : AppColors.text1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Hero Right Column — Premium Avatar Display
// ──────────────────────────────────────────────
class _HeroRightColumn extends StatelessWidget {
  final bool isMobile;
  const _HeroRightColumn({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Center(child: _HeroPremiumAvatar(isMobile: isMobile));
  }
}

class _HeroPremiumAvatar extends StatefulWidget {
  final bool isMobile;
  const _HeroPremiumAvatar({this.isMobile = false});
  @override
  State<_HeroPremiumAvatar> createState() => _HeroPremiumAvatarState();
}

class _HeroPremiumAvatarState extends State<_HeroPremiumAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  double _rx = 0, _ry = 0;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.isMobile ? 220.0 : 320.0;
    final h = widget.isMobile ? 280.0 : 400.0;

    return MouseRegion(
      onHover: (e) {
        final s = context.size ?? Size(w, h);
        setState(() {
          _ry = (e.localPosition.dx - s.width / 2) / 100;
          _rx = (s.height / 2 - e.localPosition.dy) / 100;
        });
      },
      onExit: (_) => setState(() { _rx = 0; _ry = 0; }),
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_rx)
            ..rotateY(_ry),
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Radial violet glow behind
              Container(
                width: w + 60,
                height: h + 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.violet.withOpacity(0.18),
                      blurRadius: 80,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),

              // Animated gradient border container
              Container(
                width: w + 4,
                height: h + 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: SweepGradient(
                    colors: const [
                      AppColors.cyan,
                      AppColors.violet,
                      AppColors.pink,
                      AppColors.cyan,
                    ],
                    transform: GradientRotation(_c.value * 2 * pi),
                  ),
                  boxShadow: [
                    BoxShadow(color: AppColors.cyan.withOpacity(0.3), blurRadius: 25),
                    BoxShadow(color: AppColors.violet.withOpacity(0.2), blurRadius: 50),
                  ],
                ),
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/profile_logo.jpg',
                    width: w,
                    height: h,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => Container(
                      width: w,
                      height: h,
                      color: AppColors.bg2,
                      child: const Center(
                        child: FaIcon(FontAwesomeIcons.user, color: AppColors.cyan, size: 64),
                      ),
                    ),
                  ),
                ),
              ),

              // Floating stat badge: top-left — "3+ Projects"
              Positioned(
                top: widget.isMobile ? -12 : -16,
                left: widget.isMobile ? -12 : -20,
                child: _FloatingStatChip(
                  label: '3+ Projects',
                  icon: FontAwesomeIcons.rocket,
                  floatOffset: 0,
                ),
              ),

              // Floating stat badge: bottom-left — "1 Years"
              Positioned(
                bottom: widget.isMobile ? -12 : -16,
                left: widget.isMobile ? -12 : -20,
                child: _FloatingStatChip(
                  label: '1 Years',
                  icon: FontAwesomeIcons.clock,
                  floatOffset: 0.8,
                ),
              ),

              // Floating stat badge: right — "Flutter Dev"
              Positioned(
                right: widget.isMobile ? -14 : -24,
                top: h / 2 - 22,
                child: _FloatingStatChip(
                  label: 'Flutter Dev',
                  icon: FontAwesomeIcons.code,
                  floatOffset: 1.6,
                ),
              ),

              // Available chip at bottom-right of image
              Positioned(
                bottom: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.bg0.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.green.withOpacity(0.5)),
                    boxShadow: [BoxShadow(color: AppColors.green.withOpacity(0.15), blurRadius: 12)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 7, height: 7,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.green,
                          boxShadow: [BoxShadow(color: AppColors.green.withOpacity(0.7), blurRadius: 5)],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('Available', style: GoogleFonts.spaceMono(fontSize: 9, color: AppColors.text0)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 900.ms, delay: 300.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), curve: Curves.easeOut);
  }
}

// ──────────────────────────────────────────────
// Floating Stat Chip
// ──────────────────────────────────────────────
class _FloatingStatChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final double floatOffset;
  const _FloatingStatChip({required this.label, required this.icon, required this.floatOffset});
  @override
  State<_FloatingStatChip> createState() => _FloatingStatChipState();
}

class _FloatingStatChipState extends State<_FloatingStatChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500))
      ..repeat(reverse: true);
    if (widget.floatOffset > 0) _c.value = widget.floatOffset / (2 * pi);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, sin(_c.value * pi) * 6 - 3),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.bg2.withOpacity(0.92),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.glassB),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(widget.icon, size: 11, color: AppColors.cyan),
              const SizedBox(width: 6),
              Text(widget.label,
                style: GoogleFonts.syne(fontSize: 11, color: AppColors.text0, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// ABOUT SECTION
// ══════════════════════════════════════════════
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg1,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'About Me',
            title: 'Passionate Developer,\nUnique Perspective',
          ),
          const SizedBox(height: 64),
          LayoutBuilder(
            builder: (ctx, cons) {
              if (cons.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _AboutImageCard()),
                    const SizedBox(width: 64),
                    Expanded(child: const _AboutContent()),
                  ],
                );
              }
              return Column(
                children: [
                  _AboutImageCard(),
                  const SizedBox(height: 48),
                  const _AboutContent(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AboutImageCard extends StatefulWidget {
  @override
  State<_AboutImageCard> createState() => _AboutImageCardState();
}

class _AboutImageCardState extends State<_AboutImageCard> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        transform: _hov
            ? (Matrix4.identity()..translate(0.0, -6.0))
            : Matrix4.identity(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glow
            if (_hov)
              Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withOpacity(0.25),
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            // Full body shot with bottom fade
            Container(
              width: 308,
              height: 420,
              decoration: BoxDecoration(
                boxShadow: _hov
                    ? [
                        BoxShadow(
                          color: AppColors.cyan.withOpacity(0.15),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ]
                    : [],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/screen2image.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.bg0.withOpacity(0.4),
                            AppColors.bg0,
                          ],
                          stops: const [0.6, 0.85, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Overlay badge
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bg0.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.green,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green.withOpacity(0.6),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Available for hire',
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        color: AppColors.text0,
                      ),
                    ),
                  ],
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
  const _AboutContent();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppColors.text0, AppColors.cyan],
          ).createShader(b),
          child: Text(
            'Passionate Developer, Real-World Builder',
            style: GoogleFonts.syne(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 32),
        const _AboutHighlightCard(
          icon: FontAwesomeIcons.personChalkboard,
          iconColor: AppColors.cyan,
          title: "Self-Driven & Passionate",
          body: "Passionate Flutter Developer driven by a deep love for technology and a commitment to continuous learning — picking up new concepts, tools, and best practices every single day. Transitioned into mobile development through focused self-driven training, channelling genuine curiosity into building real, complete applications from the ground up.",
          accentColor: AppColors.cyan,
          index: 0,
        ),
        const SizedBox(height: 16),
        const _AboutHighlightCard(
          icon: FontAwesomeIcons.layerGroup,
          iconColor: AppColors.violet,
          title: "Real-World Applications",
          body: "Creator of Alizo — a multi-service delivery platform built on Supabase empowering local store owners — and NaDodi, a comprehensive travel booking platform for flights, hotels, packages, and transfers. Every project is production-level, shipped, and complete.",
          accentColor: AppColors.violet,
          index: 1,
        ),
        const SizedBox(height: 16),
        const _AboutHighlightCard(
          icon: FontAwesomeIcons.heartPulse,
          iconColor: AppColors.pink,
          title: "Empathy-Driven Engineering",
          body: "My Bachelor of Social Work (BSW) background gives me a unique perspective — I approach every UI/UX problem with deep human empathy, strong command of Provider, Supabase, Firebase, REST APIs, and a commitment to clean architecture and modular development.",
          accentColor: AppColors.pink,
          index: 2,
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            _StatCard(number: '2', label: 'Production Apps'),
            _StatCard(number: '3+', label: 'Projects'),
            _StatCard(number: '1', label: 'Years'),
            _StatCard(number: '5+', label: 'Tech Stack'),
          ],
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cyan.withOpacity(0.04),
            border: const Border(left: BorderSide(color: AppColors.cyan, width: 3)),
            borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FaIcon(FontAwesomeIcons.quoteLeft, size: 16, color: AppColors.cyan),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  "Committed to clean architecture, modular development, and growing as a developer with every project built.",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.text1,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        const _GithubContributionsWidget(),
      ],
    );
  }
}

class _AboutHighlightCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final Color accentColor;
  final int index;
  
  const _AboutHighlightCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.accentColor,
    required this.index,
  });

  @override
  State<_AboutHighlightCard> createState() => _AboutHighlightCardState();
}

class _AboutHighlightCardState extends State<_AboutHighlightCard> {
  bool _hov = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        transform: _hov ? (Matrix4.identity()..translate(0.0, -5.0)) : Matrix4.identity(),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bg2,
          border: Border.all(
            color: _hov ? widget.accentColor : AppColors.glassB,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                width: 3,
                decoration: BoxDecoration(
                  color: widget.accentColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: _hov ? [BoxShadow(color: widget.accentColor, blurRadius: 8)] : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.iconColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: FaIcon(widget.icon, size: 14, color: widget.iconColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: GoogleFonts.syne(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.body,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.text1,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (150 * widget.index).ms).slideX(begin: -0.1, end: 0);
  }
}

class _StatCard extends StatefulWidget {
  final String number;
  final String label;
  const _StatCard({required this.number, required this.label});
  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        transform: _hov
            ? (Matrix4.identity()..translate(0.0, -5.0))
            : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.glass,
          border: Border.all(
            color: _hov ? AppColors.cyan.withOpacity(0.7) : AppColors.glassB,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: _hov
              ? [
                  BoxShadow(
                    color: AppColors.cyan.withOpacity(0.2),
                    blurRadius: 30,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [AppColors.cyan, AppColors.violet],
              ).createShader(b),
              child: Text(
                widget.number,
                style: GoogleFonts.syne(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.text2),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// EXPERIENCE SECTION
// ══════════════════════════════════════════════
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg0,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Experience',
            title: 'Professional Journey',
            sub:
                'My career path and the valuable experience gained along the way',
          ),
          const SizedBox(height: 64),
          Container(
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
                        colors: [
                          AppColors.cyan,
                          AppColors.violet,
                          AppColors.pink,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    _ExpCard(
                      title: 'Flutter Development Trainee',
                      company: 'Zoople Technologies',
                      date: '2025 – 2026',
                      items: const [
                        'Contributed to end-to-end Flutter application development lifecycle — UI, state management, and feature integration',
                        'Developed reusable Flutter widgets following clean code and modular architecture principles',
                        'Implemented Provider-based state management for predictable application behavior',
                        'Integrated Firebase services and REST APIs to enable dynamic data handling',
                        'Translated complex UI/UX designs into responsive Flutter interfaces for multiple screen sizes',
                        'Used Git and GitHub for version control, branching, and agile collaboration',
                      ],
                    ),
                    const SizedBox(height: 40),
                    _ExpCard(
                      title: 'Flutter Developer (Freelance)',
                      company: 'Adam Travels',
                      date: '2025',
                      color: AppColors.pink,
                      items: const [
                        'Independently scoped, designed, and developed a cross-platform Flutter application for a travel client from scratch',
                        'Implemented PDF ticket generation for travel bookings using the pdf and printing Flutter packages',
                        'Delivered production-ready app targeting Android, iOS, and Web from a single Flutter codebase',
                        'Managed client communication, requirement gathering, and iterative delivery independently',
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpCard extends StatefulWidget {
  final String title, company, date;
  final List<String> items;
  final Color color;
  const _ExpCard({
    required this.title,
    required this.company,
    required this.date,
    required this.items,
    this.color = AppColors.cyan,
  });
  @override
  State<_ExpCard> createState() => _ExpCardState();
}

class _ExpCardState extends State<_ExpCard> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 48, bottom: 48),
      child: Stack(
        children: [
          // Dot
          Positioned(
            left: -41,
            top: 4,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                border: Border.all(color: AppColors.bg0, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.7),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          MouseRegion(
            onEnter: (_) => setState(() => _hov = true),
            onExit: (_) => setState(() => _hov = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              transform: _hov
                  ? (Matrix4.identity()..translate(8.0, 0.0))
                  : Matrix4.identity(),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.glass,
                border: Border.all(
                  color: _hov
                      ? AppColors.cyan.withOpacity(0.6)
                      : AppColors.glassB,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: _hov
                    ? [
                        BoxShadow(
                          color: AppColors.cyan.withOpacity(0.12),
                          blurRadius: 40,
                        ),
                      ]
                    : null,
              ),
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
                              style: GoogleFonts.syne(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.company,
                              style: GoogleFonts.spaceMono(
                                fontSize: 13,
                                color: AppColors.cyan,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bg3,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.glassB),
                        ),
                        child: Text(
                          widget.date,
                          style: GoogleFonts.spaceMono(
                            fontSize: 11,
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ...widget.items.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2, right: 10),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.cyan,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.cyan.withOpacity(0.5),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              r,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.text1,
                                height: 1.65,
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
    ).animate().fadeIn().slideX(begin: -0.08, end: 0);
  }
}

// ══════════════════════════════════════════════
// PROJECTS SECTION — 3D flip cards
// ══════════════════════════════════════════════
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg1,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Portfolio',
            title: 'Featured Projects',
            sub: 'A selection of my recent work and technical achievements',
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 32,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: [
              _FlipProjectCard(
                title: 'Alizo',
                logoAsset: 'assets/images/alizo_logo.png',
                accentColor: AppColors.violet,
                technologies: const ['Flutter', 'Dart', 'Supabase', 'Provider', 'Vercel', 'OneSignal'],
                description:
                    'A production-ready multi-service delivery & marketplace platform empowering local vendors in Kerala — restaurants, groceries, pharmacies, and retail. Four integrated Flutter apps (Customer, Vendor, Rider, Admin Web) with real-time order tracking, multi-store checkout, and Supabase PostgreSQL backend.',
                features: const [
                  'Modular architecture',
                  'Provider state management',
                  'Supabase Auth & Database',
                  'Multi-store checkout',
                ],
                githubUrl: 'https://github.com/mhd-dilshad-p',
              ),
              _FlipProjectCard(
                title: 'Adam Travels',
                logoAsset: 'assets/images/adam_logo.png',
                accentColor: AppColors.text1,
                technologies: const ['Flutter', 'Dart', 'Web', 'Mobile'],
                description:
                    'Freelance project — a cross-platform Flutter app for Adam Travels that generates clean, formatted travel ticket PDFs. Built for both web and mobile. 🔒 Private Repo.',
                features: const [
                  'Cross-platform Web & Mobile',
                  'Clean code principles',
                  'Git version control',
                  'Production architecture',
                ],
                githubUrl: 'https://github.com/mhd-dilshad-p',
                isPrivate: true,
              ),
              _FlipProjectCard(
                title: 'Nadodi',
                logoAsset: 'assets/images/nadodi_logo.jpg',
                accentColor: AppColors.pink,
                technologies: const ['Flutter', 'Dart', 'Firebase', 'REST API', 'JS Backend', 'Admin Web'],
                description:
                    'A production-ready Flutter travel booking platform covering flight booking, hotel reservations, cab transfers, and tour packages. Features QR code booking verification, PDF ticket generation, local notifications, and a web-based admin dashboard — powered by Firebase and a custom JavaScript backend.',
                features: const [
                  'Dynamic UI/UX & animations',
                  'PDF ticket generation & QR verification',
                  'Integrated admin dashboard',
                  'REST API & Firebase backend',
                ],
                githubUrl: 'https://github.com/mhd-dilshad-p',
              ),
              _FlipProjectCard(
                title: 'FuelDost',
                logoAsset: 'assets/images/fuel_dost_logo.png',
                accentColor: AppColors.cyan,
                technologies: const ['Flutter', 'Dart', 'Provider', 'Maps APIs'],
                description:
                    'A complete fuel price calculation, location-based search, and navigation application. Includes seamless workflow to estimate trip costs, search for nearby stations, and initiate navigation.',
                features: const [
                  'Fuel price calculation',
                  'Location-based search',
                  'Navigation integration',
                  'Trip cost estimation',
                ],
                githubUrl: 'https://github.com/mhd-dilshad-p/Fuel-Dost',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlipProjectCard extends StatefulWidget {
  final String title, logoAsset, description, githubUrl;
  final bool isPrivate;
  final Color accentColor;
  final List<String> technologies, features;
  const _FlipProjectCard({
    required this.title,
    required this.logoAsset,
    required this.accentColor,
    required this.technologies,
    required this.description,
    required this.features,
    required this.githubUrl,
    this.isPrivate = false,
  });
  @override
  State<_FlipProjectCard> createState() => _FlipProjectCardState();
}

class _FlipProjectCardState extends State<_FlipProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flip;
  late Animation<double> _angle;
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    _flip = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _angle = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(parent: _flip, curve: Curves.easeInOutCubic));
  }

  @override
  void dispose() {
    _flip.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_flipped) {
      _flip.reverse();
    } else {
      _flip.forward();
    }
    setState(() => _flipped = !_flipped);
  }

  Future<void> _openGithub() async {
    final uri = Uri.parse(widget.githubUrl);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _angle,
      builder: (_, __) {
        final isBack = _angle.value > pi / 2;
        return GestureDetector(
          onTap: _toggle,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_angle.value),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 340, minWidth: 300),
                height: 520,
                decoration: BoxDecoration(
                  color: AppColors.bg2,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: widget.accentColor.withOpacity(0.35),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withOpacity(0.15),
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: isBack
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(pi),
                          child: _CardBack(
                            title: widget.title,
                            accentColor: widget.accentColor,
                            features: widget.features,
                            githubUrl: widget.githubUrl,
                            isPrivate: widget.isPrivate,
                            onGithub: _openGithub,
                            onFlip: _toggle,
                          ),
                        )
                      : _CardFront(
                          title: widget.title,
                          logoAsset: widget.logoAsset,
                          accentColor: widget.accentColor,
                          technologies: widget.technologies,
                          description: widget.description,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn().slideY(begin: 0.25, end: 0);
  }
}

class _CardFront extends StatelessWidget {
  final String title, logoAsset, description;
  final Color accentColor;
  final List<String> technologies;
  const _CardFront({
    required this.title,
    required this.logoAsset,
    required this.description,
    required this.accentColor,
    required this.technologies,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient top
        Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accentColor.withOpacity(0.25), AppColors.bg2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  child: Image.asset(
                    logoAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to a default icon if image fails
                      return Container(
                        color: accentColor.withOpacity(0.2),
                        child: Icon(Icons.apps, size: 50, color: accentColor),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 180, 28, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.syne(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: accentColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        'TAP TO FLIP',
                        style: GoogleFonts.spaceMono(
                          fontSize: 8,
                          color: accentColor,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: technologies
                      .map(
                        (t) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bg3,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.glassB),
                          ),
                          child: Text(
                            t,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.text1,
                      height: 1.65,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Accent line
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor, accentColor.withOpacity(0.3)],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardBack extends StatelessWidget {
  final String title, githubUrl;
  final bool isPrivate;
  final Color accentColor;
  final List<String> features;
  final VoidCallback onGithub, onFlip;
  const _CardBack({
    required this.title,
    required this.accentColor,
    required this.features,
    required this.githubUrl,
    required this.onGithub,
    required this.onFlip,
    this.isPrivate = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg3,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (b) => LinearGradient(
                  colors: [accentColor, AppColors.text0],
                ).createShader(b),
                child: Text(
                  title,
                  style: GoogleFonts.syne(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onFlip,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.glassB),
                    color: AppColors.glass,
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.arrowRotateLeft,
                    size: 13,
                    color: AppColors.text1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 2,
            width: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor, accentColor.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Key Features',
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              color: accentColor,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3, right: 10),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor,
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      f,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.text1,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          if (isPrivate)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: accentColor.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.glassB,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.lock, size: 14, color: accentColor),
                  const SizedBox(width: 8),
                  Text(
                    'Private Repo',
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: onGithub,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: accentColor.withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(12),
                  color: accentColor.withOpacity(0.08),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.github,
                      size: 15,
                      color: accentColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'View on GitHub',
                      style: GoogleFonts.spaceMono(
                        fontSize: 12,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (title == 'Alizo')
            GestureDetector(
              onTap: () => showAlizoDeepDive(context),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.cyan.withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.cyan.withOpacity(0.12),
                  boxShadow: [
                    BoxShadow(color: AppColors.cyan.withOpacity(0.2), blurRadius: 15),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Deep Dive',
                      style: GoogleFonts.spaceMono(
                        fontSize: 13,
                        color: AppColors.cyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const FaIcon(
                      FontAwesomeIcons.arrowRight,
                      size: 12,
                      color: AppColors.cyan,
                    ),
                  ],
                ),
              ),
            ),
          if (title == 'Nadodi')
            GestureDetector(
              onTap: () => showNaDodiDeepDive(context),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.pink.withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.pink.withOpacity(0.12),
                  boxShadow: [
                    BoxShadow(color: AppColors.pink.withOpacity(0.2), blurRadius: 15),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Deep Dive',
                      style: GoogleFonts.spaceMono(
                        fontSize: 13,
                        color: AppColors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const FaIcon(
                      FontAwesomeIcons.arrowRight,
                      size: 12,
                      color: AppColors.pink,
                    ),
                  ],
                ),
              ),
            ),
          if (title == 'FuelDost')
            GestureDetector(
              onTap: () => showFuelDostDeepDive(context),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.cyan.withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.cyan.withOpacity(0.12),
                  boxShadow: [
                    BoxShadow(color: AppColors.cyan.withOpacity(0.2), blurRadius: 15),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Deep Dive',
                      style: GoogleFonts.spaceMono(
                        fontSize: 13,
                        color: AppColors.cyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const FaIcon(
                      FontAwesomeIcons.arrowRight,
                      size: 12,
                      color: AppColors.cyan,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// SKILLS SECTION — animated hex grid
// ══════════════════════════════════════════════
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg0,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Expertise',
            title: 'Technical Skills',
            sub: 'Technologies and tools I use to bring ideas to life',
          ),
          const SizedBox(height: 56),
          // Floating tech orbs row
          _FloatingTechRow(),
          const SizedBox(height: 56),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _SkillCard(
                icon: FontAwesomeIcons.code,
                title: 'Languages',
                color: AppColors.cyan,
                skills: const ['Dart', 'Flutter'],
              ),
              _SkillCard(
                icon: FontAwesomeIcons.layerGroup,
                title: 'State Management',
                color: AppColors.violet,
                skills: const ['Provider', 'Bloc ', 'Riverpod (Learning)'],
              ),
              const _SkillCard(
                icon: FontAwesomeIcons.server,
                title: 'Backend & APIs',
                color: AppColors.pink,
                skills: [
                  'Firebase Auth',
                  'Cloud Firestore',
                  'Supabase',
                  'REST API',
                  'Node.js',
                  'JavaScript',
                  'Vercel',
                ],
              ),
              const _SkillCard(
                icon: FontAwesomeIcons.screwdriverWrench,
                title: 'Dev Tools',
                color: Color(0xFFFFCA28),
                skills: ['Git', 'GitHub', 'Android Studio', 'VS Code'],
              ),
              const _SkillCard(
                icon: FontAwesomeIcons.mobileScreen,
                title: 'Mobile Concepts',
                color: AppColors.green,
                skills: const [
                  'Responsive UI',
                  'Widget Optimization',
                  'Navigation & Routing',
                  'Form Validation',
                  'Flutter Web',
                ],
              ),
              const _SkillCard(
                icon: FontAwesomeIcons.plug,
                title: 'Integrations',
                color: AppColors.violet,
                skills: [
                  'OneSignal',
                  'QR Code',
                  'PDF Generation',
                ],
              ),
              const _SkillCard(
                icon: FontAwesomeIcons.robot,
                title: 'AI Tools & Workflow',
                color: AppColors.cyan,
                skills: const [
                  'Claude AI',
                  'Google AI',
                  'Cursor',
                  'Windsurf',
                  'Stitch',
                  'Codex',
                ],
              ),
            ],
          ),
          const SizedBox(height: 64),
          const _CurrentlyLearningCard(),
        ],
      ),
    );
  }
}

class _FloatingTechRow extends StatefulWidget {
  @override
  State<_FloatingTechRow> createState() => _FloatingTechRowState();
}

class _FloatingTechRowState extends State<_FloatingTechRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  final _techs = [
    {
      'name': 'Flutter',
      'color': const Color(0xFF54C5F8),
      'assetPath': 'assets/icons/flutter.png',
      'icon': FontAwesomeIcons.code,
    },
    {
      'name': 'Dart',
      'color': const Color(0xFF00B4AB),
      'assetPath': 'assets/icons/dart.png',
      'icon': FontAwesomeIcons.d,
    },
    {
      'name': 'Firebase',
      'color': const Color(0xFFFFCA28),
      'assetPath': 'assets/icons/firebase.png',
      'icon': FontAwesomeIcons.fire,
    },
    {
      'name': 'Git',
      'color': const Color(0xFFF05032),
      'assetPath': null,
      'icon': FontAwesomeIcons.gitAlt,
    },
    {
      'name': 'GitHub',
      'color': Colors.white,
      'assetPath': 'assets/icons/GitHub.png',
      'icon': FontAwesomeIcons.github,
    },
    {
      'name': 'Supabase',
      'color': const Color.fromARGB(255, 19, 248, 2),
      'assetPath': 'assets/icons/supabase.png',
      'icon': FontAwesomeIcons.database,
    },
    {
      'name': 'Android',
      'color': const Color(0xFF3DDC84),
      'assetPath': 'assets/icons/android.png',
      'icon': FontAwesomeIcons.android,
    },
    {
      'name': 'IOS',
      'color': const Color.fromARGB(255, 251, 250, 250),
      'assetPath': 'assets/icons/apple.png',
      'icon': FontAwesomeIcons.apple,
    },
    {
      'name': 'Web',
      'color': const Color.fromARGB(255, 234, 21, 1),
      'assetPath': 'assets/icons/html.png',
      'icon': FontAwesomeIcons.html5,
    },
  ];
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: _techs.asMap().entries.map((e) {
          final offset = sin(_c.value * 2 * pi + e.key * 0.6) * 7;
          return Transform.translate(
            offset: Offset(0, offset),
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.glass,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: (e.value['color'] as Color).withOpacity(0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (e.value['color'] as Color).withOpacity(0.08),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (e.value['assetPath'] != null)
                    Image.asset(
                      e.value['assetPath'] as String,
                      width: 28,
                      height: 28,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          e.value['icon'] as IconData,
                          size: 28,
                          color: e.value['color'] as Color,
                        );
                      },
                    )
                  else
                    Icon(
                      e.value['icon'] as IconData,
                      size: 28,
                      color: e.value['color'] as Color,
                    ),
                  const SizedBox(height: 6),
                  Text(
                    e.value['name'] as String,
                    style: GoogleFonts.spaceMono(
                      fontSize: 9,
                      color: AppColors.text1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final List<String> skills;
  const _SkillCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.skills,
  });
  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(maxWidth: 290),
        padding: const EdgeInsets.all(28),
        transform: _hov
            ? (Matrix4.identity()..translate(0.0, -6.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: AppColors.glass,
          border: Border.all(
            color: _hov ? widget.color.withOpacity(0.7) : AppColors.glassB,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _hov
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.18),
                    blurRadius: 40,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: widget.color.withOpacity(0.4)),
                  ),
                  child: Center(
                    child: Icon(widget.icon, color: widget.color, size: 20),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.title,
                    style: GoogleFonts.syne(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.skills
                  .map((s) => _SkillChip(label: s, color: widget.color))
                  .toList(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.25, end: 0);
  }
}

class _SkillChip extends StatefulWidget {
  final String label;
  final Color color;
  const _SkillChip({required this.label, required this.color});
  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _hov ? widget.color.withOpacity(0.18) : AppColors.bg3,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hov ? widget.color.withOpacity(0.7) : AppColors.glassB,
          ),
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: _hov ? widget.color : AppColors.text1,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// EDUCATION SECTION
// ══════════════════════════════════════════════
class EducationSection extends StatelessWidget {
  const EducationSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg1,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Background',
            title: 'Education & Languages',
            sub: 'The academic journey and linguistic foundation behind the developer',
          ),
          const SizedBox(height: 64),
          LayoutBuilder(
            builder: (ctx, cons) {
              if (cons.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: const _EduTimeline()),
                    const SizedBox(width: 80),
                    Expanded(flex: 4, child: const _LanguagesAndSkills()),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _EduTimeline(),
                  const SizedBox(height: 64),
                  const _LanguagesAndSkills(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EduTimeline extends StatelessWidget {
  const _EduTimeline();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 6,
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.cyan, AppColors.violet, AppColors.pink],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Column(
          children: const [
            _EduTimelineCard(
              date: '2025',
              degree: 'Flutter Development Program',
              school: 'Zoople Technologies, Kerala',
              color: AppColors.cyan,
              iconBadge: '🎓',
              description: 'Intensive Flutter development program covering production-level app architecture, state management with Provider, Supabase & Firebase integration, REST API consumption, and real-world project delivery. Built Alizo and NaDodi during this program.',
              tags: ['Flutter', 'Dart', 'Supabase', 'Firebase', 'Provider'],
            ),
            SizedBox(height: 40),
            _EduTimelineCard(
              date: '2022 – 2025',
              degree: 'Bachelor of Social Work (BSW)',
              school: 'Calicut University, Kerala',
              color: AppColors.violet,
              iconBadge: '🏛️',
              description: 'Three-year undergraduate program in social sciences developing deep empathy, human-centered problem solving, and communication skills — the unique foundation that shapes my user-centric approach to Flutter development.',
              specialNote: 'This background directly influences how I craft user experiences in every app I build.',
              tags: ['Human-Centered Design', 'Communication', 'Problem Solving'],
            ),
            SizedBox(height: 40),
            _EduTimelineCard(
              date: '2021 – 2022',
              degree: 'Higher Secondary (Humanities)',
              school: 'Kerala State Board',
              color: AppColors.pink,
              iconBadge: '📚',
              description: 'Humanities stream with a focus on social sciences, building analytical thinking and a strong foundation in understanding human behaviour — skills that translate directly into intuitive UI/UX.',
              tags: ['Humanities', 'Social Sciences', 'Analytics'],
            ),
          ],
        ),
      ],
    );
  }
}

class _EduTimelineCard extends StatefulWidget {
  final String date, degree, school, iconBadge, description;
  final String? specialNote;
  final Color color;
  final List<String> tags;
  const _EduTimelineCard({
    required this.date,
    required this.degree,
    required this.school,
    required this.iconBadge,
    required this.description,
    required this.color,
    required this.tags,
    this.specialNote,
  });
  @override
  State<_EduTimelineCard> createState() => _EduTimelineCardState();
}

class _EduTimelineCardState extends State<_EduTimelineCard> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 48),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -41,
            top: 4,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                border: Border.all(color: AppColors.bg0, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.7),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          MouseRegion(
            onEnter: (_) => setState(() => _hov = true),
            onExit: (_) => setState(() => _hov = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              transform: _hov ? (Matrix4.identity()..translate(8.0, 0.0)) : Matrix4.identity(),
              decoration: BoxDecoration(
                color: AppColors.glass,
                border: Border.all(color: _hov ? widget.color.withOpacity(0.6) : AppColors.glassB),
                borderRadius: BorderRadius.circular(20),
                boxShadow: _hov ? [BoxShadow(color: widget.color.withOpacity(0.12), blurRadius: 40)] : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 3, color: widget.color),
                    Padding(
                      padding: const EdgeInsets.all(32),
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
                                      widget.degree,
                                      style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text0),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.school,
                                      style: GoogleFonts.spaceMono(fontSize: 12, color: widget.color),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.bg3,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.glassB),
                                ),
                                child: Text(
                                  widget.date,
                                  style: GoogleFonts.spaceMono(fontSize: 11, color: AppColors.text2),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.description,
                            style: GoogleFonts.inter(fontSize: 14, color: AppColors.text1, height: 1.65),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.tags.map((t) => _SkillChip(label: t, color: widget.color)).toList(),
                          ),
                          if (widget.specialNote != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              widget.specialNote!,
                              style: GoogleFonts.inter(fontSize: 13, color: AppColors.text2, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 24,
            right: 24,
            child: Text(widget.iconBadge, style: const TextStyle(fontSize: 24)),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.08, end: 0);
  }
}

class _LanguagesAndSkills extends StatelessWidget {
  const _LanguagesAndSkills();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LANGUAGES & SOFT SKILLS',
          style: GoogleFonts.spaceMono(fontSize: 14, color: AppColors.cyan, letterSpacing: 2),
        ),
        const SizedBox(height: 24),
        const _LanguageCard(flag: '🇬🇧', name: 'English', level: 'Professional', targetPercentage: 0.9, color: AppColors.cyan),
        const SizedBox(height: 16),
        const _LanguageCard(flag: '🇮🇳', name: 'Malayalam', level: 'Native', targetPercentage: 1.0, color: AppColors.violet),
        const SizedBox(height: 16),
        const _LanguageCard(flag: '🇮🇳', name: 'Tamil', level: 'Conversational', targetPercentage: 0.7, color: AppColors.pink),
        const SizedBox(height: 40),
        Text(
          'CORE STRENGTHS',
          style: GoogleFonts.spaceMono(fontSize: 11, color: AppColors.cyan, letterSpacing: 2),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _SkillDotChip(label: 'Self-Motivated', color: AppColors.cyan),
            _SkillDotChip(label: 'Fast Learner', color: AppColors.violet),
            _SkillDotChip(label: 'Problem Solver', color: AppColors.pink),
            _SkillDotChip(label: 'Team Player', color: AppColors.green),
          ],
        ),
      ],
    );
  }
}

class _LanguageCard extends StatefulWidget {
  final String flag, name, level;
  final double targetPercentage;
  final Color color;
  const _LanguageCard({required this.flag, required this.name, required this.level, required this.targetPercentage, required this.color});
  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        transform: _hov ? (Matrix4.identity()..translate(0.0, -4.0)) : Matrix4.identity(),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.glass,
          border: Border.all(color: _hov ? widget.color : AppColors.glassB),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _hov ? [BoxShadow(color: widget.color.withOpacity(0.15), blurRadius: 20)] : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(widget.flag, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.name,
                    style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.text0),
                  ),
                ),
                Text(
                  widget.level,
                  style: GoogleFonts.spaceMono(fontSize: 11, color: AppColors.text2),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: widget.targetPercentage),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, val, _) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      height: 4,
                      width: double.infinity,
                      decoration: BoxDecoration(color: AppColors.bg3, borderRadius: BorderRadius.circular(2)),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 4,
                        width: constraints.maxWidth * val,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(colors: [widget.color, widget.color.withOpacity(0.5)]),
                          boxShadow: [BoxShadow(color: widget.color.withOpacity(0.6), blurRadius: 6)],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillDotChip extends StatelessWidget {
  final String label;
  final Color color;
  const _SkillDotChip({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.glassB),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [BoxShadow(color: color, blurRadius: 4)],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.text1),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// CONTACT SECTION
// ══════════════════════════════════════════════
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg0,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Get in Touch',
            title: "Let's Work Together",
            sub: "Have a project in mind? I'd love to hear from you.",
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _ContactCard(
                assetPath: 'assets/icons/email.json',
                icon: FontAwesomeIcons.envelope,
                label: 'Email',
                value: 'dilshadgb750@gmail.com',
                url: 'mailto:dilshadgb750@gmail.com',
                color: AppColors.cyan,
              ),
              _ContactCard(
                assetPath: 'assets/icons/call.json',
                icon: FontAwesomeIcons.phone,
                label: 'Phone',
                value: '+91 97783 53618',
                url: 'tel:+919778353618',
                color: AppColors.violet,
              ),
              _ContactCard(
                assetPath: 'assets/icons/linkedin.json',
                icon: FontAwesomeIcons.linkedinIn,
                label: 'LinkedIn',
                value: 'mhd-dilshad-p',
                url: 'https://linkedin.com/in/mhd-dilshad-p',
                color: const Color(0xFF0A66C2),
              ),
              _ContactCard(
                assetPath: 'assets/icons/GitHub.png',
                icon: FontAwesomeIcons.github,
                label: 'GitHub',
                value: 'mhd-dilshad-p',
                url: 'https://github.com/mhd-dilshad-p',
                color: AppColors.text0,
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

class _ContactCard extends StatefulWidget {
  final String? assetPath;
  final IconData icon;
  final String label, value, url;
  final Color color;
  const _ContactCard({
    this.assetPath,
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
    required this.color,
  });
  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hov = false;
  Future<void> _open() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          transform: _hov
              ? (Matrix4.identity()..translate(0.0, -5.0))
              : Matrix4.identity(),
          constraints: const BoxConstraints(minWidth: 150, maxWidth: 190),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.glass,
            border: Border.all(
              color: _hov ? widget.color.withOpacity(0.7) : AppColors.glassB,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: _hov
                ? [
                    BoxShadow(
                      color: widget.color.withOpacity(0.2),
                      blurRadius: 35,
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withOpacity(0.12),
                  border: Border.all(color: widget.color.withOpacity(0.4)),
                  boxShadow: _hov
                      ? [
                          BoxShadow(
                            color: widget.color.withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child:
                      widget.assetPath != null &&
                          widget.assetPath!.endsWith('.json')
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: Lottie.asset(
                            widget.assetPath!,
                            errorBuilder: (context, error, stackTrace) {
                              return FaIcon(
                                widget.icon,
                                color: widget.color,
                                size: 18,
                              );
                            },
                          ),
                        )
                      : widget.assetPath != null
                      ? Image.asset(
                          widget.assetPath!,
                          width: 20,
                          height: 20,
                          color: widget.color,
                          errorBuilder: (context, error, stackTrace) {
                            return FaIcon(
                              widget.icon,
                              color: widget.color,
                              size: 18,
                            );
                          },
                        )
                      : FaIcon(widget.icon, color: widget.color, size: 18),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.label,
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  color: AppColors.text2,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.value,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.text0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm();
  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _subject = TextEditingController();
  final _msg = TextEditingController();

  Future<void> _submit() async {
    if (_key.currentState!.validate()) {
      final s = Uri.encodeComponent(_subject.text);
      final b = Uri.encodeComponent(
        'Name: ${_name.text}\nEmail: ${_email.text}\n\n${_msg.text}',
      );
      final uri = Uri.parse('mailto:dilshadgb750@gmail.com?subject=$s&body=$b');
      if (await canLaunchUrl(uri)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Opening your email client...', style: GoogleFonts.inter()),
          backgroundColor: AppColors.cyan.withOpacity(0.85),
          duration: const Duration(seconds: 2),
        ));
        await launchUrl(uri);
        _key.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Could not open email client. Please email dilshadgb750@gmail.com directly',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.redAccent.withOpacity(0.85),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 680),
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: AppColors.bg1,
        border: Border.all(color: AppColors.glassB),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.violet.withOpacity(0.08), blurRadius: 50),
        ],
      ),
      child: Form(
        key: _key,
        child: Column(
          children: [
            LayoutBuilder(
              builder: (_, cons) {
                if (cons.maxWidth > 480) {
                  return Row(
                    children: [
                      Expanded(
                        child: _Field(
                          label: 'Your Name',
                          hint: 'Enter Your Name',
                          ctrl: _name,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _Field(
                          label: 'Email',
                          hint: 'Enter Your Email',
                          ctrl: _email,
                          isEmail: true,
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    _Field(
                      label: 'Your Name',
                      hint: 'Enter your name',
                      ctrl: _name,
                    ),
                    const SizedBox(height: 20),
                    _Field(
                      label: 'Email',
                      hint: 'Enter your email',
                      ctrl: _email,
                      isEmail: true,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            _Field(label: 'Subject', hint: 'Project Inquiry', ctrl: _subject),
            const SizedBox(height: 20),
            _Field(
              label: 'Message',
              hint: 'Tell me about your project...',
              ctrl: _msg,
              isMsg: true,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: _CyberButton(
                text: 'Send Message',
                icon: FontAwesomeIcons.paperPlane,
                primary: true,
                onTap: _submit,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }
}

class _Field extends StatelessWidget {
  final String label, hint;
  final TextEditingController ctrl;
  final bool isEmail, isMsg;
  const _Field({
    required this.label,
    required this.hint,
    required this.ctrl,
    this.isEmail = false,
    this.isMsg = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            color: AppColors.text1,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          maxLines: isMsg ? 5 : 1,
          style: GoogleFonts.inter(fontSize: 15, color: AppColors.text0),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: AppColors.text2),
            filled: true,
            fillColor: AppColors.bg2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.glassB),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.glassB),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cyan),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Please enter $label';
            if (isEmail && !v.contains('@')) return 'Enter a valid email';
            if (!isEmail && !isMsg && v.trim().length < 2) return 'Must be at least 2 characters';
            return null;
          },
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════
// SECTION DIVIDER
// ══════════════════════════════════════════════
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: 1,
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              AppColors.cyan.withOpacity(0.2),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// FOOTER
// ══════════════════════════════════════════════
class _Footer extends StatelessWidget {
  const _Footer();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg1,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 48),
      child: Column(
        children: [
          _GlitchLogo(),
          const SizedBox(height: 14),
          Text(
            'Flutter Developer crafting beautiful mobile experiences',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.text2),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialBtn(
                icon: FontAwesomeIcons.github,
                url: 'https://github.com/mhd-dilshad-p',
              ),
              const SizedBox(width: 14),
              _SocialBtn(
                icon: FontAwesomeIcons.linkedinIn,
                url: 'https://linkedin.com/in/mhd-dilshad-p',
              ),
              const SizedBox(width: 14),
              _SocialBtn(
                icon: FontAwesomeIcons.envelope,
                url: 'mailto:dilshadgb750@gmail.com',
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            '© 2026 Mohammed Dilshad P. All rights reserved.',
            style: GoogleFonts.spaceMono(fontSize: 11, color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// NEW COMPONENTS
// ══════════════════════════════════════════════

class _AnimatedStatsBar extends StatefulWidget {
  const _AnimatedStatsBar();
  @override
  State<_AnimatedStatsBar> createState() => _AnimatedStatsBarState();
}

class _AnimatedStatsBarState extends State<_AnimatedStatsBar> {
  bool _vis = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('stats-bar'),
      onVisibilityChanged: (i) {
        if (i.visibleFraction > 0.2 && !_vis) {
          setState(() => _vis = true);
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: AppColors.bg1,
          border: const Border(
            top: BorderSide(color: AppColors.glassB),
            bottom: BorderSide(color: AppColors.glassB),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.violet.withOpacity(0.04),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Aurora glow behind stats
            Positioned(
              left: 50,
              top: 0,
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                     BoxShadow(color: AppColors.cyan.withOpacity(0.1), blurRadius: 60),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 40,
                runSpacing: 40,
                children: [
                  _StatItem(val: 3, suffix: '+', label: 'Projects Built', delay: 0, vis: _vis),
                  _StatItem(val: 2, label: 'Production Apps', delay: 150, vis: _vis),
                  _StatItem(val: 4, label: 'Flutter Apps (Alizo Platform)', delay: 300, vis: _vis),
                  _StatItem(val: 1, label: 'Freelance Client', delay: 450, vis: _vis),
                  _StatItem(val: 5, suffix: '+', label: 'Tech Stack', delay: 600, vis: _vis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatefulWidget {
  final int val;
  final String label;
  final String suffix;
  final int delay;
  final bool vis;
  const _StatItem({required this.val, required this.label, this.suffix = '', required this.delay, required this.vis});
  
  @override
  State<_StatItem> createState() => _StatItemState();
}

class _StatItemState extends State<_StatItem> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _hov ? (Matrix4.identity()..translate(0.0, -5.0)) : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _hov ? AppColors.cyan.withOpacity(0.5) : Colors.transparent),
          boxShadow: _hov ? [BoxShadow(color: AppColors.cyan.withOpacity(0.15), blurRadius: 20)] : null,
        ),
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [AppColors.cyan, AppColors.violet],
              ).createShader(b),
              child: widget.vis ? TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: widget.val.toDouble()),
                duration: Duration(milliseconds: 1200 + widget.delay),
                curve: Curves.easeOutCubic,
                builder: (context, val, child) {
                  return Text(
                    '${val.toInt()}${widget.suffix}',
                    style: GoogleFonts.syne(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  );
                },
              ) : Text(
                '0${widget.suffix}',
                style: GoogleFonts.syne(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: GoogleFonts.spaceMono(fontSize: 12, color: AppColors.text1),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg0,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Services',
            title: 'What I Build',
            sub: 'Specialized solutions bringing your ideas to production',
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              const _ServiceCard(
                icon: FontAwesomeIcons.mobileScreen,
                color: AppColors.cyan,
                title: 'Mobile Apps',
                desc: 'Cross-platform Flutter apps for Android & iOS with smooth animations, clean architecture, and production-ready code.',
                delay: 0,
              ),
              const _ServiceCard(
                icon: FontAwesomeIcons.globe,
                color: AppColors.violet,
                title: 'Web Applications',
                desc: 'Responsive Flutter Web apps with glassmorphism UI, real-time data, and seamless cross-platform experiences.',
                delay: 150,
              ),
              const _ServiceCard(
                icon: FontAwesomeIcons.server,
                color: AppColors.pink,
                title: 'Backend Integration',
                desc: 'Supabase, Firebase, REST APIs, and custom JavaScript backends — full-stack integration from auth to real-time data.',
                delay: 300,
              ),
              const _ServiceCard(
                icon: FontAwesomeIcons.penRuler,
                color: AppColors.green,
                title: 'UI/UX to Code',
                desc: 'Pixel-perfect translation of Figma/design mockups into responsive, animated Flutter interfaces.',
                delay: 450,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title, desc;
  final int delay;
  const _ServiceCard({super.key, required this.icon, required this.color, required this.title, required this.desc, required this.delay});
  
  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _hov ? (Matrix4.identity()..translate(0.0, -6.0)) : Matrix4.identity(),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: AppColors.bg2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _hov ? widget.color.withOpacity(0.6) : AppColors.glassB),
          boxShadow: _hov ? [BoxShadow(color: widget.color.withOpacity(0.15), blurRadius: 30)] : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [widget.color, widget.color.withOpacity(0.3)]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: _hov ? [BoxShadow(color: widget.color.withOpacity(0.4), blurRadius: 20)] : null,
                      ),
                      child: AnimatedScale(
                        scale: _hov ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: FaIcon(widget.icon, color: widget.color, size: 24),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.title,
                      style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text0),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.desc,
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.text1, height: 1.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: widget.delay.ms, duration: 700.ms).slideY(begin: 0.2, end: 0);
  }
}

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg1,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Kind Words',
            title: 'Testimonials',
            sub: 'What people say about working with me',
          ),
          const SizedBox(height: 64),
          const _TestimonialCard(),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatefulWidget {
  const _TestimonialCard({super.key});
  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> with SingleTickerProviderStateMixin {
  bool _hov = false;
  late AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedBuilder(
        animation: _shimmerCtrl,
        builder: (_, _child) {
          final t = _shimmerCtrl.value;
          final borderColor = _hov
              ? AppColors.violet.withOpacity(0.3 + 0.3 * sin(t * 2 * pi))
              : AppColors.glassB;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            constraints: const BoxConstraints(maxWidth: 700),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.glass,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
              boxShadow: _hov ? [BoxShadow(color: AppColors.violet.withOpacity(0.15), blurRadius: 40)] : null,
            ),
            child: _child,
          );
        },
        child: Stack(
          children: [
            Positioned(
              left: -10,
              top: -20,
              child: Text(
                '"',
                style: GoogleFonts.syne(fontSize: 80, fontWeight: FontWeight.w700, color: AppColors.cyan.withOpacity(0.3)),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (index) => const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: FaIcon(FontAwesomeIcons.star, color: AppColors.cyan, size: 14),
                  )),
                ),
                const SizedBox(height: 24),
                // TODO: Replace with real LinkedIn recommendation when available
                Text(
                  "Dilshad demonstrated exceptional dedication and technical skill throughout his training. His ability to build production-level Flutter applications — including a full multi-service platform with Supabase — sets him apart as a developer who thinks beyond the basics.",
                  style: GoogleFonts.inter(fontSize: 16, color: AppColors.text0, height: 1.8, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [AppColors.cyan, AppColors.violet]),
                      ),
                      child: Center(
                        child: Text(
                          "ZT",
                          style: GoogleFonts.spaceMono(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Training Lead", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text0)),
                        const SizedBox(height: 4),
                        Text("Zoople Technologies, Kerala", style: GoogleFonts.spaceMono(fontSize: 12, color: AppColors.text1)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0);
  }
}

class _HeroDownloadCVBtn extends StatefulWidget {
  const _HeroDownloadCVBtn({super.key});
  @override
  State<_HeroDownloadCVBtn> createState() => _HeroDownloadCVBtnState();
}

class _HeroDownloadCVBtnState extends State<_HeroDownloadCVBtn> {
  bool _hov = false;

  void _downloadCV() {
    html.AnchorElement(href: 'assets/assets/cv/mohammed_dilshad_p.pdf')
      ..setAttribute('download', 'mohammed_dilshad_p.pdf')
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _downloadCV,
        child: Column(
          children: [
            Text(
              "⬇ Download CV",
              style: GoogleFonts.spaceMono(
                fontSize: 13,
                color: _hov ? AppColors.cyan : AppColors.text1,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _hov ? 120 : 0,
              height: 1,
              margin: const EdgeInsets.only(top: 4),
              color: AppColors.cyan,
            ),
          ]
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// GITHUB CONTRIBUTIONS WIDGET
// ══════════════════════════════════════════════
class _GithubContributionsWidget extends StatefulWidget {
  const _GithubContributionsWidget();
  @override
  State<_GithubContributionsWidget> createState() => _GithubContributionsWidgetState();
}

class _GithubContributionsWidgetState extends State<_GithubContributionsWidget> {
  bool _vis = false;
  late final List<List<int>> _gridData;

  @override
  void initState() {
    super.initState();
    _gridData = List.generate(52, (colIndex) {
      return List.generate(7, (rowIndex) {
        final rnd = math.Random(colIndex * 7 + rowIndex);
        return rnd.nextInt(10);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('github-graph'),
      onVisibilityChanged: (i) {
        if (i.visibleFraction > 0.2 && !_vis) {
          setState(() => _vis = true);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.bg2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassB),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(52, (colIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Column(
                          children: List.generate(7, (rowIndex) {
                            // Stable grid data from initState
                            final level = _gridData[colIndex][rowIndex];
                            Color c = AppColors.bg3;
                            if (level > 8) c = AppColors.cyan;
                            else if (level > 6) c = AppColors.cyan.withOpacity(0.5);
                            else if (level > 4) c = AppColors.cyan.withOpacity(0.2);

                            final delay = (colIndex * 15) + (rowIndex * 5);

                            return Tooltip(
                              message: '${(level > 4 ? level : 0)} contributions',
                              child: _vis ? AnimatedOpacity(
                                duration: const Duration(milliseconds: 400),
                                opacity: 1.0,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.only(bottom: 2),
                                  decoration: BoxDecoration(
                                    color: c,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ).animate().fadeIn(delay: delay.ms),
                              ) : Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(bottom: 2),
                                color: Colors.transparent,
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse('https://github.com/mhd-dilshad-p');
                          if (await canLaunchUrl(uri)) await launchUrl(uri);
                        },
                        child: Text(
                          'mhd-dilshad-p on GitHub',
                          style: GoogleFonts.spaceMono(fontSize: 12, color: AppColors.text1, decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text('Less', style: GoogleFonts.spaceMono(fontSize: 10, color: AppColors.text2)),
                        const SizedBox(width: 4),
                        Container(width: 8, height: 8, color: AppColors.bg3),
                        const SizedBox(width: 2),
                        Container(width: 8, height: 8, color: AppColors.cyan.withOpacity(0.2)),
                        const SizedBox(width: 2),
                        Container(width: 8, height: 8, color: AppColors.cyan.withOpacity(0.5)),
                        const SizedBox(width: 2),
                        Container(width: 8, height: 8, color: AppColors.cyan),
                        const SizedBox(width: 4),
                        Text('More', style: GoogleFonts.spaceMono(fontSize: 10, color: AppColors.text2)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('// simulated github data', style: GoogleFonts.spaceMono(fontSize: 9, color: AppColors.text2.withOpacity(0.5))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// CURRENTLY LEARNING CARD
// ══════════════════════════════════════════════
class _CurrentlyLearningCard extends StatelessWidget {
  const _CurrentlyLearningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 800),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.glass,
        border: Border.all(color: AppColors.violet.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.violet.withOpacity(0.08),
            blurRadius: 30,
          )
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 600;
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: isSmall ? WrapAlignment.center : WrapAlignment.spaceBetween,
            spacing: 32,
            runSpacing: 32,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.violet.withOpacity(0.1),
                    ),
                    child: Center(
                      child: const FaIcon(FontAwesomeIcons.brain, color: AppColors.violet, size: 28)
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 1200.ms),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Currently Learning',
                        style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.text0),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Always growing, always building',
                        style: GoogleFonts.inter(fontSize: 14, color: AppColors.text1),
                      ),
                    ],
                  ),
                ],
              ),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: isSmall ? WrapAlignment.center : WrapAlignment.end,
                children: const [
                  _LearningChip(label: 'Bloc'),
                  _LearningChip(label: 'Riverpod'),
                  _LearningChip(label: 'GitHub Actions / CI-CD'),
                  _LearningChip(label: 'Flutter Testing'),
                  _LearningChip(label: 'GetX'),
                  _LearningChip(label: 'Clean Architecture'),
                ],
              ),
            ],
          );
        }
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }
}

class _LearningChip extends StatefulWidget {
  final String label;
  const _LearningChip({required this.label});
  @override
  State<_LearningChip> createState() => _LearningChipState();
}

class _LearningChipState extends State<_LearningChip> with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.violet.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.violet.withOpacity(0.3 + 0.3 * math.sin(_c.value * 2 * math.pi)),
            ),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.spaceMono(fontSize: 12, color: AppColors.violet),
          ),
        );
      }
    );
  }
}

// ══════════════════════════════════════════════
// ALIZO DEEP DIVE MODAL
// ══════════════════════════════════════════════
void showAlizoDeepDive(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _AlizoDeepDiveModal();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: 0.9 + 0.1 * animation.value,
        child: Opacity(
          opacity: animation.value,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

class _AlizoDeepDiveModal extends StatelessWidget {
  const _AlizoDeepDiveModal();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0.withOpacity(0.95),
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const SizedBox(),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.bg2,
                          ),
                          child: const Icon(Icons.apps, color: AppColors.cyan, size: 36),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Alizo Platform', style: GoogleFonts.syne(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: ['Flutter Multi-App', 'Supabase', 'Node.js', 'Vercel']
                                    .map((t) => Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(color: AppColors.violet.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                                          child: Text(t, style: GoogleFonts.spaceMono(fontSize: 10, color: AppColors.violet)),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: AppColors.glass, shape: BoxShape.circle),
                            child: const Icon(Icons.close, color: AppColors.text1),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // Roles Grid
                    Text('Platform Microservices', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.cyan)),
                    const SizedBox(height: 24),
                    LayoutBuilder(builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          FractionallySizedBox(widthFactor: width > 600 ? 0.48 : 1.0, child: const _RoleCard(icon: '🛍️', title: 'Customer App', desc: 'Browse stores, multi-store checkout, order tracking')),
                          FractionallySizedBox(widthFactor: width > 600 ? 0.48 : 1.0, child: const _RoleCard(icon: '🏪', title: 'Vendor App', desc: 'Manage catalogue, real-time orders, analytics')),
                          FractionallySizedBox(widthFactor: width > 600 ? 0.48 : 1.0, child: const _RoleCard(icon: '🚴', title: 'Rider App', desc: 'Multi-order delivery, navigation, earnings')),
                          FractionallySizedBox(widthFactor: width > 600 ? 0.48 : 1.0, child: const _RoleCard(icon: '🖥️', title: 'Admin Dashboard', desc: 'User management, approvals, analytics (Vercel)')),
                        ],
                      );
                    }),
                    const SizedBox(height: 48),
                    // Architecture Diagram
                    Text('Architecture', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.cyan)),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 12,
                            children: const [
                              _Block('Customer App'),
                              Icon(Icons.arrow_forward, color: AppColors.violet),
                              _Block('Supabase API', primary: true),
                              Icon(Icons.arrow_back, color: AppColors.violet),
                              _Block('Vendor App'),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Icon(Icons.swap_vert, color: AppColors.violet),
                          ),
                          const _Block('Admin Dashboard'),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Icon(Icons.swap_vert, color: AppColors.violet),
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 12,
                            children: const [
                              _Block('Rider App'),
                              Icon(Icons.arrow_forward, color: AppColors.violet),
                              _Block('OneSignal'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Technical Decisions
                    Text('Key Technical Decisions', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.cyan)),
                    const SizedBox(height: 24),
                    Column(
                      children: const [
                        _TechCard(title: 'Why Supabase', desc: 'Utilizing PostgreSQL RLS for secure row-level access, real-time subscriptions for live order tracking, and leveraging the Mumbai region for low latency.'),
                        SizedBox(height: 16),
                        _TechCard(title: 'ID System', desc: 'Custom human-readable ID generation (ALZ-C-XXXXXX / ALZ-S-XXXXXX / ORD-YYYYMMDD-XXXXX) achieved reliably via database triggers instead of client-side logic.'),
                        SizedBox(height: 16),
                        _TechCard(title: 'Auth Pipeline', desc: 'Google OAuth via Firebase credentials bridged to Supabase JWTs for seamless cross-platform single sign-on.'),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // App Screens Gallery
                    Text('App Screens', style: GoogleFonts.spaceMono(fontSize: 14, color: AppColors.cyan, letterSpacing: 2)),
                    const SizedBox(height: 24),
                    const SizedBox(
                      height: 400,
                      child: _AppScreensGallery(
                        imagePaths: const [
                          'assets/screenshots/Alizo/splash.jpeg',
                          'assets/screenshots/Alizo/homeincustomer.jpeg',
                        ],
                        accentColor: AppColors.cyan,
                        placeholderLabels: const ['Splash', 'Home'],
                        placeholderEmojis: const ['✨', '🏠'],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String icon, title, desc;
  const _RoleCard({required this.icon, required this.title, required this.desc});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.bg2, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.glassB)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.text0)),
                const SizedBox(height: 4),
                Text(desc, style: GoogleFonts.inter(fontSize: 12, color: AppColors.text1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  final String text;
  final bool primary;
  const _Block(this.text, {this.primary = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: primary ? AppColors.violet.withOpacity(0.2) : AppColors.bg3,
        border: Border.all(color: primary ? AppColors.violet : AppColors.glassB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, textAlign: TextAlign.center, style: GoogleFonts.spaceMono(fontSize: 11, color: AppColors.text0)),
    );
  }
}

class _TechCard extends StatelessWidget {
  final String title, desc;
  const _TechCard({required this.title, required this.desc});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.glass, border: Border.all(color: AppColors.glassB), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.cyan),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.text0)),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: GoogleFonts.inter(fontSize: 14, color: AppColors.text1, height: 1.5)),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// NADODI DEEP DIVE MODAL
// ══════════════════════════════════════════════
void showNaDodiDeepDive(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _NaDodiDeepDiveModal();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: 0.9 + 0.1 * animation.value,
        child: Opacity(
          opacity: animation.value,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

class _NaDodiDeepDiveModal extends StatelessWidget {
  const _NaDodiDeepDiveModal();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0.withOpacity(0.95),
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const SizedBox(),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.bg2,
                          ),
                          child: const Icon(Icons.flight_takeoff, color: AppColors.pink, size: 36),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('NaDodi Travel Platform', style: GoogleFonts.syne(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: ['Flutter', 'Firebase', 'REST API', 'JS Backend', 'Admin Web']
                                    .map((t) => Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(color: AppColors.pink.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                                          child: Text(t, style: GoogleFonts.spaceMono(fontSize: 10, color: AppColors.pink)),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: AppColors.glass, shape: BoxShape.circle),
                            child: const Icon(Icons.close, color: AppColors.text1),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // Feature Cards
                    Text('Core Features', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.pink)),
                    const SizedBox(height: 24),
                    LayoutBuilder(builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          FractionallySizedBox(widthFactor: width > 600 ? 0.48 : 1.0, child: const _RoleCard(icon: '✈️', title: 'Flight Booking', desc: 'Search and book flights with real-time availability')),
                          FractionallySizedBox(widthFactor: width > 600 ? 0.48 : 1.0, child: const _RoleCard(icon: '🏨', title: 'Hotel Booking', desc: 'Browse and reserve hotels with detailed listings')),
                          FractionallySizedBox(widthFactor: width > 600 ? 0.48 : 1.0, child: const _RoleCard(icon: '🚕', title: 'Cab Transfers', desc: 'Book cab transfers between locations seamlessly')),
                          FractionallySizedBox(widthFactor: width > 600 ? 0.48 : 1.0, child: const _RoleCard(icon: '🗺️', title: 'Tour Packages', desc: 'Curated tour packages with complete itinerary details')),
                        ],
                      );
                    }),
                    const SizedBox(height: 48),
                    // Architecture Diagram
                    Text('Architecture', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.pink)),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 12,
                            children: const [
                              _Block('Flutter App'),
                              Icon(Icons.arrow_forward, color: AppColors.pink),
                              _Block('Firebase Auth'),
                              Icon(Icons.arrow_forward, color: AppColors.pink),
                              _Block('Firestore', primary: true),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Icon(Icons.swap_vert, color: AppColors.pink),
                          ),
                          const _Block('JS Backend API', primary: true),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Icon(Icons.swap_vert, color: AppColors.pink),
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 12,
                            children: const [
                              _Block('Admin Dashboard (Web)'),
                              Icon(Icons.arrow_back, color: AppColors.pink),
                              _Block('REST API Layer'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Technical Decisions
                    Text('Key Technical Decisions', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.pink)),
                    const SizedBox(height: 24),
                    Column(
                      children: const [
                        _TechCard(title: 'QR System', desc: 'QR code generation for booking verification and mobile scanner integration for instant ticket validation.'),
                        SizedBox(height: 16),
                        _TechCard(title: 'PDF Engine', desc: 'PDF generation and printing for travel tickets and booking confirmations using the pdf & printing packages, with in-app sharing via share_plus.'),
                        SizedBox(height: 16),
                        _TechCard(title: 'Backend Ecosystem', desc: 'Custom JavaScript backend connecting Flutter mobile app and web admin dashboard to shared data services securely.'),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // App Screens Gallery
                    Text('App Screens', style: GoogleFonts.spaceMono(fontSize: 14, color: AppColors.pink, letterSpacing: 2)),
                    const SizedBox(height: 24),
                    const SizedBox(
                      height: 400,
                      child: _AppScreensGallery(
                        imagePaths: const [
                          'assets/screenshots/Nadodi/splashnadodi.jpeg',
                          'assets/screenshots/Nadodi/nadodihome.jpeg',
                          'assets/screenshots/Nadodi/flightbooking.jpeg',
                        ],
                        accentColor: AppColors.pink,
                        placeholderLabels: const ['Splash', 'Home', 'Flight Booking'],
                        placeholderEmojis: const ['✈️', '🏠', '✈️'],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showFuelDostDeepDive(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _FuelDostDeepDiveModal();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: 0.9 + 0.1 * animation.value,
        child: Opacity(
          opacity: animation.value,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

class _FuelDostDeepDiveModal extends StatelessWidget {
  const _FuelDostDeepDiveModal();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0.withOpacity(0.95),
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const SizedBox(),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──────────────────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: ClipOval(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/fuel_dost_logo.png',
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.local_gas_station,
                                    color: AppColors.cyan,
                                    size: 36),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('FuelDost',
                                  style: GoogleFonts.syne(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(
                                'Smart Fuel Cost Optimization App',
                                style: GoogleFonts.inter(
                                    fontSize: 14, color: AppColors.text1),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  'Flutter',
                                  'Dart',
                                  'OpenStreetMap',
                                  'OpenRouteService',
                                  'Hive',
                                  'Overpass API',
                                  'Provider',
                                ]
                                    .map((t) => Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                              color: AppColors.cyan
                                                  .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Text(t,
                                              style: GoogleFonts.spaceMono(
                                                  fontSize: 10,
                                                  color: AppColors.cyan)),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: AppColors.glass,
                                shape: BoxShape.circle),
                            child:
                                const Icon(Icons.close, color: AppColors.text1),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // ── Overview ─────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cyan.withOpacity(0.05),
                        border: const Border(
                            left: BorderSide(color: AppColors.cyan, width: 3)),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                      ),
                      child: Text(
                        'FuelDost is a smart Flutter-based fuel cost optimization app that combines map-based route calculation, real-time fuel pricing with manual override, petrol/diesel selection, and vehicle mileage configuration (bike/car) to accurately estimate trip costs — with offline support and a premium animated UI.',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.text1,
                            height: 1.7),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ── Core Features ────────────────────────────────
                    Text('Core Features',
                        style: GoogleFonts.syne(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.cyan)),
                    const SizedBox(height: 20),
                    LayoutBuilder(builder: (context, constraints) {
                      final wide = constraints.maxWidth > 560;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          FractionallySizedBox(
                              widthFactor: wide ? 0.48 : 1.0,
                              child: const _RoleCard(
                                  icon: '🗺️',
                                  title: 'Map-Based Route Calc',
                                  desc:
                                      'OpenStreetMap + OpenRouteService for live route distance computation')),
                          FractionallySizedBox(
                              widthFactor: wide ? 0.48 : 1.0,
                              child: const _RoleCard(
                                  icon: '⛽',
                                  title: 'Real-Time Fuel Pricing',
                                  desc:
                                      'Live price fetch with manual override for petrol & diesel')),
                          FractionallySizedBox(
                              widthFactor: wide ? 0.48 : 1.0,
                              child: const _RoleCard(
                                  icon: '🏍️',
                                  title: 'Vehicle Mileage Config',
                                  desc:
                                      'Bike / Car presets with custom mileage for accurate cost estimation')),
                          FractionallySizedBox(
                              widthFactor: wide ? 0.48 : 1.0,
                              child: const _RoleCard(
                                  icon: '📍',
                                  title: 'Nearby Pump Discovery',
                                  desc:
                                      'Overpass API integration to find closest fuel stations on the map')),
                          FractionallySizedBox(
                              widthFactor: wide ? 0.48 : 1.0,
                              child: const _RoleCard(
                                  icon: '📊',
                                  title: 'Expense Tracking',
                                  desc:
                                      'Hive-powered local storage for trip history and spend insights')),
                          FractionallySizedBox(
                              widthFactor: wide ? 0.48 : 1.0,
                              child: const _RoleCard(
                                  icon: '📐',
                                  title: 'Multiple Distance Inputs',
                                  desc:
                                      'Enter via map tap, manual input, or link to external navigation apps')),
                        ],
                      );
                    }),
                    const SizedBox(height: 40),

                    // ── Tech Decisions ────────────────────────────────
                    Text('Key Technical Decisions',
                        style: GoogleFonts.syne(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.cyan)),
                    const SizedBox(height: 20),
                    Column(
                      children: const [
                        _TechCard(
                            title: 'OpenStreetMap + OpenRouteService',
                            desc:
                                'Free, open-source map stack for routing without Google Maps API cost — giving full offline tile support and accurate road-level distance.'),
                        SizedBox(height: 16),
                        _TechCard(
                            title: 'Hive for Offline Expense Tracking',
                            desc:
                                'Lightweight key-value store for fast, on-device persistence of trip history, fuel prices, and user settings — no internet required.'),
                        SizedBox(height: 16),
                        _TechCard(
                            title: 'Overpass API for POI Search',
                            desc:
                                'Query live OpenStreetMap data to discover nearby fuel pumps dynamically, displayed directly on the in-app map layer.'),
                        SizedBox(height: 16),
                        _TechCard(
                            title: 'Provider State Management',
                            desc:
                                'Clean separation of UI and business logic using Provider for predictable, testable app state across fuel calculation flows.'),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // ── App Screens ───────────────────────────────────
                    Text('App Screens',
                        style: GoogleFonts.spaceMono(
                            fontSize: 14,
                            color: AppColors.cyan,
                            letterSpacing: 2)),
                    const SizedBox(height: 24),
                    const SizedBox(
                      height: 420,
                      child: _AppScreensGallery(
                        imagePaths: const [
                          'assets/screenshots/FuelDost/home1.jpeg',
                          'assets/screenshots/FuelDost/home2.jpeg',
                          'assets/screenshots/FuelDost/insights.jpeg',
                          'assets/screenshots/FuelDost/expenceandhistory.jpeg',
                        ],
                        accentColor: AppColors.cyan,
                        placeholderLabels: const [
                          'Home',
                          'Map Search',
                          'Insights',
                          'History'
                        ],
                        placeholderEmojis: const ['🏠', '🗺️', '📈', '📜'],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// APP SCREENS GALLERY
// ══════════════════════════════════════════════
class _AppScreensGallery extends StatefulWidget {
  final List<String> imagePaths;
  final Color accentColor;
  final List<String> placeholderLabels;
  final List<String> placeholderEmojis;

  const _AppScreensGallery({
    required this.imagePaths,
    required this.accentColor,
    required this.placeholderLabels,
    required this.placeholderEmojis,
  });

  @override
  State<_AppScreensGallery> createState() => _AppScreensGalleryState();
}

class _AppScreensGalleryState extends State<_AppScreensGallery> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < widget.imagePaths.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: widget.imagePaths.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.15)).clamp(0.0, 1.0);
                      }
                      return Center(
                        child: Transform.scale(
                          scale: value,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return _FullScreenImageModal(
                                      imagePaths: widget.imagePaths,
                                      initialIndex: index,
                                      accentColor: widget.accentColor,
                                      placeholderEmojis: widget.placeholderEmojis,
                                      placeholderLabels: widget.placeholderLabels,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Hero(
                              tag: widget.imagePaths[index],
                              child: Container(
                                width: 180,
                                decoration: BoxDecoration(
                                  color: AppColors.bg3,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: widget.accentColor.withOpacity(0.4), width: 1.5),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    widget.imagePaths[index],
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _PlaceholderScreenshot(
                                        label: widget.placeholderLabels[index],
                                        emoji: widget.placeholderEmojis[index],
                                        accentColor: widget.accentColor,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              if (widget.imagePaths.length > 1) ...[
                Positioned(
                  left: 10,
                  child: AnimatedOpacity(
                    opacity: _currentIndex == 0 ? 0.4 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: _prevPage,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.glass,
                          shape: BoxShape.circle,
                          border: Border.all(color: widget.accentColor.withOpacity(0.6)),
                        ),
                        child: const Icon(Icons.chevron_left, color: AppColors.text0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: AnimatedOpacity(
                    opacity: _currentIndex == widget.imagePaths.length - 1 ? 0.4 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: _nextPage,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.glass,
                          shape: BoxShape.circle,
                          border: Border.all(color: widget.accentColor.withOpacity(0.6)),
                        ),
                        child: const Icon(Icons.chevron_right, color: AppColors.text0),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imagePaths.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index ? widget.accentColor : AppColors.bg3,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaceholderScreenshot extends StatelessWidget {
  final String label;
  final String emoji;
  final Color accentColor;
  const _PlaceholderScreenshot({required this.label, required this.emoji, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _DashedBorderPainter(color: accentColor.withOpacity(0.5)),
          child: Container(
            color: AppColors.bg3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 16),
                  Text(label, style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.text0)),
                  const SizedBox(height: 8),
                  Text('Screenshot\ncoming soon', textAlign: TextAlign.center, style: GoogleFonts.spaceMono(fontSize: 10, color: AppColors.text2)),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    double dashWidth = 8, dashSpace = 6, startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width, startY), Offset(size.width, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
    startX = size.width;
    while (startX > 0) {
      canvas.drawLine(Offset(startX, size.height), Offset(startX - dashWidth, size.height), paint);
      startX -= dashWidth + dashSpace;
    }
    startY = size.height;
    while (startY > 0) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY - dashWidth), paint);
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _FullScreenImageModal extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;
  final Color accentColor;
  final List<String> placeholderEmojis;
  final List<String> placeholderLabels;

  const _FullScreenImageModal({required this.imagePaths, required this.initialIndex, required this.accentColor, required this.placeholderEmojis, required this.placeholderLabels});

  @override
  State<_FullScreenImageModal> createState() => _FullScreenImageModalState();
}

class _FullScreenImageModalState extends State<_FullScreenImageModal> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < widget.imagePaths.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0.withOpacity(0.95),
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const SizedBox(),
            ),
          ),
          Center(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemCount: widget.imagePaths.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                  child: Hero(
                    tag: widget.imagePaths[index],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        widget.imagePaths[index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return _PlaceholderScreenshot(
                            label: widget.placeholderLabels[index],
                            emoji: widget.placeholderEmojis[index],
                            accentColor: widget.accentColor,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 24,
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.glass, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          if (widget.imagePaths.length > 1) ...[
            Positioned(
              left: 24,
              top: MediaQuery.of(context).size.height / 2 - 24,
              child: AnimatedOpacity(
                opacity: _currentIndex == 0 ? 0.4 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: _prevPage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.glass,
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.accentColor.withOpacity(0.6)),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 24,
              top: MediaQuery.of(context).size.height / 2 - 24,
              child: AnimatedOpacity(
                opacity: _currentIndex == widget.imagePaths.length - 1 ? 0.4 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: _nextPage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.glass,
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.accentColor.withOpacity(0.6)),
                    ),
                    child: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.glass,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: widget.accentColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${widget.imagePaths.length}',
                    style: GoogleFonts.spaceMono(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

