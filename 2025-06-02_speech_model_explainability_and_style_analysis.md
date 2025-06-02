## 🧠 セッション要約

- 音声キャプショニング（CLAPCap, AudioLDMなど）の基礎と応用を確認
- 音声スタイル（アクセント、話者特徴）の制御と分析に関する研究を複数調査
- ECAPAとWhisperなどの音響表現の可視化・解釈可能性（GradCAM, LRP等）に関心を展開
- 中間表現（PPG, TV, HuBERTなど）を活用した発話変換手法の詳細を検討
- L2-ARCTICコーパスを使った研究事例を調査し、音素情報や三音素単位表現の使用事例も分析
- 最終的に、音声と視覚のTransformerモデルに対する解釈可能性手法へと話題が拡張された

---

## 🔍 議論が膨らんだ話題

- ECAPA-TDNNの話者埋め込みの精度と構造的要因
- TVs（調音変数）とPPG（音素確率）を使った音声スタイル変換の精度と制御性
- ASRモデル（Whisper, HuBERT）に対するGradCAMやLRPの適用の可視化事例
- L2-ARCTIC に含まれる音素情報の有無や利用可能性の検討
- Tri-phone表現とその歴史的・技術的背景
- Transformerベースの解釈可能性技術の展開とその音声モデルへの応用可能性

---

#### 📚 論文一覧と要約

- **Contrastive Language-Audio Pretraining (CLAP)**（2023, arXiv）
  - 音声とテキストの表現を共通空間で学習する大規模なcontrastive学習モデル。音声分類・検索で最先端性能を示した。

- **CLAPCap: CLAP-powered Audio Captioning**（2023, arXiv）
  - CLAPの音声表現を活用して自然言語による音声キャプションを生成。Zero-shotの言語理解と生成を組み合わせた新アプローチ。

- **AudioLDM: Text-to-Audio Generation with Latent Diffusion Models**（ICML 2023）
  - テキストから高品質な音を生成する音声拡散モデル。音響多様性と内容整合性の両立に成功。

- **AudioCaption: Listen and Tell**（ACL 2021）
  - 音声キャプショニングのベンチマークと初のデータセット構築を報告。非言語音の記述に焦点。

- **Qwen2.5-Omni Technical Report**（2024, Alibaba）
  - テキスト・画像・音声の三モーダル統合モデル。音声理解や発話応答能力の実験も含む。

- **Analyzing the Impact of Accent on English Speech: Acoustic and Articulatory Perspectives**（Interspeech 2022）
  - アクセントが英語音声の調音・音響的特徴に与える影響を定量分析。L2話者の発話の傾向と困難を明らかに。

- **Accent Conversion with Articulatory Representations**（Interspeech 2023）
  - 調音的中間表現（TVs）とPPGを用いてL2話者の音声をL1話者風に変換。音素単位制御に基づく生成手法。

- **Layer-wise Analysis of a Self-supervised Speech Representation Model**（ASRU 2021）
  - HuBERTなどの層ごとに含まれる音韻・話者情報の変化を可視化。モデルの中間表現の役割を解明。

- **Visualizing Automatic Speech Recognition -- Means for a Better Understanding?**（arXiv 2022）
  - WhisperなどのASRモデルへのGrad-CAM的手法を適用し、時間領域と語出力の関連を視覚的に検証。

- **Explainability of Speech Recognition Transformers via Gradient-based Attention Visualization**（arXiv 2023）
  - Transformer型ASRへの可視化アプローチを提案。重要な入力フレームの特定に成功。

- **AttnLRP: Attention-Aware Layer-Wise Relevance Propagation for Transformers**（ICASSP 2022）
  - Transformerのマルチヘッド注意機構を考慮したLRPベースの解釈可能性強化手法。

- **Transformer Interpretability Beyond Attention Visualization**（CVPR 2021）
  - Attention可視化を超えて、勾配・中間特徴に基づく総合的なTransformer解釈手法を提案。

- **Explainability of Vision Transformers: A Comprehensive Review and New Perspectives**（TMLR 2023, under review）
  - ViTにおける可視化・解釈可能性技術の網羅的レビュー。視覚タスクにおけるTransformer理解を前進させた。

---

