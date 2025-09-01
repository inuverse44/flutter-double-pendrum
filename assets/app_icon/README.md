アプリアイコン配置ガイド

このフォルダにアプリアイコン用の画像を配置してください。`flutter_launcher_icons` を使用して、iOS/Android の各サイズに自動生成します。

必須ファイル
- `icon.png`（1024×1024 推奨、角丸なし・透過OK）

任意（AndroidのAdaptive Iconsを綺麗にする場合）
- `icon_foreground.png`（透明背景のシンボル、最大 432×432 目安）
- 背景色は `pubspec.yaml` の `adaptive_icon_background` で指定

生成コマンド（プロジェクト直下で実行）
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

デザイン提案（ダブルペンデュラム）
- 配色: 白×シアン（背景 #DBF7FF、シンボル #00BCD4 / #0097A7）
- 形状: 上部の支点から2本のロッド、2つのボブ（大小）
- アレンジ: ボブ2に短いトレイル（弧）を重ね、動きを示唆

注意
- iOS用はアルファ（透過）を自動で除去（`remove_alpha_ios: true`）。
- 角丸やマスクはOS側で適用されるため、原画像は角丸なしでOKです。

