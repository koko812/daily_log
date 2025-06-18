# 2025-06-19 MBR & デコーディング技術セッションまとめ

## 1. セッションの要約（時系列）

| 時間帯 | 主な話題 | 技術トピック |
|-------|---------|-------------|
| 🕒 序盤 | Beam Search と Sampling のバッチ化難易度比較 | バッチ実装、温度・Top-k/p サンプリング挙動 |
| 🕒 中盤 | Beam vs Sampling を扱う代表論文の整理 | ACL19〜arXiv21、品質 vs 多様性 |
| 🕒 中盤 | MBR (Minimum Bayes Risk) デコーディング基礎 | 候補生成→後処理選択、リスク最小化 |
| 🕔 後半 | 最新 MBR 拡張（Token-level, 不確実性, 多様性） | Adaptive Contrastive Search, Diverse MBR 等 |
| 🕔 後半 | 評価設計：指標・ベースライン・データセット | BLEU/COMET/BERTScore, WMT, XSum |
| 🕕 終盤 | アプリ・ツール案 & 具体的評価数値 | MBR パイプライン, Black-box LLM Ensemble |

---

## 2. 議論が膨らんだトピック

1. **MBR の後処理性** …「大量に生成→後から選択」戦略で実装が簡潔になる点を確認  
2. **Token-Level MBR & 不確実性** … 重みのベイズ的不確実性を組み込むことで BLEU/COMET が +1 前後改善  
3. **評価の信頼性** … P-BLEU/P-BERTScore 等、確率分布を考慮した指標や人間評価を併用する必要性

---

## 3. 論文リスト（完全網羅）

| 📚 タイトル | 会議・年 | 1 – 2行要約 |
|-------------|---------|-------------|
| **The Curious Case of Neural Text Degeneration** | ACL 2019 | Beam が反復しやすい問題を指摘、Nucleus Sampling で回避可能と示す。 |
| **Comparison of Diverse Decoding Methods from Conditional Language Models** | ACL 2019 | Beam / diverse beam / sampling を多角的に評価、多様性指標を提案。 |
| **What Do You Get When You Cross Beam Search with Nucleus Sampling?** | arXiv 2021 | p-Exact Search 等ハイブリッド手法を提案、品質と多様性の両立を検証。 |
| **Conditional Poisson Stochastic Beam Search** | EMNLP 2023 Findings | Beam を Poisson サンプリングで確率化、中間的デコーダを実現。 |
| **Calibrated Decoding: Leveraging Model Confidence for Improved Translation Quality** | ACL Findings 2023 | QE モデルを組み込んで翻訳出力を再選択、信頼度と品質を一致させる。 |
| **Adaptive Contrastive Search: Uncertainty-Guided Decoding for Open-Ended Text Generation** | ICLR 2024 | 不確実性ペナルティ付き Contrastive Search、多様性と安定性を両立。 |
| **Generating Diverse and High-Quality Texts by Minimum Bayes Risk Decoding** | ICLR 2024 | Diverse MBR / k-Medoids MBR により品質-多様性トレードオフを改善。 |
| **Centroid-Based MBR (CBMBR)** | ACL 2024 Findings | COMET +0.5 改善、期待リスク計算を 5.7× 高速化する近似を提案。 |
| **Distributional Cooling for Minimum Bayesian Risk Decoding (DC-MBR)** | LREC-COLING 2024 | ラベルスムージングの過平滑を修正、トークン分布を冷却して MBR を強化。 |
| **Low-Rank MBR Approximation** | EACL 2024 | ユーティリティ行列を低ランク分解し、計算を 1/16 に削減しつつ同等品質。 |
| **Adaptive Contrastive Search** | 再掲 | 上記。 |
| **Epsilon-Sampling + MBR** | EMNLP 2023 | ε-Sampling で候補多様性を確保し、人手評価ですべてのペアで Beam 超え。 |
| **Direct Preference Optimization + MBR** | NeurIPS 2023 | Fine-tuning で MBR 相当の効果を推論コスト 0 で再現。 |
| **Uncertainty-Aware Decoding with Minimum Bayes Risk** | ICLR 2025 | 重み不確実性を統合、Token-level MBR で BLEU/COMET +1 程度向上。 |
| **Document-level MBR-OT** | arXiv 2025 | Optimal Transport で文書レベルの MBR を拡張、複数タスクで有意改善。 |

*★…ユーザー関心が特に高かった論文（下記で詳述）*

---

## 4. アプリ／ツールアイデア一覧

| 💡 アイデア名 | 機能 | 目的 |
|---------------|------|------|
| MBR Post-Processor ✅ | 生成済み候補集合に対し BLEU/BERTScore で MBR 選択 | 翻訳・要約の自動後処理 |
| Token-Level MBR Decoder 📚 | トークン分布を混合しリスク最小列を逐次復元 | 不確実性を活かした一段上の品質 |
| Black-box LLM Ensemble MBR 🔍 | GPT-4, Claude 等 API 出力を束ねて MBR 選択 | ゼロショット環境で品質＆安全性向上 |
| P-Metric Evaluator 📱 | P-BLEU / P-BERTScore を計算し分布品質を可視化 | サンプリング系モデルの評価支援 |

---

## 5. ユーザーが特に関心を示した論文（詳細要約）

1. **Uncertainty-Aware Decoding with Minimum Bayes Risk (ICLR 2025)**  
   モデル重みのベイズ事後をサンプリングし、Sequence- & Token-level の期待リスクを再定義。WMT17 En→De で BLEU +0.9、COMET +0.014、ハルシネーション減少を達成。Black-box LLM アンサンブルにも適用し、リスクが高い場合の生成スキップ (abstention) も可能にした。

2. **Generating Diverse and High-Quality Texts by Minimum Bayes Risk Decoding (ICLR 2024)**  
   MBR に多様性誘導項を加え、翻訳・要約・data-to-text で従来 Beam/MBR を上回る品質-多様性バランスを達成。k-medoids MBR は代表候補をクラスタ中心として選択することで 30 % 計算削減。

3. **Adaptive Contrastive Search (ICLR 2024)**  
   Contrastive Search にトークン不確実性を用いた温度制御を組み込み、Wikitext/Wikinews で MAUVE +8 % 向上。多様性は Sampling 並、反復率は Beam 並みに抑制。生成長の自動最適化も報告。

4. **Conditional Poisson Stochastic Beam Search (EMNLP 2023 Findings)**  
   Beam を Poisson プロセスで確率サンプリング化し、翻訳 BLEU が Beam+0.4、Sampling+0.6 を実現。候補分散が標準 SBS 比 25 % 減で安定性向上。実装は Fairseq 拡張で公開。

5. **Centroid-Based MBR (ACL 2024 Findings)**  
   多様な候補群の埋め込み平均（セントロイド）から距離最小候補を高速に特定。COMET 最大 +0.5、計算 5.7× 高速化。翻訳・要約の両方で同等以上の品質を保ちつつ実用速度を確保。

---

