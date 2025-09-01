Latin Modern Roman (LM) font setup

Place the following font files in this folder to enable the TeX-like
Latin Modern Roman across the app (regular/italic/bold/bold-italic):

Required files (OTF or TTF)
- lmroman10-regular.otf
- lmroman10-italic.otf
- lmroman10-bold.otf
- lmroman10-bolditalic.otf

Where to get
- CTAN package: lm (Latin Modern)
  https://ctan.org/pkg/lm
- GUST e-foundry (official project site)
  https://www.gust.org.pl/projects/e-foundry/latin-modern

After placing the files, add this snippet to pubspec.yaml (under `flutter:`):

  fonts:
    - family: LatinModernRoman
      fonts:
        - asset: assets/fonts/latin_modern/lmroman10-regular.otf
        - asset: assets/fonts/latin_modern/lmroman10-italic.otf
          style: italic
        - asset: assets/fonts/latin_modern/lmroman10-bold.otf
          weight: 700
        - asset: assets/fonts/latin_modern/lmroman10-bolditalic.otf
          weight: 700
          style: italic

Then in `lib/main.dart`, set `fontFamily: 'LatinModernRoman'` in ThemeData
or keep the current STIX fallback if you prefer.

