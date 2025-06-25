# 2025-06-25 複数LLMによる翻訳・生成と評価メトリクスの探究

## 1. セッションの流れと技術トピック
1. **デュアルモデル翻訳**  
   - 日本語LLM×中国語LLMで token-wise/beam 融合 ▶ ビーム多様性の課題  
2. **Beam Search vs. Sampling**  
   - 遅延分岐問題／温度スケーリング／Diverse Beam／Contrastive Decoding  
3. **評価指標の限界**  
   - MAUVE と BERTScore の盲点 → ストレステスト導入  
4. **ストレステスト実験事例**  
   - ACL 2023 He et al. 論文での誤り注入テスト  
5. **編集型モデル・Token-level Fusion**  
   - LaserTagger, LETR, Contrastive A* Decoding など  
6. **多言語タスク概観**  
   - XNLI, XQuAD, TyDi QA, M2M-100 と cross-lingual transfer  

## 2. 深掘りされた議題
| トピック | 主要ポイント | ユーザー熱量 |
|----------|--------------|--------------|
| **Contrastive Decoding** | Expert-Amateur 差分で流暢＋多様 | 🔥🔥🔥 |
| **Beam 多様性問題** | Late divergence とビーム幅／top-k関係 | 🔥🔥 |
| **評価メトリクスの盲点** | MAUVE/BERTScore が特定誤りに弱い | 🔥🔥 |
| **ストレステスト手法** | 誤り注入→指標感度テスト | 🔥 |
| **n-gram / prefix tree / DAG 融合** | 構造共有による効率化 vs 多様性 | 🔥 |

## 3. 論文リスト（漏れなく掲載）
| # | 論文タイトル | 年 / 会議 | 1-2行要約 |
|---|--------------|-----------|-----------|
| 1 | Contrastive Decoding: Open-ended Text Generation as Optimization | 2023 ICLR | Expert と Amateur LM のスコア差で生成文を最適化し、流暢さと多様性を両立。 |
| 2 | MAUVE: Measuring the Gap Between Neural Text and Human Text using Divergence Frontiers | 2021 NeurIPS | 生成分布と人間分布の距離をダイバージェンス曲線で測る自然さ×多様性指標。 |
| 3 | On the Blind Spots of Model-Based Evaluation Metrics for Text Generation | 2023 ACL | 誤り注入ストレステストで MAUVE 等の指標が特定エラーを見逃す盲点を実証。 |
| 4 | An Empirical Study on Contrastive Search and Contrastive Decoding | 2022 arXiv | CS と CD を比較し、MAUVE と人手評価の乖離を報告。 |
| 5 | Don’t Give Me the Details, Just the Summary! | 2018 EMNLP | BBC記事を一文で要約する XSUM データセットを提案。 |
| 6 | LaserTagger | 2019 EMNLP | 挿入・削除・保持ラベルで高速テキスト編集を行うモデル。 |
| 7 | Text Editing Models are Few-Shot Learners | 2022 EMNLP | 少量例で編集タスクを学習できる生成-編集ハイブリッド。 |
| 8 | NeuroLogic A*esque Decoding | 2021 ACL | 制約充足を保証しつつ多様文を探索する A* 風生成。 |
| 9 | Lookahead Beam Search | 2022 NAACL | 将来トークンスコアを推測し早期分岐を促すビーム探索。 |
|10 | DExpert: Decoding-Time Controlled Text Generation with Experts and Anti-Experts | 2021 ICLR | Toxic除去など目的別に Expert/Anti-LM を組合せる。 |
|11 | XNLI | 2018 EMNLP | 15言語対応の自然言語推論クロスリンガル評価セット。 |
|12 | XQuAD | 2020 EMNLP | SQuADの多言語拡張でクロス言語QA評価。 |
|13 | TyDi QA | 2020 TACL | Typologically diverse 11言語の情報検索QAベンチ。 |
|14 | M2M-100: A Massively Multilingual Machine Translation Model | 2021 ACL | 100言語間で直接翻訳を学習する大規模MTモデル。 |
|15 | Contrastive Search (原論文) | 2022 arXiv | 高確率トークンと低確率トークンの差で多様かつ一貫生成。 |

## 4. アプリアイデア・ツール（抜粋）
| 名称 | 機能 | 目的 |
|------|------|------|
| Dual-Model Beam Fusion | 2つのLLMを token 単位で融合 | 日本語→中国語翻訳の品質向上 |
| Prefix-DAG Decoder | prefix 共有でビーム展開を圧縮 | 長文でも効率的な多様ビーム |
| Stress-Test Harness | 誤り自動注入と指標スコア比較 | 評価メトリクスの盲点検出 |
| Diversity-Controlled Sampler | 温度/トップp+Early Divergence | 多様性と一貫性のバランス生成 |
| Metric Dashboard | MAUVE/BERTScore/Distinct を可視化 | 複合評価と指標相互比較 |

## 5. ユーザーが特に関心を示した論文（5本詳細）

### 1. Contrastive Decoding: Open-ended Text Generation as Optimization (ICLR 2023)  
Expert（LLaMA-65B 等）と Amateur（LLaMA-1.5B 等）の logit 差を目的関数にし、低確率だが文脈適合なトークンを引き上げるデコーディング。追加学習不要で、Greedy の安定性と Sampling の多様性を統合できる点が高評価。

### 2. MAUVE (NeurIPS 2021)  
生成テキスト群と人間テキスト群の分布差をダイバージェンス曲線の面積として測定。BLEUの表層依存やPPLの多様性欠如を補う目的で設計されたが、後続研究で盲点も報告され、複合指標利用の議論を促した。

### 3. On the Blind Spots of Model-Based Evaluation Metrics (ACL 2023)  
BERTScore・MAUVE など7種指標をストレステストし、切り詰め・語順崩壊・重複挿入などの誤りに対する感度不足を体系的に示す。結果、単一指標依存を戒め、多指標＋ストレステストの必要性を提唱。

### 4. An Empirical Study on Contrastive Search and Contrastive Decoding (arXiv 2022)  
CS と CD を多タスクで比較。MAUVEではCD優位なのに人間評価ではCS支持という乖離を定量化し、評価指標の限界を可視化。CD/CS のパラメータ設計や利用シーンのガイドラインを示した点で貢献大。

### 5. Don’t Give Me the Details, Just the Summary! (EMNLP 2018)  
BBC News 記事と対応する“一文見出し”の XSUM データセットを構築。抽象度が非常に高く、要約モデルの抽象化能力や hallucination 問題の分析ベースとして現在も広く使われる。

