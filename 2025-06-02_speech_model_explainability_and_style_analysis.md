## 🧠 セッション要約

このセッションでは、音声と言語のマルチモーダルモデルを軸に、CLAPやCLAPCapなどの音声キャプショニング技術から、Whisper/ECAPAによる話者埋め込み、発話スタイル（アクセントや調音特徴）の変換、Grad-CAM的可視化まで幅広く扱われた。特に、音響特徴量（PPG, TVs）や可視化手法（LRP, Grad-CAM）に関する研究が議論の中心となった。

### 🔹 話題の流れ・技術

- GPT-4とCLIP以外のモデル（例：Qwen-Audio, CLAP）の説明力
- CLAPを用いた音声キャプショニング（CLAPCap）と生成（AudioLDM）
- 発話スタイル・アクセント変換に関する研究とL2-Arcticの活用
- ECAPAとWhisperの埋め込み空間の違い
- PPG（Phonetic PosteriorGram）・TV（調音変数）の導出と利用方法
- 音声モデルの可視化技術（Layer-wise Relevance Propagation, Grad-CAM等）
- ViTなど視覚モデルへの解釈性研究の応用と比較

---

## 🔍 議論が膨らんだ話題

- ECAPAがなぜ埋め込み空間で話者をきれいに分離できるのか（調音要素の強調？）
- 音素単位制御・TVsの導出手法とその利用可能性（Speech Inversion）
- WhisperやWav2VecにおけるGrad-CAM的可視化の妥当性と限界
- 解釈性研究（ViTなど）を音声モデルへ応用するための課題
- tri-phoneやPPGの汎用性と、L2-Arcticとの整合性

---

#### 📚 論文一覧と要約

- **Contrastive Language-Audio Pretraining (CLAP)**（2023）
  - 音声とテキストのペアをcontrastive learningで学習したモデル。音声分類・検索に広く応用されている。

- **CLAPCap: CLAP-powered Audio Captioning**（2023）
  - CLAPの音声表現を使って自然言語で音声の説明文を生成するモデル。音声理解とNLGを橋渡し。

- **AudioLDM: Text-to-Audio Generation**（ICML 2023）
  - テキストから音声を生成する拡散モデル。音声生成の質・多様性の両立を目指す。

- **AudioCaption: Listen and Tell**（ACL 2021）
  - 音声に対する自然言語によるキャプション生成タスクを初めて本格的に定義し、ベンチマークも提案。

- **Qwen2.5-Omni Technical Report**（2024）
  - 音声・画像・テキストの3モーダルを統合したLLM。音声理解機能に関するベンチマークも含まれる。

- **Analyzing the Impact of Accent on English Speech**（Interspeech 2022）
  - L2話者のアクセントが音響特徴と調音パターンに及ぼす影響を定量的に分析。

- **Accent Conversion with Articulatory Representations**（Interspeech 2023）
  - PPGやTVsを介してL2→L1の発話変換を行うフレームワークを提案。音素単位での変換が可能。

- **Layer-wise Analysis of a Self-supervised Speech Representation Model**（ASRU 2021）
  - HuBERTなどのSSLモデル内部の層ごとの音韻情報・話者情報の保持を定量的に解析。

- **Visualizing Automatic Speech Recognition -- Means for a Better Understanding?**（arXiv 2022）
  - Whisper等のASRモデルに対し、Grad-CAMやAttention分析による可視化を試みた研究。

- **Explainability of Speech Recognition Transformers via Gradient-based Attention Visualization**（2023?）
  - TransformerベースのASRに対し、勾配ベースの視覚化手法で音素/単語との対応を明示。

- **AttnLRP: Attention-Aware Layer-Wise Relevance Propagation for Transformers**（2022）
  - Attention構造に対応したLRPを提案し、Transformerの中間層の寄与を可視化。

- **Transformer Interpretability Beyond Attention Visualization**（CVPR 2021）
  - Transformerに対して注意以外の要素も可視化対象とする新たなLayer-wise関連性伝播法を提案。

- **Explainability of Vision Transformers: A Comprehensive Review and New Perspectives**（TMLR査読中, 2023）
  - ViTにおける可視化手法を体系的にレビュー。今後の方向性と評価指標についても考察。

---


