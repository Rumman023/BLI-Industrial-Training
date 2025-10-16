import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_screen.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _showLogo = false;
  bool _showText = false;
  bool _showButton = false;
  int _currentIndex = 0;
  final List<String> _logos = [
    'assets/logo/qwen-2-5.png',
    'assets/logo/ollama.png',
    'assets/logo/chat bot.png',
  ];

  @override
  void initState() {
    super.initState();
    // Staggered appearance
    Future.delayed(const Duration(milliseconds: 80), () {
      setState(() => _showLogo = true);
      _startLogoSequence();
    });
    Future.delayed(const Duration(milliseconds: 380), () {
      setState(() => _showText = true);
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() => _showButton = true);
    });
  }

  void _startLogoSequence() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 1600));
      setState(() {
        _currentIndex = (_currentIndex + 1) % _logos.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 141, 172, 232),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: List.generate(_logos.length, (i) {
                        final visible = _showLogo && (i == _currentIndex);
                        return AnimatedOpacity(
                          opacity: visible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          child: Image.asset(
                            _logos[i],
                            width: 220,
                            height: 220,
                            fit: BoxFit.contain,
                          ),
                        );
                      }),
                    ),
                  ),
      
                  const SizedBox(height: 28),
      
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: _showText ? 1.0 : 0.0,
                    child: Column(
                      children: [
                        Text(
                          'Welcome to AI Chat Bot',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Start a conversation with a local Ollama model.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                      ],
                    ),
                  ),
      
                  const SizedBox(height: 24),
      
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 350),
                    opacity: _showButton ? 1.0 : 0.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const ChatScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 28.0),
                      ),
                      child: const Text('Get started'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
