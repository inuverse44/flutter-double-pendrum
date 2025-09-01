# rk4_solver — 二重振り子シミュレーション（RK4）

二重振り子（double pendulum）をルンゲ＝クッタ法（RK4）で数値積分し、スタイリッシュにアニメ表示する Flutter アプリです。最初の公開（App Store 体験）を目指した最小構成ながら、拡張しやすい分離設計を採用しています。

## 特徴
- RK4 による二重振り子シミュレーション（θ1, ω1, θ2, ω2 / m1, m2 / L1, L2）
- アニメーション表示（白×シアンの背景、シャドウ）＋ 軌跡（フェードトレイル）ON/OFF
- 再生UI（再生/一時停止、速度 0.5x〜2.0x）
- 入力フォームの折りたたみ（初期条件 / 物理パラメータ / シミュレーション設定）
- 小画面対応（スクロール、自動スクロール、情報チップで Steps などを可視化）
- フォント：TeX ライク（既定は EB Garamond）。Latin Modern Roman 同梱にも対応可能

## 画面構成（ざっくり）
- 上部：パラメータフォーム（ExpansionTile で折りたたみ）
- 中央：アニメ領域（正方形、二重振り子）
- 下部：再生UI（再生/停止、速度）と軌跡の表示設定

## パラメータ説明（入力フォーム）
- 初期条件
  - θ1 [rad], ω1 [rad/s], θ2 [rad], ω2 [rad/s]
  - 注意：角度はラジアン表記
- 物理パラメータ
  - m1, m2 [kg]：各ボブの質量
  - L1, L2 [m]：各ロッドの長さ
- シミュレーション設定
  - 時間 [秒]：例 1.0 → 1 秒まで再生
  - 時間刻み [秒]：例 0.01 → 100 分割（小さいほど滑らか・計算点数は増加）

## 実行方法
```bash
cd rk4_solver
flutter pub get
flutter run -d <device>   # 例: ios, macos, chrome
```

デバイス例：
- iOS シミュレータ（例：iPhone SE）
- macOS デスクトップ
- Web（Chrome）

## フォントについて
- 既定：Google Fonts の EB Garamond を適用（TeX ライクなセリフ体）
- 代替：Latin Modern Roman（LMR）を同梱可能
  1. `assets/fonts/latin_modern/` に以下を配置：
     - lmroman10-regular.otf / italic.otf / bold.otf / bolditalic.otf
  2. `pubspec.yaml` の `flutter: fonts:` ブロックを有効化（コメント参照）
  3. `lib/main.dart` のテーマで `fontFamily: 'LatinModernRoman'` を設定

詳しくは `assets/fonts/latin_modern/README.md` 参照。

## ディレクトリ構成（抜粋）
```
lib/
  main.dart
  presentation/
    pages/home_page.dart                  # 画面レイアウト
    widgets/double_params_form.dart       # 入力フォーム（折りたたみ）
    widgets/double_pendulum_animator.dart # アニメ＋軌跡＋再生制御
  application/
    double_pendulum_controller.dart       # パラメータ保持と実行
  domain/
    models/                               # パラメータ/ポイント型
    ode/                                  # RK4・二重振り子の ODE
    services/                             # 実行→結果化
```

## よくある質問 / トラブルシュート
- 画面が縦に溢れる：小画面ではスクロール可能です。フォーム送信後はアニメ領域へ自動スクロールします。
- 値を変えても動かない：`時間刻み` が 0 以下でないか、`時間` が 0 以下になっていないかをご確認ください。フォーム側で最低限の補正は入ります。
- ホットリロード後に挙動が不安定：大きな UI 変更や新規プロパティ追加直後は、Hot Restart（R）を一度実行してください。

## App Store（iOS）向け準備（要約）
1. Xcode で Bundle Identifier 設定、Signing（Team 選択）
2. バージョン更新（`pubspec.yaml` の `version:`）
3. アイコン設定（`ios/Runner/Assets.xcassets`）
4. `flutter build ios --release` → Xcode Organizer で Archive & Distribute
5. App Store Connect でメタデータ入力〜申請

詳細は SPEC.md の「App Store デプロイ」を参照してください。
