# 🔧 セッション総括

## 1. セッションの要約
- **MBRデコーディング**を中心に、翻訳以外への応用、サンプリング戦略（ε-sampling・η-sampling）を検討  
- **ビームサーチ vs サンプリング**の歴史的推移と、LLM時代（2023–2025）のハイブリッド／高速化（speculative, draft-verify, contrastive）手法を整理  
- **Probability–Quality Paradox**を手がかりに「低 perplexity = 高品質ではない」問題を理論・実証両面で確認  
- 自動評価指標（流暢性・一貫性・多様性）の実用例を比較し、指標間のトレードオフを議論  
- **複数モデル協調デコード**（Co-LLM など）の将来性とコスト最適化の方向性を検討  
- 今後は MBR＋Contrastive／Speculative の組合せや、ハルシネーション低減タスクへの展開を試す方針

## 2. 議論が膨らんだ話題
- ε 値（0.001–0.05）の微調整が BLEURT では僅差でも人間評価（MQM）で大差  
- “低 perplexity 文は退屈” という確率–品質パラドックスと情報量仮説  
- Fluent・Consistent を自動で測る難しさと、NLI・QA ベース一貫性指標の利点  
- Collaborative / Speculative Decoding が推論速度を数倍向上しつつ品質を保てる仕組み  
- ハルシネーション率とデコード法（beam < contrastive < dynamic-sampling）の関係

## 📚 論文一覧と要約
| # | タイトル | 会議・年 | 1-2行要約 |
|---|----------|----------|-----------|
| 1 | *On Calibration of Modern Neural Networks* | ICML 2017 | DNN は高精度でも信頼度が過大評価になりがち；Temperature Scaling を提案 |
| 2 | *Epsilon Sampling Rocks* | Findings EMNLP 2023 | ε-sampling＋MBR が beam／top-p を上回る翻訳品質を達成 |
| 3 | *Truncation Sampling as LM Desmoothing* | Findings EMNLP 2022 | top-k/p を「平滑化解除」と再定式化し、η-sampling を提案 |
| 4 | *Probability–Quality Paradox in Language Generation* | ACL 2022 | 中程度確率の文が最も自然になる情報量仮説を理論＆実証 |
| 5 | *The Curious Case of Neural Text Degeneration* | ICLR 2020 | beam/gree­dy が繰り返しを誘発する問題を指摘し nucleus sampling を提唱 |
| 6 | *Comparison of Diverse Decoding Methods* | ACL 2019 SRW | beam・sampling・diverse-beam を複数生成タスクで比較 |
| 7 | *What Do You Get When You Cross Beam Search with Nucleus Sampling?* | Findings EMNLP 2021 | p-exact ビームで精度と多様性を両立 |
| 8 | *Empirical Analysis of Beam Search Curse* | EMNLP 2023 | ビーム幅を広げ過ぎると BLEU が劣化する現象を検証 |
| 9 | *Decoding Methods in Neural Language Generation: A Survey* | Information 2020 | 主要デコーダを目的別に体系整理 |
| 10 | *Impact of Decoding Methods on Human Alignment of Conversational LLMs* | arXiv 2024 | 会話LLMの人間らしさは小ビーム・低p値で向上 |
| 11 | *A Thorough Examination of Decoding Methods in the Era of LLMs* | EMNLP 2024 | closed vs open タスクで最適デコーダが分かれると報告 |
| 12 | *Dynamic-Width Speculative Beam Decoding* | AAAI 2025 | ドラフト＋検証型ビームで1.5–1.9×高速化 |
| 13 | *Recurrent Drafter (ReDrafter)* | ICLR 2025 | RNNドラフトで3.5×高速化し品質維持 |
| 14 | *Recursive Speculative Decoding* | arXiv 2024 | 木構造ドラフトで柔軟な多様性と速度を実現 |
| 15 | *Learning to Decode Collaboratively with Multiple LMs* | ACL 2024 | トークン単位でモデル切替を学習し性能向上 |
| 16 | *Contrastive Decoding* | ACL 2023 | expert-amateur 確率差で繰返し＆誤情報を抑制 |
| 17 | *Contrastive Decoding Improves Reasoning in LLMs* | arXiv 2023 | CD が論理推論精度を向上 |
| 18 | *Explaining and Improving CD via Hypothetical LM* | arXiv 2024 | CD を無限大LM近似と解釈し APD を提案 |
| 19 | *Stochastic Parrots* | FAccT 2021 | 低PPL追求は模倣とバイアスを助長する危険を指摘 |
| 20 | *An Empirical Study on Factuality Hallucination in LLMs* | ACL 2024 | beam が top-p より誤情報が少ないと報告 |
| 21 | *REAL Sampling* | arXiv 2024 | 動的 top-p で事実性と多様性を両立 |
| 22 | *KCTS: Knowledge-Constrained Tree Search* | arXiv 2023 | NLIベースでハルシネーションを抑える木探索 |
| 23 | *Improved Beam Search for Hallucination Mitigation* | arXiv 2022 | 要約でNLI再スコアリング付ビームが効果的 |

## 📱 アプリアイデアと要約
| アイデア | 概要 |
|----------|------|
| MBRデコーダDashboard | ε・温度・ビーム幅などをスライダーで動かし BLEURT/MQM を即時可視化 |
| Collaborative-Decoding SDK | 複数LLMをプラグイン形式で協調デコードできるライブラリ |
| Hallucination Monitor | QA/NLI 検証で生成文を自動マーキングし、指標別に警告を出すツール |

## 📃 ユーザーが特に興味を持っていた論文
### *Epsilon Sampling Rocks*, Findings EMNLP 2023
MBRと相性の良い ε-sampling を提案し、beam/top-p を超える翻訳品質を実証。適切な ε=0.02 が人間評価で最良。

### *Probability–Quality Paradox in Language Generation*, ACL 2022
高確率（低PPL）出力が不自然になる理由を情報理論で説明。自然な文はモデルのエントロピー付近の surprisalに集中。

### *Learning to Decode Collaboratively with Multiple LMs*, ACL 2024
トークン単位でモデルを切替える latent-variable デコーダを提案。指示フォロー・推論で単独モデルを上回る。

### *Contrastive Decoding*, ACL 2023
大モデルと小モデルの確率差でトークンを選択し、繰り返しと事実誤りを抑制。推論タスクで特に効果的。

### *Dynamic-Width Speculative Beam Decoding*, AAAI 2025
ドラフト→検証のパイプラインをビーム幅に動的反映し、LLM推論を高速化しつつ品質維持。

---

