# 2025-06-30 TokShop & LLM Tokenization セッションまとめ

## 1. セッションの要約（時系列＋トピック別）
1. **TokShop 2025 採択論文の網羅的ブラウズ**  
   - Sampling系・MBSR・Token Merging・Byte/Span/Script系など40本超を素読み
2. **非正規トークン化の可能性**  
   - *Broken Tokens?* ➜ ランダム／文字単位でも高精度 ✨  
   - *Where is the signal…* ➜ 周辺確率とNP/#P困難
3. **モデルサイズと挙動差**  
   - repetitionニューロン／長文翻訳／数学問題の成否  
   - Contrastive Decoding・Calibration-Tuning で改善
4. **推論時介入（ITI・nudging・IVG）**  
   - 小型 aligned-model でトークン挿入 → 生成品質↑
5. **確率キャリブレーション議論**  
   - *Calibration-Tuning*, *Lightweight LM Calibration*  
   - GPT 系 vs LLaMA 系の ECE 差・温度再調整
6. **出力文字列に依拠した包括分析**  
   - Hallucination, CoT エラー, Code Error Taxonomy

---

## 2. 議論が膨らんだ話題
| トピック | ポイント |
|---|---|
| 非正規トークンの頑健性 🔍 | ランダム分割でも意味保持・一部タスクで性能向上 |
| モデル間確率キャリブレーション 📊 | GPT 系が安定、LLaMA 系は長文で過信傾向 |
| Repetition & Sink Neuron 🔁 | 小型モデルに集中、大型では多機構分散 |
| 推論時トークン介入 🛠️ | nudging/IVG で安全性・真実性を動的補正 |
| Byte/BPE 改良潮流 🚀 | SuperBPE・Byte-Span 等で圧縮効率と品質両得 |

---

## 3. 論文リスト（漏れなく列挙）📚  
| タイトル | 年 / 会議 | 1-2行要約 |
|---|---|---|
| Epsilon Sampling Rocks | 2024 ACL Findings | ε-samplingでMBSR翻訳を高速・高精度化 |
| Sampling from Your LM One Byte at a Time | 2025 TokShop | バイトレベルSamplerでトークナイザ非依存生成 |
| Causal Estimation of Tokenisation Bias | 2025 TokShop | RDDでトークナイザ偏りを因果推定 |
| Pitfalls, Subtleties, and Techniques… | 2025 TokShop | オートマトン制約生成の罠と回避策 |
| MorphTok | 2025 TokShop | Indic語形素ベースBPEで精度＋圧縮向上 |
| Continuous Autoregressive Generation w/ MoG | 2025 TokShop | Mixture-of-Gaussiansで連続生成 |
| InCa and InDia | 2025 TokShop | ケース＋ダイアクリで頑健Tokenizer |
| ByteSpan | 2025 TokShop | 情報量駆動のSpanトークナイザ |
| Discrete JEPA | 2025 TokShop | 再構成なしで離散表現学習 |
| Tokenizing Nonverbal Communication in Salsa Dance | 2025 TokShop | ダンス動作を離散トークン列化 |
| Canonical Autoregressive Generation | 2025 TokShop | 正準変換でAR生成を安定化 |
| Adversarial Tokenization | 2025 TokShop | 非正規分割で安全性フィルタ回避を実証 |
| Entropy-Driven Pre-Tokenization for BPE | 2025 TokShop | エントロピー制御でBPE前処理最適化 |
| You Only Train Once | 2025 TokShop | 数値演算に強いTokenizer選択法 |
| GeneticBPE | 2025 TokShop | miRNAモチーフ保持の遺伝的BPE |
| How Much is Enough? | 2025 TokShop | Tokenizer学習データ量の逓減効果 |
| How Tokenization Limits Phonological Knowledge | 2025 TokShop | 音韻知識とBPE分割の限界 |
| Evaluating Morphological Alignment of Tokenizers… | 2025 TokShop | 70言語形態整合評価 ⇒ 相関低い |
| Subword Tokenization Strategies for Kurdish | 2025 TokShop | クルド語Embedding用BPE比較 |
| Contextual Morphologically-guided tokenization for Latin BERT | 2025 TokShop | ラテン語BERT用に文脈形態分割 |
| Continuous Chain of Thought Enables Parallel Reasoning | 2025 TokShop | 連続CoTで並列探索 |
| HH-Codec | 2025 TokShop | 音声離散コーデック8192語彙 |
| FLEXITOKENS | 2025 TokShop | 時間経過で語彙を変える適応Tokenizer |
| Byte Latent Transformer | 2025 TokShop | バイトパッチで推論フロップ削減 |
| BPE Stays on SCRIPT | 2025 TokShop | Unicodeスクリプト境界を守るBPE |
| Conditional Unigram Tokenization | 2025 TokShop | 並列文脈でUnigram最適化 |
| Overcoming Vocabulary Constraints… | 2025 TokShop | 未知語をピクセルFallbackで扱う |
| zip2zip | 2025 TokShop | 推論時語彙圧縮でレイテンシ↓ |
| Tokenisation is NP-Complete | 2025 TokShop | 最適語彙探索がNP完全と証明 |
| Watermarking Autoregressive Image Generation | 2025 TokShop | 画像生成に透かしトークン付与 |
| Robust Noise Attenuation via Adaptive Pooling | 2025 TokShop | Transformer出力を動的プーリング |
| One-D-Piece | 2025 TokShop | 品質制御型画像トークナイザ |
| Byte-level Tokenizers… Ill-formed UTF-8 | 2025 TokShop | バイトLMは壊れたUTF-8を生成し得る |
| Is Your LLM Overcharging You? | 2025 TokShop | 課金体系とトークン化の経済分析 |
| CAT: Content-Adaptive Image Tokenization | 2025 TokShop | 画像内容でトークン粒度を調整 |
| QuickMerge++ | 2025 TokShop | AR prior 付き高速トークンマージ |
| SuperBPE: Space Travel for LMs | 2025 TokShop | 空白越えスーパーワードBPE |
| Broken Tokens? | 2025 TokShop | 非正規分割でも90%+性能保持 |
| Where is the signal in tokenization space? | 2024 EMNLP | NP/#P困難だが非正規分割が有益 |
| Tokenization Falling Short | 2024 EMNLP Findings | サブワードに対する頑健性総点検 |
| Calibration-Tuning | 2024 NeurIPS | LoRA微調整で確率キャリブを改善 |
| Lightweight LM Calibration | 2023 arXiv | GPT vs LLaMA ECE比較（短文/長文） |
| CharED | 2024 arXiv | 文字レベル確率合算のアンサンブル |
| Contrastive Decoding | 2022 ACL | 大小モデル差分で反復・逸脱を抑制 |
| Repetitions Are Not All Alike | 2025 arXiv | repetition機構を層別に解析 |
| Graph-based Confidence Calibration | 2025 OpenReview | 応答一致グラフで信頼度推定 |

