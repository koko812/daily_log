# 📘 2025-06-15_Multilingual_LoRA_Tokenizer_CoT.md

## 1. セッションの要約

### 🧭 話題の流れ（トピック別）

- **多言語 NMT と干渉問題**  
  TACL 2022 の Scaling Laws を皮切りに、arXiv 2020 や MRL 2024 での interference 定量研究へ。言語間干渉の勾配指標や層別効果が議論された。
  
- **LoRA・Adapter・Full-FT の性能比較と理論的理解**  
  ICLR 2022 の LoRA 提案に始まり、ICLR 2024–2025 の Expressive / Limit / RAC-LoRA に関する理論展開。Adapter 系（CLIP-Adapter, MAD-X）との比較も行われた。

- **トークナイザの公平性と語彙最適化**  
  ACL 2021「How Good Is Your Tokenizer?」を軸に、fertility、Zipf分布、Universal Tokenizer（MAGNET, Qtok）といった多言語適応策が紹介された。

- **コード混合学習と自己改善戦略**  
  コードデータの混合比最適化（ICLR 2024, arXiv 2024）や、自己再学習ループ（Crescent, AlphaLLM, Chain-of-Thought Reasoning without Prompting）が注目された。

- **Attention 距離の可視化・分析**  
  翻訳・数学・コード間で Attention の依存距離が異なることを明らかにする研究が紹介され、アプリ応用も議論された。

---

## 2. 議論が膨らんだ話題

- 📌 **LoRA の理論的限界と表現力**
- 📌 **Universal Tokenizer の公平性とマルチリンガル適応性**
- 📌 **コードデータ混合による推論強化の時期と比率**
- 📌 **Prompt なしで CoT を引き出す分岐探索戦略**

---

## 3. 📚 論文リスト（タイトル／会議・年／1〜2行要約）

| 論文タイトル | 会議・年 | 要約 |
|--------------|----------|------|
| Scaling Laws for Multilingual NMT | TACL 2022 | 言語数やパラメータ規模と BLEU のスケーリング則を解析。 |
| Measuring & Mitigating Interference in Multilingual NMT | arXiv 2020 | gradient-cosine による言語間干渉の定量化。 |
| MRL Gradient-Cosine Study | MRL 2024 | 層別勾配から干渉と正転移の関係性を分析。 |
| The Same but Different | ACL 2025 | 多言語 vs 単言語 LM の内部 circuit を比較し差異を可視化。 |
| What Can an Accent Identifier Learn? | Interspeech 2023 | 音声モデルにおける層別言語・音素・韻律の表現力を分析。 |
| DINO | ICCV 2021 | Self-Distillation が物体の境界を自動抽出することを示す。 |
| Probing Self-Supervised Speech Representations | Interspeech 2021 | wav2vec2 の各層の音素認識性能を評価。 |
| LoRA | ICLR 2022 | Transformer の重み差分を低ランク近似し、パラメータ効率化を実現。 |
| The Expressive Power of Low-Rank Adaptation | ICLR 2024 | LoRA の rank が emb/2 以上で表現力を全保持できることを証明。 |
| Computational Limits of LoRA | ICLR 2025 | LoRA における rank の最適点と複雑性のトレードオフを定式化。 |
| RAC-LoRA | ICLR 2025(sub) | LoRA の最適化過程に対して初の収束保証を提示。 |
| LoRA-DreamBooth | CVPR 2023 | 画像生成モデルにおいて 1-shot 概念注入を LoRA で実現。 |
| CLIP-Adapter | ECCV 2022 | CLIP の fine-tuning に Adapter を挿入し精度を維持。 |
| How Good Is Your Tokenizer? | ACL 2021 | fertility・continued word 指標を導入し、トークン化の偏りを評価。 |
| A Formal Perspective on Subword Tokenization | TACL 2023 | BPE をサブモジュラ最適化として解析し、語彙設計理論を強化。 |
| Emergent Language Plasticity via Multilingual Tokenizers | arXiv 2025 | Universal Tokenizer による言語適応性能 +19 % を報告。 |
| Qtok | arXiv 2024 | カバレッジ・公平性・ロバスト性を評価するベンチマークスイート。 |
| MAGNET | EMNLP 2024 | 非ラテン文字言語での over-segmentation を緩和。 |
| Getting the Most out of Your Tokenizer | arXiv 2024 | vocab サイズ・前処理が性能・速度に与える影響を分析。 |
| ReTok | arXiv 2024 | トークナイザ置換＋埋め込み再学習によりモデル圧縮を実現。 |
| Tokenizer Choice: Negligible or Crucial? | arXiv 2023 | トークナイザの選択が下流性能に最大68%の差をもたらすことを実証。 |
| Chain-of-Thought Reasoning without Prompting | NeurIPS 2024 | top-k 探索で CoT を自動発見するプロンプト不要手法を提案。 |
| At Which Training Stage Does Code Data Help? | ICLR 2024 | コード混合比 25 % が推論精度最適であることを定量化。 |
| To Code, or Not To Code? | arXiv 2024 | コード比率と圧縮率・性能のバランス点を調査。 |
| Prompting with Pseudo-Code Instructions | EMNLP 2023 | 擬似コードによるプロンプトが推論性能を大幅に向上。 |
| Self-Improvement Paradox: Crescent | arXiv 2025 | 自己生成・再学習ループのみで数学タスク精度を 8 % 向上。 |
| AlphaLLM | FSE 2024 | MCTS を利用し、自己強化によるコード推論性能を向上。 |

---

## 4. 📱 アプリアイデアと要約

| アイデア名 | 概要 |
|------------|------|
| **AttentionViz++** | 翻訳・数学・コードにおける attention 距離を可視化し、依存構造の違いを比較。 |
| **Tokenizer Lab** | 任意コーパス上で BPE/Unigram を学習し、Zipf曲線や TPW/Fertility を可視化。 |
| **LoRA Rank Sweeper** | LoRA の rank × task グリッド実験を自動化し、メモリと精度のトレードオフを可視化。 |
| **Self-Improve Loop** | CoT-decoding＋信頼度判定による自動再学習ループを構築。 |

---

## 5. 🌟 ユーザーが特に関心を持っていた論文（5本）

### 📌 The Expressive Power of Low-Rank Adaptation, ICLR 2024  
LoRA の表現力を理論的に解析し、埋め込み次元の半分以上の rank で完全な再構成が可能であることを証明。理論と実験の両面から低ランク構造の強力さを示した。

### 📌 Chain-of-Thought Reasoning without Prompting, NeurIPS 2024  
プロンプトなしでも top-k 探索によって CoT が自然発生することを示し、数学・論理推論タスクで性能向上。プロンプト設計への依存を減らす実践的貢献。

### 📌 Emergent Language Plasticity via Multilingual Tokenizers, arXiv 2025  
言語間で共通語彙を持つ Universal Tokenizer により unseen 言語へのゼロショット適応が平均 +19% 向上。Tokenization と generalization の関係を明確化。

### 📌 At Which Training Stage Does Code Data Help?, ICLR 2024  
コード混合比率の変化がモデルの推論能力に与える影響を実証し、pretrain/SFT におけるコード比率の最適化設計指針を提示。

### 📌 How Good Is Your Tokenizer?, ACL 2021  
Tokenization 戦略が性能に与える影響を fertility 等の新指標で可視化し、トークナイザ設計のバイアスを定量評価するフレームワークを提案。

---

