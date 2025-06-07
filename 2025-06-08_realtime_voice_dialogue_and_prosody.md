## 🧠 セッション概要

- **話題の流れ**
  - Whisper を軸にしたリアルタイム／ターン制音声対話の実装方針を検討  
  - GCP・研究室 GPU・Singularity・Docker の運用比較  
  - FastAPI と LangGraph を使ったタスク指向対話パイプライン設計  
  - Audio VAP・Moshi・Google Duplex など “話し終わり予測” と full-duplex 対話の技術を深掘り  
  - 日本語特化 LLM（llm-jp, ELYZA, rinna/Youri など）と MultiWOZ 日本語化によるチューニング案  
  - 関西弁 TTS／prosody encoder／Voice Conversion で「声質＋方言＋韻律」を再現する方法を検討
  - 今後は **①音声→テキスト応答** と **②音声→音声応答** の 2 本柱でプロトタイプを構築し、将来的に full-duplex 化へ発展

- **主要技術／ツール**
  - `asyncio`（Queue・Semaphore・Lock・Event）  
  - Whisper / faster-whisper, VAD, Audio VAP  
  - FastAPI, LangGraph, Streamlit, WebRTC  
  - Coqui TTS, VITS, prosody encoder / GST, Voice Conversion  
  - 日本語 LLM（llm-jp-3.6B, ELYZA-Llama-2-7B-Instruct, rinna/Youri-7B）  
  - データセット：MultiWOZ, Taskmaster, Snips, 自作 FAQ

- **今後の方針（箇条書き）**
  - 最低限のベースライン：音声→Whisper→LLM→テキスト返答（リアルタイム表示）
  - 並行して TTS を組み込み「声↔声」の対話版を用意
  - LangGraph でスロット管理をモデル化し、市役所／予約系タスクへ展開
  - Prosody encoder＋文体変換で関西弁 TTS 試作
  - 将来的に Audio VAP を組み込み、発話途中で応答プリフェッチ → full-duplex へ

---

### 🔍 議論が膨らんだ話題

| トピック | 膨らんだポイント |
|----------|-----------------|
| **Docker vs Singularity** | root 権限／常駐管理／研究室 GPU運用の現実的落とし所 |
| **日本語 LLM チューニング** | MultiWOZ 日本語化・指示チューニング・雑談／ナビ両立 |
| **Audio VAP & prosody** | 発話終端予測・関西弁イントネーション再現・応答プリフェッチ |
| **UI の“思考可視化”** | LLM の候補ツリーやスロット状態をリアルタイムに表示する新しい対話 UI |

---

#### 📚 論文一覧と要約

| 論文 | 年 / 会議 | 要約 |
|------|-----------|------|
| **Who’s Next? Audio-Based Turn-Taking Prediction Using VAP** | 2021, SIGDIAL | 音声のみから 500 ms 先の発話継続／交代を二値分類する VAP モデル (1D CNN+LSTM)。 |
| **Early and Incremental Response Generation for Task-Oriented Dialogues** | 2022, ACL | 発話完了前に応答候補を逐次生成し、タスク指向対話のレイテンシを縮める手法。 |
| **Moshi: A Speech-Text Foundation Model for Real-Time Dialogue** | 2024, arXiv | STT と TTS を統合し End-to-End で音声↔音声対話を実現、full-duplex 性能を示す。 |
| **Google Duplex** | 2018, Google I/O / SIGCHI demo | 電話予約に特化し、人間らしいためらい・重なり発話を手続き型スクリプトで実現。 |

---

#### 📱 アプリアイデアと要約

| アイデア | 概要 |
|----------|------|
| **Baseline 2-mode Bot** | ①音声→テキスト応答のリアルタイムチャット ②音声→音声応答のシンプルボット |
| **市役所ナビゲータ** | スロット充足で手続きを案内、足りない情報は音声で聞き返すタスク指向対話 |
| **思考可視化 UI** | LLM の Chain-of-Thought・スロット状態・VAP 出力をライブ表示する対話フロント |
| **関西弁 Voice Converter** | 自声 TTS に関西弁 prosody を付与し、方言 × 個人声質の合成を実験 |

---

#### ⭐ ユーザーが特に興味を持った論文解説

1. **Moshi (2024, arXiv)**  
   - 音声→音声を直接モデリングし、従来の STT→LLM→TTS 分離を排除。  
   - 応答被せ・遅延最小化のため、ストリーミング処理と音響埋め込みを統合。  

2. **Who’s Next? (SIGDIAL 2021)**  
   - 音響特徴だけでターン継続を予測する VAP。  
   - VAD では取れない “話し終わりの気配” を捉え、先読み応答に活用可能。  

3. **Early & Incremental Response Generation (ACL 2022)**  
   - 発話途中でスロット推定→応答草案を生成し、発話完了と同時に返答。  
   - タスク指向対話のレイテンシ改善に直結し、ユーザーもリアルタイム応答構想の参考に。  

---