---

## 4. アプリアイデアと要約 📱
| アイデア | 目的 / 機能 | 技術要素 |
|---|---|---|
| **TokenVisualizer** | トークン境界と意味変化を可視化 | BPE分割ツリー・ヒートマップ |
| **ProbAlign** | モデル間確率分布の差・ECE図示 | 温度補正・ヒストグラム |
| **GuidedTokenEditor** | 推論中トークン介入で品質調整 | nudging / IVG API |
| **SignalSampler** | 非正規トークン化サンプラ & 周辺確率推定 | importance sampling |
| **CalibTrainer** | 校正データ最小セットでLoRA微調整 | Calibration-Tuning 実装 |

---

## 5. ユーザーが特に関心を持っていた論文（詳細要約）✨

### 🔍 Broken Tokens? Your Language Model can Secretly Handle Non-Canonical Tokenizations (TokShop 2025)
ランダム・文字単位トークン化入力でも指示チューン済み LLM は 90–93% の性能を維持し、数字タスクで +33% 改善。**表層トークン境界より意味抽象化**が優先されることを示す。

### 🧮 Where is the signal in tokenization space? (EMNLP 2024)
同一文字列の多様なトークン列に潜む「意味信号」を理論・実験で解析。周辺確率合算で Q&A 精度↑。Tokenization 探索は NP/#P-hard だが**近似でも有益**。

### 🎯 Calibration-Tuning: Teaching LLMs to Know What They Don’t Know (NeurIPS 2024)
20k例のLoRA微調整で **Expected Calibration Error を大幅低減**。モデルが自信を持つ／控える境界を学習し、安全な自己不確実性表示を可能にする。

### ⚡ QuickMerge++: Token Merging with Autoregressive Prior (TokShop 2025)
AR一貫性を保つ動的トークン圧縮。推論フロップ↓でも BLEU や MMLU を維持。**マージ後の品質劣化を防ぐ**実用的統合手法。

### 🚀 SuperBPE: Space Travel for Language Models (TokShop 2025)
空白越えのスーパーワードを自動学習する改良BPE。200k語彙でトークン数-33%、8Bモデルで平均 +4% 精度。**語彙上限と意味保持の両立**を実証。

---

