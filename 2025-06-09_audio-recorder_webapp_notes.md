# 🔧 2025-06-09 Audio-Recorder WebApp & Arch Notes

## 1. **セッション全体の技術トピック一覧**
- WaveSurfer v7 でのイベント仕様変更（`audioprocess` → `timeupdate`）
- 録音ボタン／ファイルアップロードの二択 UI と MediaRecorder 利用
- リアルタイム波形描画の実現可否（WebAudio & Canvas vs wavesurfer-mic）
- Next.js でフロント＋バックエンド API を一体化する構成
- Node.js が DB や認証を担当し、Python FastAPI が ML 推論を担当する二層アーキテクチャ
- JavaScript だけで ML を完結させる難しさと TensorFlow.js／ONNX.WebGPU の限界
- データベース連携パターン（SQLite → PostgreSQL へスケール）
- バージョン差異が原因で起きたハマりポイントのトラブルシューティング

---

## 2. **トピックごとの詳細解説**

### WaveSurfer v7 のイベント変更

- **ユーザーの初期疑問**  
  > 「シークバーを動かしても再生時間が 0 秒のままなのが気になる」

- **アシスタントの回答要約**  
  v7 では `audioprocess` が廃止され、代わりに再生・シーク・一時停止を包括する `timeupdate` が導入された。`backend: 'WebAudio'` を指定し、`wavesurfer.on('timeupdate', cb)` で秒数を更新すると解決。

- **発展的な話題・関連技術**  
  - v6 → v7 の breaking changes（プラグイン読み込み・API 簡素化）  
  - スペクトログラム表示は `WebAudio` backend が必須  
  - `wavesurfer-mic` プラグインは v6 専用で v7 では未対応

- **重要な用語・背景知識**  
  - **MediaElement backend**: `<audio>` をラップする簡易再生方式。`timeupdate` は取れるが `audioprocess` が無い  
  - **WebAudio backend**: `AudioContext` ベース。FFT や周波数解析が可能

- **ユーザーが得た理解・気づき**  
  > 「イベント名が変わっていたのか！`timeupdate` に切り替えたら秒数が同期した」

---

### 録音とアップロードの二択 UI

- **ユーザーの初期疑問**  
  > 「マイクで録音を押しても何も起こらない／録音アイコンが戻らない」

- **アシスタントの回答要約**  
  - DOM に `recordBtn` が無い・`<script type="module">` を書き忘れなどロード順の典型バグを指摘  
  - `MediaRecorder` の `onstop` を `try…finally` で囲み、必ずボタン表示を戻すことで UI が復帰

- **発展的な話題・関連技術**  
  - 録音中にリアルタイム波形を描画したい場合は WebAudio の `AnalyserNode` + Canvas が現実的

- **重要な用語・背景知識**  
  - **MediaRecorder**: ブラウザ標準の録音 API。`dataavailable` で blob を取得  
  - **AnalyserNode**: 音声の周波数 or 波形データを取り出す WebAudio ノード

- **ユーザーが得た理解・気づき**  
  > 「finally でテキストを戻すだけでアイコン問題が片付いた」

---

### Next.js のフルスタック性

- **ユーザーの初期疑問**  
  > 「Next.js ってフロントエンドとバックエンドが分かれていないの？」

- **アシスタントの回答要約**  
  Next.js は UI (`app/` or `pages/`) と API ルート (`/api/` or `app/api/*`) を同じリポジトリにまとめるフルスタック FW。UI はブラウザで動き、API ルートは Node.js で実行される。

- **発展的な話題・関連技術**  
  - Vercel にデプロイすると API も自動で Serverless 化  
  - `app/api/upload/route.ts` の例を提示

- **重要な用語・背景知識**  
  - **API Routes**: Next.js が提供する Node.js ハンドラ。Express 不要  
  - **Edge Runtime / Serverless**: デプロイ先のランタイムオプション

- **ユーザーが得た理解・気づき**  
  > 「1 つのプロジェクトで API まで完結するのは便利」

---

### Node.js と Python FastAPI の二層構成

- **ユーザーの初期疑問**  
  > 「DB 操作は JavaScript のバックエンドに任せて、重い ML だけ Python API に投げるのはどう？」

- **アシスタントの回答要約**  
  これは実務でよく使われる分業パターン。Node.js で認証・DB・ルーティングを担い、Python FastAPI が GPU 推論を担当。疎結合な REST/HTTP で通信するためスケールが容易。

- **発展的な話題・関連技術**  
  - Prisma / Drizzle（Node.js ORM）  
  - gRPC や WebSocket での高速連携案  
  - コンテナ分割デプロイ (Docker Compose / Kubernetes)

- **重要な用語・背景知識**  
  - **FastAPI**: Python の非同期 Web フレームワーク。型ヒント対応  
  - **Prisma**: TypeScript 向け ORM。型安全なクエリ生成

- **ユーザーが得た理解・気づき**  
  > 「Web は JS、モデルは Python に切ることで両者の得意分野を活かせる」

---

### JavaScript だけで ML はしんどい問題

- **ユーザーの初期疑問**  
  > 「機械学習を JS だけで完結させるのは大変では？」

- **アシスタントの回答要約**  
  JS は数値計算ライブラリが限定的で、ブラウザや Node.js では GPU 資源が制限される。推論だけなら TensorFlow.js, ONNXRuntime-Web で可能だが、学習や大規模モデルは Python が現実的。

- **発展的な話題・関連技術**  
  - WebGPU & WebNN の今後  
  - edge-ai-runner / wasm-llm など軽量推論エンジン

- **重要な用語・背景知識**  
  - **TensorFlow.js**: JS 版 TensorFlow、ブラウザ/WebGL backend  
  - **ONNXRuntime-Web**: wasm + SIMD/WebGPU backend

- **ユーザーが得た理解・気づき**  
  > 「軽量モデルならブラウザ内でも動くが、本格的な学習は Python に任せるべき」

---

## 3. **総括**

このセッションで得た最大の収穫は **“適材適所”** の設計視点だった。

1. **フロント〜バックの役割整理**  
   - WaveSurfer を正しく使うには **バージョンごとの API 仕様** を把握する重要性  
   - Next.js で UI と軽量 API を統合しつつ、重い ML 推論は Python に分離するアーキテクチャの妥当性

2. **ハマりポイントの原因究明手順**  
   - DOM の存在確認 → JS 読み込み順 → ライブラリのメジャー変更と順を追うデバッグが有効だった

3. **今後の探究ポイント**  
   - WebAudio + Canvas でのリアルタイム波形描画  
   - Node.js ⇆ FastAPI を gRPC/Protobuf で高速化するベストプラクティス  
   - WebGPU 時代のブラウザ内推論の可能性検証

フロントエンド、バックエンド、機械学習の**境界線を意識的に設計**することで、保守しやすくスケール自在なシステムを組めるという確信を得た。

