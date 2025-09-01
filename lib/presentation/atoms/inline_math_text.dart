import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Inline TeX renderer: write text with $...$ for inline math.
/// Example: InlineMathText(r'状態 $y=[\\theta_1,\\omega_1]$ とする');
class InlineMathText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final MathStyle mathStyle;

  const InlineMathText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.mathStyle = MathStyle.text,
  });

  @override
  Widget build(BuildContext context) {
    final spans = _parse(text, DefaultTextStyle.of(context).style.merge(style));
    return RichText(text: TextSpan(children: spans, style: style), textAlign: textAlign ?? TextAlign.start);
  }

  List<InlineSpan> _parse(String input, TextStyle? style) {
    final List<InlineSpan> out = [];
    final sb = StringBuffer();
    bool inMath = false;
    for (int i = 0; i < input.length; i++) {
      final ch = input[i];
      if (ch == r'\\') {
        // Preserve single backslash in text segments; write as-is.
        sb.write('\\');
        continue;
      }
      if (ch == r'\$') {
        // Escaped dollar, append literal '$'.
        sb.write(r'$');
        continue;
      }
      if (ch == r'$') {
        // Flush buffer before toggling.
        if (!inMath) {
          if (sb.isNotEmpty) {
            out.add(TextSpan(text: sb.toString(), style: style));
            sb.clear();
          }
          inMath = true;
        } else {
          // End math; consume buffer into Math widget.
          final mathSrc = sb.toString();
          sb.clear();
          out.add(WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Math.tex(mathSrc, mathStyle: mathStyle, textStyle: style),
          ));
          inMath = false;
        }
        continue;
      }
      sb.write(ch);
    }
    // Flush remainder
    if (sb.isNotEmpty) {
      out.add(TextSpan(text: sb.toString(), style: style));
    }
    return out;
  }
}

