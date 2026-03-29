import 'dart:math' show sin, cos, pi, pow, sqrt;
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
import 'package:video_player/video_player.dart';

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
    'experience': GlobalKey(),
    'projects': GlobalKey(),
    'skills': GlobalKey(),
    'education': GlobalKey(),
    'contact': GlobalKey(),
  };

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
        body: Stack(
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
                  SliverToBoxAdapter(
                    key: _keys['about'],
                    child: const _Reveal(child: AboutSection()),
                  ),
                  SliverToBoxAdapter(
                    key: _keys['experience'],
                    child: const _Reveal(child: ExperienceSection()),
                  ),
                  SliverToBoxAdapter(
                    key: _keys['projects'],
                    child: const _Reveal(child: ProjectsSection()),
                  ),
                  SliverToBoxAdapter(
                    key: _keys['skills'],
                    child: const _Reveal(child: SkillsSection()),
                  ),
                  SliverToBoxAdapter(
                    key: _keys['education'],
                    child: const _Reveal(child: EducationSection()),
                  ),
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
              top: 0,
              left: 0,
              right: 0,
              child: _NavBar(scrolled: _scrolled, onNav: _goto),
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
    nodes = List.generate(65, (_) => _Node.rng());
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 40)),
      builder: (_, __) {
        double p = 0;
        if (scroll.hasClients && scroll.position.maxScrollExtent > 0) {
          p = (scroll.offset / scroll.position.maxScrollExtent).clamp(0, 1);
        }
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
                  children:
                      ['About', 'Experience', 'Projects', 'Skills', 'Contact']
                          .map((l) => _NavLink(l, () => onNav(l.toLowerCase())))
                          .toList(),
                ),
            ],
          ),
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
              'assets/images/profile_photo.jpg',
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

// ══════════════════════════════════════════════
// FLOATING CODE WIDGET
// ══════════════════════════════════════════════
class _FloatingCode extends StatefulWidget {
  final String code;
  final int delay;
  const _FloatingCode({required this.code, required this.delay});
  @override
  State<_FloatingCode> createState() => _FloatingCodeState();
}

class _FloatingCodeState extends State<_FloatingCode>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
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
        offset: Offset(0, sin(_c.value * pi) * 9 - 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.bg2.withOpacity(0.75),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.cyan.withOpacity(0.22)),
          ),
          child: Text(
            widget.code,
            style: GoogleFonts.firaCode(
              fontSize: 11,
              color: AppColors.cyan.withOpacity(0.65),
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: widget.delay.ms, duration: 1000.ms);
  }
}

// ══════════════════════════════════════════════
// FLOATING LOGO
// ══════════════════════════════════════════════
class _FloatingLogo extends StatefulWidget {
  final String assetPath;
  final IconData icon;
  final String label;

  final int delay;
  const _FloatingLogo({
    required this.assetPath,
    required this.icon,
    required this.label,
    required this.delay,
  });
  @override
  State<_FloatingLogo> createState() => _FloatingLogoState();
}

class _FloatingLogoState extends State<_FloatingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  final double _radiusX = 30.0;
  final double _radiusY = 20.0;
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();
    _isVideo =
        widget.assetPath.endsWith('.mov') || widget.assetPath.endsWith('.mp4');
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat();
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
      builder: (_, __) {
        final angle = _c.value * 2 * pi + (widget.delay / 1000);
        final offsetX = cos(angle) * _radiusX;
        final offsetY = sin(angle) * _radiusY;
        return Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bg2.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cyan.withOpacity(0.25)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: _isVideo
                ? VideoPlayer(
                    VideoPlayerController.asset(widget.assetPath)
                      ..initialize().then((_) {
                        setState(() {}); // Refresh when loaded
                      })
                      ..setLooping(true)
                      ..play(),
                  )
                : Image.asset(
                    widget.assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
          ),
        );
      },
    ).animate().fadeIn(delay: widget.delay.ms, duration: 1000.ms);
  }
}

