# SPEC: rk4_solver

本ドキュメントは、二重振り子シミュレーションアプリ（rk4_solver）のMVP仕様、ユーザージャーニー、アーキテクチャ、およびデプロイ方針を定義します。ゴールはApp Storeへのデプロイ体験まで到達することです。

## 概要 / 目的
- 二重振り子（double pendulum）の運動方程式をルンゲ＝クッタ法（RK4）で数値積分し、アニメーションで可視化する学習・可視化アプリ。
- 最小機能（MVP）での体験を優先しつつ、将来拡張（設定、保存、共有）に耐える分離された構成を採用。

## MVP機能（現状）
- シミュレーション
  - ODE（二重振り子）: 状態 y=[θ1, ω1, θ2, ω2]、パラメタ m1, m2, L1, L2, g。
  - 初期条件（θ1, ω1, θ2, ω2）、終了時刻（tEnd）、刻み幅（h）を入力可能。
- 可視化
  - アニメーション: 2本のロッドとボブをスタイリッシュに描画（白×シアンのグラデーション背景、シャドウ）。
  - 軌跡（トレイル）: ボブ2のフェードするトレイルを任意で表示（長さ指定可）。
- 操作
  - 入力フォーム（折りたたみ）に数値を入れて「シミュレーション実行」で再計算し、アニメーション更新。
  - 再生UI: 再生/一時停止、速度（0.5x〜2.0x）。
  - 情報チップ: 計算点数・時間・時間刻みを表示。
  - 単位はラジアン表記。

## ユーザージャーニー
1) アプリ起動 → デフォルトパラメータで自動計算済みのアニメーションが再生。
2) 「初期条件 / 物理パラメータ / シミュレーション設定」を必要に応じて展開し、値を入力 → 「シミュレーション実行」。
3) アニメーションが更新（必要なら軌跡ON）。再生/一時停止や速度を調整して観察。

## アーキテクチャ
- レイヤ分離: presentation（UI）/ application（制御）/ domain（モデル・数値計算・サービス）
- 依存方向: presentation → application → domain（逆依存なし）
- 状態管理: 追加パッケージなし（画面内で Controller を保持し setState で反映）

ディレクトリ構成（主要）
```
lib/
  main.dart                         # ルート
  presentation/
    pages/home_page.dart            # 入力フォーム + アニメ + コントロール
    widgets/double_params_form.dart # パラメータ入力（ExpansionTile）
    widgets/double_pendulum_animator.dart # アニメーション表示 + 軌跡 + 再生制御
  application/
    double_pendulum_controller.dart # パラメータ保持・実行
  domain/
    models/
      double_pendulum_params.dart   # θ1, ω1, θ2, ω2, m1, m2, L1, L2, g, t,h
      double_pendulum_point.dart    # t, θ1, ω1, θ2, ω2
    ode/
      rk4.dart                      # 一般RK4ソルバ
      double_pendulum.dart          # 二重振り子の微分方程式
    services/
      double_pendulum_runner.dart   # RK4呼び出し→型付き結果へ変換
```

### ドメインモデル
- DoublePendulumParams
  - `theta1, omega1, theta2, omega2, m1, m2, L1, L2, g, t0, tEnd, h`
  - `defaults()` 工場, `copyWith()` 提供。
- DoublePendulumPoint
  - `t, theta1, omega1, theta2, omega2` の不変データ。

### 数値解法
- `rk4.dart`
  - 一般系 `ODESystem = List<double> Function(double t, List<double> y)` を受け、
    `[ [t, y0, y1, ...], ... ]` を返す。
  - 境界 `t <= tEnd` を 1e-12 で補正して浮動小数誤差に耐性。
- `double_pendulum.dart`
  - 標準的な二重振り子の式を実装。`y=[θ1, ω1, θ2, ω2]` を受け、`[θ1', ω1', θ2', ω2']` を返す。

### UI
- 入力: `DoubleParamsForm`（ExpansionTile）に θ1, ω1, θ2, ω2, m1, m2, L1, L2, シミュレーション時間・時間刻み。
- 表示: `DoublePendulumAnimator` でアニメーション描画（白×シアン背景、シャドウ、トレイル表示可）。
- 再生UI: 再生/一時停止、速度（0.5x〜2.0x）。
- 情報チップ: 計算点数・時間・時間刻み。
- 小画面: スクロール対応。Run 後にアニメ領域へ自動スクロール。

### デザイン/テーマ
- カラーテーマ: 白基調 + シアン（seed: cyan, light）。
- フォント: TeX ライク。
  - 既定: Google Fonts の EB Garamond を適用。
  - 代替: Latin Modern Roman を同梱する場合は `fontFamily: 'LatinModernRoman'` に切替。
- AppBar はホワイト、本文は読みやすい明度・コントラストに調整。

## 実装ポリシー
- まずは同期計算でシンプルに。大規模化したら Isolate/off-main-thread を検討。
- 例外はフォーム入力で吸収（NaNは既定値にフォールバック）。
- 長時間・極小刻みは計算点が多くなるため、性能に注意（トレイルは内部で間引き）。

## 実行方法
```bash
cd rk4_solver
flutter pub get
flutter run -d <device>   # 例: chrome, ios, macos 等
```

## App Store デプロイ（サマリ）
- 前提: Apple Developer Program, Xcode, Flutter stable。
- iOS設定
  - Xcode で `Runner` の Bundle Identifier を一意に設定。
  - Signing: Team 選択（Automatic Signing 有効）。
  - バージョン: `pubspec.yaml` の `version:` を更新（例: 1.0.0+1 → 1.0.1+2）。
  - アイコン: `ios/Runner/Assets.xcassets/AppIcon.appiconset` を差し替え。
  - Deployment Target は iOS 13+ 程度。
- 配布フロー
  - `flutter build ipa` もしくは `flutter build ios --release`。
  - Xcode Organizer で Archive → Distribute to App Store Connect。
  - App Store Connect でアプリ登録、プライバシー、スクショ、説明文 → 審査申請。
- 備考
  - トラッキングSDKなし想定。App Privacy は「収集なし」で整合を確認。

## 将来拡張（候補）
- デザイン: ガラスモーフィズム風カード、カスタムフォント、ダーク/ライト自動切替。
- 機能: プリセット（カオス強調/安定域）、画像・動画保存/共有、トレイルのグラデーション色、ボブ1の軌跡追加、シークバー。
- 使い勝手: パラメータ永続化（shared_preferences）、プリセット（保存/読み込み）、入力バリデーション表示。

## 受入基準（MVP）
- デフォルトパラメータで起動時自動計算し、アニメーションが表示・再生される。
- 入力変更→「シミュレーション実行」でアニメが更新される（計算点数のチップが更新）。
- 再生UI（再生/一時停止、速度）が機能する。軌跡のON/OFFと長さが反映される。
- iOS Release ビルドが成功し、TestFlight へアップロード可能。
