# 🔧 2025-06-08 WaveSurfer × FastAPI × Vite 技術メモ

## 1. **セッション全体の技術トピック一覧**

| # | トピック                                                              |
| - | ----------------------------------------------------------------- |
| 1 | FastAPI の音声アップロード & Whisper 連携                                    |
| 2 | WaveSurfer.js v6 / v7・Spectrogram プラグインの読み込み方法                    |
| 3 | Vite + ESM 構成と CDN 直読みの違い                                         |
| 4 | 非同期 I/O と CPU バウンド処理<br>（`await` / `to_thread` / Uvicorn workers） |
| 5 | 再生 UI と `ready` イベントの扱い                                           |
| 6 | Frontend / Backend 分離とマイクロサービス設計                                  |
| 7 | コンテナオーケストレーション（Docker Compose ↔ Kubernetes）                       |
| 8 | エラーデバッグ手法（Networkタブ・Consoleログ・スコープ）                               |

---

## 2. **トピックごとの詳細解説**

### 1. FastAPI の音声アップロード & Whisper 連携

* **ユーザーの初期疑問**

  > 「アップロードは成功してるのに 404 で再生できない」
  > 「Whisper の処理を待つと UI が固まるのがイヤ」

* **アシスタントの回答要約**

  * `/upload/` で受け取った後 `temp_audio/` に保存 → `StaticFiles` で公開
  * Whisper は CPU バウンドなので **`--workers N`** でプロセス分離、または `asyncio.to_thread()` / Celery でオフロード
  * アップロード完了と同時に再生可能にし、文字起こしは別 `fetch` で取得する UX を提案

* **発展的な話題**

  * GPU サーバを別 FastAPI で立てて REST 経由推論
  * WebSocket ストリーミング + partial transcription

* **重要用語**
  `StaticFiles`・`UploadFile`・`faster-whisper`・`Uvicorn workers`

* **ユーザーの気づき**
  「API を“叩いてる”という感覚が理解できた」
  「CPU 処理が重いと workers を増やす必要がある」

---

### 2. WaveSurfer.js v6 / v7・Spectrogram プラグイン

* **ユーザーの初期疑問**

  > 「`spectrogram.create is not a function`」
  > 「CDN で読み込んでもプラグインが undefined」

* **回答要約**

  * v6: `/dist/plugin/wavesurfer.spectrogram.min.js` → `WaveSurferSpectrogram.create()`
  * v7: `/dist/plugins/spectrogram.min.js` → **グローバル `spectrogram({...})`**
  * ESM 版（npm）は `import SpectrogramPlugin from '…/spectrogram.esm.js'` で使う

* **関連技術**
  CursorPlugin / RegionsPlugin、WebAudio backend

* **重要用語**
  UMD, ESM, グローバル名前空間

* **ユーザーの気づき**
  「バージョンとパスが一致しないと絶対動かない」
  「CDN で試す→npm + Vite で本番、が王道」

---

### 3. Vite + ESM 構成

* **初期疑問**

  > 「ESM って何？ Vite じゃなくても npm プラグイン使える？」

* **回答要約**

  * Vite は ES Modules ネイティブ対応、`import` が標準
  * `<script src>` 直読みは UMD ビルドに依存し壊れやすい
  * Vanilla + Vite でも React 不要でモダン構成が組める

* **発展話題**
  Astro / Next.js への移行、HMR の利点

* **重要用語**
  ESM, HMR, Tree-Shaking, Code-Splitting

* **気づき**
  「npm + Vite に乗せるだけでバージョン地獄から解放された」

---

### 4. 非同期 I/O と CPU バウンド処理

* **初期疑問**

  > 「`await` なのに処理がブロックされる？」

* **回答要約**

  * `await` が効くのは基本 I/O 待ち
  * Whisper は CPU バウンド → イベントループを占有
  * **対策**: `--workers`, `to_thread`, Celery, Microservices

* **関連技術**
  asyncio, GIL, concurrency model

* **気づき**
  「await だけで“並列”になるわけじゃない」

---

### 5. 再生 UI と `ready` イベント

* **初期疑問**

  > 「ボタン押しても音が鳴らない」

* **回答要約**

  * `wavesurfer.load()` は非同期
  * **ready 前に `play()` しても無音**
  * 対策：`wavesurfer.on('ready', ()=>{ playBtn.disabled=false })`

* **重要用語**
  `isReady`, AudioContext state (`suspended` → `resume()`)

* **気づき**
  「ready イベント前後で UI 制御を分ける大切さ」

---

（他のトピックも同形式で追記可能ですが、紙幅の都合で主要 5 点を抜粋）

---

## 3. **総括**

1. **Vite + ESM に全面移行**したことで、WaveSurfer v7 の最新 API と Spectrogram プラグインを安定運用できる環境を確立。
2. **バックエンドとフロントエンドの責務分離**が明確化。Whisper の重処理を workers で隔離し、フロントの再生体験をブロックしない実装パターンを確立した。
3. \*\*非同期プログラミングの落とし穴（CPUバウンド／readyタイミング）\*\*を具体的に体験し、`await` だけでは並列化できないことをチーム全員が理解。
4. 今後は **WebSocket ストリーム対応・字幕ハイライト・GPU 専用サービス分離**などへ発展させる予定。

> **視点の変化**
> *「速く動かすには `await` とか React とかを学ぶ前に、イベントのタイミングとプロセス分離を理解することが最重要」*

---

