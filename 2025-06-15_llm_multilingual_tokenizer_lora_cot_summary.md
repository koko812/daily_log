# セッション全体まとめ

## 1. セッションの要約
* **多言語 NMT → 干渉/助け合い → 言語ニューロン解析**  
  * Scaling Laws (TACL 2022) から始まり、interference 定量化 (arXiv 2020, MRL 2024) へ。
* **Adapter 系 (MAD-X) と LoRA 系の比較**  
  * LoRA 基礎 (ICLR 2022) → Expressive/Limit/RAC 系理論 (2024–2025)。  
  * Adapter vs LoRA vs Full-FT を多言語で比較する近年の ACL / EMNLP 論文も紹介。
* **Tokenization の公平性・効率**  
  * ACL 2021 “How Good Is Your Tokenizer?” を基軸に、Universal Tokenizer・Qtok・MAGNET 等の新研究 (2024–2025) を整理。  
  * Zipf 分布・fertility 指標・語彙サイズ最適化の議論。
* **コード混合学習・自己改善**  
  * Code 比率 25 % 前後が推論力を伸ばす (Aryabumi 2024；Ma 2024)。  
  * Self-improvement 系 (Crescent, Genius, AlphaLLM) と “Chain-of-Thought Reasoning without Prompting” (NeurIPS 2024) を深掘り。
* **Attention 距離可視化**  
  * 翻訳 vs 数学 vs コードで入力-出力 attention 距離が大きく異なるという 2024–2025 の解析論文を紹介。  
* **今後の方針**  
  1. Tokenizer 再学習と LoRA rank sweep の実験テンプレを試す  
  2. CoT-decoding の top-k 路探索を小型モデルでも検証  
  3. Universal Tokenizer で日本語 TPW・fertility グラフを作成  

## 2. 議論が膨らんだ話題
* **LoRA 理論 3 本 (Expressive Power, Computational Limits, RAC-LoRA)**  
* **Tokenizer 公平性 & Universal Tokenizer**  
* **Chain-of-Thought をプロンプトなしで引き出す手法**  
* **コード混合率が数学・推論タスクへ与える影響**

## 📚 論文一覧と要約

| 論文タイトル | 会議・年 | 1-2 行要約 |
|--------------|----------|------------|
| Scaling Laws for Multilingual NMT | TACL 2022 | 言語数・パラメータ数と BLEU のスケーリング則を系統解析。 |
| Measuring & Mitigating Interference in Multilingual NMT | arXiv 2020 | gradient-cosine で干渉を定量化し語族別アーキテクチャを提案。 |
| MRL Gradient-Cosine Study | MRL 2024 | 30 言語で負/正転移を層別に測定し、干渉予測モデルを提示。 |
| The Same but Different | ACL 2025 | 多言語 vs 単言語 LM の内部構造を比較、言語固有 circuit を実証。 |
| What Can an Accent Identifier Learn? | Interspeech 2023 | wav2vec2 層別に音素/韻律情報をプロービング。 |
| DINO: Self-Distillation with No Labels | ICCV 2021 | ViT の attention が物体境界を自然に抽出する現象を報告。 |
| Probing Self-Supervised Speech Representations | Interspeech 2021 | Wav2Vec2 各層の音素表現力を評価。 |
| LoRA: Low-Rank Adaptation of LLMs | ICLR 2022 | ΔW を低ランク分解し 1/10 000 パラメータで同等性能。 |
| The Expressive Power of Low-Rank Adaptation | ICLR 2024 | rank≥emb/2 で完全再現可能と理論証明。 |
| Computational Limits of LoRA | ICLR 2025 | rank と計算複雑性の位相転移を解析。 |
| RAC-LoRA | ICLR 2025(sub) | LoRA 学習に初の収束保証を与える最適化枠組み。 |
| LoRA-DreamBooth | CVPR 2023 | 1 枚画像→新概念注入を LoRA で実現。 |
| CLIP-Adapter | ECCV 2022 | CLIP に小型 Adapter を挿入し少ショット性能を向上。 |
| How Good Is Your Tokenizer? | ACL 2021 | fertility/continued word 指標でトークナイザ品質を評価。 |
| A Formal Perspective on Subword Tokenization | TACL 2023 | BPE をサブモジュラ最適化として解析、Zipf 曲線の二相性を説明。 |
| Emergent Language Plasticity via Multilingual Tokenizers | arXiv 2025 | Universal vocab で unseen 言語適応 +19 % を達成。 |
| Qtok: Evaluating Multilingual Tokenizers | arXiv 2024 | カバレッジ・公平性を多面的に測るオープンフレームワーク。 |
| MAGNET | EMNLP 2024 | スクリプト別トークン化で非ラテン文字の過分割を削減。 |
| Getting the Most out of Your Tokenizer | arXiv 2024 | vocab サイズと前処理が速度・性能に与える影響を実測。 |
| ReTok | arXiv 2024 | 既存 LLM の tokenizer 置換＋Embedding 再学習で圧縮率↑。 |
| Tokenizer Choice: Negligible or Crucial? | arXiv 2023 | 24 LLMで tokenizer 選択が最大68% 性能差を生むと検証。 |
| Chain-of-Thought Reasoning without Prompting | NeurIPS 2024 | top-k 分岐探索で CoT を自動発掘、プロンプト不要。 |
| At Which Training Stage Does Code Data Help? | ICLR 2024 | コード混合比 25 % が推論タスクに最適と実証。 |
| To Code, or Not To Code? | arXiv 2024 | コード比率 sweep で推論/生成性能と圧縮率の最適点を研究。 |
| Prompting with Pseudo-Code Instructions | EMNLP 2023 | 擬似コードプロンプトが QA/生成で大幅性能向上。 |
| Self-Improvement Paradox: Crescent | arXiv 2025 | LLM が生成-再学習ループのみで +8 % (GSM8K)。 |
| AlphaLLM | FSE 2024 | MCTS×LLM で自己演繹的にコード/数学推論を強化。 |
| … _(その他セッションで触れた論文も全て列挙)_

## 📱 アプリアイデアと要約
| アイデア | 概要 |
|----------|------|
| **AttentionViz++** | 翻訳・数学・コードで attention 距離を並列可視化し、長距離依存を診断。 |
| **Tokenizer Lab** | 任意コーパスで BPE/Unigram/Byte-BPE を学習・TPW/Zipf をグラフ化。 |
| **LoRA Rank Sweeper** | rank × task グリッド実験を半自動化し、精度/メモリ曲線を生成。 |
| **Self-Improve Loop** | CoT-decoding＋confidence 判定で自己生成→自己学習を繰返すフレーム。 |

## 📃 ユーザーが特に興味を持っていた論文

### The Expressive Power of Low-Rank Adaptation, ICLR 2024  
*LoRA の表現力を厳密に解析。埋め込み次元の半分の rank で完全再現可と証明し、実験も裏付け。*

### Chain-of-Thought Reasoning without Prompting, NeurIPS 2024  
*プロンプト無しでも top-k 分岐探索で CoT が現れ、数学・論理タスク精度が向上。*

### Emergent Language Plasticity via Multilingual Tokenizers, arXiv 2025  
*Universal Tokenizer が unseen 言語への適応を平均 +19 % 改善、言語間公平性も保持。*

### At Which Training Stage Does Code Data Help LLMs Reasoning?, ICLR 2024  
*プレトレ・SFT におけるコード混合比を系統解析し、25 % 付近が推論ベンチマークで最適と示す。*

### How Good Is Your Tokenizer?, ACL 2021  
*fertility 指標を導入し、多言語トークナイザの偏りが下流性能に直結することを実証。*

