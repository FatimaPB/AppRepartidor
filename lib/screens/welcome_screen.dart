import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentSlide = 0;
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  final List<SlideContent> _slides = [
    SlideContent(
      icon: Icons.book_rounded,
      title: "Llevando Fe y Esperanza",
      description: "Entrega productos religiosos que tocan corazones",
      gradient: const [Color(0xFFA38350), Color(0xFF8B6F3E)],
    ),
    SlideContent(
      icon: Icons.inventory_2_rounded,
      title: "Cada Pedido Cuenta",
      description: "Tu trabajo ayuda a difundir la palabra de Dios",
      gradient: const [Color(0xFF660000), Color(0xFF8B0000)],
    ),
    SlideContent(
      icon: Icons.map_rounded,
      title: "Rutas Optimizadas",
      description: "Sistema inteligente para entregas más rápidas",
      gradient: const [Color(0xFF8B6F3E), Color(0xFFA38350)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 👇 Ajuste visual del sistema (barra superior e inferior)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // mismo tono del fondo superior
        statusBarIconBrightness:
            Brightness.dark, // iconos oscuros si fondo claro
        systemNavigationBarColor: Color(
          0xFFFAF8F6,
        ), // parte inferior igual que el fondo
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);
    _fadeController.forward();

    // Auto-slide cada 4 segundos
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentSlide < _slides.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F5F5), Color(0xFFFFFFFF), Color(0xFFFAF8F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Elementos decorativos de fondo suaves
            _buildBackgroundEffects(),

            // Contenido principal
            SafeArea(
              child: Column(
                children: [
                  // Logo y nombre superior
                  _buildHeader(),

                  // Carrusel de slides
                  Expanded(child: _buildCarousel()),

                  // Indicadores de página
                  _buildPageIndicators(),

                  const SizedBox(height: 40),

                  // Botones de acción
                  _buildActionButtons(context),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundEffects() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: 100,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFA38350).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF660000).withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: 50,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFA38350).withOpacity(0.06),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: Column(
        children: [
          // Logo de la librería
          Container(
            width: 150,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/logosinfondo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Librería Bendición",
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 26,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Portal del Repartidor",
            style: TextStyle(
              color: Color(0xFF5A5A5A),
              fontSize: 15,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentSlide = index;
          });
        },
        itemCount: _slides.length,
        itemBuilder: (context, index) {
          return _buildSlide(_slides[index]);
        },
      ),
    );
  }

  Widget _buildSlide(SlideContent slide) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Ícono con gradiente
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: slide.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: slide.gradient[0].withOpacity(0.25),
                blurRadius: 25,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(slide.icon, size: 55, color: Colors.white),
        ),
        const SizedBox(height: 40),

        // Título
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            slide.title,
            style: const TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // Descripción
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            slide.description,
            style: const TextStyle(
              color: Color(0xFF5A5A5A),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (index) => GestureDetector(
          onTap: () {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentSlide == index ? 32 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentSlide == index
                  ? const Color(0xFFA38350)
                  : const Color(0xFFD2D2D2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // Botón principal
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF660000),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: const Color(0xFF660000).withOpacity(0.3),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                "Empezar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Texto decorativo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.favorite, size: 16, color: Color(0xFFA38350)),
              SizedBox(width: 8),
              Text(
                "Servir con amor y alegría",
                style: TextStyle(
                  color: Color(0xFF5A5A5A),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SlideContent {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;

  SlideContent({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
