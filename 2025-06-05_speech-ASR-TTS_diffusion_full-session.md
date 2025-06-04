## 1. セッション要約
- **出発点**  
  - 日本人英語スピーチを “面白く・非ありきたり” に可視化したい  
  - 単語・文法・発音・スタイルを同時に解析する UI を構想
- **話題の流れ**  
  1. 発話特徴可視化 UI → 高速アライン (Whisper→MFA)  
  2. TTS の進化 : Tacotron → VITS → 拡散 TTS / コードブック TTS  
  3. 歌声合成 (DiffSinger, VISinger) と制御軸 (F0, duration, style)  
  4. ストリーミング ASR/TTS と full-duplex (Moshi, GPT-4o)  
  5. Diffusion vs GAN/VAE、Latent Diffusion の意義  
  6. 図表生成の課題と Pix2Struct / InstructPix2Struct 系の挑戦
- **登場技術**  
  - **ASR**: Whisper, wav2vec 2.0, HuBERT, Conformer-Transducer, Speech ReaLLM  
  - **TTS**: FastSpeech2, VITS, DiffSinger, FastDiff, StyleTTS 2, VALL-E, NaturalSpeech 3  
  - **歌声合成**: VISinger, VITS-Singing, ESPnet-SVS  
  - **ストリーミング**: CosyVoice 2, SyncSpeech, LLMVoX  
  - **Full-duplex**: Moshi (Helium LLM + Mimi codec + Inner Monologue)  
  - **図表理解**: Pix2Struct / InstructPix2Struct
- **今後の方針**  
  - MVP: Whisper＋MFA で単語ヒートマップ UI  
  - 研究: Style-BERT-VITS 潜在空間で訛り軌跡を解析  
  - PoC: 拡散 TTS＋ストリーミング ASR による full-duplex デモ  
  - 構造保持生成 (Vector / Layout Diffusion) を継続ウォッチ  

## 2. 議論が膨らんだ話題
- 単語ヒートマップ UI とクリック再生  
- 潜在空間を動的に可視化する「声の彗星軌道」  
- 拡散 TTS vs コードブック TTS の比較  
- Inner Monologue (Moshi) と Speech ReaLLM の違い  
- 図表生成の一貫性問題と Pix2Struct 系

#### 📚 論文一覧と要約
| # | タイトル | 年 / 会議 | 1–2 行要約 |
|---|----------|-----------|------------|
|1|Phonetic Embedding for ASR Robustness in Entity Resolution|2021 Tech Rpt|音素 Siamese 埋め込みで固有名詞誤認を低減。|
|2|PWESuite: Phonetic Word Embeddings …|2024 LREC-COLING|音素単語埋め込みを提案、発音類似タスクで SoTA。|
|3|Error Correction by Paying Attention …|2024 Interspeech|音響+confidence を用いる非自己回帰 ASR 訂正。|
|4|Pronunciation Guided Copy and Correction|2023 Preprint|音韻コピー機構付き BART で同音誤りを大幅削減。|
|5|Mispronunciation Detection …|2022 ICASSP|音響・音韻・言語埋め込み統合で誤発音検出↑。|
|6|FastCorrect|2021 AAAI|編集距離整合 NAR モデルで ASR 訂正 6–9×高速化。|
|7|A Cross-Linguistic Study of Speech Modulation Spectra|2017 JASA|10 言語 AM/FM スペクトル差を定量化。|
|8|Statistical Analysis of Acoustic Phonetic Data|2015 arXiv|ロマンス語の音響差を統計解析。|
|9|Acoustic Characterization of Speech Rhythm|2024 arXiv|21 言語でリズム指標を深層学習で拡張。|
|10|Cross-Language LTASS & DR|2021 Clin Arch Comm Disord.|4 言語の長期平均スペクトル比較。|
|11|Speaker Individuality of LTFD|2021 Interspeech|バイリンガル60人のフォルマント分布分析。|
|12|Normalization through Fine-tuning …|2025 arXiv|wav2vec2 を FT し音素情報↑・話者バイアス↓。|
|13|Whisper Speaker Identification|2025 arXiv|Whisper 埋め込みが言語非依存な話者情報保持。|
|14|Residual Speech Embeddings for Tone Classification|2024 arXiv|音声-テキスト残差でトーン分類 +10 pt。|
|15|Dawn of the Transformer Era in SER|2023 TPAMI|wav2vec2-Large が Valence ギャップ解消。|
|16|Investigating Pre-trained Audio Encoders …|2023 Interspeech|層別情報量を多タスク検証。|
|17|HuBERT|2021 Interspeech|自己教師あり音声表現学習モデル。|
|18|DiffSinger|2021 arXiv|拡散モデルで歌声 Mel を段階生成、高音質。|
|19|FastDiff|2022 arXiv|拡散推論を4 stepに短縮しリアルタイム合成可。|
|20|DiffWave|2020 arXiv|波形直接拡散ボコーダー、WaveNet 同等音質。|
|21|DiffGAN-TTS|2022 arXiv|GAN×拡散で1 step高音質 TTS。|
|22|StyleTTS 2|2023 arXiv|スタイル拡散+音声LLM、ゼロショット高品質。|
|23|Speech ReaLLM|2024 arXiv|Decoder-only 80 M Streaming ASR (3 % WER)。|
|24|Decoder-only Architecture for Streaming ASR|2024 arXiv|CTC圧縮+decoder で WER-8 % & 2×速。|
|25|CUSIDE-T|2024 arXiv|チャンク+未来コンテキスト模擬で低遅延高精度。|
|26|Fast Streaming Transducer via KD|2024 Findings EMNLP|Whisper 蒸留で軽量多言語ストリーミング ASR。|
|27|Double Decoder Conformer|2024 ICNLSP|重み変更なしで遅延↓ WER維持。|
|28|Pix2Struct|2022 ECCV|画像→構造テキスト、図表/UI 理解に強み。|
|29|InstructPix2Struct|2023 HF Release|指示対応版 Pix2Struct、図表QA/抽出を汎化。|

#### 📱 アプリアイデアと要約
| アイデア | 概要 |
|----------|------|
|単語ヒートマップ UI|発音・文法スコアを色分け、クリック再生。|
|声の旅マップ|ベクトル軌跡を動的に可視化し音声同期。|
|潜在空間スタイル地図|Style-BERT-VITS で訛り軌跡を2D表示。|
|成長ダッシュボード|CEFR×発音スコアを時系列でトラッキング。|
|耳育てモード|ネイティブ vs 自身発話 ABテスト可視化。|
|身体感覚スライダー|声帯閉鎖・ピッチ幅をリアルタイム変換学習。|
|マルチエージェント発音コーチ|複数AIが評価・例示し最適フィードバック。|

#### ⭐ ユーザーが興味を示した論文（ピックアップ解説）
| 論文 | 解説 |
|------|------|
|**DiffSinger (2021)**|拡散モデルを SVS に応用。音素+F0+duration を条件に粗 Mel → ノイズ除去ステップで高音質歌声を生成。明示制御と多様性の両立が特徴。|
|**Residual Speech Embeddings for Tone Classification (2024)**|音声埋め込みからテキスト対応成分を線形回帰で差し引き、残差をスタイル/トーン表現として利用。トーン分類精度を一桁改善し、発話スタイル可視化に転用可能。|
|**Speech ReaLLM (2024)**|音声入力を直接 Decoder-only LLM で処理する80 M モデル。RNN-T の BLANK 概念を組み込み、3 % WER で真のストリーミング ASR を実現。|

