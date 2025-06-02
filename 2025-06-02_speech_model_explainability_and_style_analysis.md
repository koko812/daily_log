## セッション概要

このセッションでは、音声と言語のマルチモーダルモデルにおける「解釈可能性」「スタイル分析」「音素処理」などを軸に、以下のような技術・論文・議論を幅広く展開した：

### 🔹 話題の流れ・技術の焦点
- ChatGPTとの協調プログラミングには制限の少ない GPT-4-turbo が有望。
- CLAP（Contrastive Language-Audio Pretraining）モデルの性質と応用について整理。
- CLAPCap, AudioLDM など音声キャプショニングの手法とその人声対応。
- 音声キャプショニングの最新研究動向（AudioCaption, Qwen-Audio など）。
- Whisper の forced alignment 特性と音素単位認識の限界。
- ECAPA の埋め込みが話者をうまく分離できる理由とその解析可能性。
- 発話スタイル（アクセント・音響的変動）分析の研究動向。
- L2-Arctic コーパスを使った発話スタイル研究のサーベイと論文紹介。
- Accent conversion における articulatory representation（TVs, PPGs, HuBERT embeddings）の意味と出典。
- Grad-CAM / LRP を用いた音声認識モデル（Wav2Vec, Whisperなど）の可視化手法の進展。
- Transformerモデルの解釈可能性に関する2つの重要論文の解説。

---

## 議論が膨らんだ話題

- **調音変数（TVs）と音響特徴量（PPG）による発話スタイルの変換**
  - 音素単位制御とL2話者への適用可能性
  - TVsの出典（speech inversionに基づく6次元表現）の解釈
  - PPGsの三音素表現（tri-phone）の意味と一般性

- **音声モデルへの可視化手法の応用**
  - WhisperやWav2Vec 2.0などに対するGrad-CAMやLRPの応用事例
  - 可視化結果の信頼性・実用性・精度に関する議論

- **ViT（Vision Transformer）系列のモデルにおける解釈可能性**
  - attentionに依存しない中間層からの関連性伝播
  - 解釈性の評価指標の整理（忠実性、一貫性、頑健性など）

---

## セッション中に出てきた論文一覧

| 論文タイトル | 会議名 | 年 |
|--------------|--------|----|
| Contrastive Language-Audio Pretraining (CLAP) | - | 2023 |
| AudioCaption: Listen and Tell | ACL | 2021 |
| CLAPCap: CLAP-powered Audio Captioning | - | 2023 |
| AudioLDM: Text-to-Audio Generation | ICML | 2023 |
| Qwen2.5-Omni Technical Report | - | 2024 |
| Analyzing the Impact of Accent on English Speech | Interspeech | 2022 |
| Accent Conversion with Articulatory Representations | Interspeech | 2023 |
| Layer-wise Analysis of a Self-supervised Speech Representation Model | ASRU | 2021 |
| Visualizing Automatic Speech Recognition -- Means for a Better Understanding? | arXiv | 2022 |
| Explainability of Speech Recognition Transformers via Gradient-based Attention Visualization | - | 2023? |
| AttnLRP: Attention-Aware Layer-Wise Relevance Propagation for Transformers | - | 2022 |
| Transformer Interpretability Beyond Attention Visualization | CVPR | 2021 |
| Explainability of Vision Transformers: A Comprehensive Review and New Perspectives | arXiv / TMLR（査読中） | 2023 |

---


