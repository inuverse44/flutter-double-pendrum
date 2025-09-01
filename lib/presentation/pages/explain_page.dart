import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class ExplainPage extends StatelessWidget {
  const ExplainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('二重振り子の解説'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('概要', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              '二重振り子は 2 本の質量のない剛体棒と 2 つの質点から成る連成振り子で、非線形かつカオス的な挙動を示します。'
              'ここではラグランジアンから運動方程式を導き、数値的に解きます。',
            ),
            const SizedBox(height: 16),
            Text('ラグランジアン', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: Math.tex(r'''
\begin{aligned}
\mathcal{L} &= T - V,\\
T &= \tfrac{1}{2} m_1 (L_1^2 \dot{\theta}_1^2)
   + \tfrac{1}{2} m_2 \big( L_1^2 \dot{\theta}_1^2 + L_2^2 \dot{\theta}_2^2
   + 2 L_1 L_2 \dot{\theta}_1 \dot{\theta}_2 \cos(\theta_1-\theta_2) \big),\\
V &= - (m_1+m_2) g L_1 \cos\theta_1 - m_2 g L_2 \cos\theta_2.
\end{aligned}
''', textStyle: textTheme.bodyLarge),
              ),
            ),
            const SizedBox(height: 16),
            Text('状態変数と運動方程式', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: textTheme.bodyMedium,
                children: [
                  const TextSpan(text: '状態 '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Math.tex(
                      r'y=[\theta_1,\omega_1,\theta_2,\omega_2]',
                      mathStyle: MathStyle.text,
                    ),
                  ),
                  const TextSpan(text: ' とし、'),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Math.tex(r'\theta', mathStyle: MathStyle.text),
                  ),
                  const TextSpan(text: ' は角度、'),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Math.tex(r'\omega', mathStyle: MathStyle.text),
                  ),
                  const TextSpan(text: ' は角速度です。'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: Math.tex(r'''
\begin{aligned}
\dot{\theta}_1 &= \omega_1, \qquad \dot{\theta}_2 = \omega_2, \\
\dot{\omega}_1 &= \frac{-g(2m_1+m_2)\sin\theta_1 - m_2 g\sin(\theta_1-2\theta_2)
 - 2 m_2 \sin(\theta_1-\theta_2)\big( \omega_2^2 L_2 + \omega_1^2 L_1 \cos(\theta_1-\theta_2) \big)}{L_1 \big(2m_1+m_2 - m_2\cos(2\theta_1-2\theta_2)\big)}, \\
\dot{\omega}_2 &= \frac{2\sin(\theta_1-\theta_2)\big( \omega_1^2 L_1 (m_1+m_2)
 + g (m_1+m_2)\cos\theta_1 + \omega_2^2 L_2 m_2 \cos(\theta_1-\theta_2) \big)}{L_2 \big(2m_1+m_2 - m_2\cos(2\theta_1-2\theta_2)\big)}.
\end{aligned}
''', textStyle: textTheme.bodyLarge),
              ),
            ),
            const SizedBox(height: 16),
            Text('数値解法', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('本アプリでは固定刻みの 4 次ルンゲ＝クッタ法（RK4）で時間発展を計算します。刻み h が小さいほど滑らかですが計算点数は増加します。'),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
