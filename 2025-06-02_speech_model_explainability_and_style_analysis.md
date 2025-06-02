## 🧠 セッション概要

- 音声と言語のマルチモーダルモデル (CLAP, Qwen-Audio) の文献検索
- 発言スタイルの変換 (アクセントコンバージョン)や言語差を保った音声生成
- ECAPA, Whisper, HuBERT などの音声埋め込みや中間表現 (PPG, TVs) を用いた発言分析
- GradCAM, LRP, AttnLRP などの音声Transformerへの可視化アプローチ検討
- L2-ARCTIC コーパスを使ったL2言語読み手の評価と発言分析

## 🔍 課題化した論点

- TVs (Tract Variables) やPPGが特定の発言スタイルの計算にどれほど有用か
- Whisperは本8言語認識後に音素に変換しているのではないか
- ECAPAの要素がなぜ誘導性の高い埋め込みを出すのか
- GradCAM/LRPは音声のどの時間範囲が特定単語に影響したかを表示できるか

---

#### 📚 論文一覧と要約

- **Contrastive Language-Audio Pretraining (CLAP)** (2023, arXiv)
  - 音声とテキストを対応づける大規模事前学習モデル。contrastive learning を用いて音声分類や検索に高い性能。

- **CLAPCap: CLAP-powered Audio Captioning** (2023, arXiv)
  - CLAPを使って音声に該当する文章を生成するモデル。音声理解と自然言語生成の橋渡し。

- **AudioLDM** (2023, ICML)
  - テキストから音声を生成する Latent Diffusion Model。text-to-audio の生成精度向上と制御性を両立させた。

- **Accent Conversion with Articulatory Representations** (2023, Interspeech)
  - PPGs や TVs を用いて非ネイティブ音声をネイティブ発音に変換。発音スタイル制御に有効な中間表現を評価。

- **Layer-wise Analysis of a Self-supervised Speech Representation Model** (2021, ASRU)
  - HuBERTの各層が音響・言語・話者などの情報をどの程度保っているかを定量評価。中間層の意味づけに貢献。

- **Explainability of Speech Recognition Transformers via Gradient-based Attention Visualization** (2023, arXiv)
  - WhisperやWav2Vec2.0にGrad-CAMを適用し、時間軸での重要領域を可視化。音声理解における注意領域を分析。

- **AttnLRP: Attention-Aware Layer-Wise Relevance Propagation for Transformers** (2022, ICASSP)
  - Transformer に LRP を適用する際、Attention 情報も活かした方法を提案。音声モデルへの応用も意識。

- **Transformer Interpretability Beyond Attention Visualization** (2021, CVPR)
  - Attention可視化の限界を指摘し、Gradient RolloutやInput Attributionなどの代替技術を検討。

- **Explainability of Vision Transformers: A Comprehensive Review and New Perspectives** (2023, TMLR under review)
  - ViT系モデルに対する解釈性技術（GradCAM, LRP, Rollout など）の体系的レビュー。音声モデル応用の技術的基盤。


### 今後の方針

- HuBERT, TVs, PPG など複数の音響表現を用いた音声変換の実装と比較実験。
- WhisperやWav2Vec2に対して Grad-CAM/LRP を適用するプロトタイプの設計。
- ViT系の可視化手法を音声ドメインに応用したツールチェーンの試作。
- 発話単位での埋め込み変化とスタイル遷移の観測（t-SNEなど）をL2 Arcticで検証。