// ══════════════════════════════════════════════
// NEON BADGE
// ══════════════════════════════════════════════
class _NeonBadge extends StatelessWidget {
  final String text;
  const _NeonBadge({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cyan.withOpacity(0.15),
            AppColors.violet.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cyan.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.spaceMono(
          fontSize: 11,
          color: AppColors.cyan,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

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
                      image: AssetImage('assets/images/profile_photo.jpg'),
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

// ══════════════════════════════════════════════
// TECH BADGE — Using Asset Icons
// ══════════════════════════════════════════════
class _TechBadge extends StatefulWidget {
  final String? assetPath;
  final IconData? icon;
  final String label;
  final Color color;
  final Duration delay;
  const _TechBadge({
    this.assetPath,
    this.icon,
    required this.label,
    required this.color,
    required this.delay,
  });
  @override
  State<_TechBadge> createState() => _TechBadgeState();
}

class _TechBadgeState extends State<_TechBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  bool _hov = false;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _buildIcon() {
    if (widget.assetPath != null) {
      return Image.asset(
        widget.assetPath!,
        width: 16,
        height: 16,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to icon if asset fails
          return Icon(widget.icon ?? Icons.code, size: 16, color: widget.color);
        },
      );
    }
    return Icon(widget.icon ?? Icons.code, size: 16, color: widget.color);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
          onEnter: (_) {
            setState(() => _hov = true);
            _c.forward();
          },
          onExit: (_) {
            setState(() => _hov = false);
            _c.reverse();
          },
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, __) => Transform.scale(
              scale: 1.0 + _c.value * 0.18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _hov
                      ? widget.color.withOpacity(0.12)
                      : AppColors.glass,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _hov
                        ? widget.color.withOpacity(0.7)
                        : AppColors.glassB,
                  ),
                  boxShadow: _hov
                      ? [
                          BoxShadow(
                            color: widget.color.withOpacity(0.25),
                            blurRadius: 20,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIcon(),
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
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: widget.delay)
        .slideY(begin: 0.3, end: 0);
  }
}

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
// HERO SECTION
// ══════════════════════════════════════════════
class HeroSection extends StatelessWidget {
  final Function(String) onNav;
  const HeroSection({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: AppColors.bg0,
      child: Stack(
        children: [
          const _ConstellationBg(),
          // Floating code - surrounding the hero
          const Positioned(
            top: 80,
            right: 40,
            child: _FloatingCode(code: 'StatefulWidget', delay: 0),
          ),
          const Positioned(
            top: 180,
            left: 25,
            child: _FloatingCode(code: 'Provider.of<T>(ctx)', delay: 700),
          ),
          const Positioned(
            bottom: 180,
            right: 60,
            child: _FloatingCode(code: 'async / await', delay: 350),
          ),
          const Positioned(
            bottom: 300,
            left: 35,
            child: _FloatingCode(code: 'BuildContext', delay: 1100),
          ),
          const Positioned(
            top: 350,
            left: 60,
            child: _FloatingCode(code: '.animate()', delay: 600),
          ),
          const Positioned(
            top: 150,
            right: 120,
            child: _FloatingCode(code: 'Flutter', delay: 200),
          ),
          const Positioned(
            top: 280,
            right: 20,
            child: _FloatingCode(code: 'Dart', delay: 900),
          ),
          const Positioned(
            bottom: 120,
            left: 80,
            child: _FloatingCode(code: 'Firebase', delay: 450),
          ),
          const Positioned(
            bottom: 250,
            right: 120,
            child: _FloatingCode(code: 'Supabase', delay: 1300),
          ),
          const Positioned(
            top: 450,
            right: 100,
            child: _FloatingCode(code: 'GitHub', delay: 800),
          ),
          // Floating tech logos - surrounding the hero
          Positioned(
            top: 120,
            left: 60,
            child: _FloatingLogo(
              icon: FontAwesomeIcons.flutter,
              label: 'Flutter',
              assetPath: 'assets/icons/flutter.png',
              delay: 0,
            ),
          ),
          Positioned(
            top: 250,
            right: 80,
            child: _FloatingLogo(
              icon: FontAwesomeIcons.d,
              label: 'Dart',
              assetPath: 'assets/icons/dart.png',
              delay: 500,
            ),
          ),
          Positioned(
            top: 400,
            right: 40,
            child: _FloatingLogo(
              icon: FontAwesomeIcons.fire,
              label: 'Firebase',
              assetPath: 'assets/icons/firebase.png',
              delay: 1000,
            ),
          ),
          Positioned(
            bottom: 200,
            left: 50,
            child: _FloatingLogo(
              icon: FontAwesomeIcons.code,
              label: 'Supabase',
              assetPath: 'assets/icons/supabase.png',
              delay: 1500,
            ),
          ),
          Positioned(
            bottom: 370,
            right: 50,
            child: _FloatingLogo(
              icon: FontAwesomeIcons.github,
              label: 'GitHub',
              assetPath: 'assets/icons/GitHub.png',
              delay: 2000,
            ),
          ),
          Positioned(
            bottom: 280,
            left: 100,
            child: _FloatingLogo(
              icon: FontAwesomeIcons.android,
              label: 'Android',
              assetPath: 'assets/icons/android.png',

              delay: 2500,
            ),
          ),

          Positioned(
            bottom: 150,
            right: 150,
            child: _FloatingLogo(
              assetPath: 'assets/icons/apple.png',
              icon: FontAwesomeIcons.apple,
              label: 'Apple',
              delay: 3000,
            ),
          ),
          Positioned(
            top: 200,
            left: 150,
            child: _FloatingLogo(
              assetPath: 'assets/icons/html.png',
              icon: FontAwesomeIcons.html5,
              label: 'HTML',
              delay: 3500,
            ),
          ),
          // Orbs
          Positioned(
            top: -160,
            right: -90,
            child: _Orb(size: 520, color: AppColors.violet, delay: 0),
          ),
          Positioned(
            bottom: -90,
            left: -80,
            child: _Orb(size: 400, color: AppColors.cyan, delay: 6),
          ),
          Positioned(
            top: size.height * 0.32,
            left: size.width * 0.3,
            child: _Orb(size: 300, color: AppColors.pink, delay: 12),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 48,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _AvatarRing()
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .scale(
                          begin: const Offset(0.6, 0.6),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                          duration: 1300.ms,
                        ),
                    const SizedBox(height: 30),
                    const _NeonBadge(text: 'FLUTTER DEVELOPER')
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 500.ms)
                        .slideY(begin: 0.3, end: 0),
                    const SizedBox(height: 24),
                    _HeroGlitchTitle().animate().fadeIn(
                      duration: 800.ms,
                      delay: 700.ms,
                    ),
                    const SizedBox(height: 18),
                    _Typewriter(
                      texts: const [
                        'Flutter Developer',
                        'Mobile App Architect',
                        'UI/UX Craftsman',
                        'Clean Code Believer',
                        'Problem Solver',
                      ],
                    ).animate().fadeIn(duration: 700.ms, delay: 1000.ms),
                    const SizedBox(height: 38),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 12,
                      children: [
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
                      ],
                    ).animate().fadeIn(duration: 700.ms, delay: 1200.ms),
                    const SizedBox(height: 30),
                    const SizedBox(height: 36),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 14,
                      runSpacing: 12,
                      children: [
                      ],
                    ),
                    const SizedBox(height: 32),
                    _BounceArrow(),
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
            // Neon border
            Container(
              width: 308,
              height: 308,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: _hov
                      ? [AppColors.cyan, AppColors.violet, AppColors.pink]
                      : [AppColors.glassB, AppColors.glass, AppColors.glassB],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=600&auto=format&fit=crop&q=60',
                  fit: BoxFit.cover,
                  height: 304,
                  width: 304,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.bg3,
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.code,
                        size: 80,
                        color: AppColors.cyan,
                      ),
                    ),
                  ),
                ),
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
            'Crafting Digital Experiences',
            style: GoogleFonts.syne(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Junior Flutter Developer with hands-on experience building scalable, user-centric mobile applications. I transitioned into mobile development through focused technical training, bringing a unique perspective from my social science background.',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: AppColors.text1,
            height: 1.85,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Strong command of Provider state management, Firebase integration, and REST API consumption. I translate complex UI/UX designs into responsive, high-performance interfaces with a passion for clean architecture.',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: AppColors.text1,
            height: 1.85,
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            _StatCard(number: '3+', label: 'Projects'),
            _StatCard(number: '1+', label: 'Years Exp.'),
            _StatCard(number: '5+', label: 'Tech Stack'),
          ],
        ),
      ],
    );
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
                        'Assisted in debugging and performance optimisation, improving overall application stability',
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
  const _ExpCard({
    required this.title,
    required this.company,
    required this.date,
    required this.items,
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
                color: AppColors.cyan,
                border: Border.all(color: AppColors.bg0, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyan.withOpacity(0.7),
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
                technologies: const ['Flutter', 'Dart', 'Supabase', 'Provider'],
                description:
                    'A production-ready multi-service delivery & marketplace platform empowering local vendors in Kerala. Built with Flutter, Supabase, and Provider — featuring multi-store checkout, real-time order tracking, rider management, and a full admin web dashboard.',
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
                    'Freelance project — a cross-platform Flutter application for Adam Travels that generates clean, formatted travel ticket PDFs. Built for both web and mobile with a smooth, intuitive booking summary flow.',
                features: const [
                  'Cross-platform Web & Mobile',
                  'Clean code principles',
                  'Git version control',
                  'Production architecture',
                ],
                githubUrl: 'https://github.com/mhd-dilshad-p',
              ),
              _FlipProjectCard(
                title: 'Nadodi',
                logoAsset: 'assets/images/nadodi_logo.jpg',
                accentColor: AppColors.pink,
                technologies: const ['Flutter', 'Dart', 'REST API', 'Firebase'],
                description:
                    'A production-ready Flutter travel booking platform covering flight booking, hotel reservations, cab transfers, and tour packages — with a built-in admin web dashboard for complete platform management. Firebase-powered backend with cross-platform support.',
                features: const [
                  'Beautiful UI/UX',
                  'Smooth animations',
                  'REST API integration',
                  'Firebase backend',
                ],
                githubUrl: 'https://github.com/mhd-dilshad-p',
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
                  FaIcon(FontAwesomeIcons.github, size: 15, color: accentColor),
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
                skills: const ['Dart', 'Flutter', 'HTML/CSS (Learning)'],
              ),
              _SkillCard(
                icon: FontAwesomeIcons.layerGroup,
                title: 'State Management',
                color: AppColors.violet,
                skills: const ['Provider', 'Bloc ', 'Riverpod (Learning)'],
              ),
              _SkillCard(
                icon: FontAwesomeIcons.server,
                title: 'Backend & APIs',
                color: AppColors.pink,
                skills: const [
                  'Firebase Auth',
                  'Cloud Firestore',
                  'Supabase',
                  'REST API',
                ],
              ),
              _SkillCard(
                icon: FontAwesomeIcons.screwdriverWrench,
                title: 'Dev Tools',
                color: const Color(0xFFFFCA28),
                skills: const ['Git', 'GitHub', 'Android Studio', 'VS Code'],
              ),
              _SkillCard(
                icon: FontAwesomeIcons.mobileScreen,
                title: 'Mobile Concepts',
                color: AppColors.green,
                skills: const [
                  'Responsive UI',
                  'Widget Optimization',
                  'Navigation & Routing',
                  'Form Validation',
                ],
              ),
              _SkillCard(
                icon: FontAwesomeIcons.robot,
                title: 'AI Tools & Workflow',
                color: AppColors.cyan,
                skills: const [
                  'Claude AI',
                  'Google AI Studio',
                  'Antigravity',
                  'Qoder',
                  'Stitch',
                  'Codex',
                ],
              ),
            ],
          ),
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
      'icon': FontAwesomeIcons.dartLang,
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
      'assetPath': 'assets/icons/GitHub.png',
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
      'name': 'Apple',
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
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 28,
            runSpacing: 28,
            alignment: WrapAlignment.center,
            children: [
              _EduCard(
                date: '2025',
                degree: 'Flutter Development Program',
                school: 'Zoople Technologies, Kerala',
                color: AppColors.cyan,
                backgroundImage: 'assets/images/flutterdeveloper.jpeg',
              ),
              _EduCard(
                date: '2022 – 2025',
                degree: 'Bachelor of Social Work (BSW)',
                school: 'Calicut University',
                color: AppColors.text2,
                backgroundImage: 'assets/images/Social work.jpeg',
              ),
              _EduCard(
                date: '2021 – 2022',
                degree: 'Higher Secondary (Humanities)',
                school: 'Kerala State Board',
                color: AppColors.text1,
                backgroundImage: 'assets/images/humanities.jpeg',
              ),
              _EduCard(
                date: 'Languages',
                degree: 'Language Proficiency',
                school: 'Trilingual Proficiency',
                color: AppColors.green,
                languages: const ['English', 'Malayalam', 'Tamil'],
                isLanguageCard: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EduCard extends StatefulWidget {
  final String date, degree, school;
  final Color color;
  final List<String>? languages;
  final String? backgroundImage;
  final bool isLanguageCard;
  const _EduCard({
    required this.date,
    required this.degree,
    required this.school,
    required this.color,
    this.languages,
    this.backgroundImage,
    this.isLanguageCard = false,
  });
  @override
  State<_EduCard> createState() => _EduCardState();
}

class _EduCardState extends State<_EduCard> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        transform: _hov
            ? (Matrix4.identity()..translate(0.0, -6.0))
            : Matrix4.identity(),
        constraints: const BoxConstraints(maxWidth: 310),
        decoration: BoxDecoration(
          color: AppColors.glass,
          border: Border.all(
            color: _hov ? widget.color.withOpacity(0.65) : AppColors.glassB,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _hov
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.18),
                    blurRadius: 35,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background image
              if (widget.backgroundImage != null)
                Positioned.fill(
                  child: Image.asset(
                    widget.backgroundImage!,
                    fit: BoxFit.cover,
                    opacity: AlwaysStoppedAnimation(_hov ? 0.5 : 0.35),
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              // Gradient overlay for better text readability
              if (widget.backgroundImage != null)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.bg2.withOpacity(0.55),
                          AppColors.bg1.withOpacity(0.35),
                        ],
                      ),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Accent top bar
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.color, widget.color.withOpacity(0.2)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.date,
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            color: AppColors.text1,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.degree,
                          style: GoogleFonts.syne(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.school,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.text1,
                          ),
                        ),
                        if (widget.languages != null) ...[
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 8,
                            children: widget.languages!
                                .map(
                                  (l) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.bg3,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.glassB,
                                      ),
                                    ),
                                    child: Text(
                                      l,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.text1,
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
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
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
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              _ContactCard(
                assetPath: 'assets/icons/linkedin.json',
                icon: FontAwesomeIcons.linkedinIn,
                label: 'LinkedIn',
                value: 'mhd-dilshad-p',
                url: 'https://linkedin.com/in/mhd-dilshad-p',
                color: AppColors.glassB,
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
      if (await canLaunchUrl(uri)) await launchUrl(uri);
      _key.currentState!.reset();
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
            return null;
          },
        ),
      ],
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
