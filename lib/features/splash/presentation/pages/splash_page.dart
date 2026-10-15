import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

const _totalMs = 2700;
const _gap = .075;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _totalMs),
  );

  @override
  void initState() {
    super.initState();
    final reduceMotion = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    _controller.forward(from: reduceMotion ? 1 : 0).whenComplete(() {
      if (mounted) context.go('/');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _t(int startMs, int endMs, [Curve curve = Curves.easeOutCubic]) =>
      Interval(
        startMs / _totalMs,
        endMs / _totalMs,
        curve: curve,
      ).transform(_controller.value);

  Widget _layer(String name, double opacity, double dy, [double scale = 1]) =>
      Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          alignment: Alignment(0, .435 + dy * 2),
          child: FractionalTranslation(
            translation: Offset(0, dy),
            child: SvgPicture.asset('assets/images/logo_$name.svg'),
          ),
        ),
      );

  Widget _letter(int i) {
    final t = _t(900 + i * 200, 1200 + i * 200);
    return _layer('hunt'[i], t, _gap + .03 * (1 - t));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * .46;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: width,
          height: width / 882 * 980,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final settle = _t(1900, 2400, Curves.easeInOutCubic);
              final pop = _t(300, 800, Curves.easeOutBack);
              final cap = _t(2000, 2500, Curves.easeOutBack);
              return Transform.scale(
                scale: 1.18 - .18 * settle,
                child: Stack(
                  fit: .expand,
                  clipBehavior: .none,
                  children: [
                    _layer(
                      'mark',
                      _t(300, 650),
                      -_gap,
                      (.6 + .4 * pop) * (1.12 - .12 * settle),
                    ),
                    _layer('cap', _t(2000, 2300), -_gap - .08 * (1 - cap)),
                    for (var i = 0; i < 4; i++) _letter(i),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
