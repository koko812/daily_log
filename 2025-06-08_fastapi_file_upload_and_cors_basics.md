# 📚 FastAPI × フロントエンド開発チャット：技術メモ

---

## 1. セッション全体の技術トピック一覧

- FastAPI + Uvicorn の最小構成とディレクトリ作成スクリプト  
- WSGI と ASGI の違い／Uvicorn・Gunicorn・uvloop  
- Python における非同期プログラミングと「10 K 問題」  
- WebSocket の常時接続と帯域・リソース・セキュリティ  
- CORS の役割・プリフライト・`allow_origins / methods / headers`  
- API 公開時のセキュリティ設計（認証・IP 制限・CSRF）  
- FastAPI の `UploadFile`／`FormData` とファイルアップロード処理  
- MIME 判定ライブラリ **python-magic** と拡張子偽装対策  
- フロントの `fetch().json()` と `Content-Type: application/json`  
- TCP/IP ループバック通信・`tcpdump` で見るパケットフロー  

---

## 2. トピックごとの詳細解説

### ASGI と WSGI

- **ユーザーの初期疑問**  
  > 「ASGIって何？ gunicornとの違いは？」  

- **アシスタントの回答要約**  
  - WSGI は同期専用インターフェース。  
  - ASGI は `async/await`・WebSocket を扱える次世代仕様。  
  - Uvicorn は ASGI サーバー、Gunicorn は WSGI（ただし `UvicornWorker` で橋渡し可）。  

- **発展的な話題**  
  - Django Channels・Starlette など ASGI 対応 FW。  

- **重要用語**  
  - **ASGI**: Asynchronous Server Gateway Interface。  
  - **Uvicorn**: uvloop + httptools に基づく高速 ASGI サーバー。  

- **ユーザーの気づき**  
  > 「非同期が根本の違いだから FastAPI は ASGI 前提なんだ」  

---

### 非同期プログラミングと 10 K 問題

- **ユーザーの初期疑問**  
  > 「async が使えたら何が嬉しい？ 10k 問題に関係？」  

- **回答要約**  
  - I/O 待ち中でも他コルーチンを動かせる＝同時接続に強い。  
  - スレッド数でなく軽量タスクで 1 万接続も処理可能。  

- **関連技術**  
  - `asyncio`, `uvloop`, Node.js ライクなイベントループ。  

- **キーワード**  
  - **10 K問題**: 1 台で 10 k ソケットを捌けるか。  

- **ユーザー理解**  
  > 「WSGI だとスレッド枯渇するけど、ASGI なら捌ける」  

---

### WebSocket と常時接続

- **ユーザーの初期疑問**  
  > 「繋ぎっぱなしは帯域やセキュリティ的に大丈夫？」  

- **回答要約**  
  - Idle 時は帯域を消費しないが、メモリ・FD を持つため接続数依存の負荷はある。  
  - `wss://` + 認証 + ping/pong・タイムアウトで守る。  

- **関連技術**  
  - FastAPI の `@app.websocket()`、Redis PubSub でスケール。  

---

### CORS とブラウザ同源制約

- **ユーザーの初期疑問**  
  > 「CORS を * で開けると危険？ そもそも何を守る？」  

- **回答要約**  
  - CORS は **ブラウザ JS に対する制限**でありサーバー防御ではない。  
  - `allow_origins` には信頼フロントのみを列挙。  
  - `allow_methods`, `allow_headers` で許可を最小化。  

- **重要用語**  
  - **プリフライト** (`OPTIONS`)：実リクエスト前に許可ヘッダを問い合わせ。  
  - **CSRF**：クッキーつき悪意リクエスト。CORS では完全には防げない。  

- **ユーザー理解**  
  > 「CORS は“ブラウザの注意書き”であって API を直接守らない」  

---

### FastAPI のファイルアップロード (`UploadFile`)

- **初期疑問**  
  > 「upload されたファイルはどこに入る？ 画像も音声も同じ？」  

- **回答要約**  
  - `file: UploadFile = File(...)` と書くだけで FastAPI が multipart ボディを解析し `UploadFile` に格納。  
  - 画像/音声/文書などすべてバイナリとして扱い、`file.content_type` で MIME がわかる。  

- **発展技術**  
  - 複数ファイル (`List[UploadFile]`)、ストリーミング処理。  

---

### python-magic と MIME 判定

- **ユーザーの初期疑問**  
  > 「python-magic って何？」  

- **回答要約**  
  - `libmagic` の Python ラッパー。拡張子を信用せずバイナリヘッダを解析して MIME を推定。  
  - 偽装 `.jpg` → 実は PDF などを検出するセキュリティ用途で重要。  

- **関連リンク**  
  - GitHub: <https://github.com/ahupp/python-magic>  

---

### JSON レスポンスと `fetch().json()`

- **初期疑問**  
  > 「`.json()` は何をしている？ レスポンスのどこを抜いてる？」  

- **回答要約**  
  - `Content-Type: application/json` を見て、HTTPボディを JSON パース。  
  - FastAPI の `JSONResponse` が自動でヘッダ付与。  

---

## 3. 総括

- **視点の変化**  
  - 「CORS はセキュリティ“対策”ではなくブラウザの壁」という認識を獲得。  
  - 非同期（ASGI）と同期（WSGI）の本質的差分を理解し、FastAPI の強みが “イベントループ + 軽量タスク” にあることを把握。  

- **得られた知見**  
  - ファイルアップロードは `UploadFile` で抽象化され、画像も音声も同一フロー。  
  - IP 制限や SSH トンネルでネットワーク層を閉じつつ、アプリ層では認証・バリデーションが不可欠。  

- **今後の探究ポイント**  
  - JWT 認証・レートリミット・CSRF トークン実装による API 多層防御。  
  - python-magic を用いた厳格な MIME 判定＋アンチウイルス連携。  
  - WebSocket + Redis でスケーラブルなリアルタイム配信パイプラインの構築。

---

