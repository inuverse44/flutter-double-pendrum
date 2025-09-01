import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Text widget that supports TeX inline `$...$` and display `$$...$$` math.
/// - Inline example: InlineMathText(r'状態 $y=[\\theta_1,\\omega_1]$ とする')
/// - Display example: InlineMathText(r'$$\\int_0^1 x^2 \\, dx = 1/3$$')
class InlineMathText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool scrollableDisplay; // horizontally scroll long display math

  const InlineMathText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.scrollableDisplay = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style.merge(style);
    final tokens = _tokenize(text);

    // Group into blocks: text/inline-rich vs display widgets
    final List<Widget> children = [];
    List<InlineSpan> currentSpans = [];

    void flushSpans() {
      if (currentSpans.isNotEmpty) {
        children.add(RichText(text: TextSpan(style: defaultStyle, children: List.of(currentSpans)), textAlign: textAlign));
        currentSpans = [];
      }
    }

    for (final t in tokens) {
      switch (t.type) {
        case _TokType.text:
          currentSpans.add(TextSpan(text: t.value));
          break;
        case _TokType.inline:
          currentSpans.add(WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Math.tex(t.value, mathStyle: MathStyle.text, textStyle: defaultStyle),
          ));
          break;
        case _TokType.display:
          flushSpans();
          final math = Math.tex(t.value, mathStyle: MathStyle.display, textStyle: defaultStyle);
          children.add(scrollableDisplay
              ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: math)
              : math);
          break;
      }
    }
    flushSpans();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  // Tokenizer supporting escaped dollar (\$), inline $...$, and display $$...$$
  List<_Tok> _tokenize(String s) {
    final out = <_Tok>[];
    final buf = StringBuffer();
    int i = 0;
    void pushText() {
      if (buf.isNotEmpty) {
        out.add(_Tok.text(buf.toString()));
        buf.clear();
      }
    }

    while (i < s.length) {
      if (s[i] == r'\\') {
        // Preserve backslash in text
        buf.write('\\');
        i++;
        continue;
      }
      if (s[i] == r'\$') {
        buf.write(r'$');
        i++;
        continue;
      }
      if (s[i] == r'$') {
        final isDisplay = (i + 1 < s.length) && s[i + 1] == r'$';
        final delim = isDisplay ? r'$$' : r'$';
        i += isDisplay ? 2 : 1;
        // collect until same delimiter unescaped
        final math = StringBuffer();
        while (i < s.length) {
          if (s[i] == r'\' && i + 1 < s.length && s[i + 1] == r'$') {
            math.write(r'$');
            i += 2;
            continue;
          }
          if (s[i] == r'$') {
            if (isDisplay && i + 1 < s.length && s[i + 1] == r'$') {
              i += 2; // consume closing $$
              break;
            } else if (!isDisplay) {
              i += 1; // consume closing $
              break;
            }
          }
          math.write(s[i]);
          i++;
        }
        pushText();
        out.add(isDisplay ? _Tok.display(math.toString()) : _Tok.inline(math.toString()));
        continue;
      }
      buf.write(s[i]);
      i++;
    }
    pushText();
    return out;
  }
}

enum _TokType { text, inline, display }

class _Tok {
  final _TokType type;
  final String value;
  _Tok(this.type, this.value);
  factory _Tok.text(String v) => _Tok(_TokType.text, v);
  factory _Tok.inline(String v) => _Tok(_TokType.inline, v);
  factory _Tok.display(String v) => _Tok(_TokType.display, v);
}
