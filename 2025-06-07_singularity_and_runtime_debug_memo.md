# 🧠 セッションサマリー（Markdown本文）

## 📚 セッション全体の技術トピック一覧
- Singularity と Docker のファイルシステム構造の違い  
- `singularity shell / exec / run` の使い分け  
- `%runscript`（entrypoint）を設定する利点と運用上の制約  
- `--overlay`・`--sandbox` で可変コンテナを作る方法  
- ローカル開発（uv・VSCode）＋実行時だけ Singularity に投げる開発フロー  
- CUDA 連携：`libcuda.so` が見つからないビルド失敗の原因と対処  
- mamba-ssm / Triton ビルドにおける `--no-build-isolation` の有効性  
- fakeroot ビルドの可否と制限  
- VSCode Remote で発生する無駄通信と SFTP／rsync 運用  
- ネットワーク帯域の定量計測：`iftop` / `nethogs` / FastAPI ミドルウェア  
- TTS 音声がマイクにループバックするリアルタイム会話エージェントの課題  

## 📱 トピックごとの詳細解説

### Singularity と Docker のファイルシステムの違い
- **ユーザーの初期疑問**  
  > 「singularity を shell で実行するとホストのファイルが全部見えている気が…？」  
- **アシスタントの回答要約**  
  Singularity は `.sif` を `/` にマウントしつつ **ホストの /home, $PWD, /tmp を自動バインド**。  
  Docker は完全隔離で、`-v` 指定がない限りホストは見えない。`--contain` で Singularity も隔離可能。  
- **発展的な話題・関連技術**  
  - `singularity inspect image.sif` でルート構成と `%runscript` を確認  
  - HPC ではホスト共有前提の設計が支持される  
- **重要な用語・背景知識**  
  *bind mount*（ホストディレクトリを実行名前空間に接続）  
  *user namespace*（非 root でも隔離実行するカーネル機能）  
- **ユーザーが得た理解・気づき**  
  > 「再現性が欲しいワークロードでは `--contain` を必ず付けるべきだな」

---

### singulairty shell / exec / run の使い分け
- **ユーザーの初期疑問**  
  > 「exec -it /bin/bash みたいに、中に入って変更を残せるの？」  
- **アシスタントの回答要約**  
  - `shell`：対話的に入りたいとき（変更は tmpfs で揮発）  
  - `exec`：任意コマンドを 1 度だけ実行  
  - `run` ：`%runscript` を呼び出す（ENTRYPOINT 相当）  
  永続変更は `--overlay` か `--sandbox` を明示的に使わない限り不可。  
- **発展的な話題・関連技術**  
  *overlay.img* を ext3 で作成 → 差分のみ保存  
- **重要な用語・背景知識**  
  *overlayfs*：読み取り専用イメージに差分レイヤを重ねる FS  
- **ユーザーが得た理解・気づき**  
  > 「開発では exec、共有バイナリでは run（entrypoint）を分けて使う」

---

### `%runscript`（entrypoint）
- **ユーザーの初期疑問**  
  > 「毎回 entrypoint を書くより exec で直接指定した方が柔軟なのでは？」  
- **アシスタントの回答要約**  
  `%runscript` は “このコンテナが何をするか” を**暗黙ドキュメント化**する。  
  ジョブスケジューラや他人が一行で呼べる。開発中は使わず exec で良い。  
- **発展的な話題・関連技術**  
  `%runscript` 内で `$@` を渡し、簡易ランチャーにする手もある。  
- **重要な用語・背景知識**  
  *%startscript*：`instance start` で実行するデーモンスクリプト。  
- **ユーザーが得た理解・気づき**  
  > 「ENTRYPOINT は README の一部と割り切ろう」

---

### Overlay と Sandbox
- **ユーザーの初期疑問**  
  > 「sandbox は重い。overlay だけで済ませたい」  
- **アシスタントの回答要約**  
  - *overlay*：差分ファイル（軽量） → `truncate -s 2G overlay.img`  
  - *sandbox*：可変ディレクトリ（Docker風） → 大規模 apt/pip 更新向き  
- **発展的な話題・関連技術**  
  sandbox → `.sif` へは `singularity build` で固め直し (= Docker commit)  
- **重要な用語・背景知識**  
  *immutable sif*：既定は読み取り専用  
- **ユーザーが得た理解・気づき**  
  > 「普段は overlay。環境確定フェーズで sandbox → sif に固める」

---

### ローカル開発＋Singularity 実行
- **ユーザーの初期疑問**  
  > 「基本はローカルで作業、実行だけ Singularity が一般的？」  
- **アシスタントの回答要約**  
  研究/HPC では王道。`uv`・VSCode で編集し、  
  ```bash
  singularity exec --nv --bind $(pwd):/ws image.sif python /ws/run.py
```

で GPU 本番環境と再現性を両立。

* **発展的な話題・関連技術**
  ジョブスクリプト 1 行化、`.sif` 配布で環境差異を排除。
* **重要な用語・背景知識**
  *bind option*：`--bind src:dst` でホストを見せる。
* **ユーザーが得た理解・気づき**

  > 「開発体験を壊さずに HPC へ持って行ける運用が見えた」

---

### CUDA + mamba-ssm ビルド失敗 (`-lcuda` not found)

* **ユーザーの初期疑問**

  > 「/usr/bin/ld: -lcuda が見つからない…」
* **アシスタントの回答要約**
  `libcuda.so` シンボリックリンク不足 or LD\_LIBRARY\_PATH 未設定。
  `/usr/lib/x86_64-linux-gnu/libcuda.so.1` を `libcuda.so` へリンク、
  もしくは PATH に追加。Triton ビルドには `--no-build-isolation` が有効。
* **発展的な話題・関連技術**
  fakeroot ビルドではホストの `/usr/lib` が見えず失敗 → overlay で対処可。
* **重要な用語・背景知識**
  *CUDA Driver Lib (`libcuda.so`)*：ユーザ空間から GPU 制御を行うライブラリ。
* **ユーザーが得た理解・気づき**

  > 「CUDA 周りはリンク名がキモ。`--no-build-isolation` は必須オプション」

---

### ネットワーク帯域の定量計測

* **ユーザーの初期疑問**

  > 「VSCode で無駄通信があるか定量的に見たい」
* **アシスタントの回答要約**
  クライアント側：`tcpdump`, `Wireshark`、
  サーバ側：`iftop`, `nethogs`, `vnstat`。
  FastAPI ならミドルウェアで送受信バイトをログに出力。
* **重要な用語・背景知識**
  *vnstat*：日次・時間帯別トラフィック集計ツール。
* **ユーザーが得た理解・気づき**

  > 「数値を出せば“モラル問題”が議論ではなく事実ベースになる」

---

## 📝  総括

このセッションを通じて、ユーザーは **Singularity の設計思想・Docker との差分・実践的な運用フロー** を体系的に把握し、

* 開発と再現性を両立する「ローカル開発＋実行時だけ Singularity」を明確に選択
* `%runscript`・overlay/sandbox・CUDA リンクエラーなど、**詰まりポイントの原因と対処を具体化**
* ネットワーク帯域計測や VSCode SFTP 運用など、**チーム全体のモラル向上につながる定量化手法** を獲得

した。
今後は **ジョブスクリプトテンプレ整備** と **mamba 系モデルの完全オフライン動作** を進め、研究室内で再現性と効率を両立させたワークフローを完成させることが次のステップとなる。


